`timescale 1ns / 1ps
// 2013011076 Wang Han
// ALU module
// This part should be Chen Zhijie's duty.

module ALU (input	[31:0]	A,
			input	[31:0]	B,
			input			Signed,
			input	[5:0]	ALUFunc,
			output	[31:0]	ALUOut);

	parameter ALU_ARITH = 2'b00;
	parameter ALU_LOGIC = 2'b01;
	parameter ALU_SHIFT = 2'b10;
	parameter ALU_CMP = 2'b11;

	wire	[31:0]	ArithOut;
	wire			Zero;
	wire			Overflow;
	wire			Negative;
	wire			CompareOut;
	wire	[31:0]	LogicOut;
	wire	[31:0]	ShiftOut;
	
	ARITH arith0(A, B, ALUFunc[0], Signed, ArithOut, Zero, Overflow, Negative);

	CMP cmp0(Zero, Overflow, Negative, ALUFunc[3:1], CompareOut);

	LOGIC logic0(A, B, ALUFunc[3:0], LogicOut);

	SHIFT shift0(A[4:0], B, ALUFunc[1:0], ShiftOut);

	assign ALUOut = (ALUFunc[5:4] == ALU_ARITH) ? ArithOut :
						(ALUFunc[5:4] == ALU_LOGIC) ? LogicOut :
							(ALUFunc[5:4] == ALU_SHIFT) ? ShiftOut :
								{ {31{1'b0}}, CompareOut};

endmodule
