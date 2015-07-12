`timescale 1ns/1ps

module RegFile (reset,clk,addr1,data1,addr2,data2,wr,addr3,data3);
input reset,clk;
input wr;
input [4:0] addr1,addr2,addr3;
output [31:0] data1,data2;
input [31:0] data3;

reg [31:0] RF_DATA[31:1];

//$0 MUST be all zeros
//Resolve the conflict of read/write
assign data1 = (addr1==5'b0)?32'b0:
			(addr1==addr3)?data3:
			RF_DATA[addr1];
assign data2 = (addr2==5'b0)?32'b0:
			(addr2==addr3)?data3:
			RF_DATA[addr2];

always@(negedge reset or posedge clk) begin
	if(~reset) begin
		RF_DATA[1]<=32'b0;
		RF_DATA[2]<=32'b0;
		RF_DATA[3]<=32'b0;
		RF_DATA[4]<=32'b0;
		RF_DATA[5]<=32'b0;
		RF_DATA[6]<=32'b0;
		RF_DATA[7]<=32'b0;
		RF_DATA[8]<=32'b0;
		RF_DATA[9]<=32'b0;
		RF_DATA[10]<=32'b0;
		RF_DATA[11]<=32'b0;
		RF_DATA[12]<=32'b0;
		RF_DATA[13]<=32'b0;
		RF_DATA[14]<=32'b0;
		RF_DATA[15]<=32'b0;
		RF_DATA[16]<=32'b0;
		RF_DATA[17]<=32'b0;
		RF_DATA[18]<=32'b0;
		RF_DATA[19]<=32'b0;
		RF_DATA[20]<=32'b0;
		RF_DATA[21]<=32'b0;
		RF_DATA[22]<=32'b0;
		RF_DATA[23]<=32'b0;
		RF_DATA[24]<=32'b0;
		RF_DATA[25]<=32'b0;
		RF_DATA[26]<=32'b0;
		RF_DATA[27]<=32'b0;
		RF_DATA[28]<=32'b0;
		RF_DATA[29]<=32'b0;
		RF_DATA[30]<=32'b0;
		RF_DATA[31]<=32'b0;
	end
	else begin
		if(wr && addr3) RF_DATA[addr3] <= data3;
	end
end
endmodule
