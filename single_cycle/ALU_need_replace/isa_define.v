`ifndef __ISA_DEFINE__INC
`define __ISA_DEFINE__INC

`define OPCODE_RSTYLE       6'h00
`define OPCODE_LW           6'h23
`define OPCODE_SW           6'h2b
`define OPCODE_LUI          6'h0f
`define  FUNCT_ADD          6'h20
`define  FUNCT_ADDU         6'h21
`define OPCODE_ADDI         6'h08
`define OPCODE_ADDIU        6'h09
`define  FUNCT_SUB          6'h22
`define  FUNCT_SUBU         6'h23
`define  FUNCT_AND          6'h24
`define OPCODE_ANDI         6'h0c
`define  FUNCT_OR           6'h25
`define OPCODE_ORI          6'h0d
`define  FUNCT_XOR          6'h26
`define  FUNCT_NOR          6'h27
`define  FUNCT_SLL          6'h00
`define  FUNCT_SRL          6'h02
`define  FUNCT_SRA          6'h03
`define  FUNCT_SLLV         6'h04
`define  FUNCT_SRLV         6'h06
`define  FUNCT_SRAV         6'h07
`define  FUNCT_SLT          6'h2a
`define OPCODE_SLTI         6'h0a
`define OPCODE_SLTIU        6'h0b
`define OPCODE_BEQ          6'h04
`define OPCODE_BNE          6'h05
`define OPCODE_BGTZ         6'h07
`define OPCODE_BLEZ         6'h06
`define OPCODE_J            6'h02
`define OPCODE_JAL          6'h03
`define  FUNCT_JR           6'h08
`define  FUNCT_JALR         6'h09

`define ALUCTRL_ADD     6'b000000
`define ALUCTRL_SUB     6'b000001
`define ALUCTRL_AND     6'b011000
`define ALUCTRL_OR      6'b011110
`define ALUCTRL_XOR     6'b010110
`define ALUCTRL_NOR     6'b010001
`define ALUCTRL_A       6'b011010
`define ALUCTRL_LUI     6'b011011
`define ALUCTRL_SLL     6'b100000
`define ALUCTRL_SRL     6'b100001
`define ALUCTRL_SRA     6'b100011
`define ALUCTRL_EQ      6'b110011
`define ALUCTRL_NEQ     6'b110001
`define ALUCTRL_LT      6'b110101
`define ALUCTRL_LEZ     6'b111101
`define ALUCTRL_GEZ     6'b111001
`define ALUCTRL_GTZ     6'b111111
`define INTERRUPT_REG   5'd26
`endif
