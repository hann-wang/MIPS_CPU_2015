
module ALU(in1, in2, ALUCtl, Sign, out, zero);
	input [31:0] in1, in2;
	input [5:0] ALUCtl;
	input Sign;
	output reg [31:0] out;
	output zero;
	
	assign zero = (out == 0);
	
	wire [1:0]ss;
	assign ss = {in1[31], in2[31]};
	
	wire lt_31;
	assign lt_31 = (in1[30:0] < in2[30:0]);
	
	wire lt_signed;
	assign lt_signed = (in1[31] ^ in2[31])? 
		((ss == 2'b01)? 0: 1): lt_31;
	
	always @(*)
		case (ALUCtl)
			6'b000000: out <= in1 + in2;
			6'b000001: out <= in1 - in2;
			6'b011000: out <= in1 & in2;
			6'b011110: out <= in1 | in2;
			6'b010110: out <= in1 ^ in2;
			6'b010001: out <= ~(in1 | in2);
			6'b010000: out <= in1;
			6'b100000: out <= (in2 << in1[4:0]);
			6'b100001: out <= (in2 >> in1[4:0]);
			6'b100011: out <= ({{32{in2[31]}}, in2} >> in1[4:0]);
			6'b110011: out <= (in1==in2)? 32'h00000001 :32'h00000000;
			6'b110001: out <= (in1!=in2)? 32'h00000001 :32'h00000000;
			6'b110101: out <= {31'h00000000, Sign? lt_signed: (in1 < in2)};
			6'b111101: out <= (in1==32'h00000000 || in1[31])? 32'h00000001 :32'h00000000;
			6'b111001: out <= (in1[31])? 32'h00000000 :32'h00000001;
			6'b111111: out <= (in1==32'h00000000 || in1[31])? 32'h00000000 :32'h00000001;
			default: out <= 32'h00000000;
		endcase
	
endmodule