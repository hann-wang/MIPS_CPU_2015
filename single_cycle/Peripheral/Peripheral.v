`timescale 1ns/1ps
//2013011076 Wang Han
//Provide connection to Memory, timer, LEDs, switches and UART.
//Timer:
////TCON[2:0]={interrupt_state, interrupt_controll, enable}
////TL is the automatic counter
////TH is the start point of counter
//UART:
////rx_data_store: the data received
////tx_data: the data to sending
////received: 1-data received & unread
////sent: 1-data has been sent
////tx_control: 1-tx enable
////rx_control: 1-rx enable 
////tx_status: 0-idle, 1-busy

module Peripheral (reset,sysclk,clk,rd,wr,addr,wdata,rdata,led,switch,digi,irqout,txd,rxd);
	//===== I/O =====
	input reset,clk;
	input rd,wr;
	input [31:0] addr;
	input [31:0] wdata;
	output [31:0] rdata;
	//=====UART======
	//If tx_data has been sent, set sent=1
	input sysclk;
	input rxd;
	output txd;
	wire uart_clk, tx_status, rx_status;
	reg tx_en, rx_status_buf;
	reg tx_control, rx_control, sent, received;
	wire [7:0] rx_data;
	reg [7:0] rx_data_store;
	reg [7:0] tx_data;
	//===== LED =====
	output [7:0] led;
	reg [7:0] led;
	input [7:0] switch;
	output [11:0] digi;
	reg [11:0] digi;
	output irqout;
	//===== Timer =====
	reg [31:0] TH,TL;
	reg [2:0] TCON;
	assign irqout = TCON[2];
	//===== Memory =====
	wire [31:0] MemReadData;
	DataMem datamem0(.reset(reset),.clk(clk),.rd(rd),.wr(wr),.addr(addr),.wdata(wdata),.rdata(MemReadData));
	
	//UART module uses a 16-times baud rate clock
	uart_clk_gen uart_clk_gen0(sysclk,uart_clk);
	uarttx tx0(.uart_clk(uart_clk), .tx_data(tx_data), .tx_en(tx_en), .tx_status(tx_status), .txd(txd));
	uartrx rx0(.uart_clk(uart_clk), .rxd(rxd), .rx_data(rx_data), .rx_status(rx_status));
	
	assign rdata =  (rd) ? (
					(addr==32'h40000000) ? TH :
					(addr==32'h40000004) ? TL :
					(addr==32'h40000008) ? {29'b0,TCON} :
					(addr==32'h4000000C) ? {24'b0,led} :
					(addr==32'h40000010) ? {24'b0,switch} :
					(addr==32'h40000014) ? {20'b0,digi} :
					(addr==32'h40000018) ? {24'b0,tx_data} :
					(addr==32'h4000001C) ? {24'b0,rx_data_store} :
					(addr==32'h40000020) ? {27'b0,tx_status, received, sent, rx_control, tx_control} :
					MemReadData):32'b0;
	
	always@(negedge reset or posedge clk)
	begin
		if(~reset)
		begin
			TH <= 32'b0;
			TL <= 32'b0;
			TCON <= 3'b0;
			led <= 8'b0;
			digi <= 12'b0;
			tx_control <=1'b0;
			rx_control <=1'b0;
			sent <= 1'b1;
			received <= 1'b0;
			tx_data <= 8'b0;
			rx_data_store <= 8'b0;
			rx_status_buf <= 1'b1;
			tx_en <= 1'b0;
		end
		else
		begin
			if(rd && addr==32'h4000001C)
					received <= 1'b0;
			
			if(TCON[0]) begin	//timer is enabled
				if(TL==32'hffffffff) begin
					TL <= TH;
					if(TCON[1]) TCON[2] <= 1'b1;		//irq is enabled
				end
				else TL <= TL + 1;
			end
			
			if (tx_en && tx_status)
				tx_en <= 1'b0;							//If sending process has begun, restore tx_en to 0
			
			if (rx_control)								//UART receiver enabled
				begin
					rx_status_buf <= rx_status;			//Detect the posedge of rx_status
					if ((~rx_status_buf) && rx_status)
						begin
							rx_data_store = rx_data;
							received <= 1'b1;
						end
				end
			
			if(wr)
			begin
				case(addr)
					32'h40000000: TH <= wdata;
					32'h40000004: TL <= wdata;
					32'h40000008: TCON <= wdata[2:0];		
					32'h4000000C: led <= wdata[7:0];			
					32'h40000014: digi <= wdata[11:0];
					32'h40000018: 
						begin
							tx_data = wdata[7:0];
							sent <= 1'b0;
							if (tx_control && ~tx_status)
								begin
									tx_en<=1'b1;
									sent <= 1'b1;
								end
						end
					32'h40000020:
						begin
							tx_control <= wdata[0];
							rx_control <= wdata[1];
						end
					default: ;
				endcase
			end
			
			
		end
	end
endmodule
