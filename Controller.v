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
		output[2:0]PC_SELECT,
		output[1:0]RegDst,
		output MemWrite,
		output [1:0] MemtoReg,
		output MemRead,
		output EXTop,
		output ALUSrc,
		output [2:0] ALU_SELECT,
		input [4:0]rt,
		output [2:0]Multiop,
		output start,
		output M_sh,
		output M_sb,
		output [2:0]DMextop
    );
		wire  addu,subu, ori, lw, sw, beq, lui, jal, jr, nop,j;
		wire lb,lbu,lh,lhu,sb,sh,add,sub,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav;
		wire andd,orr,xorr,norr,addi,addiu,andi,xori,slt,slti,sltiu,sltu,bne,blez,bgtz,bltz,bgez;
		wire jalr,mfhi,mflo,mthi,mtlo;
		
		
		assign bltz = (op == 6'b000001 && rt == 5'b00000)?1:0;
		assign bgez = (op == 6'b000001 && rt == 5'b00001)?1:0;
		
		assign jalr = (op == 6'b000000 && func == 6'b001001)?1:0;
		assign mfhi = (op == 6'b000000 && func == 6'b010000)?1:0;
		assign mflo = (op == 6'b000000 && func == 6'b010010)?1:0;
		assign mthi = (op == 6'b000000 && func == 6'b010001)?1:0;
		assign mtlo = (op == 6'b000000 && func == 6'b010011)?1:0;
		
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
		
		assign lb = (op == 6'b100000) ?  1 :0;
		assign lbu = (op == 6'b100100) ? 1:0;
		assign lh = (op == 6'b100001)?1:0;
		assign lhu = (op == 6'b100101)?1:0;
		assign sb = (op == 6'b101000)?1:0;
		assign sh =(op == 6'b101001)?1:0;
		assign add = (op == 6'b000000 && func == 6'b100000)?1:0;
		assign sub = (op == 6'b000000 && func == 6'b100010)?1:0;
		assign mult = (op == 6'b000000 && func ==6'b011000)?1:0;
		assign multu=(op == 6'b000000 && func == 6'b011001)?1:0;
		assign div = (op == 6'b000000 && func == 6'b011010)?1:0;
		assign divu = (op== 6'b000000 && func == 6'b011011)?1:0;
		assign sll = (op == 6'b000000 && func == 6'b000000)?1:0;
		assign srl = (op == 6'b000000 && func == 6'b000010)?1:0;
		assign sra = (op == 6'b000000 && func == 6'b000011)?1:0;
		assign sllv = (op == 6'b000000 && func == 6'b000100)?1:0;
		assign srlv = (op == 6'b000000 && func == 6'b000110)?1:0;
		assign srav = (op == 6'b000000 && func == 6'b000111)?1:0;
		assign andd = (op == 6'b000000 && func == 6'b100100)?1:0;
		assign orr = (op == 6'b000000 && func == 6'b100101)?1:0;
		assign xorr = (op == 6'b000000 && func == 6'b100110)?1:0;
		assign norr = (op == 6'b000000 && func == 6'b100111)?1:0;
		assign addi = (op == 6'b001000)?1:0;
		assign addiu = (op == 6'b001001)?1:0;
		assign andi = ( op == 6'b001100)?1:0;
		assign xori = (op == 6'b001110)?1:0;
		assign slt = (op == 6'b000000 && func == 6'b101010 )?1:0;
		assign slti = (op == 6'b001010) ? 1:0;
		assign sltiu = (op == 6'b001011)?1:0;
		assign sltu = (op == 6'b000000 && func == 6'b101011)?1:0;
		assign bne = (op == 6'b000101)?1:0;
		assign blez = ( op == 6'b000110)?1:0;
		assign bgtz = (op == 6'b000111)?1:0;
		
		
		
		assign M_sh = sh;
		assign M_sb = sb;
		
		//’‚¿Ô
		assign RegWrite = lb|| addu || subu || lui || lw || ori || jal;
		
		
		assign PC_SELECT = beq ? 3'b001:
								(jal || j )? 3'b010:
								jr ? 3'b011:3'b000;
		
		
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
									
									
		assign Multiop = (mult)? 3'b000 : 
								multu? 3'b001 :
								div ?  3'b010:
								divu ? 3'b011:
								mthi ? 3'b100:
								mtlo ? 3'b101:
								mflo ? 3'b110:
								mfhi ? 3'b111:0;
		assign start = (mult || multu || div || divu) ? 1:0;
		
		assign DMextop = ( lb )? 3'b001:
								( lbu)?3'b010:
								lh ? 3'b011:
								lhu? 3'b100:0;
		
endmodule
