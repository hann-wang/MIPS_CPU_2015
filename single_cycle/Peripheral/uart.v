`timescale 1ns/1ps
//2013011076 Wang Han
//UART Controller

module uart(sysclk,reset,rxd,txd);
	input sysclk, reset, rxd;
	output txd;
	wire uart_clk, tx_status, rx_status;
	reg tx_en, tx_ready, rx_status_buf;
	wire [7:0] rx_data;
	reg [7:0] tx_data, tmp_data;
	
	initial begin
		tx_en <= 1'b0;
		tx_data <= 8'b0;
		tx_ready <= 1'b0;
		tmp_data <= 8'b0;
		rx_status_buf <= 1'b1;
	end
	
	//UART module uses a 16-times baud rate clock
	uart_clkdiv uart_clkgen(sysclk,uart_clk);
	uarttx tx0(uart_clk, tx_data, tx_en, tx_status, txd);
	uartrx rx0(uart_clk, rxd, rx_data, rx_status);
	
	//UART控制
	always @(posedge uart_clk or negedge reset)
	begin
		if (~reset)
			begin
				tx_en <= 1'b0;
				tx_data <= 8'b0;
				tx_ready <= 1'b0;
				tmp_data <= 8'b0;
				rx_status_buf <= 1'b1;
			end
		else
			begin
				//rx_status上升沿，接收到一个字节
				rx_status_buf <= rx_status;
				if ((~rx_status_buf) && rx_status)
					begin
						if (rx_data[7])
							tmp_data = (~rx_data) | 8'b1000_0000;
						else
							tmp_data = rx_data;
						//发送数据准备好了
						tx_ready<=1'b1;
					end
				//等到发送空闲
				if (tx_status && tx_ready)
					begin
						tx_data = tmp_data;
						tx_en<=1'b1;
						tx_ready<=1'b0;
					end
				else if (~tx_status) tx_en<=1'b0;
			end
	end
	
endmodule
