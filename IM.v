`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:47:37 11/15/2020 
// Design Name: 
// Module Name:    IM 
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
module IM(
		input [31:0] PC,
		output [31:0] Instr
    );
		reg [31:0] Instruction [1023:0];
		// 32bit ¡Á 1024£¬1024¸öÖ¸Áî

		initial begin
			$readmemh("code.txt",Instruction);
		end
		
		assign Instr = Instruction[PC[11:2]];
endmodule
