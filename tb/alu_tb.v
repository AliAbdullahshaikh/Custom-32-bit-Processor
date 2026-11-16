/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah              
// Create  Date:   05/05/2024                
// Module  Name:   ALU tb                   
// Project Name:   32 bit custom processor   
// Description:                              
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps
module alu_tb;

    reg [31:0] A;
    reg [31:0] B;
    reg [1:0] ALU_Control;
    wire [31:0] ALU_Result;

    // Instantiate the ALU
    alu #(.WIDTH(32)) uut (
        .A(A),
        .B(B),
        .ALU_Control(ALU_Control),
        .ALU_Result(ALU_Result)
    );

    // Waveform Generation
    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, alu_tb);
    end

    // Test Sequence
    initial begin
        // Print the output in Decimal and Hex for readability
        $monitor("Time=%0t | Ctrl=%b | A=%d (h%h) | B=%d (h%h) | Result=%d (h%h)", 
                 $time, ALU_Control, A, A, B, B, ALU_Result, ALU_Result);

        // 1. Test ADD (10 + 20 = 30)
        A = 32'd10; B = 32'd20; ALU_Control = 2'b00;
        #20;

        // 2. Test SUB (50 - 15 = 35)
        A = 32'd50; B = 32'd15; ALU_Control = 2'b01;
        #20;

        // 3. Test MUL (12 * 12 = 144)
        A = 32'd12; B = 32'd12; ALU_Control = 2'b10;
        #20;

        // 4. Test AND (0xFFFFFFFF & 0x0F0F0F0F = 0x0F0F0F0F)
        A = 32'hFFFFFFFF; B = 32'h0F0F0F0F; ALU_Control = 2'b11;
        #20;

        $finish;
    end
endmodule
