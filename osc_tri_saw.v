`timescale 1ns / 1ps

// Module for generating sawtooth and triangle waves
module osc_tri_saw(freq, clk, sig_saw, sig_tri);
    input [11:0] freq;
    input clk;  // 1MHz clock
    output [15:0] sig_saw;
    output [15:0] sig_tri;
    
    reg [15:0] sig_saw;
    reg [15:0] sig_tri;
    
    reg [15:0] sig_temp;
    reg [31:0] cycleCount;  // Time in clock cycles
    reg [31:0] sigPeriod;
    reg [15:0] amplitude;
    reg [15:0] X;
    reg [35:0] AmulC;
    
    initial begin
        sig_saw <= 16'b0000000000000000;
        sig_tri <= 16'b0000000000000000;
        
        sig_temp <= 16'b0000000000000000;
        cycleCount <= 0;
        sigPeriod <= 1000000 / 440;
        amplitude <= 16'b0001111111111111;
    end
    
    // Sawtooth wave equation:
    // sig_saw = ((amplitude * cycleCount) / sigPeriod) - X
    // where X = 0 if the cycleCount is less than half the
    // period and X = amplitude otherwise
    
    // Triangle wave can then be obtained by taking the
    // absolute value of the sawtooth wave, shifting it down by a
    // quarter of the original amplitude, and scaling it by some
    // factor.
    
    always @(posedge clk)
    begin
        // Reset the cycle count after every period
        if (cycleCount >= sigPeriod) begin
            cycleCount = 0;
        end
        
        if ((cycleCount << 1) < sigPeriod) begin
            X = 0;
        end
        else begin
            X = amplitude;
        end
        
        // Multiply the amplitude and cycle count into a larger
        // temporary register
        AmulC = amplitude * cycleCount;
        sig_temp = (AmulC / sigPeriod) - X;
        // Set the sawtooth wave signal
        sig_saw = sig_temp;
        
        // Convert sawtooth wave into triangle wave
        if (sig_temp[15] == 1) begin
            sig_temp = ~sig_temp + 1;
        end
        sig_temp = sig_temp - (amplitude >> 2);
        // Set the triangle wave signal
        sig_tri = sig_temp << 2;
        
        cycleCount = cycleCount + 1;
    end
    
    // Recalculate the period whenever the user changes the frequency to play
    always @(freq)
    begin
        sigPeriod <= 1000000 / freq;
    end
    
endmodule
