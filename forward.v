`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:10:14 12/10/2020 
// Design Name: 
// Module Name:    forward 
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
module forward(
		input [31:0]ID_Instr_o,
		input [31:0]EX_Instr_o,
		input [31:0]MEM_Instr_o,
		input [31:0]WB_Instr_o,
		input [4:0]MEM_RegAddr_o,
		input [4:0]WB_RegAddr_o,
		input [31:0]D_RD1,
		input [31:0]D_RD2,
		input [31:0]MEM_ALUout_o,
		input [31:0]W_RegData,
		input W_RegWrite,
		input [31:0]MEM_PC8_o,
		input [31:0]EX_RD1_o,
		input [31:0]EX_RD2_o,
		input [31:0]M_MemData,
		output [31:0]D_RD1_forward,
		output [31:0]D_RD2_forward,
		output [31:0]EX_RD1_o_forward,
		output [31:0]EX_RD2_o_forward,
		output [31:0]M_MemData_forward
    );

		wire [5:0]D_op;
		wire [5:0]D_func;
		wire [4:0]D_rs;
		wire [4:0]D_rt;
		wire [4:0]D_rd;
		assign D_op = ID_Instr_o[31:26];
		assign D_rs = ID_Instr_o[25:21];
		assign D_rt = ID_Instr_o[20:16];
		assign D_rd = ID_Instr_o[15:11];
		assign D_func = ID_Instr_o[5:0];	
		
		wire [5:0]E_op;
		wire [5:0]E_func;
		wire [4:0]E_rs;
		wire [4:0]E_rt;
		wire [4:0]E_rd;
		assign E_op = EX_Instr_o[31:26];
		assign E_rs = EX_Instr_o[25:21];
		assign E_rt = EX_Instr_o[20:16];
		assign E_rd = EX_Instr_o[15:11];
		assign E_func = EX_Instr_o[5:0];
	
	
		wire [5:0]op;
		wire [5:0]func;
		wire [4:0]rs;
		wire [4:0]rt;
		wire [4:0]rd;
		assign op = MEM_Instr_o[31:26];
		assign rs = MEM_Instr_o[25:21];
		assign rt = MEM_Instr_o[20:16];
		assign rd = MEM_Instr_o[15:11];
		assign func = MEM_Instr_o[5:0];
		wire addu,subu, ori, lw, sw, beq, lui,jal, jr, nop,j;
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
		//以上是M级的指令翻译
		
		
		wire M_RegWrite;
		
		
		//这个地方比较重要，需要改动
		assign M_RegWrite = addu || subu || lui || lw || ori || jal;
		
		assign D_RD1_forward = ((MEM_RegAddr_o == D_rs) && (MEM_RegAddr_o != 0) && M_RegWrite && jal == 0) ? MEM_ALUout_o:
										((MEM_RegAddr_o == D_rs) && (MEM_RegAddr_o != 0) && M_RegWrite && jal == 1) ? MEM_PC8_o:
										((WB_RegAddr_o == D_rs) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData:D_RD1;
										
		assign D_RD2_forward = ((MEM_RegAddr_o == D_rt) && (MEM_RegAddr_o != 0) && M_RegWrite && jal == 0) ? MEM_ALUout_o:
										((MEM_RegAddr_o == D_rt) && (MEM_RegAddr_o != 0) && M_RegWrite && jal == 1) ? MEM_PC8_o:
										((WB_RegAddr_o == D_rt) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData:D_RD2;
		
		assign EX_RD1_o_forward = ((MEM_RegAddr_o == E_rs) && (MEM_RegAddr_o != 0) && M_RegWrite && jal == 0) ? MEM_ALUout_o:
										((MEM_RegAddr_o == E_rs) && (MEM_RegAddr_o != 0) && M_RegWrite && jal == 1) ? MEM_PC8_o:
										((WB_RegAddr_o == E_rs) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData : EX_RD1_o;
										
		assign EX_RD2_o_forward = ((MEM_RegAddr_o == E_rt) && (MEM_RegAddr_o != 0) && M_RegWrite && jal == 0) ? MEM_ALUout_o:
										((MEM_RegAddr_o == E_rt) && (MEM_RegAddr_o != 0) && M_RegWrite && jal == 1) ? MEM_PC8_o:
										((WB_RegAddr_o == E_rt) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData : EX_RD2_o;
										
		assign M_MemData_forward = ((WB_RegAddr_o == rt) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData : M_MemData;
		
		
endmodule
