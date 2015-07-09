module top();
//
    parameter   CLK_UP = 8;
    parameter   CLK_DOWN = 8;

    reg         Clk;
    reg         iReset;

    initial
    begin
        Clk = 0;
    end

    always
    begin
        #CLK_DOWN
        Clk = 1;
        #CLK_UP
        Clk = 0;
    end

    initial begin
        $dumpfile("v.lxt");
        $dumpvars(0, top);

        #10000

        $dumpflush;
        $stop;
    end
endmodule
