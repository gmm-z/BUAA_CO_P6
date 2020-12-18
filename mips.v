`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:09:17 11/15/2020 
// Design Name: 
// Module Name:    mips 
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
module mips(clk,reset);	
		//---------
		input clk;
		input reset;
		
		wire [31:0] IN_PC;
		wire [31:0] IF_PC_i;
		wire [31:0] IF_Instr_i;
		wire [31:0] IF_PC_i_4;
		assign IF_PC_i_4 = IF_PC_i + 4;
		
		wire [31:0] ID_PC_o;
		wire [31:0] ID_Instr_o;
		wire [31:0] ID_PC4_o;
		wire [31:0] ID_PC8_o;
		
		wire en;
		assign en = 1;
		
		IFU IFU (
			.clk(clk), 
			.reset(reset), 
			.IN_PC(IN_PC), 
			.PC(IF_PC_i), 
			.Instr(IF_Instr_i)
		);
		
		wire en_IFtoID;
		IFtoID IFtoID (
			.clk(clk), 
			.reset(reset), 
			.en(en_IFtoID), 
			.IF_Instr_i(IF_Instr_i), 
			.IF_PC_i(IF_PC_i),  
			.ID_PC_o(ID_PC_o),
			.ID_Instr_o(ID_Instr_o), 
			.ID_PC4_o(ID_PC4_o), 
			.ID_PC8_o(ID_PC8_o)
		);
		
		wire [5:0] D_op;	
		wire [4:0] D_rs;
		wire [4:0] D_rt;
		wire [4:0] D_rd;
		wire [5:0] D_func;
		wire [15:0]D_imm16;

		assign D_func = ID_Instr_o[5:0];
		assign D_op = ID_Instr_o[31:26];
		assign D_imm16 = ID_Instr_o[15:0];
		assign D_rs = ID_Instr_o[25:21];
		assign D_rt = ID_Instr_o[20:16];
		assign D_rd = ID_Instr_o[15:11];
	
		wire [31:0] D_RD1_forward;
		wire [31:0] D_RD1;
		wire [31:0] D_RD2_forward;
		wire [31:0] D_RD2;
		
		//assign D_RD1_forward = D_RD1;  // <----------------------------
		wire [31:0] W_RegData;
		wire W_RegWrite;
		wire [4:0]WB_RegAddr_o;
		
		wire [31:0]WB_PC_o;
		grf grf (
			.clk(clk), 
			.reset(reset), 
			.A1(D_rs), 
			.A2(D_rt), 
			.RegAddr(WB_RegAddr_o), 
			.RegData(W_RegData), 
			.RegWrite(W_RegWrite), 
			.PC(WB_PC_o), 
			.RD1(D_RD1), 
			.RD2(D_RD2)
		);
		
		wire [31:0] ID_Instr_i;
		wire [31:0] ID_PC_i;
		wire [31:0] ID_PC4_i;
		wire [31:0] ID_PC8_i;
		wire [31:0] ID_RD1_i;
		wire [31:0] ID_RD2_i;
		wire [31:0] ID_EXTout_i;
		wire [4:0] ID_RegAddr_i;
		wire [4:0] EX_RegAddr_o;
		wire [31:0] EX_Instr_o;
		wire [31:0] EX_PC_o;
		wire [31:0] EX_PC4_o;
		wire [31:0] EX_PC8_o;
		wire [31:0] EX_RD1_o;
		wire [31:0] EX_RD2_o;
		wire [31:0] EX_EXTout_o;
		
		assign ID_Instr_i = ID_Instr_o;
		assign ID_PC_i = ID_PC_o;
		assign ID_PC4_i = ID_PC4_o;
		assign ID_PC8_i = ID_PC8_o;
		assign ID_RD1_i = D_RD1_forward;
		assign ID_RD2_i = D_RD2_forward;
		
		wire [1:0] D_RegDst;
		wire D_EXTop;
		wire [1:0] PC_SELECT;
		Controller D_Controller (
			.op(D_op), 
			.func(D_func), 
			.RegDst(D_RegDst),
			.EXTop(D_EXTop),
			.PC_SELECT(PC_SELECT)
		);
		
		MUX_RegAddr D_MUX_RegAddr (
			.RegDst(D_RegDst), 
			.rt(D_rt), 
			.rd(D_rd), 
			.RegAddr(ID_RegAddr_i)
		);
		
		EXT D_EXT (
			.imm16(D_imm16), 
			.EXTop(D_EXTop), 
			.EXTout(ID_EXTout_i)
		);
		
		wire isEqual;
		
		ALU D_CMP (
			 .A(D_RD1_forward), 
			 .B(D_RD2_forward), 
			 .isEqual(isEqual)
		 );
		 
		wire [1:0]ID_Tnew_i;
		wire [1:0]EX_Tnew_o;
		
		wire en_IDtoEX;
		IDtoEX IDtoEX (
			.clk(clk), 
			.reset(reset), 
			.en(en_IDtoEX), 
			 .ID_Instr_i(ID_Instr_i), 
			 .ID_PC_i(ID_PC_i), 
			 .ID_PC4_i(ID_PC4_i), 
			 .ID_PC8_i(ID_PC8_i), 
			 .ID_RD1_i(ID_RD1_i), 
			 .ID_RD2_i(ID_RD2_i), 
			 .ID_EXTout_i(ID_EXTout_i), 
			 .ID_RegAddr_i(ID_RegAddr_i), 
			 .ID_Tnew_i(ID_Tnew_i),
			 .EX_Tnew_o(EX_Tnew_o),
			 .EX_RegAddr_o(EX_RegAddr_o), 
			 .EX_Instr_o(EX_Instr_o), 
			 .EX_PC_o(EX_PC_o), 
			 .EX_PC4_o(EX_PC4_o), 
			 .EX_PC8_o(EX_PC8_o), 
			.EX_RD1_o(EX_RD1_o), 
			.EX_RD2_o(EX_RD2_o), 
			.EX_EXTout_o(EX_EXTout_o)
		);
		
		
		
		wire [5:0] E_op;	
		wire [4:0] E_rs;
		wire [4:0] E_rt;
		wire [4:0] E_rd;
		wire [5:0] E_func;
		wire [15:0]E_imm16;
		
		assign E_func = EX_Instr_o[5:0];
		assign E_op = EX_Instr_o[31:26];
		assign E_imm16 = EX_Instr_o[15:0];
		assign E_rs = EX_Instr_o[25:21];
		assign E_rt = EX_Instr_o[20:16];
		assign E_rd = EX_Instr_o[15:11];
		
		wire E_ALUSrc;
		wire [2:0]E_ALU_SELECT;
		wire [31:0] E_ALU_IN;
		
		Controller E_Controller(
			.op(E_op), 
			.func(E_func), 
			.ALUSrc(E_ALUSrc), 
			.ALU_SELECT(E_ALU_SELECT)
		);	
		wire [31:0]EX_RD2_o_forward;
		
		MUX_ALUSrc E_MUX_ALUSrc (
			 .ALUSrc(E_ALUSrc), 
			 .RD2(EX_RD2_o_forward), 
			 .EXTout(EX_EXTout_o), 
			 .ALU_IN(E_ALU_IN)
		);
		
		wire [31:0] E_ALUout;
		wire [31:0] EX_RD1_o_forward;
	
		ALU ALU (
			.A(EX_RD1_o_forward), 
			.B(E_ALU_IN), 
			.ALU_SELECT(E_ALU_SELECT), 
			.ALU_RESULT(E_ALUout)
		);

		wire [31:0]EX_Instr_i;
		wire [31:0]EX_PC_i;
		wire [31:0]EX_PC4_i;
		wire [31:0]EX_PC8_i;
		wire [31:0]EX_ALUout_i;
		wire [31:0]EX_RT_i;
		wire [31:0]MEM_Instr_o;
		wire [31:0]MEM_PC_o;
		wire [31:0]MEM_PC4_o;
		wire [31:0]MEM_PC8_o;
		wire [31:0]MEM_ALUout_o;
		wire [31:0]MEM_RT_o;
		wire [4:0]EX_RegAddr_i;
		wire [4:0]MEM_RegAddr_o;
		
		assign EX_Instr_i = EX_Instr_o;
		assign EX_PC_i = EX_PC_o;
		assign EX_PC4_i = EX_PC4_o;
		assign EX_PC8_i = EX_PC8_o;
		assign EX_ALUout_i = E_ALUout;
		assign EX_RT_i = EX_RD2_o_forward;
		assign EX_RegAddr_i = EX_RegAddr_o;
		
		
		wire [1:0] EX_Tnew_i;
		assign EX_Tnew_i = (EX_Tnew_o == 2'b0)? 2'b0 : EX_Tnew_o - 1;
		wire [1:0] MEM_Tnew_o;
		
		EXtoMEM EXtoMEM (
			 .clk(clk), 
			 .reset(reset), 
			 .en(en), 
			 .EX_Instr_i(EX_Instr_i), 
			 .EX_PC_i(EX_PC_i), 
			 .EX_PC4_i(EX_PC4_i), 
			 .EX_PC8_i(EX_PC8_i), 
			 .EX_ALUout_i(EX_ALUout_i), 
			 .EX_RT_i(EX_RT_i), 
			 .EX_RegAddr_i(EX_RegAddr_i),
			 .EX_Tnew_i(EX_Tnew_i),
			 .MEM_Tnew_o(MEM_Tnew_o),
			 .MEM_RegAddr_o(MEM_RegAddr_o),
			 .MEM_Instr_o(MEM_Instr_o), 
			 .MEM_PC_o(MEM_PC_o), 
			 .MEM_PC4_o(MEM_PC4_o), 
			 .MEM_PC8_o(MEM_PC8_o), 
			 .MEM_ALUout_o(MEM_ALUout_o), 
			 .MEM_RT_o(MEM_RT_o)
		);
		
		wire M_MemWrite,M_MemRead;
		wire [5:0]M_op;
		wire [5:0]M_func;
		assign M_op = MEM_Instr_o[31:26];
		assign M_func = MEM_Instr_o[5:0];
		
		Controller M_Controller (
			.op(M_op), 
			.func(M_func),  
			.MemWrite(M_MemWrite), 
			.MemRead(M_MemRead)
		);	
		
		wire [31:0] M_MemAddr;
		wire [31:0]M_MemData;
		wire [31:0] M_MemOut;
		
		assign M_MemAddr = MEM_ALUout_o;
		assign M_MemData = MEM_RT_o;
		wire [31:0]M_MemData_forward;
		DM DM (
			.clk(clk), 
			.reset(reset), 
			.MemWrite(M_MemWrite), 
			.MemRead(M_MemRead), 
			.MemAddr(M_MemAddr), 
			.MemData(M_MemData_forward), 
			.PC(MEM_PC_o), 
			.MemOut(M_MemOut)
		);
		
		wire [31:0] MEM_Instr_i;
		wire [31:0] MEM_PC_i;
		wire [31:0] MEM_PC4_i;
		wire [31:0] MEM_PC8_i;
		wire [31:0] MEM_ALUout_i;
		wire [31:0] MEM_DM_i;
		wire [4:0]MEM_RegAddr_i;
	
		wire [31:0]WB_Instr_o;
		wire [31:0]WB_PC4_o;
		wire [31:0] WB_PC8_o;
		wire [31:0] WB_ALUout_o;
		wire [31:0] WB_MemData_o;
	
		
		assign MEM_Instr_i = MEM_Instr_o;
		assign MEM_PC_i = MEM_PC_o;
		assign MEM_PC4_i = MEM_PC4_o;
		assign MEM_PC8_i = MEM_PC8_o;
		assign MEM_ALUout_i = MEM_ALUout_o;
		assign MEM_DM_i = M_MemOut;
		assign MEM_RegAddr_i = MEM_RegAddr_o;
		
 		MEMtoWB MEMtoWB (
			.clk(clk), 
			.reset(reset), 
			.en(en), 
			.MEM_Instr_i(MEM_Instr_i), 
			.MEM_PC_i(MEM_PC_i), 
			.MEM_PC4_i(MEM_PC4_i), 
			.MEM_PC8_i(MEM_PC8_i), 
			.MEM_ALUout_i(MEM_ALUout_i), 
			.MEM_DM_i(MEM_DM_i), 
			.MEM_RegAddr_i(MEM_RegAddr_i), 
			.WB_RegAddr_o(WB_RegAddr_o), 
			.WB_Instr_o(WB_Instr_o), 
			.WB_PC_o(WB_PC_o), 
			.WB_PC4_o(WB_PC4_o), 
			.WB_PC8_o(WB_PC8_o), 
			.WB_ALUout_o(WB_ALUout_o), 
			.WB_MemData_o(WB_MemData_o)
			);

		wire [5:0]W_op;
		wire [5:0]W_func;
		assign W_op = WB_Instr_o[31:26];
		assign W_func = WB_Instr_o[5:0];
		wire [1:0] W_MemtoReg;
		
		Controller W_Controller (
			.op(W_op), 
			.func(W_func), 
			.MemtoReg(W_MemtoReg),
			.RegWrite(W_RegWrite)
		);
		
		
		MUX_RegData MUX_RegData (
			.ALU_RESULT(WB_ALUout_o), 
			.MemOut(WB_MemData_o), 
			.PC8(WB_PC8_o), 
			.MemtoReg(W_MemtoReg), 
			.RegData(W_RegData)
		);
		
	
		wire [31:0]PC_BEQ;
		assign PC_BEQ = ID_PC4_o + {ID_EXTout_i,{2{1'b0}}};
		
		wire [31:0]PC_JAL;
		assign PC_JAL = {ID_PC_o[31:28], ID_Instr_o[25:0],2'b00};
	
		wire en_PC;
		nPC nPC (
			.PC4(IF_PC_i_4), 
			.PC_BEQ(PC_BEQ), 
			.PC_JAL(PC_JAL), 
			.RD1(D_RD1_forward), 
			.IN_PC(IN_PC), 
			.PC_SELECT(PC_SELECT), 
			.isEqual(isEqual),
			.en(en_PC),
			.PC(IF_PC_i)
		);
	 
		
		
		
		
forward forward(
	.ID_Instr_o(ID_Instr_o), 
    .EX_Instr_o(EX_Instr_o), 
    .MEM_Instr_o(MEM_Instr_o), 
    .WB_Instr_o(WB_Instr_o), 
    .MEM_RegAddr_o(MEM_RegAddr_o), 
    .WB_RegAddr_o(WB_RegAddr_o), 
    .D_RD1(D_RD1), 
	 .D_RD2(D_RD2),
    .MEM_ALUout_o(MEM_ALUout_o), 
    .W_RegData(W_RegData), 
    .W_RegWrite(W_RegWrite), 
    .MEM_PC8_o(MEM_PC8_o), 
	 .EX_RD1_o(EX_RD1_o),
	 .EX_RD2_o(EX_RD2_o),
	 .M_MemData(M_MemData),
    .D_RD1_forward(D_RD1_forward),
	 .D_RD2_forward(D_RD2_forward),
	 .EX_RD1_o_forward(EX_RD1_o_forward),
	 .EX_RD2_o_forward(EX_RD2_o_forward),
	 .M_MemData_forward(M_MemData_forward)
    );
		
		wire [1:0] Tuse_rs;
		wire [1:0] Tuse_rt;
		// ID_Tnew_i;
		
		Stall Stall (
    .ID_Instr_o(ID_Instr_o), 
    .Tuse_rs(Tuse_rs), 
    .Tuse_rt(Tuse_rt), 
    .ID_Tnew_i(ID_Tnew_i), 
    .EX_Tnew_o(EX_Tnew_o), 
    .MEM_Tnew_o(MEM_Tnew_o), 
    .D_RD1_forward(D_RD1_forward), 
    .D_RD2_forward(D_RD2_forward), 
    .D_RD1(D_RD1), 
    .D_RD2(D_RD2), 
    .en_PC(en_PC), 
    .en_IFtoID(en_IFtoID), 
    .en_IDtoEX(en_IDtoEX), 
    .MEM_RegAddr_o(MEM_RegAddr_o), 
    .EX_RegAddr_o(EX_RegAddr_o)
    );
		
endmodule
