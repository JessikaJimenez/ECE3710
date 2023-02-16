/**
* A module designed to drive a seven segment display.
* Supports the full range of 4 bit inputs 0 - F. 
* Assumes the output wire is declared with the largest bit on the left.
* Listed pins are for DE10 Lite. Review your manual before making assignments.
* 
* Author: Rich Baird
* Date: 04/21/2022
**/

module SevenSeg (
	input wire [4:0] hex_input, 
	output reg [6:0] seven_seg
);

always @(hex_input)
 begin
  case (hex_input)
   5'h0 : begin seven_seg = ~7'b0111111; end
   5'h1 : begin seven_seg = ~7'b0110000; end
   5'h2 : begin seven_seg = ~7'b1011011; end
   5'h3 : begin seven_seg = ~7'b1001111; end
   5'h4 : begin seven_seg = ~7'b1100110; end
   5'h5 : begin seven_seg = ~7'b1101101; end
   5'h6 : begin seven_seg = ~7'b1111101; end
   5'h7 : begin seven_seg = ~7'b0000111; end
   5'h8 : begin seven_seg = ~7'b1111111; end
   5'h9 : begin seven_seg = ~7'b1100111; end
   5'ha : begin seven_seg = ~7'b0110111; end
   5'hb : begin seven_seg = ~7'b1111100; end
   5'hc : begin seven_seg = ~7'b0111001; end
   5'hd : begin seven_seg = ~7'b1011110; end
   5'he : begin seven_seg = ~7'b1111001; end
   5'hf : begin seven_seg = ~7'b1110001; end
   default : begin seven_seg = ~7'b0000000; end
  endcase
 end
endmodule