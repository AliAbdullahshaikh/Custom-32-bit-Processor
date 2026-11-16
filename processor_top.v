/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah              
// Create  Date:   06/05/2024                
// Module  Name:   processor top                   
// Project Name:   32 bit custom processor   
// Description:                              
/////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

// ==========================================
// 1. Program Counter
// ==========================================
module counter_block(
    input clk, 
    input rst, 
    output reg [3:0] counter
);
    always @(posedge clk) begin
        if (rst) begin
            counter <= 4'b0000;
        end else begin
            counter <= counter + 1'b1;
        end
    end
endmodule

// ==========================================
// 2. Program Memory
// ==========================================
module program_memory#(
    parameter RAM_WIDTH = 32,
    parameter RAM_ADDR_BITS = 9,
    parameter DATA_FILE = "data_in_address.txt",
    parameter INIT_START_ADDR = 0,
    parameter INIT_END_ADDR = 6 // Updated for your 7 instructions
)(
    input clk,
    input ram_enable,
    input write_enable,
    input [RAM_ADDR_BITS-1:0] write_address,
    input [RAM_WIDTH-1:0] data_in,
    output reg [RAM_WIDTH-1:0] data_out
);
    reg [RAM_WIDTH-1:0] ram_name [(2**RAM_ADDR_BITS)-1:0];
    initial $readmemb(DATA_FILE, ram_name, INIT_START_ADDR, INIT_END_ADDR);

    // Synchronous Write (Only used for initialization)
    always @(posedge clk) begin
        if(ram_enable && write_enable) begin
            ram_name[write_address] <= data_in;
        end
    end

    // Asynchronous Read (Combinational - Outputs instantly!)
    always @(*) begin
        data_out = ram_name[write_address]; 
    end
endmodule

// ==========================================
// 3. Register File
// ==========================================
module register_file #(
    parameter DATA_WIDTH = 32,          
    parameter ADDR_WIDTH = 5,           
    parameter INIT_FILE  = "regfile.txt"          
)(
    input clk,
    input write_enable,
    input [ADDR_WIDTH-1:0] write_address,
    input [DATA_WIDTH-1:0] write_data,
    input [ADDR_WIDTH-1:0] read_address1,
    input [ADDR_WIDTH-1:0] read_address2,
    output [DATA_WIDTH-1:0] read_data1,    
    output [DATA_WIDTH-1:0] read_data2     
);
    reg [DATA_WIDTH-1:0] registers [0:(1<<ADDR_WIDTH)-1];
    initial $readmemh(INIT_FILE, registers);

    // Combinational Read
    assign read_data1 = registers[read_address1];
    assign read_data2 = registers[read_address2];

    // Synchronous Write
    always @(posedge clk) begin
        if (write_enable) begin
            registers[write_address] <= write_data;
        end
    end
endmodule

// ==========================================
// 4. ALU (Combinational)
// ==========================================
module alu #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] A,
    input [WIDTH-1:0] B,
    input [1:0] ALU_Control,
    output reg [WIDTH-1:0] ALU_Result
);
    always @(*) begin
        case(ALU_Control)
            2'b00: ALU_Result = A + B;
            2'b01: ALU_Result = A - B;
            2'b10: ALU_Result = A * B;
            2'b11: ALU_Result = A & B;
            default: ALU_Result = 0;
        endcase
    end
endmodule

// ==========================================
// 5. Data Memory
// ==========================================
module data_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 17
)(
    input clk,
    input mem_write,
    input mem_read,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] write_data,
    output reg [DATA_WIDTH-1:0] read_data
);
    reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];
    
    always @(posedge clk) begin
        if (mem_write) begin
            ram[addr] <= write_data;
        end
        if (mem_read) begin
            read_data <= ram[addr];
        end
    end
endmodule

// ==========================================
// 6. Top-Level Processor
// ==========================================
module processor_top (
    input clk,
    input rst
);
    wire [3:0]  pc_out;
    wire [31:0] instruction;
    wire [31:0] read_data1, read_data2;
    wire [31:0] alu_result;
    wire [31:0] dram_read_data;
    wire [31:0] reg_write_data;
    
    // Control Signals
    wire        reg_write;
    wire        mem_write;
    wire        mem_read;
    wire        alu_src;      
    wire        mem_to_reg;   
    wire [1:0]  alu_op;

    // 1. Program Counter
    counter_block pc (.clk(clk), .rst(rst), .counter(pc_out));

    // 2. Program Memory
    program_memory pm (
        .clk(clk), 
        .ram_enable(1'b1),
        .write_enable(1'b0),
        .write_address({5'b0, pc_out}), 
        .data_in(32'h0), 
        .data_out(instruction)
    );

    // 3. Control Unit
    wire [4:0] opcode = instruction[31:27];
    assign reg_write  = (opcode != 5'b00101); 
    assign mem_write  = (opcode == 5'b00101); 
    assign mem_read   = (opcode == 5'b00100); 
    assign mem_to_reg = (opcode == 5'b00100); 
    assign alu_src    = (opcode == 5'b00100 || opcode == 5'b00101); 
    assign alu_op = (opcode == 5'b00000) ? 2'b00 : 
                    (opcode == 5'b00001) ? 2'b01 : 
                    (opcode == 5'b00010) ? 2'b10 : 2'b11;

    // 4. Register File
    register_file rf (
        .clk(clk),
        .write_enable(reg_write),
        .write_address(instruction[26:22]), // Destination
        .write_data(reg_write_data),
        .read_address1(instruction[16:12]), // Source 1
        .read_address2(instruction[21:17]), // Source 2
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // 5. ALU
    wire [31:0] alu_input_B = alu_src ? {15'b0, instruction[16:0]} : read_data2;
    alu alu_unit (
        .A(read_data1),
        .B(alu_input_B),
        .ALU_Control(alu_op),
        .ALU_Result(alu_result)
    );

    // 6. Data Memory
    data_memory dm (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(instruction[16:0]), 
        .write_data(read_data2),  
        .read_data(dram_read_data)
    );

    // 7. Write-Back Multiplexer
    assign reg_write_data = mem_to_reg ? dram_read_data : alu_result;

endmodule