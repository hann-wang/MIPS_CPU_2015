`timescale 1ns / 1ps

module temptb();

    reg [31:0] iA;
    reg [31:0] iB;
    reg [5:0] iALUFun;
    reg iSign;

    wire [31:0] oS;
    wire oZ;
    wire oV;
    wire oN;

    parameter DELAY = 20;

    ALU ALU1( .iA(iA), .iB(iB), .iALUFun(iALUFun), .iSign(iSign),
              .oS(oS), .oZ(oZ), .oV(oV), .oN(oN));

    reg [16:0] test_result;

    initial
    begin
        $dumpfile("test.lxt");
        $dumpvars(0,temptb);
        $dumpvars(0,ALU1);
    end

    initial
    begin
        iA = 0;
        iB = 0;
        iSign = 0;
        iALUFun = 6'b000000;

        # DELAY;

        iA = 7;
        iB = 8;
        # DELAY;
        if ((oS == 15) && (oZ == 0) && (oV == 0) && (oN == 0)) test_result[0] = 1;
        else test_result[0] = 0;

        # DELAY;

        iALUFun = 6'b000001;
        iSign = 1;
        # DELAY;
        if ((oS == -1) && (oZ == 0) && (oV == 0) && (oN == 1)) test_result[1] = 1;
        else test_result[1] = 0;

        # DELAY;

        iALUFun = 6'b011000;
        iSign = 0;
        iA = 32'b10000000000000000000000011011001;
        iB = 32'b00000000000000000000000010101010;
        # DELAY;
        if (oS == 32'b00000000000000000000000010001000) test_result[2] = 1;
        else test_result[2] = 0;

        # DELAY;

        iALUFun = 6'b011110;
        # DELAY;
        if (oS == 32'b10000000000000000000000011111011) test_result[3] = 1;
        else test_result[3] = 0;

        # DELAY;
        
        iALUFun = 6'b010110;
        # DELAY;
        if (oS == 32'b10000000000000000000000001110011) test_result[4] = 1;
        else test_result[4] = 0;

        # DELAY;

        iALUFun = 6'b010001;
        # DELAY;
        if (oS == 32'b01111111111111111111111100000100) test_result[5] = 1;
        else test_result[5] = 0;

        # DELAY;

        iALUFun = 6'b011010;
        # DELAY;
        if (oS == iA) test_result[6] = 1;
        else test_result[6] = 1;

        # DELAY;

        iALUFun = 6'b100000;
        iA = 4;
        iB = 32'b10000000000000000000000011011001;
        # DELAY;
        if (oS == 32'b00000000000000000000110110010000) test_result[7] = 1;
        else test_result[7] = 0;

        # DELAY;

        iALUFun = 6'b100001;
        # DELAY;
        if (oS == 32'b00001000000000000000000000001101) test_result[8] = 1;
        else test_result[8] = 0;

        # DELAY;
        
        iALUFun = 6'b100011;
        # DELAY;
        if (oS == 32'b11111000000000000000000000001101) test_result[9] = 1;
        else test_result[9] = 0;

        # DELAY;
        
        iALUFun = 6'b110011;
        iA = 7;
        iB = 7;
        # DELAY;
        if (oS == 1) test_result[10] = 1;
        else test_result[10] = 0;

        # DELAY;

        iALUFun = 6'b110001;
        iB = 6;
        # DELAY;
        if (oS == 1) test_result[11] = 1;
        else test_result[11] = 0;

        # DELAY;

        iALUFun = 6'b110101;
        iA = 5;
        # DELAY;
        if (oS == 1) test_result[12] = 1;
        else test_result[12] = 0;

        # DELAY;
        
        iALUFun = 6'b111101;
        iSign = 1;
        iA = -2;
        # DELAY;
        if (oS == 1) test_result[13] = 1;
        else test_result[13] = 0;

        # DELAY;

        iALUFun = 6'b111001;
        iA = 0;
        # DELAY;
        if (oS == 1) test_result[14] = 1;
        else test_result[14] = 0;

        # DELAY;

        iALUFun = 6'b111111;
        # DELAY;
        if (oS == 0) test_result[15] = 1;
        else test_result[15] = 0;

        # DELAY;
        
        iALUFun = 6'b011011;
        iB = 32'b10000000000000000000000011011001;
        # DELAY;
        if (oS == 32'b00000000110110010000000000000000) test_result[16] = 1;
        else test_result[16] = 0;

        #2000
        $dumpflush;
        $stop;
    end
endmodule
