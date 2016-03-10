`timescale 1ns / 1ps

// Module which sends the total calculated output signal to the PmodI2S
// stereo audio output device
module pmod_out(sig, clk, MCLK, LRCLK, SCLK, SDIN);
    input [15:0] sig;
    input clk;      // 500MHz clock
    output MCLK;    // Master clock to send to PmodI2S to maintain
                    // synchronization
    output LRCLK;   // Left-right clock stereo audio output
    output SCLK;    // Clock for transmitting induvidual signal bits
                    // to PmodI2S
    output SDIN;    // Current signal bit to transmit
    
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
            // Transmit the signal bit-by-bit at every negative edge of
            // the SCLK
            if (SCLK == 0) begin
                SDIN = sig_temp[15];
                sig_temp = sig_temp << 1;
            end
        end
        // 31.25kHz
        if (LRCLK_count == 1600) begin
            LRCLK = ~LRCLK;
            LRCLK_count = 0;
            // Reset sig_temp to the current signal when switching sides
            // of stereo output to transmit
            sig_temp = sig;
        end
        
        MCLK_count = MCLK_count + 1;
        LRCLK_count = LRCLK_count + 1;
        SCLK_count = SCLK_count + 1;
    end
    
endmodule

