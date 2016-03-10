`timescale 1ns / 1ps

// Module for generating a sine wave
module osc_sine(freq, clk, sin);
    input [11:0] freq;
    input clk;          // 1MHz clock
    output [15:0] sin;  // Signal value
    
    reg [15:0] sin;
    integer sin_curr;
    integer cos_curr;
    integer sin_last;
    integer cos_last;
    integer denom;
    
    initial begin
        sin_last <= 0;
        cos_last <= 32'b00111111111111110000000000000000;
        denom = 159154 / 440;
    end
    
    // Sine wave generation accomplished using a phase-locked loop
    // given by the following equations:
    // sin(t) = sin(t-1) + C*cos(t-1)
    // cos(t) = cos(t-1) - C*sin(t-1)
    // where:
    // sin(t) given by variable sin_curr
    // sin(t-1) given by variable sin_last
    // cos(t) given by variable cos_curr
    // cos(t-1) given by variable cos_last
    // C is a constant given by the reciprocal of the variable denom
    // variable denom is dependent on the input frequency given by the user
    // sin_last and cos_last are initialized to their respective t=0 values
    // left shifted by 16 bits. Left shifting is done in order to gain
    // the required precision for calculation.
    
    always @(posedge clk)
    begin
        sin_curr = (cos_last / denom);
        sin_curr = sin_last + sin_curr;
        cos_curr = (sin_last / denom);
        cos_curr = cos_last - cos_curr;
        
        sin = sin_curr[31:16];
        
        // Reinitialize values at the beginning of every period
        if (sin_curr[31] == 0 && sin_last[31] == 1) begin
            sin_last = 0;
            cos_last = 32'b00111111111111110000000000000000;
            denom = 159154 / freq;
        end
        // Update sin(t-1) and cos(t-1) before subsequent sine wave calculation
        else begin
            sin_last = sin_curr;
            cos_last = cos_curr;
        end
    end
    
endmodule
