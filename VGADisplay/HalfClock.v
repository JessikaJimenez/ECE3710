module HalfClock (
	input wire clk, //input is 50MHz clk from board
	output reg clk_25
);

	always@(posedge clk) begin
		clk_25 <= !clk_25;
	end
	
endmodule 