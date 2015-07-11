`timescale 1ns / 1ps
//2013011076 Wang Han
//PC Register

module PC_reg(clk,
			reset,
			PCWrite,
			iPC,
			oPC);

	input clk;
    input reset;
    input PCWrite;
    input [31:0] iPC;
    output reg [31:0] oPC;
	
	always @(posedge clk or negedge reset)
	begin
		if (~reset)
			oPC <= 32'h00400000;
		else
		begin
			if (PCWrite == 1'b1)
			begin
				oPC <= iPC;
			end
		end
	end

endmodule
