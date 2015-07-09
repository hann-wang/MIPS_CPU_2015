`timescale 1ns / 1ps

module ADD(A,B,Sign,S,Z,V,N);

    input [31:0] A;
    input [31:0] B;
    input Sign;

    output reg [31:0] S;
    output reg Z;
    output reg V;
    output reg N;

    reg [31:0] tempA,tempB;
    
  //  add adder(.a(A),.b(B),.s(S),.cin(1'b0));

    always@(*)
    begin
        S = A + B;
        if (~Sign)
        begin
            V = ((S < A) || (S < B));
        end
        else
        begin
            if ((A[31] == 0) && (B[31] == 0))
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
            else if (A[31] != B[31])
            begin
                V = 0;
            end
            else
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
        end
    end
endmodule

module ADD_BACKUP(A,B,Sign,S,V);

    input [31:0] A;
    input [31:0] B;
    input Sign;

    output [31:0] S;
    output reg V;

    reg [31:0] tempA,tempB;
    
    add adder(.a(A),.b(B),.s(S),.cin(1'b0));

    always@(*)
    begin
        if (~Sign)
        begin
            if ((S < A) || (S < B)) V = 1;
            else V = 0;
        end
        else
        begin
            if ((A[31] == 0) && (B[31] == 0))
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
            else if (A[31] != B[31])
            begin
                V = 0;
            end
            else
            begin
                if (S[31] == 0) V = 1;
                else V = 0;
            end
        end
    end

endmodule

module adder4BitsSuper(a,b,s,cLow,cHigh);
	input [3:0] a,b;
	output [3:0] s;
	input cLow;
	output cHigh;
	
    wire[3:0] g;
	wire[3:0] p;
	wire[2:0] cin;

	and g0(g[0],a[0],b[0]);
	and g1(g[1],a[1],b[1]);
	and g2(g[2],a[2],b[2]);
	and g3(g[3],a[3],b[3]);

	xor p0(p[0],a[0],b[0]);
	xor p1(p[1],a[1],b[1]);
	xor p2(p[2],a[2],b[2]);
	xor p3(p[3],a[3],b[3]);

	and te0(t0,p[0],cLow);
    and te1(t1,p[1],cin[0]);
	and te2(t2,p[2],cin[1]);
	and te3(t3,p[3],cin[2]);

	or in0(cin[0],g[0],t0);
	or in1(cin[1],g[1],t1);
	or in2(cin[2],g[2],t2);
	or in3(cHigh,g[3],t3);

	xor us0(s[0],p[0],cLow);
	xor us1(s[1],p[1],cin[0]);
	xor us2(s[2],p[2],cin[1]);
	xor us3(s[3],p[3],cin[2]);

endmodule

module add(a,b,s,cin,chigh);
    input   [31:0] a;
    input   [31:0] b;
    input          cin;
    output  [31:0] s;
    output         chigh;

    adder4BitsSuper u0(.a(a[3:0]),.b(b[3:0]),.s(s[3:0]),.cLow(cin),.cHigh(c0));
    adder4BitsSuper u1(.a(a[7:4]),.b(b[7:4]),.s(s[7:4]),.cLow(c0),.cHigh(c1));
    adder4BitsSuper u2(.a(a[11:8]),.b(b[11:8]),.s(s[11:8]),.cLow(c1),.cHigh(c2));
    adder4BitsSuper u3(.a(a[15:12]),.b(b[15:12]),.s(s[15:12]),.cLow(c2),.cHigh(c3));
    adder4BitsSuper u4(.a(a[19:16]),.b(b[19:16]),.s(s[19:16]),.cLow(c3),.cHigh(c4));
    adder4BitsSuper u5(.a(a[23:20]),.b(b[23:20]),.s(s[23:20]),.cLow(c4),.cHigh(c5));
    adder4BitsSuper u6(.a(a[27:24]),.b(b[27:24]),.s(s[27:24]),.cLow(c5),.cHigh(c6));
    adder4BitsSuper u7(.a(a[31:28]),.b(b[31:28]),.s(s[31:28]),.cLow(c6),.cHigh(chigh));
endmodule






















