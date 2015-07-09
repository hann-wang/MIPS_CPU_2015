`timescale 1ns / 1ps

module ALU( iA, iB, iALUFun, iSign, oS, oZ, oV, oN);

    input [31:0] iA;
    input [31:0] iB;
    input [5:0] iALUFun;
    input iSign;

    output reg [31:0] oS;
    output     oZ;
    output reg oV;
    output     oN;

    wire [31:0] oSadd, oSsub, oSand, oSor, oSxor, oSnor, oSsta;
    wire [31:0] oSsll, oSsrl, oSsra, oSeq, oSneq, oSlt, oSlez;
    wire [31:0] oSgez, oSgtz, oSlui;

    `define oADD (6'b000000)
    `define oSUB (6'b000001)
                    
    `define oAND (6'b011000)
    `define oOR  (6'b011110)
    `define oXOR (6'b010110)
    `define oNOR (6'b010001)
    `define oSTA (6'b011010)
                    
    `define oSLL (6'b100000)
    `define oSRL (6'b100001)
    `define oSRA (6'b100011)
                    
    `define oEQ  (6'b110011)
    `define oNEQ (6'b110001)
    `define oLT  (6'b110101)
    `define oLEZ (6'b111101)
    `define oGEZ (6'b111001)
    `define oGTZ (6'b111111)

    `define oLUI (6'b011011)

            ADD ADD1(.A(iA), .B(iB), .Sign(iSign), .S(oSadd), .V(oVadd));
            SUB SUB1(.A(iA), .B(iB), .Sign(iSign), .S(oSsub), .V(oVsub));
            AND AND1(.A(iA), .B(iB), .Sign(iSign), .S(oSand), .V(oVand));
            OR OR1(.A(iA), .B(iB), .Sign(iSign), .S(oSor), .V(oVor));
            XOR XOR1(.A(iA), .B(iB), .Sign(iSign), .S(oSxor), .V(oVxor));
            NOR NOR1(.A(iA), .B(iB), .Sign(iSign), .S(oSnor), .V(oVnor));
            STA STA1(.A(iA), .B(iB), .Sign(iSign), .S(oSsta), .V(oVsta));
            SLL SLL1(.A(iA), .B(iB), .Sign(iSign), .S(oSsll), .V(oVsll));
            SRL SRL1(.A(iA), .B(iB), .Sign(iSign), .S(oSsrl), .V(oVsrl));
            SRA SRA1(.A(iA), .B(iB), .Sign(iSign), .S(oSsra), .V(oVsra));
            EQ_BACKUP EQ1(.A(iA), .B(iB), .Sign(iSign), .S(oSeq), .V(oVeq));
            NEQ_BACKUP NEQ1(.A(iA), .B(iB), .Sign(iSign), .S(oSneq), .V(oVneq));
            LT LT1(.A(iA), .B(iB), .Sign(iSign), .S(oSlt), .V(oVlt));
            LEZ LEZ1(.A(iA), .B(iB), .Sign(iSign), .S(oSlez), .V(oVlez));
            GEZ GEZ1(.A(iA), .B(iB), .Sign(iSign), .S(oSgez), .V(oVgez));
            GTZ GTZ1(.A(iA), .B(iB), .Sign(iSign), .S(oSgtz), .V(oVgtz));
            LUI LUI1(.A(iA), .B(iB), .Sign(iSign), .S(oSlui), .V(oVlui));

    assign oZ = (oS == 32'b0);
    assign oN = iSign & oS[31];

    always@(*)
    begin
        case(iALUFun)
        `oADD:
        begin
	    oS = oSadd;
        oV = oVadd;
        end
        `oSUB:
        begin
	    oS = oSsub;
        oV = oVsub;
        end
        `oAND:
        begin
	    oS = oSand;
        oV = oVand;
        end
        `oOR:
        begin
	    oS = oSor;
        oV = oVor;
        end
	    `oXOR:
        begin
	    oS = oSxor;
        oV = oVxor;
        end
	    `oNOR:
        begin
	    oS = oSnor;
        oV = oVnor;
        end
        `oSTA:
        begin
	    oS = oSsta;
        oV = oVsta;
        end
        `oSLL:
        begin
	    oS = oSsll;
        oV = oVsll;
        end
        `oSRL:
        begin
	    oS = oSsrl;
        oV = oVsrl;
        end
        `oSRA:
        begin
	    oS = oSsra;
        oV = oVsra;
        end
        `oEQ:
        begin
	    oS = oSeq;
        oV = oVeq;
        end
        `oNEQ:
        begin
	    oS = oSneq;
        oV = oVneq;
        end
        `oLT:
        begin
	    oS = oSlt;
        oV = oVlt;
        end
        `oLEZ:
        begin
	    oS = oSlez;
        oV = oVlez;
        end
        `oGEZ:
        begin
	    oS = oSgez;
        oV = oVgez;
        end
        `oGTZ:
        begin
	    oS = oSgtz;
        oV = oVgtz;
        end
        `oLUI:
        begin
	    oS = oSlui;
        oV = oVlui;
        end
        default:
        begin
            oS = 0;
            oV = 0;
        end
        endcase
    end

endmodule


