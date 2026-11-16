/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah              
// Create  Date:   03/05/2024                
// Module  Name:   register file                   
// Project Name:   32 bit custom processor   
// Description:                              
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module register_file #(
    parameter DATA_WIDTH = 32,          // Width of each register
    parameter ADDR_WIDTH = 5,           // 5 bits = 32 registers
    parameter INIT_FILE  = "regfile.txt",          // Initial data file
    parameter DUMP_FILE  = "regfile_updated.txt"   // Output file for simulation
)(
    input clk,
    input write_enable,
    input [ADDR_WIDTH-1:0] write_address,
    input [DATA_WIDTH-1:0] write_data,
    input [ADDR_WIDTH-1:0] read_address1,
    input [ADDR_WIDTH-1:0] read_address2,
    output [DATA_WIDTH-1:0] read_data1,    // Asynchronous read
    output [DATA_WIDTH-1:0] read_data2     // Asynchronous read
);

    // Array of registers based on parameters
    reg [DATA_WIDTH-1:0] registers [0:(1<<ADDR_WIDTH)-1];
    integer file_handle;

    // 1. Initialize from file and open dump file
    initial begin
        $readmemh(INIT_FILE, registers);
        file_handle = $fopen(DUMP_FILE, "w");
    end

    // 2. Asynchronous Read (Combinational - No clock needed)
    assign read_data1 = registers[read_address1];
    assign read_data2 = registers[read_address2];

    // 3. Synchronous Write
    always @(posedge clk) begin
        if (write_enable) begin
            // Write to hardware register
            registers[write_address] <= write_data;
            
           	// SIMULATION ONLY: Write to file AND print to console
            if (file_handle != 0) begin
                $fdisplay(file_handle, "Time: %0t | Wrote %h to Register %d", $time, write_data, write_address);
            end
            // This guarantees we see the output in the EDA Playground console
            $display("[FILE WRITE] Time: %0t | Wrote %h to Register %d", $time, write_data, write_address);
        end
    end

endmodule
