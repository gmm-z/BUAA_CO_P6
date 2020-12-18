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
		wire  D_addu,D_subu, D_ori, D_lw, D_sw, D_beq, D_lui,D_jal, D_jr, D_nop,D_j;
		
		assign D_addu = (D_op == 6'b000000 && D_func == 6'b100001)?1:0;
		assign D_subu = (D_op == 6'b000000 && D_func == 6'b100011)?1:0;
		assign D_ori =  (D_op == 6'b001101) ? 1:0;
		assign D_lw =   (D_op == 6'b100011) ? 1:0;
		assign D_sw =   (D_op == 6'b101011) ? 1:0;
		assign D_beq =  (D_op == 6'b000100) ? 1:0;
		assign D_lui =  (D_op == 6'b001111) ? 1:0;
		assign D_jal =  (D_op == 6'b000011) ? 1:0;
		assign D_jr  =  (D_op == 6'b000000 && D_func == 6'b001000) ? 1:0;
		assign D_nop =  (D_op == 6'b000000 && D_func == 6'b000000) ? 1:0;
		assign D_j = (D_op == 6'b000010) ? 1:0;
		
		
		
		
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
		wire  E_addu,E_subu, E_ori, E_lw, E_sw, E_beq, E_lui,E_jal, E_jr, E_nop,E_j;
		
		assign E_addu = (E_op == 6'b000000 && E_func == 6'b100001)?1:0;
		assign E_subu = (E_op == 6'b000000 && E_func == 6'b100011)?1:0;
		assign E_ori =  (E_op == 6'b001101) ? 1:0;
		assign E_lw =   (E_op == 6'b100011) ? 1:0;
		assign E_sw =   (E_op == 6'b101011) ? 1:0;
		assign E_beq =  (E_op == 6'b000100) ? 1:0;
		assign E_lui =  (E_op == 6'b001111) ? 1:0;
		assign E_jal =  (E_op == 6'b000011) ? 1:0;
		assign E_jr  =  (E_op == 6'b000000 && E_func == 6'b001000) ? 1:0;
		assign E_nop =  (E_op == 6'b000000 && E_func == 6'b000000) ? 1:0;
		assign E_j = (E_op == 6'b000010) ? 1:0;
		
		
		wire [5:0]M_op;
		wire [5:0]M_func;
		wire [4:0]M_rs;
		wire [4:0]M_rt;
		wire [4:0]M_rd;
		assign M_op = MEM_Instr_o[31:26];
		assign M_rs = MEM_Instr_o[25:21];
		assign M_rt = MEM_Instr_o[20:16];
		assign M_rd = MEM_Instr_o[15:11];
		assign M_func = MEM_Instr_o[5:0];
		wire  M_addu,M_subu, M_ori, M_lw, M_sw, M_beq, M_lui,M_jal, M_jr, M_nop,M_j;
		
		assign M_addu = (M_op == 6'b000000 && M_func == 6'b100001)?1:0;
		assign M_subu = (M_op == 6'b000000 && M_func == 6'b100011)?1:0;
		assign M_ori =  (M_op == 6'b001101) ? 1:0;
		assign M_lw =   (M_op == 6'b100011) ? 1:0;
		assign M_sw =   (M_op == 6'b101011) ? 1:0;
		assign M_beq =  (M_op == 6'b000100) ? 1:0;
		assign M_lui =  (M_op == 6'b001111) ? 1:0;
		assign M_jal =  (M_op == 6'b000011) ? 1:0;
		assign M_jr  =  (M_op == 6'b000000 && M_func == 6'b001000) ? 1:0;
		assign M_nop =  (M_op == 6'b000000 && M_func == 6'b000000) ? 1:0;
		assign M_j = (M_op == 6'b000010) ? 1:0;
		
		wire M_RegWrite;
		assign M_RegWrite = M_addu || M_subu || M_lui || M_lw || M_ori || M_jal;
		
		assign D_RD1_forward = ((MEM_RegAddr_o == D_rs) && (MEM_RegAddr_o != 0) && M_RegWrite && M_jal == 0) ? MEM_ALUout_o:
										((MEM_RegAddr_o == D_rs) && (MEM_RegAddr_o != 0) && M_RegWrite && M_jal == 1) ? MEM_PC8_o:
										((WB_RegAddr_o == D_rs) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData:D_RD1;
										
		assign D_RD2_forward = ((MEM_RegAddr_o == D_rt) && (MEM_RegAddr_o != 0) && M_RegWrite && M_jal == 0) ? MEM_ALUout_o:
										((MEM_RegAddr_o == D_rt) && (MEM_RegAddr_o != 0) && M_RegWrite && M_jal == 1) ? MEM_PC8_o:
										((WB_RegAddr_o == D_rt) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData:D_RD2;
		
		assign EX_RD1_o_forward = ((MEM_RegAddr_o == E_rs) && (MEM_RegAddr_o != 0) && M_RegWrite && M_jal == 0) ? MEM_ALUout_o:
										((MEM_RegAddr_o == E_rs) && (MEM_RegAddr_o != 0) && M_RegWrite && M_jal == 1) ? MEM_PC8_o:
										((WB_RegAddr_o == E_rs) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData : EX_RD1_o;
										
		assign EX_RD2_o_forward = ((MEM_RegAddr_o == E_rt) && (MEM_RegAddr_o != 0) && M_RegWrite && M_jal == 0) ? MEM_ALUout_o:
										((MEM_RegAddr_o == E_rt) && (MEM_RegAddr_o != 0) && M_RegWrite && M_jal == 1) ? MEM_PC8_o:
										((WB_RegAddr_o == E_rt) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData : EX_RD2_o;
										
		assign M_MemData_forward = ((WB_RegAddr_o == M_rt) && (WB_RegAddr_o != 0) && W_RegWrite) ? W_RegData : M_MemData;
endmodule
