`timescale 1ns / 1ps

module pmod_out(sig, clk, MCLK, LRCLK, SCLK, SDIN);
    input [15:0] sig;
    input clk;
    output MCLK;
    output LRCLK;
    output SCLK;
    output SDIN;
    
    reg MCLK;
    reg LRCLK;
    reg SCLK;
    reg SDIN;

    reg [15:0] sig_temp;
    integer MCLK_count;
    integer LRCLK_count;
    integer SCLK_count;

    initial begin
        MCLK <= 0;
        LRCLK <= 0;
        SCLK <= 0;
    
        sig_temp <= sig;
        MCLK_count <= 0;
        LRCLK_count <= 0;
        SCLK_count <= 0;
    end

    always @(posedge clk)
    begin
        // 2000kHz
        if (MCLK_count == 25) begin
            MCLK = ~MCLK;
            MCLK_count = 0;
        end
        // 1000kHz
        if (SCLK_count == 50) begin
            SCLK = ~SCLK;
            SCLK_count = 0;
            if (SCLK == 0) begin
                SDIN = sig_temp[15];
                sig_temp = sig_temp << 1;
            end
        end
        // 31.25kHz
        if (LRCLK_count == 1600) begin
            LRCLK = ~LRCLK;
            LRCLK_count = 0;
            sig_temp = sig;
        end
        
        MCLK_count = MCLK_count + 1;
        LRCLK_count = LRCLK_count + 1;
        SCLK_count = SCLK_count + 1;
    end
    
endmodule

