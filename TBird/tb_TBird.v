`timescale 1ns/1ns

module tb_TBird ();

	reg clk, reset, left, right, hazard;
	
	
	TBird tbird (
		.clk(), 
		.reset(),
		.sw(),
		.L2(), .L1(), .L0(),
		.R2(), .R1(), .R0()
	);


	initial begin
		clk = 1'b0;
		reset = 1'b1;
		left = 1'b1;
		right = 1'b1;
		hazard = 1'b1;
		
		#10
		// trigger a reset
		reset = 1'b0;		
		#10
		// trigger left
		left = 1'b1;	
		#10
		// trigger right
		right = 1'b1;	
		#10
		// trigger hazard
		hazard = 1'b1;
		
		#10
		// return reset to default value 
		reset = 1'b1;
		#10
		// return left to deafult value 
		left = 1'b0;
		#10
		// return right to its default value. 
		right = 1'b0;
		#10
		// return hazard to its default value. 
		hazard = 1'b0;
	end




endmodule 