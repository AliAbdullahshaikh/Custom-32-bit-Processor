/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah 
// Create  Date:   01/05/2024 
// Module  Name:   counter_block_tb
// Project Name:   32 bit custom processor 
// Description:    
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module counter_block_tb;
      // Inputs
      reg clk;
      reg rst;
      // Outputs
      wire [3:0] counter;

      // Instantiate the design under the test (DUT)
      counter_block dut(.clk(clk), .rst(rst), .counter(counter));
      
      // Clock Generation (20ns period)
      initial clk=0;
      always #10 clk=~clk;

      // Test Sequence
      initial begin
	  	// Monitor the signals
      	$monitor("Time=%0t | clk=%b | rst=%b | counter=%b", $time, clk, rst, counter);
        
	  	// Initialize with Reset Active
      	rst = 1;
        
      	// Hold reset for 3 clock cycles to ensure it catches a posedge
      	#60; 
        
      	// Release reset (Counter should start incrementing on the next posedge)
      	rst = 0;
        
      	// Let the counter run for 100ns
      	#100; 
        
      	// Assert reset again to verify the counter clears to 0 mid-execution
      	rst = 1;
      	#20;
        
      	// End simulation
      	$finish; 
      end

      initial begin // Monitoring and waveform 
        $dumpfile("counter_block.vcd");
        $dumpvars(0,counter_block_tb);
      end
endmodule
