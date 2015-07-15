module ADDER_32(
	X,
	Y,
	Cin,
	Z,
	Cout);
	input [31:0]X,Y;
	input Cin;
	output [31:0] Z;
	output Cout;
	wire c;
	ADDER_16 a0(X[15:0],Y[15:0],Cin,Z[15:0],c);
	ADDER_16 a1(X[31:16],Y[31:16],c,Z[31:16],Cout);
endmodule
 
module Fun_00 (
	A,
	B,
	fun,
	sig,	//0 for unsigned
	S,
	Z,
	V,
	N);
	input [31:0]A,B;
	input fun,sig;
	output [31:0] S;
	output Z,V,N;
	wire [31:0]b;
	wire c,j;
	
	ADDER_32 a(A,b,fun,S,c);
	
	assign j=(A[31]==b[31])&(A[31]!=S[31]);
	assign b=
		(fun==1'b0)?B:~B;
	assign Z=
		(S==32'b0)?1'b1:1'b0;
	assign V=
		(sig==1'b0)?1'b0:
		(j==1'b1)?1'b1:1'b0;
	assign N=
		(sig==1'b0)?~c:
		(j==1'b1)?~S[31]:S[31];
endmodule
		
module Fun_01 (
	A,
	B,
	fun,
	S);
	input [31:0] A,B;
	input [3:0] fun;
	output [31:0] S;
	
	assign S=
		(fun==4'b1000)?A&B:
		(fun==4'b1110)?A|B:
		(fun==4'b0110)?A^B:
		(fun==4'b0001)?~(A|B):
		(fun==4'b1010)?A:32'b0;
endmodule

module Fun_10 (
	A,
	B,
	fun,
	S);
	input [31:0] A,B;
	input [1:0] fun;
	output [31:0]S;
	wire [31:0] bl1,bl2,bl3,bl4,bl5,br1,br2,br3,br4,br5,ba1,ba2,ba3,ba4,ba5;
	
	assign bl1=A[4]?{B[15:0],16'b0}:B;
	assign bl2=A[3]?{bl1[23:0],8'b0}:bl1;
	assign bl3=A[2]?{bl2[27:0],4'b0}:bl2;	
	assign bl4=A[1]?{bl3[29:0],2'b0}:bl3;
	assign bl5=A[0]?{bl4[30:0],1'b0}:bl4;
	
	
	assign br1=A[4]?{16'b0,B[31:16]}:B;
	assign br2=A[3]?{8'b0,br1[31:8]}:br1;
	assign br3=A[2]?{4'b0,br2[31:4]}:br2;	
	assign br4=A[1]?{2'b0,br3[31:2]}:br3;
	assign br5=A[0]?{1'b0,br4[31:1]}:br4;
	
	assign ba1=A[4]?{16'hffff,B[31:16]}:B;
	assign ba2=A[3]?{8'hff,ba1[31:8]}:ba1;
	assign ba3=A[2]?{4'hf,ba2[31:4]}:ba2;	
	assign ba4=A[1]?{2'd3,ba3[31:2]}:ba3;
	assign ba5=A[0]?{1'b1,ba4[31:1]}:ba4;
	
	assign S=
		fun[1]?B[31]?ba5:br5:
		fun[0]?br5:bl5;
endmodule

module Fun_11 (
	A,
	B,
	fun,
	sig,
	S);
	input [31:0] A,B;
	input [2:0] fun;
	input sig;
	output [31:0] S;
	wire s,z,v,n;
	
	Fun_00 f(A,B,1,sig,s,z,v,n);
	
	assign S[31:1]=31'b0;
	assign S[0]=
		(fun==3'b001)?z:
		(fun==3'b000)?~z:
		(fun==3'b010)?n:
		(fun==3'b100)?~(A[31]&sig): //GEZ
		(fun==3'b110)?(A==32'b0)|(A[31]&sig): //LEZ
		(fun==3'b111)?~((A==32'b0)|(A[31]&sig)):1'b0; //GTZ
endmodule

	
