//1Hz控制时钟
/* module clk_gen(sysclk,clk);
	input sysclk;
	output clk;
	reg clk;
	reg [24:0] counter;
	initial begin
		clk<=0;
		counter<=24000000;
	end
	always@(posedge sysclk)
	begin
		if (counter==24999999)
			begin
				counter<=0;
				clk<=~clk;
			end
		else
			counter<=counter+25'b0_0000_0000_0000_0000_0000_0001;
	end
endmodule */
module clk_gen(sysclk,clk);
	input sysclk;
	output clk;
	reg clk;
	reg [9:0] counter;
	initial begin
		clk<=0;
		counter<=0;
	end
	always@(posedge sysclk)
	begin
		if (counter==10'd500)
			begin
				counter<=0;
				clk<=~clk;
			end
		else
			counter<=counter+10'b00000_00001;
	end
endmodule
