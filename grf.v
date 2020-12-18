`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:23:29 11/15/2020 
// Design Name: 
// Module Name:    grf 
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
module grf(
		input clk,
		input reset,
		input [4:0]A1,
		input [4:0]A2,
		input [4:0]RegAddr,
		input [31:0]RegData,
		input RegWrite,
		input [31:0]PC,
		output [31:0] RD1,
		output [31:0] RD2
    );
	 
	 
		// 定义寄存器
		reg [31:0] register [31:0];
		integer i;
		
		// 初始化
		initial begin
			for(i = 0; i < 32; i=i+1)
				register[i] <= 0;
		end
	 
	 
		//组合逻辑建模
		assign RD1 = register[A1];
		assign RD2 = register[A2];
	 
		always @(posedge clk)begin
			if(reset) begin
				for(i = 0; i < 32; i=i+1)
				register[i] <= 0;
			end else if(RegWrite && RegAddr != 5'b00000) begin
				
				register[RegAddr] <= RegData;
				
				$display("%d@%h: $%d <= %h",$time,PC,RegAddr,RegData);
			end
		
		end
		
		
endmodule
