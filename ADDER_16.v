module FA(
	X,
	Y,
	Cin,
	Z,
	p,
	g);
	input X,Y,Cin;
	output Z,p,g;
xor (p,X,Y),
	(Z,p,Cin);
and	(g,X,Y);
endmodule

module ADDER_4(
	X,
	Y,
	Cin,
	Z,
	P,
	G);
	input [3:0]X,Y;
	input Cin;
	output [3:0]Z;
	output P,G;
	wire [3:0]c,p,g;
	wire t10,t21,t20,t32,t31,t30,t3,t2,t1;

FA f0(X[0],Y[0],c[0],Z[0],p[0],g[0]);
FA f1(X[1],Y[1],c[1],Z[1],p[1],g[1]);
FA f2(X[2],Y[2],c[2],Z[2],p[2],g[2]);
FA f3(X[3],Y[3],c[3],Z[3],p[3],g[3]);

assign c[0]=Cin;

and	(t10,c[0],p[0]);
or	(c[1],g[0],t10);

and	(t21,g[0],p[1]),
	(t20,c[0],p[1],p[0]);
or	(c[2],g[1],t21,t20);

and	(t32,g[1],p[2]),
	(t31,g[0],p[2],p[1]),
	(t30,c[0],p[2],p[1],p[0]);
or	(c[3],g[2],t32,t31,t30);

and	(P,p[3],p[2],p[1],p[0]),
	(t3,g[2],p[3]),
	(t2,g[1],p[3],p[2]),
	(t1,g[0],p[3],p[2],p[1]);
or	(G,g[3],t3,t2,t1);

endmodule

module ADDER_16(
	X,
	Y,
	Cin,
	Z,
	Cout);
	input [15:0]X,Y;
	input Cin;
	output [15:0]Z;
	output Cout;
	wire [3:0]c,p,g;
	wire t10,t21,t20,t32,t31,t30,t;

ADDER_4 a0(X[3:0],Y[3:0],c[0],Z[3:0],p[0],g[0]);
ADDER_4 a1(X[7:4],Y[7:4],c[1],Z[7:4],p[1],g[1]);
ADDER_4 a2(X[11:8],Y[11:8],c[2],Z[11:8],p[2],g[2]);
ADDER_4 a3(X[15:12],Y[15:12],c[3],Z[15:12],p[3],g[3]);

assign c[0]=Cin;

and	(t10,c[0],p[0]);
or	(c[1],g[0],t10);

and	(t21,g[0],p[1]),
	(t20,c[0],p[1],p[0]);
or	(c[2],g[1],t21,t20);

and	(t32,g[1],p[2]),
	(t31,g[0],p[2],p[1]),
	(t30,c[0],p[2],p[1],p[0]);
or	(c[3],g[2],t32,t31,t30);

and	(t,p[3],c[3]);
or	(Cout,t,g[3]);

endmodule
