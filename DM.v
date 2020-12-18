`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:30:49 11/15/2020 
// Design Name: 
// Module Name:    DM 
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
module DM(
		input clk,
		input reset,
		input MemWrite,
		input MemRead,
		input [31:0] MemAddr, 
		input [31:0] MemData,
		input [31:0] PC,
		output [31:0] MemOut
    );
		reg [31:0] memory [1023:0];
		
		integer i;
		
		initial begin
			for(i=0; i < 1024 ; i= i+1)begin
				memory[i] <= 0;
			end
		end
	
		assign MemOut = MemRead ? memory[MemAddr[11:2]] : 0;
	
		always@(posedge clk)begin
			if(reset) begin
				for(i=0; i < 1024 ; i= i+1)begin
					memory[i] <= 0;
				end
			end else if(MemWrite)begin
				memory[MemAddr[11:2]] <= MemData;
				$display("%d@%h: *%h <= %h",$time,PC, MemAddr, MemData);
			end 
		end

endmodule
