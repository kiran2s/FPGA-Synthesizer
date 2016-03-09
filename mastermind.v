`timescale 1ns / 1ps

module mastermind(clk, sw, JCR, JCC, JA, seg, an);
    input clk;
    input [4:0] sw;
    input [3:0] JCR;
    output [3:0] JCC;
    inout [3:0] JA;
    output [6:0] seg;
    output [3:0] an;
    
    wire [15:0] sig_square;
    wire [15:0] sig_saw;
    wire [15:0] sig_tri;
    wire [15:0] sig_sine;
    wire [15:0] sig;
    wire [31:0] freq;
    
    pmod_kypd_input pkin_ (
        // Inputs
        .clk    (clk),
        .Row    (JCR),
        // Outputs
        .Col    (JCC),
        .freq   (freq)
    );
    
    display disp_ (
        //Inputs
        .freq   (freq),
        //Outputs
        .segOut (seg),
        .anode  (an)
    );
    
    osc_square squosc_ (
        // Inputs
        .freq   (freq),
        .clk    (JA[2]),
        // Outputs
        .sig    (sig_square)
    );
    
    osc_tri_saw trisawsc_ (
        // Inputs
        .freq   (freq),
        .clk    (JA[2]),
        // Outputs
        .sig_saw    (sig_saw),
        .sig_tri    (sig_tri)
    );
    
    osc_sine sinesc_ (
        // Inputs
        .freq   (freq),
        .clk    (JA[2]),
        // Outputs
        .sin    (sig_sine)
    );
    
    sig_adder sigadd_ (
        //Inputs
        .sw (sw),
        .sig_saw    (sig_saw),
        .sig_tri    (sig_tri),
        .sig_square (sig_square),
        .sig_sine   (sig_sine),
        .clk    (JA[2]),
        //Outputs
        .sig    (sig)
    );

    pmod_out out_ (
        // Inputs
        .sig    (sig),
        .clk    (clk),
        // Outputs
        .MCLK   (JA[0]),
        .LRCLK  (JA[1]),
        .SCLK   (JA[2]),
        .SDIN   (JA[3])
    );

endmodule
