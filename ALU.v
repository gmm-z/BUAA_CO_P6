`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:36 11/15/2020 
// Design Name: 
// Module Name:    ALU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ALU(
		input [31:0] A,
		input [31:0] B,
		input [4:0] ALU_SELECT,
		output [31:0] ALU_RESULT,
		output reg[7:0] b_flag
    );
		initial begin
			b_flag <= 0;
		end
		
		assign ALU_RESULT = (ALU_SELECT==5'b00000)? A&B:
									(ALU_SELECT == 5'b00001)?A|B:
									(ALU_SELECT == 5'b00010)?A+B:
									(ALU_SELECT == 5'b00011)?A-B:
									(ALU_SELECT == 5'b00100)?{B,{16{1'b0}}} :
									(ALU_SELECT == 5'b00101)? (B << A[4:0] ):
									(ALU_SELECT == 5'b00110)? (B >> A[4:0]):
									(ALU_SELECT == 5'b00111)? $signed( $signed(B) >>> A[4:0]):
									(ALU_SELECT == 5'b01000)? A^B:
									(ALU_SELECT == 5'b01001)? ~(A|B):
									(ALU_SELECT == 5'b01010)? (  ($signed(A) < $signed(B)) ? 32'b1:32'b0 ):
									(ALU_SELECT == 5'b01011)? ( (A<B)?32'b1:32'b0): 0;
		
		always @*begin
			// 0 beq  1-bne 2-blez 3-bgtz 4-bltz 5-bgez
			if( A == B)	b_flag[0] = 1; else b_flag[0] = 0;
			if( A != B) b_flag[1] = 1; else b_flag[1] = 0;
			if( $signed(A)<= 0) b_flag[2] = 1;else b_flag[2] = 0;
			if( $signed(A) > 0)  b_flag[3] = 1; else b_flag[3] = 0;
			if( $signed(A) <0) b_flag[4] = 1;else b_flag[4] = 0;
			if( $signed(A) >= 0) b_flag[5] = 1; else b_flag[5] = 0;
			
		end
endmodule
