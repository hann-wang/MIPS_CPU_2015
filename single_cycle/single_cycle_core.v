`timescale 1ns/1ps
//2013011076 Wang Han
//single_cycle_core, only Instruction ROM, Register File, ALU & Controller are accessible here.
//CPU should communicate with Memory and other peripheral through the top module.

module single_cycle_core(clk,
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
	reg		[31:0]	PC;
	wire	[31:0]	Instruction;
	wire	[5:0]	InstOpCode;
	wire	[4:0]	InstRs;
	wire	[4:0]	InstRt;
	wire	[4:0]	InstRd;
	wire	[4:0]	InstShamt;
	wire	[5:0]	InstFunct;
	wire	[15:0]	InstImmediate;
	wire	[25:0]	InstJumpAddr;
	wire			UndefinedInst;
	//===== Register File =====
	wire	[4:0]	RegWriteAddr;
	wire	[31:0]	RegReadData1;
	wire	[31:0]	RegReadData2;
	wire	[31:0]	RegWriteData;
	
	//===== ALU =====
	wire	[31:0]	ALUIn1;
	wire	[31:0]	ALUIn2;
	wire	[31:0]  ALUOut;
	wire			ALUSign;
	wire	[5:0]	ALUFunc;

	//===== Controller =====
	wire	[1:0]	RegDst;
	wire	[1:0]	PCSrc;
	wire			MemRead;
	wire			MemWrite;
	wire	[1:0]	MemToReg;
	wire	[1:0]	ALUOp;
	wire			ExtOp;
	wire			LuOp;
	wire			ALUSrc1;
	wire			ALUSrc2;
	wire			RegWrite;
	
	//===== Others =====
	wire	[31:0]	PC_plus_4;
	wire	[31:0]	Ext_out;
	wire	[31:0]	LU_out;
	wire	[31:0]	BranchTarget;
	wire	[31:0]	JumpTarget;
	wire	[31:0]	PC_next_raw;
	wire	[31:0]	PC_next;
	wire			BeginInterrupt;
	wire			IsJrJal;
	//========================
	//========================
	//========================
	
	//===== Instruction Fetch & Split =====
	assign PC_plus_4 = PC + 32'd4;
	always @(negedge reset or posedge clk)
	begin
		if (~reset)
			PC <= 32'h80000000;
		else
			PC <= PC_next;
	end
	assign PC_next_raw =(UndefinedInst) ? 32'h80000008:
						(BeginInterrupt) ? 32'h80000004:
						(PCSrc == 2'b00) ? PC_plus_4:
						(PCSrc == 2'b01) ? BranchTarget:
						(PCSrc == 2'b10) ? JumpTarget:
						RegReadData1;
	assign PC_next = (BeginInterrupt|IsJrJal) ? PC_next_raw :
                    {PC[31],PC_next_raw[30:0]};

	ROM rom0(.addr(PC),.data(Instruction));
	assign InstOpCode = Instruction[31:26];
    assign InstRs = Instruction[25:21];
    assign InstRt = Instruction[20:16];
    assign InstRd = Instruction[15:11];
    assign InstShamt = Instruction[10:6];
    assign InstFunct = Instruction[5:0];
    assign InstImmediate = Instruction[15:0];
    assign InstJumpAddr = Instruction[25:0];
	
	assign BeginInterrupt = (~PC[31])&iInterrupt;
	
	//====== Controller ======
	Controller controller0(
		.OpCode(InstOpCode),
		.Funct(InstFunct),
		.IRQ(BeginInterrupt),
		.PCSrc(PCSrc),
		.RegWrite(RegWrite),
		.RegDst(RegDst), 
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.MemToReg(MemToReg),
		.ALUSrc1(ALUSrc1),
		.ALUSrc2(ALUSrc2),
		.ExtOp(ExtOp),
		.LuOp(LuOp),
		.ALUOp(ALUOp),
		.UndefinedInst(UndefinedInst));

	//===== Reg File Access =====
	assign RegWriteAddr = (RegDst == 2'b00)? InstRt: (RegDst == 2'b01)? InstRd: (RegDst == 2'b10)? 5'b11111 : 5'd26;
	assign RegWriteData = (MemToReg == 2'b00)? ALUOut: (MemToReg == 2'b01)? iMemReadData: PC_plus_4;
	RegFile reg0(.clk(clk),
				.reset(reset),
				.addr1(InstRs),
				.data1(RegReadData1),
				.addr2(InstRt),
				.data2(RegReadData2),
				.addr3(RegWriteAddr),
				.data3(RegWriteData),
				.wr(RegWrite));
				
	//====== Extender ======
	assign Ext_out = {ExtOp? {16{InstImmediate[15]}}: 16'h0000, InstImmediate[15:0]};
	assign LU_out = LuOp? {InstImmediate[15:0], 16'h0000}: Ext_out;
	
	//====== ALU ======
	ALUController alucontroller0(.ALUOp(ALUOp), .OpCode(InstOpCode), .Funct(InstFunct), .ALUFunc(ALUFunc), .Sign(ALUSign), .IsJrJal(IsJrJal));
	assign ALUIn1 = ALUSrc1? {17'h00000, InstShamt}: RegReadData1;
	assign ALUIn2 = ALUSrc2? LU_out: RegReadData2;
	ALU alu0(.A(ALUIn1), .B(ALUIn2), .Signed(ALUSign), .ALUFunc(ALUFunc), .ALUOut(ALUOut));
			
	//====== Direct Jump Target ======
	assign JumpTarget = {PC_plus_4[31:28], InstJumpAddr, 2'b00};
	
	//====== Branch Target ======
	assign BranchTarget = (ALUOut[0])? PC_plus_4 + {LU_out[29:0], 2'b00}: PC_plus_4;
	
	//====== Memory Access Signal ======
	assign oMemAddr = ALUOut;
	assign oMemWrite = MemWrite;
	assign oMemRead = MemRead;
	assign oMemWriteData = RegReadData2;
	
endmodule
