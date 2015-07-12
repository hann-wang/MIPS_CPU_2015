`timescale 1ns / 1ps
//2013011076 Wang Han
//HazardUnit, handling load-use, jump & branch

module HazardUnit(
					input			ID_EX_MemRead,
					input	[4:0]	ID_EX_InstRt,
					input	[4:0]	IF_ID_InstRs,
					input	[4:0]	IF_ID_InstRt,
					input	[2:0]	ID_PCSrc,
					input	[2:0]	ID_EX_PCSrc,
					input			EX_ALUOut0,
					output			PCWrite, 
					output			IF_ID_write,
					output			IF_ID_flush,
					output			ID_EX_flush
					);
	
	reg [2:0] PCWrite_request, IF_ID_write_request, IF_ID_flush_request, ID_EX_flush_request;
	
	assign PCWrite = PCWrite_request[0] & PCWrite_request[1] & PCWrite_request[2];
	assign IF_ID_write = IF_ID_write_request[0] & IF_ID_write_request[1] & IF_ID_write_request[2];
	assign IF_ID_flush = IF_ID_flush_request[0] | IF_ID_flush_request[1] | IF_ID_flush_request[2];
	assign ID_EX_flush = ID_EX_flush_request[0] | ID_EX_flush_request[1] | ID_EX_flush_request[2];
	
	//Load-use
	always @(*)
	begin
		if (ID_EX_MemRead == 1'b1 && 
			(ID_EX_InstRt == IF_ID_InstRs || ID_EX_InstRt == IF_ID_InstRt))
			begin
				PCWrite_request[0] = 1'b0;
				IF_ID_write_request[0] = 1'b0;
				ID_EX_flush_request[0] = 1'b1;
				IF_ID_flush_request[0] = 1'b0;
			end
		else
			begin
				PCWrite_request[0] = 1'b1;
				IF_ID_write_request[0] = 1'b1;
				ID_EX_flush_request[0] = 1'b0;
				IF_ID_flush_request[0] = 1'b0;
			end
	end
	
	//Jump
	always @(*) begin
		if (ID_PCSrc == 3'b010 || ID_PCSrc == 3'b011 || ID_PCSrc == 3'b100 || ID_PCSrc == 3'b101)
			begin
				PCWrite_request[1] = 1'b1;
				IF_ID_write_request[1] = 1'b1;
				ID_EX_flush_request[1] = 1'b0;
				IF_ID_flush_request[1] = 1'b1;
			end
		else
			begin
				PCWrite_request[1] = 1'b1;
				IF_ID_write_request[1] = 1'b1;
				ID_EX_flush_request[1] = 1'b0;
				IF_ID_flush_request[1] = 1'b0;
			end
	end
	
	//Branch
	always @(*) begin
		if (ID_EX_PCSrc == 3'b001 && EX_ALUOut0 == 1'b1)
		begin
			PCWrite_request[2] = 1'b1;
			IF_ID_write_request[2] = 1'b1;
			ID_EX_flush_request[2] = 1'b1;
			IF_ID_flush_request[2] = 1'b1;
		end
		else begin
			PCWrite_request[2] = 1'b1;
			IF_ID_write_request[2] = 1'b1;
			ID_EX_flush_request[2] = 1'b0;
			IF_ID_flush_request[2] = 1'b0;
		end
	end

endmodule
