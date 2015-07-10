`timescale 1ns/1ps
//2013011076 Wang Han
//DataMemory, forbid reading or writing to address begining with 4

module DataMem (reset,clk,rd,wr,addr,wdata,rdata);
	input reset,clk;
	input rd,wr;
	input [31:0] addr;	//Address Must be Word Aligned
	output [31:0] rdata;
	input [31:0] wdata;

	parameter RAM_SIZE = 256;
	parameter RAM_SIZE_BIT = 8;

	reg [31:0] RAMDATA [RAM_SIZE-1:0];

	//assign rdata=(rd && (addr < RAM_SIZE))?RAMDATA[addr[31:2]]:32'b0;
	assign rdata = (rd && addr[31:28]!=4'h4)? RAMDATA[addr[RAM_SIZE_BIT + 1:2]]: 32'h00000000;

	/*always@(posedge clk) begin
		if(wr && (addr < RAM_SIZE)) RAMDATA[addr[31:2]]<=wdata;
	end*/
	integer i;
	always @(negedge reset or posedge clk)
	begin
		if (~reset)
		begin
			for (i = 0; i < RAM_SIZE; i = i + 1)
				RAMDATA[i] <= 32'h00000000;
		end	
		else
			if (wr && addr[31:28]!=4'h4)
				RAMDATA[addr[RAM_SIZE_BIT + 1:2]] <= wdata;
	end
endmodule
