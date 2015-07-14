`timescale 1ns/1ps

module ROM (addr,data);
input [31:0] addr;
output [31:0] data;
reg [31:0] data;
localparam ROM_SIZE = 32;
reg [31:0] ROM_DATA[ROM_SIZE-1:0];

always@(*)
	case (addr[9:2])
			// addi $a0, $zero, 3
			8'd0:    data <= {6'h08, 5'd00, 5'd04, 16'h0003};
			// jal sum
			8'd1:    data <= {6'h03, 26'h0000003};
			// Loop: beq $zero, $zero, Loop
			8'd2:    data <= {6'h04, 5'd00, 5'd00, 16'hffff};
			// sum: addi $sp, $sp, -8
			8'd3:    data <= {6'h08, 5'd29, 5'd29, 16'hfff8};
			// sw $ra, 4($sp)
			8'd4:    data <= {6'h2b, 5'd29, 5'd31, 16'h0004};
			// sw $a0, 0($sp)
			8'd5:    data <= {6'h2b, 5'd29, 5'd04, 16'h0000};
			// slti $t0, $a0, 1
			8'd6:    data <= {6'h0a, 5'd04, 5'd08, 16'h0001};
			// beq $t0, $zero, L1
			8'd7:    data <= {6'h04, 5'd00, 5'd08, 16'h0003};
			// xor $v0, $zero, $zero
			8'd8:    data <= {6'h00, 5'd00, 5'd00, 5'd02, 5'd00, 6'h26};
			// addi $sp, $sp, 8
			8'd9:    data <= {6'h08, 5'd29, 5'd29, 16'h0008};
			// jr $ra
			8'd10:   data <= {6'h00, 5'd31, 15'h0000, 6'h08};
			// addi $a0, $a0, -1
			8'd11:   data <= {6'h08, 5'd04, 5'd04, 16'hffff};
			// jal sum
			8'd12:   data <= {6'h03, 26'h0000003};
			// lw $a0, 0($sp)
			8'd13:   data <= {6'h23, 5'd29, 5'd04, 16'h0000};
			// lw $ra, 4($sp)
			8'd14:   data <= {6'h23, 5'd29, 5'd31, 16'h0004};
			// addi $sp, $sp, 8
			8'd15:   data <= {6'h08, 5'd29, 5'd29, 16'h0008};
			// add $v0, $a0, $v0
			8'd16:   data <= {6'h00, 5'd04, 5'd02, 5'd02, 5'd00, 6'h20};
			// jr $ra
			8'd17:   data <= {6'h00, 5'd31, 15'h0000, 6'h08};
			default: data <= 32'h00000000;
		endcase
	/*
	case(addr[7:2])	//Address Must Be Word Aligned.
		0: data <= 32'h3c114000;
		1: data <= 32'h26310004;
		2: data <= 32'h241000aa;
		3: data <= 32'hae200000;
		4: data <= 32'h08100000;
		5: data <= 32'h0c000000;
		6: data <= 32'h00000000;
		7: data <= 32'h3402000a;
		8: data <= 32'h0000000c;
		9: data <= 32'h0000_0000;
		10: data <= 32'h0274_8825;
		11: data <= 32'h0800_0015;
		12: data <= 32'h0274_8820;
		13: data <= 32'h0800_0015;
		14: data <= 32'h0274_882A;
		15: data <= 32'h1011_0002;
		16: data <= 32'h0293_8822;
		17: data <= 32'h0800_0015;
		18: data <= 32'h0274_8822;
		19: data <= 32'h0800_0015; 
		20: data <= 32'h0274_8824;
		21: data <= 32'hae11_0003;
		22: data <= 32'h0800_0001;
	   default:	data <= 32'h0800_0000;
	endcase*/
endmodule
