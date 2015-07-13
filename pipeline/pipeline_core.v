`timescale 1ns/1ps
//2013011076 Wang Han
//pipline_core

module pipeline_core(clk,
					reset, 
					oMemAddr,
					oMemWrite, 
					oMemWriteData,
					oMemRead, 
					iMemReadData,
					iInterrupt);

	//===== I/O =====
	input			clk;
	input			reset;
	output	[31:0]	oMemAddr;
	output			oMemWrite;
	output			oMemRead;
	output	[31:0]  oMemWriteData;
	input	[31:0]  iMemReadData;
	input			iInterrupt;

	//===== Instruction =====
	wire	[2:0]	PCSrc;
	
	wire	[31:0]	IF_PC;
	wire	[31:0]	IF_PC_plus_4;
	wire	[31:0]	IF_Instruction;
	wire	[31:0]	IF_PC_next_raw;
	wire	[31:0]	IF_PC_next;
	
	wire	[31:0]	ID_PC_plus_4;
	wire	[31:0]	ID_Instruction;
	wire	[5:0]	ID_InstOpCode;
	wire	[4:0]	ID_InstRs;
	wire	[4:0]	ID_InstRt;
	wire	[4:0]	ID_InstRd;
	wire	[4:0]	ID_InstShamt;
	wire	[5:0]	ID_InstFunct;
	wire	[15:0]	ID_InstImmediate;
	wire	[25:0]	ID_InstJumpAddr;
	wire			ID_UndefinedInst;
	
	wire	[31:0]	EX_PC_plus_4;
	wire	[5:0]	EX_InstOpCode;
	wire	[4:0]	EX_InstRs;
	wire	[4:0]	EX_InstRt;
	wire	[4:0]	EX_InstRd;
	wire	[4:0]	EX_InstShamt;
	wire	[5:0]	EX_InstFunct;
	
	wire	[31:0]	MEM_PC_plus_4;
	wire	[4:0]	MEM_InstRt;
	wire	[4:0]	MEM_InstRd;
	
	wire	[31:0]	WB_PC_plus_4;
	wire	[4:0]	WB_InstRt;
	wire	[4:0]	WB_InstRd;
	
	//===== Register File =====
	wire	[31:0]	ID_RegReadData1;
	wire	[31:0]	ID_RegReadData2;
	wire	[31:0]	EX_RegReadData1;
	wire	[31:0]	EX_RegReadData2;
	wire	[4:0]	EX_RegWriteAddr;
	
	wire	[31:0]	MEM_RegReadData2;
	wire	[4:0]	MEM_RegWriteAddr;
	
	wire	[4:0]	WB_RegWriteAddr;
	wire	[31:0]	WB_RegWriteData;
	
	//===== ALU =====
	wire	[31:0]	EX_ALUIn1;
	wire	[31:0]	EX_ALUIn2;
	wire	[31:0]  EX_ALUOut;
	wire			EX_ALUSign;
	wire	[5:0]	EX_ALUFunc;
	wire			EX_ALUZero;
	wire			EX_ALUNegative;
	
	wire	[31:0]	MEM_ALUOut;
	
	wire	[31:0]	WB_ALUOut;
	//===== Controller =====
	wire	[1:0]	ID_RegDst;
	wire	[2:0]	ID_PCSrc;
	wire			ID_MemRead;
	wire			ID_MemWrite;
	wire	[1:0]	ID_MemToReg;
	wire	[1:0]	ID_ALUOp;
	wire			ID_ExtOp;
	wire			ID_LuOp;
	wire			ID_ALUSrc1;
	wire			ID_ALUSrc2;
	wire			ID_RegWrite;
	
	wire	[1:0]	EX_RegDst;
	wire	[2:0]	EX_PCSrc;
	wire			EX_MemRead;
	wire			EX_MemWrite;
	wire	[1:0]	EX_MemToReg;
	wire	[1:0]	EX_ALUOp;
	wire			EX_ALUSrc1;
	wire			EX_ALUSrc2;
	wire			EX_RegWrite;
	
	wire	[1:0]	MEM_RegDst;
	wire			MEM_MemRead;
	wire			MEM_MemWrite;
	wire	[1:0]	MEM_MemToReg;
	wire			MEM_RegWrite;
	
	wire	[1:0]	WB_RegDst;
	wire	[1:0]	WB_MemToReg;
	wire			WB_RegWrite;
	//===== Memory =====
	wire	[31:0]	WB_MemReadData;
	
	//===== Others =====
	wire	[31:0]	ID_Ext_out;
	wire	[31:0]	ID_LU_out;
	
	wire	[31:0]	EX_Ext_out;
	wire	[31:0]	EX_LU_out;
	
	wire	[31:0]	EX_BranchTarget;
	wire	[31:0]	ID_JumpTarget;
	
	wire			BeginInterrupt;
	
	//====Forward Signal====
	wire [1:0] EX_ForwardA, EX_ForwardB, EX_ForwardJr;
	wire [31:0] EX_ForwardAData, EX_ForwardBData, EX_ForwardJrData;
	//====Hazard Signal====
	wire PCWrite, IF_ID_write, IF_ID_flush, ID_EX_flush;
	//========================
	//========================
	//========================
	
	//===== IF Stage =====
	assign BeginInterrupt = (~IF_PC[31])&iInterrupt;
	assign PCSrc = (EX_PCSrc == 3'b001 && EX_ALUOut[0]) ? 3'b001 : (ID_PCSrc == 3'b001 ? 3'b000 : ID_PCSrc);
	
	assign EX_ForwardJrData = (EX_ForwardJr == 2'b00) ? ID_RegReadData1 :
								(EX_ForwardJr == 2'b01) ? EX_ALUOut :
								(EX_ForwardJr == 2'b10) ? iMemReadData :
								WB_RegWriteData;
	
	assign IF_PC_plus_4 = IF_PC + 32'd4;
	assign IF_PC_next =
						(PCSrc == 3'b000) ? IF_PC_plus_4:
						(PCSrc == 3'b001) ? EX_BranchTarget:
						(PCSrc == 3'b010) ? ID_JumpTarget:
						(PCSrc == 3'b011) ? EX_ForwardJrData:
						(PCSrc == 3'b100) ? 32'h80000004:
						32'h80000008;

	PC_reg PC_reg0(.clk(clk), .reset(reset), .PCWrite(PCWrite), .iPC(IF_PC_next), .oPC(IF_PC));
	
	ROM rom0(.addr(IF_PC),.data(IF_Instruction));
	
	IF_ID_reg IF_ID_reg0(.clk(clk),
			.reset(reset),
			.flush(IF_ID_flush),
			.pre_flush(ID_EX_flush),
			.IF_ID_write(IF_ID_write),
			.iInstruction(IF_Instruction),
			.iPC_plus_4(IF_PC_plus_4),
			.oPC_plus_4(ID_PC_plus_4),
			.oInstOpCode(ID_InstOpCode),
			.oInstRs(ID_InstRs),
			.oInstRt(ID_InstRt),
			.oInstRd(ID_InstRd),
			.oInstShamt(ID_InstShamt),
			.oInstFunct(ID_InstFunct),
			.oInstImmediate(ID_InstImmediate),
			.oInstJumpAddr(ID_InstJumpAddr)
			);
	
	
	//====== ID Stage & WB Stage ======
	HazardUnit HazardUnit0(.ID_EX_MemRead(EX_MemRead),
							.ID_EX_InstRt(EX_InstRt),
							.IF_ID_InstRs(ID_InstRs),
							.IF_ID_InstRt(ID_InstRt),
							.ID_PCSrc(ID_PCSrc),
							.ID_EX_PCSrc(EX_PCSrc),
							.EX_ALUOut0(EX_ALUOut[0]),
							.PCWrite(PCWrite),
							.IF_ID_write(IF_ID_write),
							.IF_ID_flush(IF_ID_flush),
							.ID_EX_flush(ID_EX_flush));
	
	
	Controller controller0(
		.OpCode(ID_InstOpCode),
		.Funct(ID_InstFunct),
		.IRQ(BeginInterrupt),
		.PCSrc(ID_PCSrc),
		.RegWrite(ID_RegWrite),
		.RegDst(ID_RegDst), 
		.MemRead(ID_MemRead),
		.MemWrite(ID_MemWrite),
		.MemToReg(ID_MemToReg),
		.ALUSrc1(ID_ALUSrc1),
		.ALUSrc2(ID_ALUSrc2),
		.ExtOp(ID_ExtOp),
		.LuOp(ID_LuOp),
		.ALUOp(ID_ALUOp));

	assign WB_RegWriteAddr = (WB_RegDst == 2'b00)? WB_InstRt: (WB_RegDst == 2'b01)? WB_InstRd: (WB_RegDst == 2'b10)? 5'b11111 : 5'd26;
	assign WB_RegWriteData = (WB_MemToReg == 2'b00)? WB_ALUOut: (WB_MemToReg == 2'b01)? WB_MemReadData: WB_PC_plus_4;
	RegFile reg0(.clk(clk),
				.reset(reset),
				.addr1(ID_InstRs),
				.data1(ID_RegReadData1),
				.addr2(ID_InstRt),
				.data2(ID_RegReadData2),
				.addr3(WB_RegWriteAddr),
				.data3(WB_RegWriteData),
				.wr(WB_RegWrite));

	assign ID_Ext_out = {ID_ExtOp? {16{ID_InstImmediate[15]}}: 16'h0000, ID_InstImmediate[15:0]};
	assign ID_LU_out = ID_LuOp? {ID_InstImmediate[15:0], 16'h0000}: ID_Ext_out;
	assign ID_JumpTarget = {IF_PC_plus_4[31:28], ID_InstJumpAddr, 2'b00};
	
	
	ID_EX_reg ID_EX_reg0(.clk(clk),
			.reset(reset),
			.flush(ID_EX_flush),
			.iInstOpCode(ID_InstOpCode),
			.iInstFunct(ID_InstFunct),
			.iPC_plus_4(ID_PC_plus_4),
			.iInstRs(ID_InstRs),
			.iInstRt(ID_InstRt),
			.iInstRd(ID_InstRd),
			.iInstShamt(ID_InstShamt),
			.iRegReadData1(ID_RegReadData1),
			.iRegReadData2(ID_RegReadData2),
			.iRegDst(ID_RegDst),
			.iPCSrc(ID_PCSrc),
			.iMemRead(ID_MemRead),
			.iMemWrite(ID_MemWrite),
			.iMemToReg(ID_MemToReg),
			.iALUOp(ID_ALUOp),
			.iALUSrc1(ID_ALUSrc1),
			.iALUSrc2(ID_ALUSrc2),
			.iRegWrite(ID_RegWrite),
			.iExt_out(ID_Ext_out),
			.iLU_out(ID_LU_out),
			.oInstOpCode(EX_InstOpCode),
			.oInstFunct(EX_InstFunct),
			.oPC_plus_4(EX_PC_plus_4),
			.oInstRs(EX_InstRs),
			.oInstRt(EX_InstRt),
			.oInstRd(EX_InstRd),
			.oInstShamt(EX_InstShamt),
			.oRegReadData1(EX_RegReadData1),
			.oRegReadData2(EX_RegReadData2),
			.oRegDst(EX_RegDst),
			.oPCSrc(EX_PCSrc),
			.oMemRead(EX_MemRead),
			.oMemWrite(EX_MemWrite),
			.oMemToReg(EX_MemToReg),
			.oALUOp(EX_ALUOp),
			.oALUSrc1(EX_ALUSrc1),
			.oALUSrc2(EX_ALUSrc2),
			.oRegWrite(EX_RegWrite),
			.oExt_out(EX_Ext_out),
			.oLU_out(EX_LU_out));
	
	
	//====== EX Stage ======
	ALUController alucontroller0(.ALUOp(EX_ALUOp), .OpCode(EX_InstOpCode), .Funct(EX_InstFunct), .ALUFunc(EX_ALUFunc), .Sign(EX_ALUSign));
	assign EX_ALUIn1 = EX_ALUSrc1? {17'h00000, EX_InstShamt}: EX_ForwardAData;
	assign EX_ALUIn2 = EX_ALUSrc2? EX_LU_out: EX_ForwardBData;
	ALU alu0(EX_ALUIn1, EX_ALUIn2, EX_ALUFunc, EX_ALUSign, EX_ALUOut, EX_ALUZero);
	
	assign EX_BranchTarget = (EX_ALUOut[0])? EX_PC_plus_4 + {EX_Ext_out[29:0], 2'b00}: EX_PC_plus_4;
	
	EX_MEM_reg EX_MEM_reg0(.clk(clk),
							.reset(reset),
							.iPC_plus_4(EX_PC_plus_4),
							.iInstRt(EX_InstRt),
							.iInstRd(EX_InstRd),
							.iRegReadData2(EX_ForwardBData),
							.iRegDst(EX_RegDst),
							.iMemRead(EX_MemRead),
							.iMemWrite(EX_MemWrite),
							.iMemToReg(EX_MemToReg),
							.iRegWrite(EX_RegWrite),
							.iALUOut(EX_ALUOut),
							.oPC_plus_4(MEM_PC_plus_4),
							.oInstRt(MEM_InstRt),
							.oInstRd(MEM_InstRd),
							.oRegReadData2(MEM_RegReadData2),
							.oRegDst(MEM_RegDst),
							.oMemRead(MEM_MemRead),
							.oMemWrite(MEM_MemWrite),
							.oMemToReg(MEM_MemToReg),
							.oRegWrite(MEM_RegWrite),
							.oALUOut(MEM_ALUOut));
	
	assign EX_RegWriteAddr = (EX_RegDst == 2'b00)? EX_InstRt: (EX_RegDst == 2'b01)? EX_InstRd: (EX_RegDst == 2'b10)? 5'b11111 : 5'd26;	
	
	ForwardUnit ForwardUnit0(.EX_MEM_RegWrite(MEM_RegWrite),
							.EX_MEM_RegWriteAddr(MEM_RegWriteAddr),
							.ID_EX_InstRt(EX_InstRt),
							.ID_EX_InstRs(EX_InstRs),
							.ID_PCSrc(ID_PCSrc),
							.IF_ID_InstRs(ID_InstRs),
							.ID_EX_RegWriteAddr(EX_RegWriteAddr),
							.ID_EX_RegWrite(EX_RegWrite),
							.MEM_WB_RegWrite(WB_RegWrite),
							.MEM_WB_RegWriteAddr(WB_RegWriteAddr),
							.ForwardA(EX_ForwardA),
							.ForwardB(EX_ForwardB),
							.ForwardJr(EX_ForwardJr));
	assign EX_ForwardAData = (EX_ForwardA==2'b00) ? EX_RegReadData1 :
							(EX_ForwardA==2'b01) ? WB_RegWriteData :
							MEM_ALUOut;
	assign EX_ForwardBData = (EX_ForwardB==2'b00) ? EX_RegReadData2 :
							(EX_ForwardB==2'b01) ? WB_RegWriteData :
							MEM_ALUOut;
							
	//====== MEM Stage ======
	assign oMemAddr = MEM_ALUOut;
	assign oMemWrite = MEM_MemWrite;
	assign oMemRead = MEM_MemRead;
	assign oMemWriteData = MEM_RegReadData2;
	assign MEM_RegWriteAddr = (MEM_RegDst == 2'b00)? MEM_InstRt: (MEM_RegDst == 2'b01)? MEM_InstRd: (MEM_RegDst == 2'b10)? 5'b11111 : 5'd26;
	MEM_WB_reg MEM_WB_reg0(.clk(clk),
							.reset(reset),
							.iPC_plus_4(MEM_PC_plus_4),
							.iInstRt(MEM_InstRt),
							.iInstRd(MEM_InstRd),
							.iRegDst(MEM_RegDst),
							.iMemToReg(MEM_MemToReg),
							.iRegWrite(MEM_RegWrite),
							.iALUOut(MEM_ALUOut),
							.iMemReadData(iMemReadData),
							.oPC_plus_4(WB_PC_plus_4),
							.oInstRt(WB_InstRt),
							.oInstRd(WB_InstRd),
							.oRegDst(WB_RegDst),
							.oMemToReg(WB_MemToReg),
							.oRegWrite(WB_RegWrite),
							.oALUOut(WB_ALUOut),
							.oMemReadData(WB_MemReadData));
endmodule
