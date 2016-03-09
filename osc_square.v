`timescale 1ns / 1ps

module osc_square(freq, clk, sig);
    input [11:0] freq;
    input clk;
    output [15:0] sig;
    
    reg [15:0] sig;
    reg [31:0] cycleCount;
    reg [31:0] sigHalfPeriod;
    
    initial begin
        sig <= 16'b0000111111111111;
        cycleCount <= 0;
        sigHalfPeriod <= 1000000 / (440 * 2);
    end
    
    always @(posedge clk)
    begin
        // POSER BULLSHIT
        if (cycleCount >= sigHalfPeriod) begin
            sig <= ~sig;
            cycleCount <= 0;
        end
        else begin
            cycleCount <= cycleCount + 1;
        end
    end
    
    always @(freq)
    begin
        sigHalfPeriod = 1000000 / (freq * 2);
    end
    
endmodule
