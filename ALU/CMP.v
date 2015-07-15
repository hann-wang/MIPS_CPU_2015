`timescale 1ns / 1ps
// 2013011076 Wang Han
// Compare Operation Module

module CMP (input			Zero,
			input			Overflow,
			input			Negative,
			input	[2:0]	FLAG,
			output			S);

    parameter FLAG_CMP_EQ  = 3'b001;
    parameter FLAG_CMP_NEQ = 3'b000;
    parameter FLAG_CMP_LT  = 3'b010;
    parameter FLAG_CMP_LEZ = 3'b110;
    parameter FLAG_CMP_GEZ = 3'b100;
    parameter FLAG_CMP_GTZ = 3'b111;

    parameter ERROR_OUTPUT = 1'b1;

    assign S = (FLAG == FLAG_CMP_EQ) ? Zero :
					(FLAG == FLAG_CMP_NEQ) ? ~Zero :
						(FLAG == FLAG_CMP_LT) ? Negative :
							(FLAG == FLAG_CMP_LEZ) ? (Negative | Zero) :
								(FLAG == FLAG_CMP_GEZ) ? (~Negative) : 
									(FLAG == FLAG_CMP_GTZ) ? (~Negative & ~Zero) :
										ERROR_OUTPUT;

endmodule
