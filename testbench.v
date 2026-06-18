`timescale 1ns / 1ps

module tb_risc_v_core();
    reg clk;
    reg rst;


    risc_v_core uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;

        #20;
        rst = 0;


        #200;
        
        $finish;
    end
endmodule