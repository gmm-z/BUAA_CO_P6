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
		input [2:0] ALU_SELECT,
		output [31:0] ALU_RESULT,
		output isEqual
    );
		
		assign ALU_RESULT = (ALU_SELECT==3'b000)? A&B:
									(ALU_SELECT == 3'b001)?A|B:
									(ALU_SELECT == 3'b010)?A+B:
									(ALU_SELECT == 3'b011)?A-B:
									(ALU_SELECT == 3'b100)?{B,{16{1'b0}}} :0;
		assign isEqual = (A == B) ? 1 : 0;
	
endmodule
