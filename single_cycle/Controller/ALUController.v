`timescale 1ns/1ps
//2013011076 Wang Han
//ALU Controller
//ORI is added!

`define OPCODE_RSTYLE       6'h00
`define OPCODE_LW           6'h23
`define OPCODE_SW           6'h2b
`define OPCODE_LUI          6'h0f
`define FUNCT_ADD           6'h20
`define FUNCT_ADDU          6'h21
`define OPCODE_ADDI         6'h08
`define OPCODE_ADDIU        6'h09
`define FUNCT_SUB           6'h22
`define FUNCT_SUBU          6'h23
`define FUNCT_AND           6'h24
`define OPCODE_ANDI         6'h0c
`define OPCODE_ORI          6'h0d
`define FUNCT_OR            6'h25
`define FUNCT_XOR           6'h26
`define FUNCT_NOR           6'h27
`define FUNCT_SLL           6'h00
`define FUNCT_SRL           6'h02
`define FUNCT_SRA           6'h03
`define FUNCT_SLT           6'h2a
`define OPCODE_SLTI         6'h0a
`define OPCODE_SLTIU        6'h0b
`define OPCODE_BEQ          6'h04
`define OPCODE_BNE          6'h05
`define OPCODE_BLEZ         6'h06
`define OPCODE_BGTZ         6'h07
`define OPCODE_BGEZ         6'h01
`define OPCODE_J            6'h02
`define OPCODE_JAL          6'h03
`define FUNCT_JR            6'h08
`define FUNCT_JALR          6'h09

`define ALUFUNC_ADD     6'b000000
`define ALUFUNC_SUB     6'b000001
`define ALUFUNC_AND     6'b011000
`define ALUFUNC_OR      6'b011110
`define ALUFUNC_XOR     6'b010110
`define ALUFUNC_NOR     6'b010001
`define ALUFUNC_A       6'b011010
`define ALUFUNC_SLL     6'b100000
`define ALUFUNC_SRL     6'b100001
`define ALUFUNC_SRA     6'b100011
`define ALUFUNC_EQ      6'b110011
`define ALUFUNC_NEQ     6'b110001
`define ALUFUNC_LT      6'b110101
`define ALUFUNC_LEZ     6'b111101
`define ALUFUNC_GEZ     6'b111001
`define ALUFUNC_GTZ     6'b111111

module ALUController(ALUOp,OpCode,Funct,ALUFunc,Sign,IsJrJal);
	input [1:0] ALUOp;
	input [5:0] OpCode;
	input [5:0] Funct;
	output reg [5:0] ALUFunc;
	output reg Sign;
	output reg IsJrJal;
	
	always @(*)
    begin
        ALUFunc = 6'b000000;
        Sign = 1'b0;
		IsJrJal = 1'b0;
        case(ALUOp)
			2'b00:
				begin
					ALUFunc = `ALUFUNC_ADD;
					Sign = 1'b0;
				end
			2'b01:
				begin
					ALUFunc = `ALUFUNC_EQ;
					Sign = 1'b1;
				end
			2'b10:
				begin
					case (Funct)
						`FUNCT_ADD:
							begin
								ALUFunc = `ALUFUNC_ADD;  Sign = 1'b1;
							end
						`FUNCT_ADDU:
							begin
								ALUFunc = `ALUFUNC_ADD;  Sign = 1'b0;
							end
						`FUNCT_SUB:
							begin
								ALUFunc = `ALUFUNC_SUB;  Sign = 1'b1;
							end
						`FUNCT_SUBU:
							begin
								ALUFunc = `ALUFUNC_SUB;  Sign = 1'b0;
							end
						`FUNCT_AND:
							ALUFunc = `ALUFUNC_AND;
						`FUNCT_OR:
							ALUFunc = `ALUFUNC_OR;
						`FUNCT_XOR:
							ALUFunc = `ALUFUNC_XOR;
						`FUNCT_NOR:
							ALUFunc = `ALUFUNC_NOR;
						`FUNCT_SLL:
							ALUFunc = `ALUFUNC_SLL;
						`FUNCT_SRL:
							ALUFunc = `ALUFUNC_SRL;
						`FUNCT_SRA:
							ALUFunc = `ALUFUNC_SRA;
						`FUNCT_SLT:
							begin
								ALUFunc = `ALUFUNC_LT;	Sign = 1'b1;
							end
						`FUNCT_JR:
							IsJrJal = 1'b1;
						`FUNCT_JALR:
							IsJrJal = 1'b1;
					endcase
				end
			2'b11:
				begin
					case (OpCode)
						`OPCODE_ADDI:
							begin
								ALUFunc = `ALUFUNC_ADD;  Sign = 1'b1;
							end
						`OPCODE_ADDIU:
							begin
								ALUFunc = `ALUFUNC_ADD;  Sign = 1'b0;
							end   
						`OPCODE_ANDI:
							ALUFunc = `ALUFUNC_AND;
						`OPCODE_ORI:
							ALUFunc = `ALUFUNC_OR;
						`OPCODE_SLTI:
							begin
								ALUFunc = `ALUFUNC_LT;   Sign = 1'b1;
							end    
						`OPCODE_SLTIU:
							begin
								ALUFunc = `ALUFUNC_LT;   Sign = 1'b0;
							end
						`OPCODE_BNE:
							begin
								ALUFunc = `ALUFUNC_NEQ;  Sign = 1'b1;
							end
						`OPCODE_BLEZ:
							begin
								ALUFunc = `ALUFUNC_LEZ;  Sign = 1'b1;
							end
						`OPCODE_BGTZ:
							begin
								ALUFunc = `ALUFUNC_GTZ;  Sign = 1'b1;
							end
						`OPCODE_BGEZ:
							begin
								ALUFunc = `ALUFUNC_GEZ;  Sign = 1'b1;
							end
					endcase
				end
        endcase
    end
endmodule
