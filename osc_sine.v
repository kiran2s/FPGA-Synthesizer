`timescale 1ns / 1ps

module osc_sine(freq, clk, sin);
    input [11:0] freq;
    input clk;
    output [15:0] sin;
    
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
    
    always @(posedge clk)
    begin
        sin_curr = (cos_last / denom);
        sin_curr = sin_last + sin_curr;
        cos_curr = (sin_last / denom);
        cos_curr = cos_last - cos_curr;
        
        sin = sin_curr[31:16];
        
        if (sin_curr[31] == 0 && sin_last[31] == 1) begin
            sin_last = 0;
            cos_last = 32'b00111111111111110000000000000000;
            denom = 159154 / freq;
        end
        else begin
            sin_last = sin_curr;
            cos_last = cos_curr;
        end
    end
    
endmodule
