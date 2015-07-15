`timescale 1ns / 1ps
// 2013011076 Wang Han
// Arithmetic Operation Module

module ARITH(
			input	[31:0]	A,
			input	[31:0]	B,
			input			SubSign,
			input			Signed,
			output	[31:0]	ArithOut,
			output			Zero,
			output			Overflow,
			output			Negative);

	wire[31:0] S_ADD;
	wire[31:0] S_SUB;

	wire Zero_ADD, Overflow_ADD, Negative_ADD;
	ADD add0(A, B, Signed, S_ADD, Zero_ADD, Overflow_ADD, Negative_ADD);

	wire Zero_SUB, Overflow_SUB, Negative_SUB;
	SUB sub0(A, B, Signed, S_SUB, Zero_SUB, Overflow_SUB, Negative_SUB);

	assign ArithOut = SubSign ? S_SUB : S_ADD;
	assign Zero = SubSign ? Zero_SUB : Zero_ADD;
	assign Overflow = SubSign ? Overflow_SUB : Overflow_ADD;
	assign Negative = SubSign ? Negative_SUB : Negative_ADD;

endmodule
