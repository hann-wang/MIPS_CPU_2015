`timescale 1ns/1ps
//2013011076 Wang Han
//Pipeline Cycle Controller
//ORI is added!
//Remove IsJrJal signal; UndefinedInst is not an output now; PCSrc is widened so interrupt and exception can be handled together with PCSrc.
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
	output [2:0] PCSrc;
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
	wire UndefinedInst;
	
	assign UndefinedInst =  (OpCode[4]) ? 1'b1 :
							(OpCode[5]) ? ((OpCode[3:0]==4'h3 || OpCode[3:0]==4'hb)?1'b0:1'b1) :
							(OpCode[3:0]==4'he) ? 1'b1 :
							(OpCode[3:0]==4'h0) ? ( (Funct[4]) ? 1'b1 :
													(Funct[5]) ? ((Funct[3:0]<4'h8 || Funct[3:0]==4'ha)?1'b0:1'b1) :
													(Funct[3:0]==4'h0 || Funct[3:0]==4'h2 || Funct[3:0]==4'h3 || Funct[3:0]==4'h8 || Funct[3:0]==4'h9 || Funct[3:0]==4'ha) ? 1'b0 : 1'b1
													) :
							1'b0;
													
	assign PCSrc = (UndefinedInst) ? 3'b101 :
					(IRQ) ? 3'b100 :
					(OpCode == 6'h02 || OpCode == 6'h03) ? 3'b010 :
					(OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09)) ? 3'b011 :
					(OpCode >= 6'h01 && OpCode <= 6'h07) ? 3'b001 :
					3'b000;
		
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
		
	assign ALUSrc1 = (OpCode == 6'h00 && Funct <= 6'h03) ? 1'b1 : 1'b0;
	assign ALUSrc2 = (OpCode >= 6'h08) ? 1'b1 : 1'b0;
	
	assign ExtOp = (OpCode == 6'h09 || OpCode == 6'h0b || OpCode == 6'h0c || OpCode == 6'h0d) ? 1'b0 : 1'b1;
	
	assign LuOp = (OpCode == 6'h0f) ? 1'b1 : 1'b0;
	
	assign ALUOp = (OpCode == 6'h00)? 2'b00: 
				(OpCode == 6'h04)? 2'b01: 
				(OpCode == 6'h23 || OpCode == 6'h2b || OpCode == 6'h0f)? 2'b10: 
				2'b11;
		
endmodule
