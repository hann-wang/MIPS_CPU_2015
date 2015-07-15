module ALU(
	A,
	B,
	fun,
	sign,
	Z);
	input [31:0] A,B;
	input [5:0] fun;
	input sign;
	output [31:0] Z;
	wire [31:0]z1,z2,z3,z4;
	
	Fun_00 f1(A,B,fun[0],sign,z1);
	Fun_01 f2(A,B,fun[3:0],z2);
	Fun_10 f3(A,B,fun[1:0],z3);
	Fun_11 f4(A,B,fun[3:1],sign,z4);
	
	assign	Z=
	(fun[5:4]==2'b00)?z1:
	(fun[5:4]==2'b01)?z2:
	(fun[5:4]==2'b10)?z3:
	(fun[5:4]==2'b11)?z4:32'b0;
endmodule	
	