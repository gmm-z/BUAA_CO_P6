`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:29:38 12/04/2020 
// Design Name: 
// Module Name:    IFtoID 
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
module IFtoID(
		input clk,
		input reset,
		input en,
		input [31:0]IF_Instr_i,
		input [31:0]IF_PC_i,
		output reg[31:0] ID_PC_o,
		output reg[31:0] ID_Instr_o,
		output reg[31:0] ID_PC4_o,
		output reg[31:0] ID_PC8_o
    );
	 
	 initial begin
		ID_Instr_o <= 0;
	 end

	 always@(posedge clk)begin
		if(reset)begin
			ID_Instr_o <= 0;
		end
		else if(en)begin
			ID_PC_o <= IF_PC_i;
			ID_Instr_o <= IF_Instr_i;
			ID_PC4_o <= IF_PC_i + 4;
			ID_PC8_o <= IF_PC_i + 8;
		end else begin
			
		end
	 end
endmodule
