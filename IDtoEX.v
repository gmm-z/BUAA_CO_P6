`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:52:50 12/04/2020 
// Design Name: 
// Module Name:    IDtoEX 
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
module IDtoEX(
		input clk,
		input reset,
		input en,
		input [31:0] ID_Instr_i,
		input [31:0] ID_PC_i,
		input [31:0] ID_PC4_i,
		input [31:0] ID_PC8_i,
		input [31:0] ID_RD1_i,
		input [31:0] ID_RD2_i,
		input [31:0] ID_EXTout_i,
		input [4:0] ID_RegAddr_i,
		input [1:0]ID_Tnew_i,
		output reg[1:0]EX_Tnew_o,
		output reg[4:0] EX_RegAddr_o,
		output reg[31:0] EX_Instr_o,
		output reg[31:0] EX_PC_o,
		output reg[31:0] EX_PC4_o,
		output reg[31:0] EX_PC8_o,
		output reg[31:0] EX_RD1_o,
		output reg[31:0] EX_RD2_o,
		output reg[31:0] EX_EXTout_o
    );
	
		initial begin
			EX_Instr_o <= 0;
			EX_RegAddr_o <= 0;
		end
		
		always@(posedge clk)begin
			if(reset)begin
				EX_Instr_o <= 0;
			end
			else if(en) begin
				EX_Tnew_o <= ID_Tnew_i;
				EX_RegAddr_o <= ID_RegAddr_i;
				EX_Instr_o <= ID_Instr_i;
				EX_PC_o <= ID_PC_i;
				EX_PC4_o <= ID_PC4_i;
				EX_PC8_o <= ID_PC8_i;
				EX_RD1_o <= ID_RD1_i;
				EX_RD2_o <= ID_RD2_i;
				EX_EXTout_o <= ID_EXTout_i;
			end else begin
				EX_Tnew_o <= 0;
				EX_RegAddr_o <= 0;
				EX_Instr_o <= 0;
				EX_PC_o <= 0;
				EX_PC4_o <= 0;
				EX_PC8_o <= 0;
				EX_RD1_o <= 0;
				EX_RD2_o <= 0;
				EX_EXTout_o <= 0;
			end
		end

endmodule
