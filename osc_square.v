`timescale 1ns / 1ps

// Module for generating a square wave
module osc_square(freq, clk, sig);
    input [11:0] freq;
    input clk;          // 1MHz clock
    output [15:0] sig;  // Square wave signal
    
    reg [15:0] sig;
    reg [31:0] cycleCount;      // Time in clock cycles
    reg [31:0] sigHalfPeriod;
    
    initial begin
        // Initialize signal at default positive maginitude
        sig <= 16'b0000111111111111;
        cycleCount <= 0;
        // Initialize the half-period of the waveform to correspond to a
        // frequency of 440Hz
        sigHalfPeriod <= 1000000 / (440 * 2);
    end
    
    always @(posedge clk)
    begin
        // Flip the signal at every half-period
        if (cycleCount >= sigHalfPeriod) begin
            sig <= ~sig;
            cycleCount <= 0;
        end
        else begin
            cycleCount <= cycleCount + 1;
        end
    end
    
    // Recalculate the period whenever the user changes the frequency to play
    always @(freq)
    begin
        sigHalfPeriod = 1000000 / (freq * 2);
    end
    
endmodule
