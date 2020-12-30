`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:02:35 12/28/2020 
// Design Name: 
// Module Name:    Multi 
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
module Multi(
		input clk,
		input reset,
		input [31:0] rs,
		input [31:0] rt,
		input [2:0]Multiop,
		input start,
		output reg busy,
		output [31:0] hi,
		output [31:0] low
    );
		reg [31:0]HI;
		reg [31:0]LOW;
		
		assign hi = HI;
		assign low = LOW;
		reg [31:0]cycles;
		reg [63:0]tmp;
		
		initial begin
			HI<=0;
			LOW<=0;
			cycles <=0;
			busy <=0;
		end
		
		always@(posedge clk) begin
			if(reset)begin
				HI<=0;
				LOW<=0;
				cycles <=0;
				busy <=0;
			end 
			else if(!busy)begin
				if(start)begin
					case(Multiop)
						3'b000:begin
						//mult
							tmp <=   $signed(rs) * $signed(rt);
							cycles <= 5;
						end
						3'b001:begin
						//multu
							tmp <= rs*rt;
							cycles <= 5;
						end
						3'b010:begin
						//div
							tmp<={$signed(rs)%$signed(rt),$signed(rs)/$signed(rt)};
							cycles <= 10;
						end
						3'b011:begin
						//divu
							tmp <= {rs%rt,rs/rt};
							cycles <= 10;
						end
					endcase
					busy <= 1;
				end
				if(Multiop == 3'b100)begin
				//mthi
					HI <= rs;
				end 
				if(Multiop == 3'b101)begin
				//mtlo	
					LOW <= rs;
				end
			end
			else if(busy)begin
				if(cycles > 0)begin
					cycles = cycles - 1;
					if(cycles == 0)begin
						{HI,LOW} <= tmp;
						busy <= 0;
					end
				end
			end
		end
	

endmodule
