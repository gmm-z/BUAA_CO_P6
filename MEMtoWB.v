`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:30:15 12/04/2020 
// Design Name: 
// Module Name:    MEMtoWB 
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
module MEMtoWB(
	 input clk,
    input reset,
    input en,
    input [31:0] MEM_Instr_i,
	 input [31:0] MEM_PC_i,
    input [31:0] MEM_PC4_i,
    input [31:0] MEM_PC8_i,
    input [31:0] MEM_ALUout_i,
    input [31:0] MEM_DM_i,
	 input [4:0] MEM_RegAddr_i,
	 output reg[4:0] WB_RegAddr_o,
    output reg[31:0] WB_Instr_o,
	 output reg[31:0] WB_PC_o,
    output reg[31:0] WB_PC4_o,
    output reg[31:0] WB_PC8_o,
    output reg[31:0] WB_ALUout_o,
    output reg[31:0] WB_MemData_o
    );

	 initial begin
		WB_Instr_o <= 0;
		WB_RegAddr_o <= 0;
	 end
	 
	 always@(posedge clk)begin
		if(reset)begin
			WB_Instr_o <= 0;
		end
		else if(en)begin
			WB_RegAddr_o <= MEM_RegAddr_i;
			WB_Instr_o <= MEM_Instr_i;
			WB_PC_o <= MEM_PC_i;
			WB_PC4_o <= MEM_PC4_i;
			WB_PC8_o <= MEM_PC8_i;
			WB_ALUout_o <= MEM_ALUout_i;
			WB_MemData_o <= MEM_DM_i;
		end
	 end
endmodule
