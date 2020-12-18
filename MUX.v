`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:08:40 11/16/2020 
// Design Name: 
// Module Name:    MUX 
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
module MUX_ALUSrc(
		input ALUSrc,
		input [31:0]RD2,
		input [31:0]EXTout,
		output [31:0]ALU_IN
    );
		assign ALU_IN = ALUSrc ? EXTout : RD2;
endmodule


module MUX_RegData(
		input [31:0]ALU_RESULT,
		input [31:0]MemOut,
		input [31:0]PC8,
		input [1:0]MemtoReg,
		output [31:0]RegData
		);
		assign RegData =  (MemtoReg == 2'b11)?PC8:
								(MemtoReg == 2'b01)?MemOut: ALU_RESULT;	
endmodule


module MUX_RegAddr(
		input [1:0]RegDst,
		input	[4:0]rt,
		input [4:0]rd,
		output [4:0]RegAddr
		);
		assign RegAddr = (RegDst == 2'b01)?rd:
								(RegDst == 2'b10)? (5'b11111):rt;
endmodule

module nPC(
		input [31:0]PC4,
		input [31:0]PC_BEQ,
		input [31:0]PC_JAL,
		input [31:0] RD1,
		output [31:0] IN_PC,
		input [1:0] PC_SELECT,
		input isEqual,
		input en,
		input [31:0]PC
		);
		
		assign IN_PC = (en == 0)? PC:(PC_SELECT == 2'b01 && isEqual == 1)?PC_BEQ:
							(PC_SELECT == 2'b10)? PC_JAL:
							(PC_SELECT == 2'b11)? RD1: PC4;
		
endmodule
