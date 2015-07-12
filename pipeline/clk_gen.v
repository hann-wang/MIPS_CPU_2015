`timescale 1ns/1ps
//2013011076 Wang Han
//This CPU is now working at 25MHz

module clk_gen(sysclk,clk);
	input sysclk;
	output clk;
	reg clk;
	reg counter;
	initial begin
		clk<=0;
		counter<=0;
	end
	always@(posedge sysclk)
	begin
		if (counter)
			begin
				counter<=0;
				clk<=~clk;
			end
		else
			counter<=~counter;
	end
endmodule
