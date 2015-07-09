`timescale 1ns/1ps
//Incomplete
//2013011076 Wang Han
//single_cycle_tb

module single_cycle_tb;
	
	reg reset;
	reg clk;
	
	single_cycle cpu1(clk,reset);
	
	initial begin
		reset = 0;
		clk = 0;
		#100 reset = 1;
	end
	
	always #50 clk = ~clk;
		
endmodule
