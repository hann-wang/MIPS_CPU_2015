`timescale 1ns / 1ps
//2013011076 Wang Han
//ForwardUnit, handling data association

module ForwardUnit(
	input			EX_MEM_RegWrite,
	input	[4:0]	EX_MEM_RegWriteAddr,
	input	[4:0]	ID_EX_InstRt,
	input	[4:0]	ID_EX_InstRs,
	input	[2:0]	ID_PCSrc,
	input	[4:0]	IF_ID_InstRd,
	input	[4:0]	ID_EX_InstRd,
	input			ID_EX_RegWrite,
	input			MEM_WB_RegWrite,
	input	[4:0]	MEM_WB_RegWriteAddr,
	output	reg [1:0]	ForwardA,
	output	reg [1:0]	ForwardB,
	output	reg [1:0]	ForwardJr
    );

	always @(*) begin
		if (EX_MEM_RegWrite == 1'b1 && 
			EX_MEM_RegWriteAddr != 5'h00 &&
			EX_MEM_RegWriteAddr == ID_EX_InstRs)
				ForwardA = 2'b10;
		else if (MEM_WB_RegWrite == 1'b1 &&
				MEM_WB_RegWriteAddr != 5'h00 &&
				MEM_WB_RegWriteAddr == ID_EX_InstRs)
					ForwardA = 2'b01;
			else
					ForwardA = 2'b00;

		if (EX_MEM_RegWrite == 1'b1 && 
			EX_MEM_RegWriteAddr != 5'h00 &&
			EX_MEM_RegWriteAddr == ID_EX_InstRt)
				ForwardB = 2'b10;
		else if (MEM_WB_RegWrite == 1'b1 &&
				MEM_WB_RegWriteAddr != 5'h00 &&
				MEM_WB_RegWriteAddr == ID_EX_InstRt)
					ForwardB = 2'b01;
			else
					ForwardB = 2'b00;

		if (ID_PCSrc == 3'b011 && IF_ID_InstRd == ID_EX_InstRd && ID_EX_InstRd != 0 && ID_EX_RegWrite)
			ForwardJr = 2'b01;
		else if (ID_PCSrc == 3'b011 && 
				IF_ID_InstRd != ID_EX_InstRd && 
				IF_ID_InstRd == EX_MEM_RegWriteAddr && 
				EX_MEM_RegWrite && 
				EX_MEM_RegWriteAddr != 0)
					ForwardJr = 2'b10;
				else if (ID_PCSrc == 3'b011 && 
						IF_ID_InstRd != ID_EX_InstRd &&
						IF_ID_InstRd != EX_MEM_RegWriteAddr && 
						IF_ID_InstRd == MEM_WB_RegWriteAddr && 
						MEM_WB_RegWriteAddr != 0 &&
						MEM_WB_RegWrite)
							ForwardJr = 2'b11;
					else
						ForwardJr = 2'b00;
	end

endmodule
