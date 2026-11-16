/////////////////////////////////////////////////////////////////////////////
// Creator Name:   Ali Abdullah              
// Create  Date:   05/05/2024                
// Module  Name:   ALU                   
// Project Name:   32 bit custom processor   
// Description:                              
/////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module alu #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] A,           // Operand 1
    input [WIDTH-1:0] B,           // Operand 2
    input [1:0] ALU_Control,       // 00=ADD, 01=SUB, 10=MUL, 11=AND
    output reg [WIDTH-1:0] ALU_Result
);

    // Combinational Logic (No clock!)
    always @(*) begin
        case(ALU_Control)
            2'b00: ALU_Result = A + B;
            2'b01: ALU_Result = A - B;
            2'b10: ALU_Result = A * B;
            2'b11: ALU_Result = A & B; // Pure AND operation
            default: ALU_Result = {WIDTH{1'b0}};
        endcase
    end

endmodule