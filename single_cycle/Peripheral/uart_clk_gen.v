// 分频
// 波特率9600，取16倍采样频率
// 50000000/(16*9600) = 325.52
module uart_clk_gen(sysclk, uart_clk);
	input sysclk; //系统时钟
	output uart_clk; //采样时钟
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