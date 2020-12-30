`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:11:35 12/10/2020 
// Design Name: 
// Module Name:    Stall 
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
module Stall(
		input [31:0]ID_Instr_o,
		output [1:0] Tuse_rs,
		output [1:0] Tuse_rt,
		output [1:0]ID_Tnew_i,
		input [1:0] EX_Tnew_o,
		input [1:0] MEM_Tnew_o,
		input [31:0]D_RD1_forward,
		input [31:0]D_RD2_forward,
		input [31:0] D_RD1,
		input [31:0] D_RD2,
		output en_PC,
		output en_IFtoID,
		output en_IDtoEX,
		input [4:0]MEM_RegAddr_o,
		input [4:0]EX_RegAddr_o,
		input start,
		input busy
    );
		
		//以下都是D级指令
		wire [5:0]op;
		wire [5:0]func;
		wire [4:0]rs;
		wire [4:0]rt;
		wire [4:0]rd;
		assign op = ID_Instr_o[31:26];
		assign rs = ID_Instr_o[25:21];
		assign rt = ID_Instr_o[20:16];
		assign rd = ID_Instr_o[15:11];
		assign func = ID_Instr_o[5:0];
		
		wire  addu,subu, ori, lw, sw, beq, lui,jal, jr, nop,j;
		wire stall_rs,stall_rt;
		wire lb,lbu,lh,lhu,sb,sh,add,sub,mult,multu,div,divu,sll,srl,sra,sllv,srlv,srav;
		wire andd,orr,xorr,norr,addi,addiu,andi,xori,slt,slti,sltiu,sltu,bne,blez,bgtz,bltz,bgez;
		wire jalr,mfhi,mflo,mthi,mtlo;
		
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
		
		
		assign bltz = (op == 6'b000001 && rt == 5'b00000)?1:0;
		assign bgez = (op == 6'b000001 && rt == 5'b00001)?1:0;
		
		assign jalr = (op == 6'b000000 && func == 6'b001001)?1:0;
		assign mfhi = (op == 6'b000000 && func == 6'b010000)?1:0;
		assign mflo = (op == 6'b000000 && func == 6'b010010)?1:0;
		assign mthi = (op == 6'b000000 && func == 6'b010001)?1:0;
		assign mtlo = (op == 6'b000000 && func == 6'b010011)?1:0;
		
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
		//以上是D级的指令翻译
		
		//需要进行改动
		assign ID_Tnew_i = (addu || subu || ori || lui || jal)? 1:
									(lw ) ? 2: 0;
		
		assign Tuse_rs = (beq || jr) ? 0:(addu || subu || ori || lw || sw) ? 1 : 3;
		assign Tuse_rt =  (beq) ? 0: 
								(addu || subu) ? 1 : 
								(sw )? 2 : 3;

		
		assign stall_rs = ( (EX_RegAddr_o == rs && EX_RegAddr_o != 0 && Tuse_rs < EX_Tnew_o ) || (MEM_RegAddr_o == rs && MEM_RegAddr_o !=0 && Tuse_rs < MEM_Tnew_o) )? 1 : 0; 
		assign stall_rt =( (EX_RegAddr_o == rt && EX_RegAddr_o != 0 && Tuse_rt < EX_Tnew_o ) || (MEM_RegAddr_o == rt && MEM_RegAddr_o !=0 && Tuse_rt < MEM_Tnew_o) )? 1 : 0; 
		assign en_PC = (stall_rs || stall_rt) || busy || start ? 0:1;
		assign en_IFtoID = (stall_rs || stall_rt) || busy || start? 0:1;
		assign en_IDtoEX = (stall_rs || stall_rt) || busy || start? 0:1;
endmodule
