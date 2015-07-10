`timescale 1ns/1ps
//Incomplete
//2013011076 Wang Han
//single_cycle_tb

module single_cycle_tb;
	
	reg reset;
	reg clk;
	reg [7:0] switch;
	wire [7:0] led;
	wire [6:0] digi1;
	wire [6:0] digi2;
	wire [6:0] digi3;
	wire [6:0] digi4;
	
	single_cycle cpu0(clk,reset,switch,digi1,digi2,digi3,digi4,led);
	
	initial begin
		reset = 0;
		clk = 0;
		#100 reset = 1;
		switch = 8'b01001010;
	end
	
	always #50 clk = ~clk;
		
endmodule
