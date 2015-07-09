`timescale 1ns / 1ps

module EQ( A, B, Sign, S, V);

    input [31:0] A;
    input [31:0] B;
    input Sign;

    output reg [31:0] S;
    output reg V;

    always@(*)
    begin
        if (A == B) S = 1;
	    else S = 0;
        V = 0;
    end

endmodule

module EQ_BACKUP( A, B, Sign, S, Z, V, N);

    input [31:0] A;
    input [31:0] B;
    input Sign;

    output [31:0] S;
    output reg Z;
    output reg V;
    output reg N;

    eq u1(A,B,S);
    always@(*)
    begin
        V = 0;
        N = 0;
        if (S == 0) Z = 1;
        else Z = 0;
    end

endmodule


module eq(a,b,out);
    input   [31:0] a;
    input   [31:0] b;
    output  [31:0] out;

    wire [31:0] s;
    sub u1(a,b,s);

    assign out[31:1] = 0;
    assign out[0] = ~(|s);

endmodule
