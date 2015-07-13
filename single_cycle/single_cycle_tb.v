`timescale 1ns/1ps

//2013011076 Wang Han
//single_cycle_tb

module single_cycle_tb;
	
	reg reset;
	reg clk;
	reg [7:0] switch;
	reg rxd;
	wire txd;
	reg [7:0] rdata;
	wire [7:0] led;
	wire [6:0] digi1;
	wire [6:0] digi2;
	wire [6:0] digi3;
	wire [6:0] digi4;
	
	single_cycle cpu0(clk,reset,switch,digi1,digi2,digi3,digi4,led,txd,rxd);
	
	initial begin
		reset <= 0;
		clk <= 0;
		reset <= 0;
		switch <= 8'b01001010;
		rdata <= 8'h01;
		rxd <= 1'b1;
	end
	
	initial fork
		#20 reset <= 1;
		forever #10 clk = ~clk;
		forever
			begin
				#104166.667 rxd=1'b0;
				#104166.667 rxd=rdata[0];
				#104166.667 rxd=rdata[1];
				#104166.667 rxd=rdata[2];
				#104166.667 rxd=rdata[3];
				#104166.667 rxd=rdata[4];
				#104166.667 rxd=rdata[5];
				#104166.667 rxd=rdata[6];
				#104166.667 rxd=rdata[7];
				#104166.667 rxd=1'b1;
			end
	join
endmodule
