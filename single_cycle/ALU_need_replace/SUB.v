`timescale 1ns / 1ps

module SUB( A, B, Sign, S, V );

    input [31:0] A;
    input [31:0] B;
    input Sign;

    output reg [31:0] S;
    output reg V;

    reg [31:0] tempA,tempB;

    always@(*)
    begin
        S = A - B;
        if (~Sign)
        begin
            V = (A < B);
        end
        else
        begin
            if ((A[31] == B[31]))
            begin
                V = 0;
            end
            else
            begin
                if (A[31])
                begin
                    if (S[31] == 0)
                    begin
                        V = 1;
                    end
                    else
                    begin
                        V = 0;
                    end
                end
                else
                begin
                    if (S[31] == 1)
                    begin
                        V = 1;
                    end
                    else
                    begin
                        V = 0;
                    end
                end
            end
        end
    end
endmodule



module SUB_BACKUP( A, B, Sign, S, V );
    input [31:0] A;
    input [31:0] B;
    input Sign;

    output [31:0] S;
    output reg V;

    reg [31:0] tempA,tempB;
    sub u1(A,B,S);

    always@(*)
    begin
        if (~Sign)
        begin
            V = S[31];
        end
        else
        begin
            if ((A[31] == B[31]))
            begin
                V = 0;
            end
            else
            begin
                if (A[31])
                begin
                    if (S[31] == 0)
                    begin
                        V = 1;
                    end
                    else
                    begin
                        V = 0;
                    end
                end
                else
                begin
                    if (S[31] == 1)
                    begin
                        V = 1;
                    end
                    else
                    begin
                        V = 0;
                    end
                end
            end
        end
    end

endmodule

module sub(a,b,s);
    input   [31:0] a;
    input   [31:0] b;
    output  [31:0] s;

    wire [31:0] temp;
    wire out;
    assign temp = ~b;
    add u1(a,temp,s,1'b1,out);
endmodule
