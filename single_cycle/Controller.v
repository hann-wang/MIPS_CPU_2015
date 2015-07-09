`timescale 1ns/1ps
//Incomplete
//2013011076 Wang Han
//Controller, incomplete

module Controller ( OpCode,
					Funct,
					IRQ,
					PCSrc,
					RegWrite,
					RegDst, 
					MemRead,
					MemWrite,
					MemToReg,
					ALUSrc1,
					ALUSrc2,
					ExtOp,
					LuOp,
					ALUOp);
	input  [5:0] OpCode;
	input  [5:0] Funct;
	input 	IRQ;
	output [1:0] PCSrc;
	output RegWrite;
	output [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output [1:0] MemToReg;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	output [1:0] ALUOp;
	
	assign PCSrc =
		(OpCode == 6'h02 || OpCode == 6'h03) ? 2'b10 :
		(OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09)) ? 2'b11 :
		(OpCode >= 6'h01 && OpCode <= 6'h07) ? 2'b01 :
		2'b00;
		
	assign RegWrite = (IRQ) ? 1'b1 :
			(OpCode == 6'h2b || (OpCode >= 6'h04 && OpCode <= 6'h07) || OpCode == 6'h01 || OpCode == 6'h02 || (OpCode == 6'h00 && Funct == 6'h08)) ? 1'b0 : 1'b1;
			
	assign RegDst = (IRQ) ? 2'b11 :
		(OpCode >= 6'h08) ? 2'b00 :
		(OpCode == 6'h03) ? 2'b10 :
		2'b01;
	
	assign MemRead = (IRQ) ? 1'b0 :
					(OpCode == 6'h23) ? 1'b1 : 1'b0;
	
	assign MemWrite = (IRQ) ? 1'b0 :
					(OpCode == 6'h2b) ? 1'b1 : 1'b0;
	
	assign MemToReg = (IRQ) ? 2'b10 :
		(OpCode == 6'h23) ? 2'b01 :
		(OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09)) ? 2'b10 :
		2'b00;
		
	
	
endmodule
