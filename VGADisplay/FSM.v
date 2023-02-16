// FSM for TBird tail lights signaling
module FSM (
	input clk, 
	input clk_25,
	input reset, 
	input left, 
	input right, 
	input hazard, //clk is en clock from ClockDivider
	input bright,
	input wire [9:0] hCount, 
	output reg [2:0] rgb_lights
);	
	
	// Having clk be en from ClockDivider & having always @(negedge clk) & having if (clk_25) --> blank screen
	// Having clk be en from ClockDivider & having always @(*) & having if (clk_25) --> rainbow/pixel stripes
	// Having clk be en from ClockDivider & having always @(*) & having if (bright) --> rainbow/pixel stripes
	always @(*) begin
		if (bright) begin
		//if (clk_25) begin		
			//signal is hazard
			if (left == 1'b0 && right == 1'b0 && hazard == 1'b1) begin
				if (rgb_lights == 3'b000 && hCount < 80) begin
					rgb_lights  = 3'b100; // RED
				end	
				else if (rgb_lights == 3'b100 && hCount < 160) begin
					rgb_lights  = 3'b010; // GREEN
				end
				else if (rgb_lights == 3'b010 && hCount < 240) begin
					rgb_lights  = 3'b001; // BLUE
				end
				else if (rgb_lights == 3'b001 && hCount < 320) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 400) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 480) begin
					rgb_lights = 3'b001; // BLUE
				end
				else if (rgb_lights == 3'b001 && hCount < 560) begin
					rgb_lights = 3'b010; // GREEN
				end
				else if (rgb_lights == 3'b010 && hCount < 640) begin
					rgb_lights = 3'b100; // RED
				end		
				else begin
					rgb_lights = 3'b000; // off
				end
			end	
			
		
			//signal is left
			else if (left == 1'b1 && right == 1'b0 && hazard == 1'b0) begin
				if (rgb_lights == 3'b000 && hCount < 80) begin
					rgb_lights = 3'b100; // RED
				end
				else if (rgb_lights == 3'b100 && hCount < 160) begin
					rgb_lights = 3'b010; // GREEN
				end
				else if (rgb_lights == 3'b010 && hCount < 240) begin
					rgb_lights = 3'b001; // BLUE
				end
				else if (rgb_lights == 3'b001 && hCount < 320) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 400) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 480) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 560) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 640) begin
					rgb_lights  = 3'b000; // off
				end		
				else begin
					rgb_lights = 3'b000; // off
				end
			end	
			
			//signal is right
			else if (left == 1'b0 && right == 1'b1 && hazard == 1'b0) begin
				if (rgb_lights == 3'b000 && hCount < 80) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 160) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 240) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 320) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 400) begin
					rgb_lights  = 3'b000; // off
				end
				else if (rgb_lights == 3'b000 && hCount < 480) begin
					rgb_lights = 3'b001; // BLUE
				end
				else if (rgb_lights == 3'b001 && hCount < 560) begin
					rgb_lights = 3'b010; // GREEN
				end
				else if (rgb_lights == 3'b010 && hCount < 640) begin
					rgb_lights = 3'b100; // RED
				end
				else begin
					rgb_lights = 3'b000; // off
				end
			end
			
			//default
			else begin
				rgb_lights  = 3'b000; // off
			end	
		end
	end

	
	
endmodule 