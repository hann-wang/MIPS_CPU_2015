`timescale 1ns / 1ps

module LT( A, B, Sign, S, V);

    input [31:0] A;
    input [31:0] B;
    input Sign;

    output reg [31:0] S;
    output reg V;

    always@(*)
    begin
        if (A < B) S = 1;
	    else S = 0;
        V = 0;
    end

endmodule
