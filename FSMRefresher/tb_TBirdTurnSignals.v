`timescale 1ns/1ns

module tb_TBirdTurnSignals ();

   integer counter = 0;
	reg clk, reset, left, right, hazard;
	wire [6:0] sevsegLeft1, sevsegLeft2, sevsegLeft3, sevsegRight1, sevsegRight2, sevsegRight3;

	TBirdTurnSignals signal (.clk(clk),   .reset(resest), .left(left),  .right(right),  .hazard(hazard),
									 .sevsegLeft1(sevsegLeft1),   .sevsegLeft2(sevsegLeft2),    .sevsegLeft3(sevsegLeft3), 
									 .sevsegRight1(sevsegRight1), .sevsegRight2(sevsegRight2),  .sevsegRight3(sevsegRight3));	
		
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
		left = 1'b0;	
		#10
		// trigger right
		right = 1'b0;	
		#10
		// trigger hazard
		hazard = 1'b0;
		
		#10
		// return reset to default value 
		reset = 1'b1;
		#10
		// return left to deafult value 
		left = 1'b1;
		#10
		// return right to its default value. 
		right = 1'b1;
		#10
		// return hazard to its default value. 
		hazard = 1'b1;
	end
	
	
	always #20 begin
		clk = !clk;	
		//simulates pushing reset
	   if(counter == 10) begin
			reset = 1'b0;
			$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
			#10
			reset = 1'b1; 
			$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
		end
		//simulates pushing left
	   if(counter == 20) begin
			left = 1'b0;
			$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
			#10
			left = 1'b1; 
			$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
		end
		//simulates pushing right
	   if(counter == 30) begin
			right = 1'b0;
			$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
			#10
			right = 1'b1; 
			$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
		end
		//simulates pushing hazard
	   if(counter == 40) begin
			hazard = 1'b0;
			$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
			#10
			hazard = 1'b1; 
			$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
		end
	   // because this is a simulation file, we don't need an else block here
		counter = counter + 1;
	end
	
	
	//always @(*) begin
		//print outputs
		//$display("%b %b %b    %b %b %b\n\n", sevsegLeft3, sevsegLeft2, sevsegLeft1, sevsegRight1, sevsegRight2, sevsegRight3);
	//end
	

endmodule