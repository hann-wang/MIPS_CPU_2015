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
	parameter ALUFUNC_ADD = 6'b000000;
	parameter ALUFUNC_SUB = 6'b000001;

	parameter ALU_LOGIC = 2'b01;
	parameter ALUFUNC_AND = 6'b011000;
	parameter ALUFUNC_OR  = 6'b011110;
	parameter ALUFUNC_XOR = 6'b010110;
	parameter ALUFUNC_NOR = 6'b010001;
	parameter ALUFUNC_A   = 6'b011010;

	parameter ALU_SHIFT = 2'b10;
	parameter ALUFUNC_SLL = 6'b100000;
	parameter ALUFUNC_SRL = 6'b100001;
	parameter ALUFUNC_SRA = 6'b100011;

	parameter ALU_CMP = 2'b11;
	parameter ALUFUNC_EQ  = 6'b110011;
	parameter ALUFUNC_NEQ = 6'b110001;
	parameter ALUFUNC_LT  = 6'b110101;
	parameter ALUFUNC_LEZ = 6'b111101;
	parameter ALUFUNC_GEZ = 6'b111001;
	parameter ALUFUNC_GTZ = 6'b111111;

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
