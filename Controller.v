`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:50:45 11/15/2020 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
		input [5:0]op,
		input [5:0]func,
		output RegWrite,
		output[1:0]PC_SELECT,
		output[1:0]RegDst,
		output MemWrite,
		output [1:0] MemtoReg,
		output MemRead,
		output EXTop,
		output ALUSrc,
		output [2:0] ALU_SELECT
    );
		wire  addu,subu, ori, lw, sw, beq, lui, jal, jr, nop,j;
		
		assign addu = (op == 6'b000000 && func == 6'b100001)?1:0;
		assign subu = (op == 6'b000000 && func == 6'b100011)?1:0;
		assign ori =  (op == 6'b001101) ? 1:0;
		assign lw =   (op == 6'b100011) ? 1:0;
		assign sw =   (op == 6'b101011) ? 1:0;
		assign beq =  (op == 6'b000100) ? 1:0;
		assign lui =  (op == 6'b001111) ? 1:0;
		assign jal =  (op == 6'b000011) ? 1:0;
		assign jr  =  (op == 6'b000000 && func == 6'b001000) ? 1:0;
		assign nop =  (op == 6'b000000 && func == 6'b000000) ? 1:0;
		assign j = (op == 6'b000010) ? 1:0;
		
		assign RegWrite = addu || subu || lui || lw || ori || jal;
		assign PC_SELECT = beq ? 2'b01:
								(jal || j )? 2'b10:
								jr ? 2'b11:2'b00;
		assign RegDst = (addu || subu) ? 2'b01:
								jal ? 2'b10 : 2'b00;
		assign MemWrite = sw ? 1 : 0;
		assign MemtoReg = lw ? 2'b01:
								jal ? 2'b11: 2'b00;
		assign MemRead = lw ? 1 : 0;
		assign EXTop = ori ? 1: 0;
		assign ALUSrc = ori || sw || lw || lui;
		assign ALU_SELECT = (addu || sw || lw) ? 3'b010:
									subu ? 3'b011:
									ori ? 3'b001:
									lui? 3'b100:0;
		
		
		
		
endmodule
