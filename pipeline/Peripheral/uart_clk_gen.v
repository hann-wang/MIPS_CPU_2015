`timescale 1ns/1ps
//2013011076 Wang Han
// UART Clock Generator
// Baud rate 9600, 16 times 1600 sampling
// 50000000/(16*9600) = 325.52

module uart_clk_gen(sysclk, uart_clk);
	input sysclk;
	output uart_clk;
	reg uart_clk;
	reg [15:0] cnt;
	initial begin
		cnt<=0;
		uart_clk<=0;
	end
	always @(posedge sysclk)
	begin
		if(cnt == 16'd162)
		begin
			uart_clk <= 1'b1;
			cnt <= cnt + 16'd1;
		end
		else
			if(cnt == 16'd325)
			begin
				uart_clk <= 1'b0;
				cnt <= 16'd0;
			end
			else
				cnt <= cnt + 16'd1;
	end
endmodule