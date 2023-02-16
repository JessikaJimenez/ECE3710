module ClockDivider(
	input wire fastClk, 
	output reg slowClk = 1'b0
	);

	reg [31:0] count = 0;
	
	// ticks at 1Hz
	always @ (posedge fastClk) begin
		slowClk = 0;
		// 50*10^6/2 ->for half ticks
		if(count == 25000000) begin
		//if(count == 100) begin
			count = 0;
			slowClk = 1'b1;
		end
		else
			count = count+1;
	end

endmodule