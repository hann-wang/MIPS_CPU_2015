`timescale 1ns/1ps
//Incomplete
//2013011076 Wang Han
//single_cycle, Top Level Module

module single_cycle(clk,reset);

	input			clk;
	input			reset;
	
	wire	[31:0]	MemAddr;
	wire			MemWrite;
	wire			MemRead;
	wire	[31:0]  MemWriteData;
	wire	[31:0]  MemReadData;
	
	single_cycle_core single_cycle_core0(.clk(clk),
										.reset(reset),
										.oMemAddr(MemAddr),
										.oMemWrite(MemWrite),
										.oMemWriteData(MemWriteData),
										.oMemRead(MemRead),
										.iMemReadData(MemReadData),
										.iInterrupt(0));
	DataMem datamem0(reset,clk,MemRead,MemWrite,MemAddr,MemWriteData,MemReadData);
	
endmodule
