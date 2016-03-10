`timescale 1ns / 1ps

// Pmod keypad input module which allows user to choose which note
// (frequency) to play
module pmod_kypd_input(clk, Row, Col, freq);
    input clk;
    input [3:0] Row;
    output [3:0] Col;
    output [11:0] freq;
    
    reg [3:0] Col;
    reg [11:0] freq;
    
    reg [19:0] sclk;
    
    initial begin
        freq <= 440;    // Default note A
        sclk <= 20'b00000000000000000000;
    end

    always @(posedge clk)
    begin
        // 1ms
        if (sclk == 20'b00011000011010100000) begin
            // Column 1
            Col <= 4'b0111;
            sclk <= sclk + 1'b1;
        end
        
        // Check row pins
        else if(sclk == 20'b00011000011010101000) begin
            // Row 1
            if (Row == 4'b0111) begin
                freq <= 523;        // Button 1
            end
            // Row 2
            else if(Row == 4'b1011) begin
                freq <= 494;        // Button 4
            end
            // Row 3
            else if(Row == 4'b1101) begin
                freq <= 440;        // Button 7
            end
            // Row 4
            else if(Row == 4'b1110) begin
                freq <= 392;        // Button 0
            end
            sclk <= sclk + 1'b1;
        end

        // 2ms
        else if(sclk == 20'b00110000110101000000) begin
            // Column 2
            Col <= 4'b1011;
            sclk <= sclk + 1'b1;
        end
        
        // Check row pins
        else if(sclk == 20'b00110000110101001000) begin
            // Row 1
            if (Row == 4'b0111) begin
                freq <= 349;        // Button 2
            end
            // Row 2
            else if(Row == 4'b1011) begin
                freq <= 330;        // Button 5
            end
            // Row 3
            else if(Row == 4'b1101) begin
                freq <= 294;        // Button 8
            end
            // Row 4
            else if(Row == 4'b1110) begin
                freq <= 262;        // Button F
            end
            sclk <= sclk + 1'b1;
        end

        // 3ms
        else if(sclk == 20'b01001001001111100000) begin
            // Column 3
            Col<= 4'b1101;
            sclk <= sclk + 1'b1;
        end
        
        // Check row pins
        else if(sclk == 20'b01001001001111101000) begin
            // Row 1
            if(Row == 4'b0111) begin
                freq <= 262;        // Button 3 
            end
            // Row 2
            else if(Row == 4'b1011) begin
                freq <= 247;        // Button 6
            end
            // Row 3
            else if(Row == 4'b1101) begin
                freq <= 220;        // Button 9
            end
            // Row 4
            else if(Row == 4'b1110) begin
                freq <= 196;        // Button E
            end
            sclk <= sclk + 1'b1;
        end

        // 4ms
        else if(sclk == 20'b01100001101010000000) begin
            // Column 4
            Col <= 4'b1110;
            sclk <= sclk + 1'b1;
        end

        // Check row pins
        else if(sclk == 20'b01100001101010001000) begin
            // Row 1
            if (Row == 4'b0111) begin
                freq <= 175;        // Button A
            end
            // Row 2
            else if (Row == 4'b1011) begin
                freq <= 165;        // Button B
            end
            // Row 3
            else if(Row == 4'b1101) begin
                freq <= 147;        // Button C
            end
            // Row 4
            else if(Row == 4'b1110) begin
                freq <= 131;        // Button D
            end
            sclk <= 20'b00000000000000000000;
        end

        // Otherwise increment
        else begin
            sclk <= sclk + 1'b1;
        end
    end
endmodule

