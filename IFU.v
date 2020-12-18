`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:34 11/15/2020 
// Design Name: 
// Module Name:    IFU 
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
module IFU(
		input clk,
		input reset,
		input [31:0] IN_PC,
		output [31:0] PC,
		output [31:0] Instr
    );
	 
		reg [31:0] PC_Reg;
		
		initial begin
			PC_Reg <= 32'h00003000 ;
		end
		
		
		IM IM (
			.PC(PC), 
			.Instr(Instr)
		);
		
		assign PC = PC_Reg;
		
		always @(posedge clk)begin
			if(reset)begin
				PC_Reg <= 32'h00003000;
			end else begin
				PC_Reg <= IN_PC;
			end
		
		end
endmodule
