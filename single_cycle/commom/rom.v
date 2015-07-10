`timescale 1ns/1ps

module ROM (addr,data);
	input [31:0] addr;
	output [31:0] data;
	
	localparam ROM_SIZE = 64;
	parameter ROM_SIZE_BIT = 6;
	
	reg [31:0] ROM_DATA[ROM_SIZE-1:0];
	
	initial
	begin
		$readmemh("F:/Git/MIPS_CPU_2015/single_cycle/commom/test_digi.rom", ROM_DATA);
	end
	
	assign data = ROM_DATA[addr[ROM_SIZE_BIT + 1:2]];
	

endmodule
