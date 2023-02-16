// top level module for vga synthesis
// designed for 640x480, 60Hz display
module bitGen2_new  (
	input wire clk, reset,  // 50MHz clk
	input wire [2:0] sw,
	output wire hsync, vsync,
	output reg [7:0] vga_red,
	output reg [7:0] vga_green, 
	output reg [7:0] vga_blue,
	output wire VGA_CLK, 
	output wire VGA_BLANK_N, 
	output wire VGA_SYNC_N
);
		
	wire bright;
	wire [9:0] hCount, vCount;
	reg red, green, blue;

	reg clk_25 = 0;
	always @(negedge clk) begin //generate pixel clock at 25MHz
		 clk_25 = ~clk_25;
	end
	
	//instantiate vga timing module
	vga_timing_new vgatiming (
		.clk(clk), 
		.reset(reset),
		.hsync(hsync), 
		.vsync(vsync), 
		.bright(bright),
		.hCount(hCount),
		.vCount(vCount)
	);
	
	
		//instantiate clk divider
	ClockDivider clock  (
		.fastClk(clk), 
		.slowClk(en)
	);
		
		
	//instantiate TBird FSM module
	FSM fsm (
		.clk(en), 
		.left(sw[0]), 
		.right(sw[1]), 
		.hazard(sw[2]), 
		.reset(reset),
		.rgb_lights(rgb_lights),
		.hCount(hCount)
	);
	

	//checks 1'b registers red/green/blue to assign VGA red/green/blue values
	//checks if in display area
	always @(negedge clk) begin
		if (clk_25) begin
			if (bright) begin		
				if (rgb_lights == 3'b100) begin      // RED
					vga_red   <= 8'b11111111;
					vga_green <= 8'b00000000;
					vga_blue  <= 8'b00000000;
				end 
				else if (rgb_lights == 3'b010) begin // GREEN
					vga_red   <= 8'b00000000;
					vga_green <= 8'b11111111;
					vga_blue  <= 8'b00000000;
				end 
				else if (rgb_lights == 3'b001) begin // BLUE
					vga_red   <= 8'b00000000;
					vga_green <= 8'b00000000;
					vga_blue  <= 8'b11111111;
				end 
				else begin								   // BLACK
					vga_red   <= 8'b00000000;
					vga_green <= 8'b00000000;
					vga_blue  <= 8'b00000000;
				end
			end
			else begin
				vga_red   <= 8'b00000000;
				vga_green <= 8'b00000000;
				vga_blue  <= 8'b00000000;
			end
		end
	end
	
	
	//DAC clock that uses derived 25 MHz clock
	assign VGA_CLK = clk_25;
	
	//this VGA_BLANK_N active-low blanking signal 
	//  is the same as not active-high “bright” signal  
	assign VGA_BLANK_N = bright;
	
	// tie this signal low
	assign VGA_SYNC_N = 0;
	
	
endmodule 