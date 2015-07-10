`timescale 1ns/1ps

module ROM (addr,data);
input [31:0] addr;
output [31:0] data;
reg [31:0] data;
localparam ROM_SIZE = 32;
reg [31:0] ROM_DATA[ROM_SIZE-1:0];

always@(*)
	case(addr[7:2])	//Address Must Be Word Aligned.
		0: data <= 32'h3c114000;
		1: data <= 32'h26310004;
		2: data <= 32'h241000aa;
		3: data <= 32'hae200000;
		4: data <= 32'h08100000;
		5: data <= 32'h0c000000;
		6: data <= 32'h00000000;
		7: data <= 32'h3402000a;
		8: data <= 32'h0000000c;
		9: data <= 32'h0000_0000;
		10: data <= 32'h0274_8825;
		11: data <= 32'h0800_0015;
		12: data <= 32'h0274_8820;
		13: data <= 32'h0800_0015;
		14: data <= 32'h0274_882A;
		15: data <= 32'h1011_0002;
		16: data <= 32'h0293_8822;
		17: data <= 32'h0800_0015;
		18: data <= 32'h0274_8822;
		19: data <= 32'h0800_0015; 
		20: data <= 32'h0274_8824;
		21: data <= 32'hae11_0003;
		22: data <= 32'h0800_0001;
	   default:	data <= 32'h0800_0000;
	endcase
endmodule
