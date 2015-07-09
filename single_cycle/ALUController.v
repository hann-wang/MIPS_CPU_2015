`timescale 1ns/1ps
`include "isa_define.v"
//Incomplete
//2013011076 Wang Han
//ALU Controller

module ALUController(ALUOp,OpCode,Funct,ALUFunc,Sign);
	input [1:0] ALUOp;
	input [5:0] OpCode;
	input [5:0] Funct;
	output reg [5:0] ALUFunc;
	output Sign;
	
	always @(*)
    begin
        ALUFunc = 6'b000000;
        Sign = 1'b0;
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
								ALUFunc = `ALUFUNC_LEZ;  Sign = 1'b1;
							end
						`OPCODE_BGTZ:
							begin
								ALUFunc = `ALUFUNC_GTZ;  Sign = 1'b1;
							end
					endcase
				end
        endcase
    end
endmodule
