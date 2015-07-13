`timescale 1ns/1ps
//2013011076 Wang Han
//This version of ROM uses $readmemh to initialize ROM.
//Instruction should be written in HEX.
module ROM (addr,data);
	input [31:0] addr;
	output [31:0] data;
	
	localparam ROM_SIZE = 256;
	parameter ROM_SIZE_BIT = 8;
	
	reg [31:0] ROM_DATA[ROM_SIZE-1:0];
	
	initial
	begin
		$readmemh("F:/Git/MIPS_CPU_2015/pipeline/InstructionROM/MIPScode_pipeline.rom", ROM_DATA);
	end
	
	assign data = ROM_DATA[addr[ROM_SIZE_BIT + 1:2]];
	

endmodule
