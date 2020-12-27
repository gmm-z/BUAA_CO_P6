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
		reg [31:0] Instruction [4095:0];
		// 32bit ¡Á 4096£¬4096¸öÖ¸Áî

		initial begin
			$readmemh("code.txt",Instruction);
		end
		
		assign Instr = Instruction[ PC[31:2] - (32'h0000_3000 >> 2)];
endmodule
