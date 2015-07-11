`timescale 1ns / 1ps
//2013011076 Wang Han
//EX_MEM Register

module EX_MEM_reg(
	input			clk,
	input			reset,
	input	[31:0]	iPC_plus_4,
	input	[4:0]	iInstRt,
	input	[4:0]	iInstRd,
	input	[31:0]	iRegReadData2,
	input	[1:0]	iRegDst,
	input			iMemRead,
	input			iMemWrite,
	input	[1:0]	iMemToReg,
	input			iRegWrite,
	input	[31:0]	iALUOut,
	output	reg [31:0]	oPC_plus_4,
	output	reg [4:0]	oInstRt,
	output	reg [4:0]	oInstRd,
	output	reg [31:0]	oRegReadData2,
	output	reg [1:0]	oRegDst,
	output	reg 		oMemRead,
	output	reg 		oMemWrite,
	output	reg [1:0]	oMemToReg,
	output	reg 		oRegWrite,
	output	reg [31:0]	oALUOut);

	always @(posedge clk or negedge reset) begin
		if (~reset)
		begin
			oPC_plus_4 <= 32'h00000000;
			oInstRt <= 5'h00;
			oInstRd <= 5'h00;
			oRegReadData2 <= 32'h00000000;
			oRegDst <= 2'h0;
			oMemRead <= 1'b0;
			oMemWrite <= 1'b0;
			oMemToReg <= 2'h0;
			oRegWrite <= 1'b0;
			oALUOut <= 32'h00000000;
		end
		else
		begin
			oPC_plus_4 <= iPC_plus_4;
			oInstRt <= iInstRt;
			oInstRd <= iInstRd;
			oRegReadData2 <= iRegReadData2;
			oRegDst <= iRegDst;
			oMemRead <= iMemRead;
			oMemWrite <= iMemWrite;
			oMemToReg <= iMemToReg;
			oRegWrite <= iRegWrite;
			oALUOut <= iALUOut;
		end
	end
endmodule
