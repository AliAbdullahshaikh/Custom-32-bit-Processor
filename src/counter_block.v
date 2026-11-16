/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah 
// Create  Date:   01/05/2024 
// Module  Name:   counter
// Project Name:   32 bit custom processor 
// Description:    
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module counter_block(
	input  clk, 
	input  rst, 
	output reg [3:0] counter
);
    // 4-bit Program Counter (PC) for sequential instruction fetching
	always @(posedge clk) begin
		if (rst) begin
	    	counter <= 4'b0000; // Reset to first instruction
	 	end 
	 	else begin
	    	counter <= counter + 1'b1; // Increment to next instruction
	 	end
	end
endmodule
