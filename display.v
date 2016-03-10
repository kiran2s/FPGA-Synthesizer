`timescale 1ns / 1ps

// Module which displays the current note being played to the
// 7-segment display
module display(freq, anode, segOut);
    input [11:0] freq;
    output [3:0] anode;     // Controls the display digits
    output [6:0] segOut;    // Controls which digit to display
    
    // Output wires and registers
    wire [3:0] anode;
    reg [6:0] segOut;
    
    // Only display the rightmost digit
    assign anode = 4'b1110;
    
    always @(freq) begin
        case (freq)                     // Musical notes:
            523 : segOut <= 7'b1000110; // C
            494 : segOut <= 7'b0000011; // B
            440 : segOut <= 7'b0001000; // A
            392 : segOut <= 7'b0010000; // G
            349 : segOut <= 7'b0001110; // F
            330 : segOut <= 7'b0000110; // E
            294 : segOut <= 7'b0100001; // D
            262 : segOut <= 7'b1000110; // C
            247 : segOut <= 7'b0000011; // B
            220 : segOut <= 7'b0001000; // A
            196 : segOut <= 7'b0010000; // G
            175 : segOut <= 7'b0001110; // F
            165 : segOut <= 7'b0000110; // E
            147 : segOut <= 7'b0100001; // D
            131 : segOut <= 7'b1000110; // C
            default : segOut <= 7'b0111111;
        endcase
    end
endmodule
