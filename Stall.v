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
		input [4:0]EX_RegAddr_o
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
		
		assign ID_Tnew_i = (D_addu || D_subu || D_ori || D_lui || D_jal)? 1:
									(D_lw ) ? 2: 0;
		
		assign Tuse_rs = (D_beq || D_jr) ? 0:(D_addu || D_subu || D_ori || D_lw || D_sw) ? 1 : 3;
		assign Tuse_rt =  (D_beq) ? 0: 
								(D_addu || D_subu) ? 1 : 
								(D_sw )? 2 : 3;

		wire stall_rs,stall_rt;
		assign stall_rs = ( (EX_RegAddr_o == D_rs && EX_RegAddr_o != 0 && Tuse_rs < EX_Tnew_o ) || (MEM_RegAddr_o == D_rs && MEM_RegAddr_o !=0 && Tuse_rs < MEM_Tnew_o) )? 1 : 0; 
		assign stall_rt =( (EX_RegAddr_o == D_rt && EX_RegAddr_o != 0 && Tuse_rt < EX_Tnew_o ) || (MEM_RegAddr_o == D_rt && MEM_RegAddr_o !=0 && Tuse_rt < MEM_Tnew_o) )? 1 : 0; 
		assign en_PC = (stall_rs || stall_rt) ? 0:1;
		assign en_IFtoID = (stall_rs || stall_rt) ? 0:1;
		assign en_IDtoEX = (stall_rs || stall_rt) ? 0:1;
endmodule
