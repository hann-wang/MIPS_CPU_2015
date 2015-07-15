`timescale 1ns / 1ps
// 2013011076 Wang Han
// Add Operation Module
////////////////////////
////// Overflow happens when pos+pos=neg or neg+neg=pos in SIGNED situation, and
////// big(MSB = 1)+big or big+small=small or small+big=small in UNSIGNED situation.
////////////////////////
////// In UNSIGNED situation, Negtive always equals to 0 .
////// In SIGNED situation, if neg+neg or pos+pos, Negtive equals to the MSB of the inputs, 
////// otherwise, check the MSB of the output.

module ADD (input	[31:0]	A,
			input	[31:0]	B,
			input			Signed,
			output	[31:0]	S,
			output			Zero,
			output			Overflow,
			output			Negative);

    assign S = A + B;

    assign Zero = ((S == 0) & ~Overflow);

    assign Overflow = (Signed) ?
								((A[31] & B[31] & ~S[31]) | (~A[31] & ~B[31] & S[31])) : 
								((A[31] & B[31]) | (A[31] & ~S[31]) | (B[31] & ~S[31]));

    assign Negative = Signed & ((A[31] ^ B[31]) ? S[31] : A[31]);

endmodule
