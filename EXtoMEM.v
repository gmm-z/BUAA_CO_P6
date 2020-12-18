`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:30:32 12/04/2020 
// Design Name: 
// Module Name:    EXtoMEM 
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
module EXtoMEM(
		input clk,
		input reset,
		input en,
		input [31:0] EX_Instr_i,
		input [31:0] EX_PC_i,
		input [31:0] EX_PC4_i,
		input [31:0] EX_PC8_i,
		input [31:0] EX_ALUout_i,
		input [31:0] EX_RT_i,
		input [4:0] EX_RegAddr_i,
		input [1:0] EX_Tnew_i,
		output reg[1:0] MEM_Tnew_o,
		output reg[4:0] MEM_RegAddr_o,
		output reg[31:0] MEM_Instr_o,
		output reg[31:0] MEM_PC_o,
		output reg[31:0] MEM_PC4_o,
		output reg[31:0] MEM_PC8_o,
		output reg[31:0] MEM_ALUout_o,
		output reg[31:0] MEM_RT_o
    );

		initial begin
			MEM_Instr_o <= 0;
			MEM_RegAddr_o <= 0;
		end

		always@(posedge clk)begin
			if(reset)begin
				MEM_Instr_o <= 0;
			end
			else if(en)begin
				MEM_Tnew_o <= EX_Tnew_i;
				MEM_RegAddr_o <= EX_RegAddr_i;
				MEM_Instr_o <= EX_Instr_i;
				MEM_PC_o <= EX_PC_i;
				MEM_PC4_o <= EX_PC4_i;
				MEM_PC8_o <= EX_PC8_i;
				MEM_ALUout_o <= EX_ALUout_i;
				MEM_RT_o <= EX_RT_i;
			end
		end
endmodule
