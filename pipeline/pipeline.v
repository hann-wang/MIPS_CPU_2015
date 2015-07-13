`timescale 1ns/1ps
//2013011076 Wang Han
//Pipeline top module
//Incomplete!

module pipeline(sysclk,reset,switch,digi1,digi2,digi3,digi4,led,txd,rxd);

	input			sysclk;
	input			reset;
	input	[7:0]	switch;
	input			rxd;
	output	[6:0]	digi1;
	output	[6:0]	digi2;
	output	[6:0]	digi3;
	output	[6:0]	digi4;
	output	[7:0]	led;
	output			txd;
	
	wire	[31:0]	MemAddr;
	wire			MemWrite;
	wire			MemRead;
	wire	[31:0]  MemWriteData;
	wire	[31:0]  MemReadData;
	wire 			IRQ;
	wire	[11:0]	digi;
	wire 			clk;
	
	assign clk = sysclk;
	
	digitube_scan digitube_scan0(.digi_in(digi),.digi_out1(digi1),.digi_out2(digi2),.digi_out3(digi3),.digi_out4(digi4));

	Peripheral peripheral0(.reset(reset),
						.sysclk(sysclk),
						.clk(clk),
						.rd(MemRead),
						.wr(MemWrite),
						.addr(MemAddr),
						.wdata(MemWriteData),
						.rdata(MemReadData),
						.led(led),
						.switch(switch),
						.digi(digi),
						.irqout(IRQ),
						.txd(txd),
						.rxd(rxd));

	pipeline_core pipeline_core(.clk(clk),
										.reset(reset),
										.oMemAddr(MemAddr),
										.oMemWrite(MemWrite),
										.oMemWriteData(MemWriteData),
										.oMemRead(MemRead),
										.iMemReadData(MemReadData),
										.iInterrupt(IRQ));

endmodule
