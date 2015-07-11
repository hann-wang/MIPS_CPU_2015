`timescale 1ns / 1ps
//2013011076 Wang Han
//ID_EX Register

module ID_EX_reg(
	input			clk,
	input			reset,
	input			flush,
	input	[5:0]	iInstOpCode,
	input	[5:0]	iInstFunct,
	input	[31:0]	iPC_plus_4,
	input	[4:0]	iInstRt,
	input	[4:0]	iInstRd,
	input	[4:0]	iInstShamt,
	input 	[31:0]	iRegReadData1,
	input	[31:0]	iRegReadData2,
	input	[1:0]	iRegDst,
	input	[1:0]	iPCSrc,
	input			iMemRead,
	input			iMemWrite,
	input	[1:0]	iMemToReg,
	input	[1:0]	iALUOp,
	input			iALUSrc1,
	input			iALUSrc2,
	input			iRegWrite,
	input	[31:0]	iExt_out,
	input	[31:0]	iLU_out,
	output	reg [5:0]	oInstOpCode,
	output	reg [5:0]	oInstFunct,
	output	reg [31:0]	oPC_plus_4,
	output	reg [4:0]	oInstRt,
	output	reg [4:0]	oInstRd,
	output	reg [4:0]	oInstShamt,
	output	reg [31:0]	oRegReadData1,
	output	reg [31:0]	oRegReadData2,
	output	reg [1:0]	oRegDst,
	output	reg [1:0]	oPCSrc,
	output	reg 		oMemRead,
	output	reg 		oMemWrite,
	output	reg [1:0]	oMemToReg,
	output	reg [1:0]	oALUOp,
	output	reg 		oALUSrc1,
	output	reg 		oALUSrc2,
	output	reg 		oRegWrite,
	output	reg [31:0]	oExt_out,
	output	reg [31:0]	oLU_out);

	always @(posedge clk or negedge reset) begin
		if (~reset)
		begin
			oInstOpCode <= 6'h00;
			oInstFunct <= 6'h00;
			oPC_plus_4 <= 32'h00000000;
			oInstRt <= 5'h00;
			oInstRd <= 5'h00;
			oInstShamt <= 5'h00;
			oRegReadData1 <= 32'h00000000;
			oRegReadData2 <= 32'h00000000;
			oRegDst <= 2'h0;
			oPCSrc <= 2'h0;
			oMemRead <= 1'b0;
			oMemWrite <= 1'b0;
			oMemToReg <= 2'h0;
			oALUOp <=2'b00;
			oALUSrc1 <= 1'b0;
			oALUSrc2 <= 1'b0;
			oRegWrite <= 1'b0;
			oExt_out <= 32'h00000000;
			oLU_out <= 32'h00000000;
		end
		else
		begin
			if (flush)
			begin
				oInstOpCode <= 6'h00;
				oInstFunct <= 6'h00;
				oPC_plus_4 <= 32'h00000000;
				oInstRt <= 5'h00;
				oInstRd <= 5'h00;
				oInstShamt <= 5'h00;
				oRegReadData1 <= 32'h00000000;
				oRegReadData2 <= 32'h00000000;
				oRegDst <= 2'h0;
				oPCSrc <= 2'h0;
				oMemRead <= 1'b0;
				oMemWrite <= 1'b0;
				oMemToReg <= 2'h0;
				oALUOp <=2'b00;
				oALUSrc1 <= 1'b0;
				oALUSrc2 <= 1'b0;
				oRegWrite <= 1'b0;
				oExt_out <= 32'h00000000;
				oLU_out <= 32'h00000000;
			end
			else
			begin
				oInstOpCode <= iInstOpCode;
				oInstFunct <= iInstFunct;
				oPC_plus_4 <= iPC_plus_4;
				oInstRt <= iInstRt;
				oInstRd <= iInstRd;
				oInstShamt <= iInstShamt;
				oRegReadData1 <= iRegReadData1;
				oRegReadData2 <= iRegReadData2;
				oRegDst <= iRegDst;
				oPCSrc <= iPCSrc;
				oMemRead <= iMemRead;
				oMemWrite <= iMemWrite;
				oMemToReg <= iMemToReg;
				oALUOp <= iALUOp;
				oALUSrc1 <= iALUSrc1;
				oALUSrc2 <= iALUSrc2;
				oRegWrite <= iRegWrite;
				oExt_out <= iExt_out;
				oLU_out <= iLU_out;
			end
		end
	end
endmodule
