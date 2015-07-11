`timescale 1ns / 1ps
//2013011076 Wang Han
//ID_EX Register

module ID_EX(clk,
			reset,
			flush,
			PCSrc,
			RegDst,
			RegWrite,
			ALUSrc1,
			ALUSrc2,
			ALUFunc,
			MemWrite,
			MemRead,
			MemToReg,
			ExtOut,
			LuOut,
			InstRs,
			InstRt,
			InstRd,
			InstShamt,
			RegReadData1,
			RegReadData2,
			PC_next,
			oPCSrc,
			oRegDst,
			oRegWrite,
			oALUSrc1,
			oALUSrc2,
			oALUOp,
			oMemWrite,
			oMemRead,
			oMemToReg,
			oExtOut,
			oLuOut,
			oInstRs,
			oInstRt,
			oInstRd,
			oInstShamt,
			oRegReadData1,
			oRegeadData2,
			oPC_next);
	input			clk;
	input			reset;
	input			flush;
	input	[5:0]	InstOpCode;
	input	[5:0]	InstFunct;
	input	[2:0]	PCSrc;
	input	[1:0]	RegDst;
	input			RegWrite;
	input			ALUSrc1;
	input			ALUSrc2;
	input	[5:0]	ALUFunc;
	input			MemWrite;
	input			MemRead;
	input	[1:0]	MemToReg;
	input	[31:0]	ExtOut;
	input	[31:0]	LuOut;
	input	[4:0]	InstRs;
	input	[4:0]	InstRt;
	input	[4:0]	InstRd;
	input	[4:0]	InstShamt;
	input	[31:0]	RegReadData1;
	input	[31:0]	RegReadData2;
	input	[31:0]	PC_next;
	output	[5:0]	oInstOpCode;
	output	[5:0]	oInstFunct;
	output	reg	[2:0]	oPCSrc;
	output	reg	[1:0]	oRegDst;
	output	reg			oRegWrite;
	output	reg			oALUSrc1;
	output	reg			oALUSrc2;
	output	reg	[1:0]	oALUOp;
	output	reg			oMemWrite;
	output	reg			oMemRead;
	output	reg	[1:0]	oMemToReg;
	output	reg	[31:0]	oExtOut;
	output	reg	[31:0]	oLuOut;
	output	reg	[4:0]	oInstRs;
	output	reg	[4:0]	oInstRt;
	output	reg	[4:0]	oInstRd;
	output	reg	[4:0]	oInstShamt;
	output	reg	[31:0]	oReadData1;
	output	reg	[31:0]	oReadData2;
	output	reg	[31:0]	oPC_next;

	always @(posedge clk or negedge reset) begin
		if (~reset || flush)
		begin
			oInstOpCode <= 6'b000000;
			oInstFunct <= 6'b000000;
			oPCSrc <= 3'b000;
			oRegDst <= 2'b00;
			oRegWrite <= 1'b0;
			oALUSrc1 <= 1'b0;
			oALUSrc2 <= 1'b0;
			oALUOp <= 2'b10;
			oMemWrite <= 1'b0;
			oMemRead <= 1'b0;
			oMemToReg <= 2'b00;
			oExtOut <= 32'h0;
			oLuOut <= 32'h0;
			oInstRs <= 5'h00;
			oInstRt <= 5'h00;
			oInstRd <= 5'h00;
			oInstShamt <= 5'h00;
			oRegReadData1 <= 32'h0;
			oRegReadData2 <= 32'h0;
			oPC_next <= 32'h0;
		end
		else
		begin
			oInstOpCode <= InstOpCode;
			oInstFunct <= InstFunct;
			oPCSrc <= PCSrc;
			oRegDst <= RegDst;
			oRegWrite <= RegWrite;
			oALUSrc1 <= ALUSrc1;
			oALUSrc2 <= ALUSrc2;
			oALUOp <= ALUOp;
			oMemWrite <= MemWrite;
			oMemRead <= MemRead;
			oMemToReg <= MemToReg;
			oExtOut <= ExtOut;
			oLuOut <= LuOut;
			oInstRs <= InstRs;
			oInstRt <= InstRt;
			oInstRd <= InstRd;
			oInstShamt <= InstShamt;
			oRegReadData1 <= RegReadData1;
			oRegReadData2 <= RegReadData2;
			oPC_next <= oPC_next;
		end
	end
endmodule
