`timescale 1ns / 1ps

module pmod_kypd_input(clk, Row, Col, freq);
    input clk;
    input [3:0] Row;
    output [3:0] Col;
    output [11:0] freq;
	
	reg [3:0] Col;
	reg [11:0] freq;
	
	reg [19:0] sclk;
    
    initial begin
        //Col = 4'b1111; //
        freq <= 440;
        sclk <= 20'b00000000000000000000;
    end

	always @(posedge clk)
    begin
    
        // 1ms
        if (sclk == 20'b00011000011010100000) begin
            //C1
            Col <= 4'b0111;
            sclk <= sclk + 1'b1;
        end
        
        // check row pins
        else if(sclk == 20'b00011000011010101000) begin
            //R1
            if (Row == 4'b0111) begin
                freq <= 523;		//1
            end
            //R2
            else if(Row == 4'b1011) begin
                freq <= 494; 		//4
            end
            //R3
            else if(Row == 4'b1101) begin
                freq <= 440; 		//7
            end
            //R4
            else if(Row == 4'b1110) begin
                freq <= 392; 		//0
            end
            sclk <= sclk + 1'b1;
        end

        // 2ms
        else if(sclk == 20'b00110000110101000000) begin
            //C2
            Col <= 4'b1011;
            sclk <= sclk + 1'b1;
        end
        
        // check row pins
        else if(sclk == 20'b00110000110101001000) begin
            //R1
            if (Row == 4'b0111) begin
                freq <= 349; 		//2
            end
            //R2
            else if(Row == 4'b1011) begin
                freq <= 330; 		//5
            end
            //R3
            else if(Row == 4'b1101) begin
                freq <= 294; 		//8
            end
            //R4
            else if(Row == 4'b1110) begin
                freq <= 262; 		//F
            end
            sclk <= sclk + 1'b1;
        end

        //3ms
        else if(sclk == 20'b01001001001111100000) begin
            //C3
            Col<= 4'b1101;
            sclk <= sclk + 1'b1;
        end
        
        // check row pins
        else if(sclk == 20'b01001001001111101000) begin
            //R1
            if(Row == 4'b0111) begin
                freq <= 262; 		//3	
            end
            //R2
            else if(Row == 4'b1011) begin
                freq <= 247; 		//6
            end
            //R3
            else if(Row == 4'b1101) begin
                freq <= 220; 		//9
            end
            //R4
            else if(Row == 4'b1110) begin
                freq <= 196; 		//E
            end
            sclk <= sclk + 1'b1;
        end

        //4ms
        else if(sclk == 20'b01100001101010000000) begin
            //C4
            Col <= 4'b1110;
            sclk <= sclk + 1'b1;
        end

        // Check row pins
        else if(sclk == 20'b01100001101010001000) begin
            //R1
            if (Row == 4'b0111) begin
                freq <= 175; //A
            end
            //R2
            else if (Row == 4'b1011) begin
                freq <= 165; //B
            end
            //R3
            else if(Row == 4'b1101) begin
                freq <= 147; //C
            end
            //R4
            else if(Row == 4'b1110) begin
                freq <= 131; //D
            end
            sclk <= 20'b00000000000000000000;
        end

        // Otherwise increment
        else begin
            sclk <= sclk + 1'b1;
        end
	end
endmodule

