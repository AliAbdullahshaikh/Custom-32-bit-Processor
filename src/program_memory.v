/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah              
// Create  Date:   02/05/2024                
// Module  Name:   program memory                   
// Project Name:   32 bit custom processor   
// Description:                              
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module program_memory#(
    parameter RAM_WIDTH = 32,
    parameter RAM_ADDR_BITS = 9,
    parameter DATA_FILE = "data_in_address.txt",
    parameter INIT_START_ADDR = 0,
    parameter INIT_END_ADDR = 6
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
