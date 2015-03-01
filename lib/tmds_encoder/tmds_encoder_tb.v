`timescale 1ns / 1ps
`include "tmds_encoder.v"
/*
----------------------------------------
Stereoscopic Vision System
Senior Design Project - Team 11
California State University, Sacramento
Spring 2015 / Fall 2015
----------------------------------------

TMDS Encoder Testbench

Authors:  Greg M. Crist, Jr. (gmcrist@gmail.com)

Description:
  Testbench for TMDS Encoder
*/
module tmds_encoder_tb ();
    parameter CLOCKPERIOD = 10;
    
    reg reset;
    reg clock;

    reg disp_en;
    reg [1:0] ctrl;
    reg [7:0] data;
    
    wire [9:0] tmds;


    // for counting the cycles    
    reg [15:0] cycle;

    // module, parameters, instance, ports
    tmds_encoder #() tmds_encoder (.clk(clock), .reset(reset), .disp_en(disp_en), .ctrl(ctrl), .data(data), .tmds(tmds));

    // Initial conditions; setup
    initial begin
        $timeformat(-9,1, "ns", 12);
        $monitor("%t, CYCLE: %d, DISP_EN: %b, CTRL: %b, DATA: %b, TMDS: %b", $realtime, cycle, disp_en, ctrl, data, tmds);
        $display("Initializing");

        cycle <= 0;
        reset <= 1'b0;

        disp_en <= 1'b0;
        ctrl    <= 2'b00;
        data    <= 8'b00000000;

        #1
        reset <= 1'b1;

        // Initial clock setting
        #10
        clock <= 1'b0;

        #10 ctrl <= 2'b00;
        #10 ctrl <= 2'b01;
        #10 ctrl <= 2'b10;
        #10 ctrl <= 2'b11;
        #10 ctrl <= 2'b00;
        #10 disp_en <= 1'b1;

        #100 $finish;
    end

    // Cycle Counter
    always @ (posedge clock)
        cycle <= cycle + 1;

    // Clock generation
    always #(CLOCKPERIOD / 2) clock <= ~clock;

/*
  Conditional Environment Settings for the following:
    - Icarus Varilog
    - VCS
    - Altera Modelsim
    - Xilinx ISIM
*/
`ifdef IVERILOG
    initial $dumpfile("dump.vcd");
    initial $dumpvars();
`else
    `ifdef VCS
        initial $vcdpluson;
    `else
        // code for simulation with modelsim
        `ifdef MODEL_TECH
        `else
            `ifdef XILINX_ISIM
            `endif
        `endif
    `endif
`endif
endmodule
