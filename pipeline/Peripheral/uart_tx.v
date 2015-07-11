`timescale 1ns/1ps
//2013011076 Wang Han
//UART Sender

module uarttx(uart_clk, tx_data, tx_en, tx_status, txd);
	input uart_clk;
	input [7:0] tx_data; 	//data to send
	input tx_en; 			//sender enable
	output reg tx_status;	//0=idle, 1=busy
	output reg txd;
	reg sending;
	reg sigbuf, sigrise;
	reg[7:0] cnt; 			//counter
	
	initial begin
		cnt <= 1'b0;
		sigbuf <= 1'b0;
		sigrise <= 1'b0;
		txd <= 1'b1;
		tx_status <= 1'b0;
		sending <= 1'b0;
	end
	
	//find the posedge of tx_en
	always @(posedge uart_clk)
	begin
		sigbuf <= tx_en;
		sigrise <= (~sigbuf) & tx_en;
	end
	
	//start or terminate a sending thread
	always @(posedge uart_clk)
	begin
		if (sigrise && ~tx_status)	//posedge of tx_en detected && idle
			sending <= 1'b1;
		else
			if(cnt == 8'd160) 		//a byte has been transferred
				sending <= 1'b0;
	end
	
	//sending thread
	always @(posedge uart_clk)
	begin
		if (sending)
		begin
			case(cnt)
				//start bit
				8'd0:
					begin
						txd <= 1'b0;
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				//tx_data
				8'd16:
					begin
						txd <= tx_data[0];
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd32:
					begin
						txd <= tx_data[1];
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd48:
					begin
						txd <= tx_data[2];
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd64:
					begin
						txd <= tx_data[3];
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd80:
					begin
						txd <= tx_data[4];
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd96:
					begin
						txd <= tx_data[5];
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd112:
					begin
						txd <= tx_data[6];
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				8'd128:
					begin
						txd <= tx_data[7];
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				//stop bit
				8'd144:
					begin
						txd <= 1'b1;
						tx_status <= 1'b1;
						cnt <= cnt + 8'd1;
					end
				//idle
				8'd160:
					begin
						txd <= 1'b1;
						tx_status <= 1'b0;
						cnt <= 8'd0;
					end
				default:
						cnt <= cnt + 8'd1;
			endcase
		end
		else
		begin
			txd <= 1'b1;
			cnt <= 8'd0;
			tx_status <= 1'b0;
		end
	end
endmodule
