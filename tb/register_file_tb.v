/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah 
// Create  Date:   03/05/2024 
// Module  Name:   register_file_tb
// Project Name:   32 bit custom processor 
// Description:    
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module register_file_tb;

    // Testbench signals
    reg clk;
    reg write_enable;
    reg [4:0] write_address;
    reg [31:0] write_data;
    reg [4:0] read_address1;
    reg [4:0] read_address2;
    
    wire [31:0] read_data1;
    wire [31:0] read_data2;

    // Instantiate the UUT with Parameters
    register_file #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(5)
    ) uut (
        .clk(clk),
        .write_enable(write_enable),
        .write_address(write_address),
        .write_data(write_data),
        .read_address1(read_address1),
        .read_address2(read_address2),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // Clock Generation
    initial clk = 0;
    always #10 clk = ~clk;

    // Waveform Generation
    initial begin
        $dumpfile("regfile.vcd");
        $dumpvars(0, register_file_tb);
    end

    // Test Sequence
    initial begin
      $monitor("Time=%0t | WE=%b | WriteAddr=%d | WriteData=%h | ReadAddr1=%d | ReadData1=%h | ReadAddr2=%d | ReadData2=%h", $time, write_enable, write_address, write_data, read_address1, read_data1, read_address2, read_data2);

        // Initialize
        write_enable = 0; write_address = 0; write_data = 0;
        read_address1 = 0; read_address2 = 0;
        #20;

        // 1. Read Initial Data from regfile.txt (Address 0)
        read_address1 = 5'd0;
        #20;
        // 2. Write New Data to Address 0 (0xABCD0123)
        write_enable = 1;
        write_address = 5'd0;
      	write_data = 32'hABCD0123;
        #20;
        
        // 3. Stop Writing and Read Address 0 again
        write_enable = 0;
        #20;

        // 4. Write to Address 10 and Read it at the same time
        write_enable = 1;
        write_address = 5'd10;
        write_data = 32'h12345678;
        read_address2 = 5'd10; // Asynchronous read should update in the same cycle
        #20;
        
        // 5. End
        write_enable = 0;
        #20;

        $finish;
    end
endmodule
