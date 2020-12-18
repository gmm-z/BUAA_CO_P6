`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:45:51 11/15/2020 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
		input [15:0] imm16,
		input EXTop,
		output [31:0] EXTout
    );
	 
	
		assign EXTout = (EXTop == 1) ? {{16{1'b0}},imm16} : {{16{imm16[15]}},imm16};

endmodule
