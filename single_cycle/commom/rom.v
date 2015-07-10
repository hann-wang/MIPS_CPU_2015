`timescale 1ns/1ps

module ROM (addr,data);
	input [31:0] addr;
	output [31:0] data;
	
	localparam ROM_SIZE = 32;
	parameter ROM_SIZE_BIT = 5;
	
	reg [31:0] ROM_DATA[ROM_SIZE-1:0];
	
	initial
	begin
		ROM_DATA[0]<=32'h0800000c;
		ROM_DATA[1]<=32'h08000003;
		ROM_DATA[2]<=32'h08000002;
		ROM_DATA[3]<=32'h8ef90008;
		ROM_DATA[4]<=32'h3339fff9;
		ROM_DATA[5]<=32'haef90008;
		ROM_DATA[6]<=32'h24180140;
		ROM_DATA[7]<=32'haef80014;
		ROM_DATA[8]<=32'h23390002;
		ROM_DATA[9]<=32'haef90008;
		ROM_DATA[10]<=32'h235afffc;
		ROM_DATA[11]<=32'h03400008;
		ROM_DATA[12]<=32'h20190038;
		ROM_DATA[13]<=32'h03200008;
		ROM_DATA[14]<=32'h3c174000;
		ROM_DATA[15]<=32'haee00008;
		ROM_DATA[16]<=32'h3c19ffff;
		ROM_DATA[17]<=32'h27393caf;
		ROM_DATA[18]<=32'haef90000;
		ROM_DATA[19]<=32'h0000c827;
		ROM_DATA[20]<=32'haef90004;
		ROM_DATA[21]<=32'h24190003;
		ROM_DATA[22]<=32'haef90008;
		ROM_DATA[23]<=32'h08000017;
	end
	
	assign data = ROM_DATA[addr[ROM_SIZE_BIT + 1:2]];
	

endmodule
