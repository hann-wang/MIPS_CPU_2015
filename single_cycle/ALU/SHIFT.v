`timescale 1ns / 1ps
// 2013011076 Wang Han
// Shift Operation Module

module SHIFT(input	[4:0]	A,
				input	[31:0]	B,
				input	[1:0]	FLAG,
				output	[31:0]	S);

	parameter FLAG_SHIFT_SLL = 2'b00;
	parameter FLAG_SHIFT_SRL = 2'b01;
	parameter FLAG_SHIFT_SRA = 2'b11;

	parameter ERROR_OUTPUT = 32'h00000000;

	wire[31:0] shift_16;
	wire[31:0] shift_8;
	wire[31:0] shift_4;
	wire[31:0] shift_2;
	wire[31:0] shift_1;

	assign shift_16 = A[4] ? ((FLAG == FLAG_SHIFT_SLL) ? { B[15:0], {16{1'b0}} } :
								(FLAG == FLAG_SHIFT_SRL) ? { {16{1'b0}}, B[31:16] } :
									(FLAG == FLAG_SHIFT_SRA) ? { {16{B[31]}}, B[31:16] } :
										ERROR_OUTPUT
							) : B;

	assign shift_8 = A[3] ? ((FLAG == FLAG_SHIFT_SLL) ? { shift_16[23:0], {8{1'b0}} } :
								(FLAG == FLAG_SHIFT_SRL) ? { {8{1'b0}}, shift_16[31:8] } :
									(FLAG == FLAG_SHIFT_SRA) ? { {8{shift_16[31]}}, shift_16[31:8]} :
										ERROR_OUTPUT
							) : shift_16;

	assign shift_4 = A[2] ? ((FLAG == FLAG_SHIFT_SLL) ? { shift_8[27:0], {4{1'b0}} } :
								(FLAG == FLAG_SHIFT_SRL) ? { {4{1'b0}}, shift_8[31:4] } :
									(FLAG == FLAG_SHIFT_SRA) ? { {4{shift_8[31]}}, shift_8[31:4]} :
										ERROR_OUTPUT
							) : shift_8;

	assign shift_2 = A[1] ? ((FLAG == FLAG_SHIFT_SLL) ? { shift_4[29:0], {2{1'b0}} } :
								(FLAG == FLAG_SHIFT_SRL) ? { {2{1'b0}}, shift_4[31:2] } :
									(FLAG == FLAG_SHIFT_SRA) ? { {2{shift_4[31]}}, shift_4[31:2]} :
										ERROR_OUTPUT
							) : shift_4;

	assign shift_1 = A[0] ? ((FLAG == FLAG_SHIFT_SLL) ? { shift_2[30:0], {1{1'b0}} } :
								(FLAG == FLAG_SHIFT_SRL) ? { {1{1'b0}}, shift_2[31:1] } :
									(FLAG == FLAG_SHIFT_SRA) ? { {1{shift_2[31]}}, shift_2[31:1]} :
										ERROR_OUTPUT
							) : shift_2;

	assign S = shift_1;

endmodule
