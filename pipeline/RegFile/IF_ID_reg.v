`timescale 1ns/1ps
//2013011076 Wang Han
//IF_ID Register

module IF_ID_reg(clk,
			reset,
			flush,
			IF_ID_write,
			iInstruction,
			iPC_plus_4,
			oPC_plus_4,
			oInstruction,
			oInstOpCode,
			oInstRs,
			oInstRt,
			oInstRd,
			oInstShamt,
			oInstFunct,
			oInstImmediate,
			oInstJumpAddr);

    input			clk;
    input			reset;
	input 			flush;
	input 			IF_ID_write;
	input	[31:0]	iInstruction;
	input	[31:0]	iPC_plus_4;
	output	reg [31:0]	oPC_plus_4;
	output	reg	[31:0]	oInstruction;
	output	[5:0]	oInstOpCode;
	output	[4:0]	oInstRs;
	output	[4:0]	oInstRt;
	output	[4:0]	oInstRd;
	output	[4:0]	oInstShamt;
	output	[5:0]	oInstFunct;
	output	[15:0]	oInstImmediate;
	output	[25:0]	oInstJumpAddr;
	
	always @(posedge clk or negedge reset) begin
		if (~reset)
		begin
			oPC_plus_4 <= 32'h80000000;
			oInstruction <= 32'h00000000;
		end
		else
		begin
			if (flush)
			begin
				oPC_plus_4 <= 32'h80000000;
				oInstruction <= 32'h00000000;
			end
			else
			if (IF_ID_write == 1'b1)
			begin
				oPC_plus_4 <= iPC_plus_4;
				oInstruction <= iInstruction;
			end
		end
	end
	
	assign oInstOpCode = oInstruction[31:26];
    assign oInstRs = oInstruction[25:21];
    assign oInstRt = oInstruction[20:16];
    assign oInstRd = oInstruction[15:11];
    assign oInstShamt = oInstruction[10:6];
    assign oInstFunct = oInstruction[5:0];
    assign oInstImmediate = oInstruction[15:0];
    assign oInstJumpAddr = oInstruction[25:0];
	
endmodule
