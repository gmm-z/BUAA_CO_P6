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
		output [31:0] MemOut,
		input sh,
		input sb
    );
		reg [31:0] memory [4095:0];
		
		integer i;
		
		initial begin
			for(i=0; i < 4096 ; i= i+1)begin
				memory[i] <= 0;
			end
		end
	
		assign MemOut = MemRead ? memory[MemAddr[31:2]] : 0;
	
		always@(posedge clk)begin
			if(reset) begin
				for(i=0; i < 4096 ; i= i+1)begin
					memory[i] <= 0;
				end
			end else if(MemWrite)begin
				if(sh)begin
					if(MemAddr[1] == 1'b1)begin
						memory[MemAddr[31:2]][31:16] <= MemData[15:0];
						$display("%d@%h: *%h <= %h",$time,PC, {MemAddr[31:2],2'b00 }, { MemData[15:0] , memory[MemAddr[31:2]][15:0]});
					end
					if(MemAddr[1] == 1'b0)begin
						memory[MemAddr[31:2]][15:0] <= MemData[15:0];
						$display("%d@%h: *%h <= %h",$time,PC, {MemAddr[31:2],2'b00 }, { memory[MemAddr[31:2]][31:16], MemData[15:0] });
					end
				end 
				else if(sb)begin
					case(MemAddr[1:0])
						2'b00: begin
							memory[MemAddr[13:2]][7:0] <= MemData[7:0];
							//因为是非阻塞赋值，所以下面需要自己更改内容。
							$display("%d@%h: *%h <= %h",$time,PC,{MemAddr[31:2],2'b00},{memory[MemAddr[13:2]][31:8],MemData[7:0]});
						end
						2'b01: begin
							memory[MemAddr[13:2]][15:8] <= MemData[7:0];
							$display("%d@%h: *%h <= %h",$time,PC,{MemAddr[31:2],2'b00},{memory[MemAddr[13:2]][31:16],MemData[7:0],memory[MemAddr[13:2]][7:0]});
						end
						2'b10: begin
							memory[MemAddr[13:2]][23:16] <= MemData[7:0];
							$display("%d@%h: *%h <= %h",$time,PC,{MemAddr[31:2],2'b00},{memory[MemAddr[13:2]][31:24],MemData[7:0],memory[MemAddr[13:2]][15:0]});
						end
						2'b11: begin
							memory[MemAddr[13:2]][31:24] <= MemData[7:0];
							$display("%d@%h: *%h <= %h",$time,PC,{MemAddr[31:2],2'b00},{MemData[7:0],memory[MemAddr[13:2]][23:0]});
						end
					endcase
				end else begin
					memory[MemAddr[31:2]] <= MemData;
					$display("%d@%h: *%h <= %h",$time,PC, MemAddr, MemData);
				end
			end 
		end

endmodule
