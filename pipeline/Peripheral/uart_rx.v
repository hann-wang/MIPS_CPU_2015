`timescale 1ns/1ps
//2013011076 Wang Han
//UART Receiver

module uartrx(reset, uart_clk, rxd, rx_data, rx_status);
	input reset, uart_clk, rxd;
	output reg [7:0] rx_data;
	output reg rx_status;
	reg [7:0] cnt;
	reg sigbuf, sigfall, receiving, idle;
	
	initial begin
		cnt <= 8'b0;
		rx_data <= 8'b0;
		rx_status <= 1'b0;
		sigbuf <= 1'b1;
		sigfall <= 1'b0;
		receiving <= 1'b0;
		idle <= 1'b1;				//1=idle
	end
	
	//find the negedge of rxd
	always @(negedge reset or posedge uart_clk) 
	begin
		if (~reset)
			begin
				sigbuf <= 1'b1;
				sigfall <= 1'b0;
			end
		else
			begin 
				sigbuf <= rxd;
				sigfall <= sigbuf & (~rxd);
			end
	end
	
	always @(negedge reset or posedge uart_clk)
	begin
		if (~reset)
			receiving <= 1'b0;
		else
		begin
			if (sigfall && idle) 		//negedge detected && idle
				receiving <= 1'b1;
			else
				if(cnt == 8'd152) 		//a byte has been transferred
					receiving <= 1'b0;
		end
	end

	always @(negedge reset or posedge uart_clk)
	begin
		if (~reset)
			begin
				idle <= 1'b1;
				cnt <= 8'b0;
				rx_status <= 1'b0;
				rx_data <= 8'b0;
			end
		else
		begin
			if (receiving)
			begin
				case (cnt)
					//start bit
					8'd0:
						begin
							idle <= 1'b0;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					//rx_data
					8'd24: 
						begin
							idle <= 1'b0;
							rx_data[0] <= rxd;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					8'd40: 
						begin
							idle <= 1'b0;
							rx_data[1] <= rxd;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					8'd56: 
						begin
							idle <= 1'b0;
							rx_data[2] <= rxd;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					8'd72: 
						begin
							idle <= 1'b0;
							rx_data[3] <= rxd;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					8'd88: 
						begin
							idle <= 1'b0;
							rx_data[4] <= rxd;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					8'd104: 
						begin
							idle <= 1'b0;
							rx_data[5] <= rxd;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					8'd120: 
						begin
							idle <= 1'b0;
							rx_data[6] <= rxd;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					8'd136: 
						begin
							idle <= 1'b0;
							rx_data[7] <= rxd;
							cnt <= cnt + 8'd1;
							rx_status <= 1'b0;
						end
					//stop bit
					8'd152: 
						begin
							idle <= 1'b0;
							rx_status <= 1'b1;
							cnt <= 8'd0;
						end
					default:
						begin
							cnt <= cnt + 8'd1;
						end
				endcase
			end
			else
			begin
				cnt <= 8'd0;
				idle <= 1'b1;
				rx_status <= 1'b0;
			end
		end
	end
endmodule
