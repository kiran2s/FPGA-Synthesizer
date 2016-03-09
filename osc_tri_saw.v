`timescale 1ns / 1ps

module osc_tri_saw(freq, clk, sig_saw, sig_tri);
    input [11:0] freq;
    input clk;
    output [15:0] sig_saw;
    output [15:0] sig_tri;
    
    reg [15:0] sig_saw;
    reg [15:0] sig_tri;
    
    reg [15:0] sig_temp;
    reg [31:0] cycleCount;
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
    
    always @(posedge clk)
    begin
        if (cycleCount >= sigPeriod) begin
            cycleCount = 0;
        end
        
        if ((cycleCount << 1) < sigPeriod) begin
            X = 0;
        end
        else begin
            X = amplitude;
        end
        AmulC = amplitude * cycleCount;
        sig_temp = (AmulC / sigPeriod) - X;
        sig_saw = sig_temp;
        
        if (sig_temp[15] == 1) begin
            sig_temp = ~sig_temp + 1;
        end
        sig_temp = sig_temp - (amplitude >> 2);
        sig_tri = sig_temp << 2;
        
        cycleCount = cycleCount + 1;
    end
    
    always @(freq)
    begin
        sigPeriod <= 1000000 / freq;
    end
    
endmodule
