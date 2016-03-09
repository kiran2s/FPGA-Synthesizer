`timescale 1ns / 1ps

module sig_adder(clk, sw, sig_square, sig_saw, sig_tri, sig_sine, sig);
    input clk;
    input [4:0] sw;
    input [15:0] sig_square;
    input [15:0] sig_saw;
    input [15:0] sig_tri;
    input [15:0] sig_sine;
    output reg [15:0] sig;
    
    reg [15:0] sig_temp;
    reg [15:0] sig_noise;

    initial begin
        sig <= 0;
        sig_temp <= 0;
        sig_noise <= 773;
    end
    
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
        if (sw[4] == 1) begin
            sig_noise = { sig_noise[14:0], sig_noise[15] ^ sig_noise[14] ^ sig_noise[12] ^ sig_noise[3] };
            sig_temp = sig_temp + sig_noise;
        end
        
        sig = sig_temp;
    end

endmodule
