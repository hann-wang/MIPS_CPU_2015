`timescale 1ns / 1ps
// 2013011076 Wang Han
// Logical Operation Module

module LOGIC(input	[31:0]	A,
			input	[31:0]	B,
			input	[3:0]	FLAG,
			output	[31:0]	S);

	parameter FLAG_LOGIC_AND = 4'b1000;
	parameter FLAG_LOGIC_OR  = 4'b1110;
	parameter FLAG_LOGIC_XOR = 4'b0110;
	parameter FLAG_LOGIC_NOR = 4'b0001;
	parameter FLAG_LOGIC_A   = 4'b1010;

	parameter ERROR_OUTPUT = 32'h00000000;

	assign S = (FLAG == FLAG_LOGIC_AND) ? (A & B) :
					(FLAG == FLAG_LOGIC_OR) ? (A | B) :
						(FLAG == FLAG_LOGIC_XOR) ? (A ^ B) :
							(FLAG == FLAG_LOGIC_NOR) ? ~(A | B) :
								(FLAG == FLAG_LOGIC_A) ? A :
									ERROR_OUTPUT;

endmodule