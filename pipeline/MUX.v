`timescale 1ns / 1ps

// 2013011076 Wang Han
// MUX2/4/8

module MUX2(
	input [31:0] iData0,
	input [31:0] iData1,
	input Ctrl,
	output [31:0] oData
	);
	assign oData = (Ctrl == 1'b1) ? iData1 : iData0;
endmodule

module MUX4(
    input [31:0] iData0,
    input [31:0] iData1,
    input [31:0] iData2,
    input [31:0] iData3,
    input [1:0] Ctrl,
    output [31:0] oData
    );
	assign oData = (Ctrl == 2'b00) ? iData0 :
				(Ctrl == 2'b01) ? iData1 :
                (Ctrl == 2'b10) ? iData2 :
				iData3;
endmodule

module MUX8(
	input [31:0] iData0,
	input [31:0] iData1,
	input [31:0] iData2,
	input [31:0] iData3,
	input [31:0] iData4,
	input [31:0] iData5,
	input [31:0] iData6,
	input [31:0] iData7,
	input [2:0] Ctrl,
	output [31:0] oData
	);

	wire [31:0] oData1, oData;

	MUX4 Mux4_1(
		.iData0(iData0),
		.iData1(iData1),
		.iData2(iData2),
		.iData3(iData3),
		.iControl(Ctrl[1:0]),
		.oData(oData1)
		);

	MUX4 Mux4_2(
		.iData0(iData4),
		.iData1(iData5),
		.iData2(iData6),
		.iData3(iData7),
		.iControl(Ctrl[1:0]),
		.oData(oData2)
		);

	MUX2 Mux2(
		.iData0(oDataTemp1),
		.iData1(oDataTemp2),
		.Ctrl(Ctrl[2]),
		.oData(oData)
		);
endmodule
