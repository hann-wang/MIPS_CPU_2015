`timescale 1ns/1ps

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
	assign rdata = rd? RAMDATA[addr[RAM_SIZE_BIT + 1:2]]: 32'h00000000;

	/*always@(posedge clk) begin
		if(wr && (addr < RAM_SIZE)) RAMDATA[addr[31:2]]<=wdata;
	end*/
	always @(posedge reset or posedge clk)
		if (wr)
			RAMDATA[addr[RAM_SIZE_BIT + 1:2]] <= wdata;

endmodule
