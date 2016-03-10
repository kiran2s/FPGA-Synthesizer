`timescale 1ns / 1ps

// Module which accumulates the waveforms chosen by the nexys 3 switches
// into the total output signal
// Allows user to play multiple types of waveforms simultaneously
module sig_adder(clk, sw, sig_square, sig_saw, sig_tri, sig_sine, sig);
    input clk;                  // 1MHz clock
    input [4:0] sw;             // Switches on FPGA
    input [15:0] sig_square;
    input [15:0] sig_saw;
    input [15:0] sig_tri;
    input [15:0] sig_sine;
    output reg [15:0] sig;      // Total output signal
    
    reg [15:0] sig_temp;
    reg [15:0] sig_noise;

    initial begin
        sig <= 0;
        sig_temp <= 0;
        sig_noise <= 773;
    end
    
    // Accumulate chosen waveforms
    always @(posedge clk)
    begin
        sig_temp = 0;
        if (sw[0] == 1) begin
            sig_temp = sig_temp + sig_square;
        end
        if (sw[1] == 1) begin
            sig_temp = sig_temp + sig_saw;
        end
        if (sw[2] == 1) begin
            sig_temp = sig_temp + sig_tri;
        end
        if (sw[3] == 1) begin
            sig_temp = sig_temp + sig_sine;
        end
        // Generates random noise
        if (sw[4] == 1) begin
            sig_noise = { sig_noise[14:0], sig_noise[15] ^ sig_noise[14] ^ sig_noise[12] ^ sig_noise[3] };
            sig_temp = sig_temp + sig_noise;
        end
        
        sig = sig_temp;
    end

endmodule
