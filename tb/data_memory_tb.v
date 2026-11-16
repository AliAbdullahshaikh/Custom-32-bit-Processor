/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah              
// Create  Date:   04/05/2024                
// Module  Name:   data memory tb                  
// Project Name:   32 bit custom processor   
// Description:                              
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module data_memory_tb;

    reg clk;
    reg mem_write;
    reg mem_read;
  	reg [8:0] addr;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Instantiate DUT
    data_memory #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(9),
        .INIT_FILE("") // Empty for this test so we start from scratch
    ) uut (
        .clk(clk),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock
    initial clk = 0;
    always #10 clk = ~clk;

    // Waveform
    initial begin
        $dumpfile("data_memory.vcd");
        $dumpvars(0, data_memory_tb);
    end

    // Test Sequence
    initial begin
        $monitor("Time=%0t | WE=%b | RE=%b | Addr=%d | WData=%h | RData=%h", $time, mem_write, mem_read, addr, write_data, read_data);

        // 1. Initialize
        mem_write = 0; mem_read = 0; addr = 0; write_data = 0;
        #20;

        // 2. Write 0xCAFE1234 to Address 10
        mem_write = 1; 
        mem_read = 0;
        addr = 9'd10; 
        write_data = 32'hCAFE1234;
        #20;
        
        // 3. Stop writing, wait a cycle
        mem_write = 0;
        #20;

        // 4. Read from Address 10
        mem_read = 1;
        addr = 9'd10;
        #20;

        // 5. Change address to 20 (should be empty/x)
        addr = 9'd20;
        #20;

        $finish;
    end
endmodule
