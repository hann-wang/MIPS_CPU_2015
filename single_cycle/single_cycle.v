`timescale 1ns/1ps
//2013011076 Wang Han
//single_cycle, Top Level Module
//This module connect the CPU core to peripherals like LEDs, switches, timer and UART.
//Clock is also generated here.

module single_cycle(sysclk,reset,switch,digi1,digi2,digi3,digi4,led);

	input			sysclk;
	input			reset;
	input	[7:0]	switch;
	output	[6:0]	digi1;
	output	[6:0]	digi2;
	output	[6:0]	digi3;
	output	[6:0]	digi4;
	output	[7:0]	led;
	
	wire	[31:0]	MemAddr;
	wire			MemWrite;
	wire			MemRead;
	wire	[31:0]  MemWriteData;
	wire	[31:0]  MemReadData;
	wire 			IRQ;
	wire	[11:0]	digi;
	wire 			clk;
	
	clk_gen clk_gen0(sysclk,clk);
	
	digitube_scan digitube_scan0(.digi_in(digi),.digi_out1(digi1),.digi_out2(digi2),.digi_out3(digi3),.digi_out4(digi4));

	Peripheral peripheral0(.reset(reset),
						.clk(clk),
						.rd(MemRead),
						.wr(MemWrite),
						.addr(MemAddr),
						.wdata(MemWriteData),
						.rdata(MemReadData),
						.led(led),
						.switch(switch),
						.digi(digi),
						.irqout(IRQ));

	single_cycle_core single_cycle_core0(.clk(clk),
										.reset(reset),
										.oMemAddr(MemAddr),
										.oMemWrite(MemWrite),
										.oMemWriteData(MemWriteData),
										.oMemRead(MemRead),
										.iMemReadData(MemReadData),
										.iInterrupt(IRQ));

endmodule
