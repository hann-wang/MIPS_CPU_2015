`timescale 1ns/1ps
//Incomplete
//2013011076 Wang Han
//Controller, incomplete

module Controller ( .OpCode,
					.Funct,
					.BeginInterrupt,
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
					.ALUOp,
					.IsJrJal);
	input  [5:0] OpCode;
	input  [5:0] Funct;
	input BeginInterrupt;
	output [2:0] PCSrc;
	output RegWrite;
	output [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output [1:0] MemtoReg;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	output [3:0] ALUOp;
	output IsJrJal;
	
endmodule
