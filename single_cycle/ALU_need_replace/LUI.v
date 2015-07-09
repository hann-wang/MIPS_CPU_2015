`timescale 1ns / 1ps

module LUI( A, B, Sign, S, V);

    input [31:0] A;
    input [31:0] B;
    input Sign;

    output reg [31:0] S;
    output reg V;

    always@(*)
    begin
        S = {B[15:0], {16{1'b0}}};
        V = 0;
    end

endmodule
