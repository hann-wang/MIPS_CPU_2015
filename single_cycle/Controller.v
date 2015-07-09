`timescale 1ns/1ps
//Incomplete
//2013011076 Wang Han
//Controller, incomplete

module Controller ( .OpCode,
					.Funct,
					.IRQ,
					.PCSrc,
					.RegWrite,
					.RegDst, 
					.MemRead,
					.MemWrite,
					.MemtoReg,
					.ALUSrc1,
					.ALUSrc2,
					.ExtOp,
					.LuOp,
					.ALUOp);
	input  [5:0] OpCode;
	input  [5:0] Funct;
	input 	IRQ;
	output [1:0] PCSrc;
	output RegWrite;
	output [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output [1:0] MemtoReg;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	output [1:0] ALUOp;
	
endmodule
