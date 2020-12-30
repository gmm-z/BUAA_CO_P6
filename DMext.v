`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:57:58 12/30/2020 
// Design Name: 
// Module Name:    DMext 
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
module DMext(
		input [31:0] Memout,
		input [2:0] DMextop,
		input [31:0] MemAddr,
		output reg[31:0] out
    );
		wire [1:0] Addr = MemAddr[1:0];
	 
		always@*begin
			case(DMextop)
				3'b000: out<=  Memout;
				3'b001: begin
				//lb
					case(Addr)
						2'b00:
						begin
							out <= { {24{Memout[7]}},Memout[7:0]};
						end
						2'b01: out <= {{24{Memout[15]}},Memout[15:8] };
						2'b10: out <= { {24{Memout[23]}},Memout[23:16] };
						2'b11: out <= { {24{Memout[31]}},Memout[31:24]};
					endcase
				end
				3'b010:
				//lbu
				begin
					case(Addr)
						2'b00:
						begin
							out <= { {24'b0},Memout[7:0]};
						end
						2'b01: out <= {24'b0,Memout[15:8] };
						2'b10: out <= { 24'b0,Memout[23:16] };
						2'b11: out <= { 24'b0,Memout[31:24]};
					endcase
				end
				3'b011:
				//lh
				begin
					case(Addr[1])
						1'b0:begin
							out <= {{16{Memout[15]}},Memout[15:0] };
						end
						1'b1:begin
							out <= {{16{Memout[31]}},Memout[31:16]};
						end
					endcase
				end
				3'b100:
				//lhu
				begin
					case(Addr[1])
						1'b0: out <= {16'b0,Memout[15:0]};
						1'b1: out <= {16'b0,Memout[31:16]};
					endcase
				end
			endcase
		end
endmodule
