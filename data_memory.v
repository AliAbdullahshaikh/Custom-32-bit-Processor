/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah              
// Create  Date:   04/05/2024                
// Module  Name:   data memory                   
// Project Name:   32 bit custom processor   
// Description:                              
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module data_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 9, // 512 words of memory
    parameter INIT_FILE  = "datafile.txt"
)(
    input clk,
    input mem_write,   // 1 = Write, 0 = Read
    input mem_read,    // 1 = Read enabled
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] write_data,
    output reg [DATA_WIDTH-1:0] read_data
);

    // Memory array
    reg [DATA_WIDTH-1:0] ram [0:(1<<ADDR_WIDTH)-1];

    // Initialize memory (optional, for simulation)
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, ram);
        end
    end

    // Synchronous Write, Synchronous Read
    always @(posedge clk) begin
        if (mem_write) begin
            ram[addr] <= write_data;
        end
        if (mem_read) begin
            read_data <= ram[addr];
        end
    end

endmodule