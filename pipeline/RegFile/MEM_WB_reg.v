`timescale 1ns / 1ps
//2013011076 Wang Han
//MEM_WB Register

module MEM_WB_reg(
	input			clk,
	input			reset,
	input	[31:0]	iPC_plus_4,
	input	[4:0]	iInstRt,
	input	[4:0]	iInstRd,
	input	[1:0]	iRegDst,
	input	[1:0]	iMemToReg,
	input			iRegWrite,
	input	[31:0]	iALUOut,
	input	[31:0]	iMemReadData,
	output	reg [31:0]	oPC_plus_4,
	output	reg [4:0]	oInstRt,
	output	reg [4:0]	oInstRd,
	output	reg [1:0]	oRegDst,
	output	reg [1:0]	oMemToReg,
	output	reg 		oRegWrite,
	output	reg [31:0]	oALUOut,
	output	reg [31:0]	oMemReadData);

	always @(posedge clk or negedge reset) begin
		if (~reset)
		begin
			oPC_plus_4 <= 32'h00000000;
			oInstRt <= 5'h00;
			oInstRd <= 5'h00;
			oRegDst <= 2'h0;
			oMemToReg <= 2'h0;
			oRegWrite <= 1'b0;
			oALUOut <= 32'h00000000;
			oMemReadData <= 32'h00000000;
		end
		else
		begin
			oPC_plus_4 <= iPC_plus_4;
			oInstRt <= iInstRt;
			oInstRd <= iInstRd;
			oRegDst <= iRegDst;
			oMemToReg <= iMemToReg;
			oRegWrite <= iRegWrite;
			oALUOut <= iALUOut;
			oMemReadData <= iMemReadData;
		end
	end
endmodule
