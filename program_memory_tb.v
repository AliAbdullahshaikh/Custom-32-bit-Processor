/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah 
// Create  Date:   02/05/2024 
// Module  Name:   program_memory_tb
// Project Name:   32 bit custom processor 
// Description:    
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module program_memory_tb;

    // Inputs
    reg clk;
    reg ram_enable;
    reg write_enable;
    reg [8:0] write_address;
    reg [31:0] data_in;

    // Outputs
    wire [31:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    program_memory #(.DATA_FILE("data_in_address.txt")) uut (
        .clk(clk), 
        .ram_enable(ram_enable), 
        .write_enable(write_enable), 
        .write_address(write_address), 
        .data_in(data_in), 
        .data_out(data_out)
    );

    // Clock Generation
    initial clk = 0;
    always #10 clk = ~clk;

    // Waveform Generation
    initial begin
        $dumpfile("program_memory.vcd");
        $dumpvars(0, program_memory_tb);
    end

    // Test Sequence
    integer i; // Integer for the loop
    initial begin
        $monitor("Time=%0t | Address=%d | Write_Enable=%b | Data_Out=%b", 
                 $time, write_address, write_enable, data_out);

        // 1. Initialize: Enable memory, disable writing (Read-Only)
        ram_enable = 1;
        write_enable = 0; 
        data_in = 32'h0;

        // 2. Loop through all 7 addresses (0 to 6)
        for (i = 0; i < 7; i = i + 1) begin
            write_address = i; // Assign loop variable to address
            #20;               // Wait 1 clock cycle
        end

        // End Simulation
        $finish;
    end
      
endmodule