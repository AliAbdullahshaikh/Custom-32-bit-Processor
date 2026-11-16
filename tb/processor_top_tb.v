/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah              
// Create  Date:   06/05/2024                
// Module  Name:   processor top tb                   
// Project Name:   32 bit custom processor   
// Description:                              
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module processor_top_tb;

    reg clk;
    reg rst;

    processor_top uut (
        .clk(clk),
        .rst(rst)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        $dumpfile("processor_top.vcd");
        $dumpvars(0, processor_top_tb);
    end

    initial begin
        // Monitor the Program Counter and ALU output
        $monitor("Time=%0t | PC=%d | Opcode=%b | ALU_Res=%h", $time, uut.pc_out, uut.opcode, uut.alu_result);

        rst = 1;
        #40; 
        rst = 0;
        #200;
        $finish;
    end
endmodule
