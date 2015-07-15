`timescale 1ns / 1ps
// 2013011076 Wang Han
// Sub Operation Module
////////////////////////
////// In SIGNED situation, Overflow happens when pos-neg=neg or neg-pos=pos.
////// In UNSIGNED situation, if small-big, definitely Overflow; if big-big or small-small, check the MSB of the output.
////////////////////////
////// In SIGNED situation, if pos-pos or neg-neg, Negative equals to the MSB of the output; otherwise it equals to the MSB of the first parameter.
////// In UNSIGNED situation, if big-small, positive; if small-big, negtive; otherwise just check the MSB of the output.
 
module SUB (input	[31:0]	A,
			input	[31:0]	B,
			input			Signed,
			output	[31:0]	S,
			output			Zero,
			output			Overflow,
			output			Negative);

	wire m_zero;
	wire m_overflow;
	wire m_negative;

	ADD m_add0(A, ~B + 1, Signed, S, m_zero, m_overflow, m_negative);

	assign Zero = ((S == 0) & ~Overflow);

	assign Overflow = (Signed) ? ((A[31] & ~B[31] & ~S[31]) | (~A[31] & B[31] & S[31])) :
								((~A[31] & B[31]) | ((A[31] == B[31]) & S[31]));

	assign Negative = (A[31] ^ B[31]) ? (Signed ? A[31] : B[31]) : S[31];

endmodule
