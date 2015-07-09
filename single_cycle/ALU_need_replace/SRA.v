`timescale 1ns / 1ps

module SRA( A, B, Sign, S, V);

    input [31:0] A;
    input [31:0] B;
    input Sign;

    output reg [31:0] S;
    output reg V;

    wire [63:0] ExtB;
    assign ExtB = {{32{B[31]}}, B} >> A;

    always@(*)
    begin
        S = ExtB[31:0];
        V = 0;
    end

endmodule
