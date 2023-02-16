// top level module for vga synthesis
// designed for 640x480, 60Hz display
module bitGen2  (
	input wire clk, reset, // 50MHz clk
	input wire [2:0] sw,
	output wire hSync, vSync,
	output reg [7:0] vga_red,
	output reg [7:0] vga_green, 
	output reg [7:0] vga_blue,
	output wire VGA_CLK, 
	output wire VGA_BLANK_N, 
	output wire VGA_SYNC_N
);

	wire en; // divided clk
	wire clk_25; // half clock
	wire bright;
	wire [9:0] hCount;
	wire [9:0] vCount;
	reg left, right, hazard;
	wire [2:0] rgb_lights;
	
	
	//instantiate 25MHz half clock
	HalfClock hclock (
		.clk(clk),
		.clk_25(clk_25)
	);
	
	
	//instantiate clk divider
	ClockDivider clockd  (
		.fastClk(clk), 
		.slowClk(en)
	);

	
	//instantiate vga timing module
	VGA_Timing vgatiming (
		.clk(clk), 
		.clk_25(clk_25),
		.reset(reset),
		.hSync(hSync), 
		.vSync(vSync), 
		.bright(bright),
		.hCount(hCount),
		.vCount(vCount)
	);
		
/*
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
*/		
		
	//instantiate TBird FSM module
	FSM fsm (
		.clk(en), 
		.clk_25(clk_25),
		.reset(reset),
		.left(left), 
		.right(right), 
		.hazard(hazard), 
		.bright(bright),
		.rgb_lights(rgb_lights),
		.hCount(hCount)
	);
	
		
	//my super neat vga rgb display with TBird FSM:
	// the 640x480 display is split into 8 vertical sections.
	// the middle 2 sections will permanently remain black.
	//left signal:  turns on 3 left-most sections (colored red/green/blue)
	//right signal: turns on 3 right-most sections (colored blue/green/red)
	//hazard:       turns on 3 left-most and 3 right-most sections (^ same colors)
	
	//assigns 1'b registers left/right/hazard 
	// according to [2:0]sw (input switches)
	// 3'b(left)(right)(hazard)
	always @(*) begin
		if (~reset) begin
			left   <= 1'b0;
			right  <= 1'b0;
			hazard <= 1'b0;
		end
		else begin
			case (sw)
				3'b100:	begin    // left
							left   <= 1'b1;
							right  <= 1'b0;
							hazard <= 1'b0;
							end
				3'b010:	begin    // right
							left   <= 1'b0;
							right  <= 1'b1;
							hazard <= 1'b0;
							end
				3'b001:	begin    // hazard
							left   <= 1'b0;
							right  <= 1'b0;
							hazard <= 1'b1;
							end
				default: begin    // off
							left   <= 1'b0;
							right  <= 1'b0;
							hazard <= 1'b0;
							end
			endcase 
		end
	end
	
	
	//assign 3-bit rgb lights to VGA red/green/blue
	//also checks bright (if in display area)
	always @(clk_25) begin
		if (bright) begin
			//[2:0]rgb_lights: 3'b(red)(green)(blue)
			case (rgb_lights)
				3'b000:  begin    // off
							vga_red   <= 8'b00000000;
							vga_green <= 8'b00000000;
							vga_blue  <= 8'b00000000;
							end
				3'b001:	begin    // BLUE
							vga_red   <= 8'b00000000;
							vga_green <= 8'b00000000;
							vga_blue  <= 8'b11111111;
							end		
				3'b010:	begin    // GREEN
							vga_red   <= 8'b00000000;
							vga_green <= 8'b11111111;
							vga_blue  <= 8'b00000000;
							end	
				3'b100:	begin    // RED
							vga_red   <= 8'b11111111;
							vga_green <= 8'b00000000;
							vga_blue  <= 8'b00000000;
							end
				default: begin    // off
							vga_red   <= 8'b00000000;
							vga_green <= 8'b00000000;
							vga_blue  <= 8'b00000000;
							end
			endcase
		end
	end
	
		
	//DAC clock that uses derived 25 MHz clock
	assign VGA_CLK = clk_25;
	
	//this VGA_BLANK_N active-low blanking signal 
	//  is the same as a not active-high “bright” signal  
	assign VGA_BLANK_N = bright;
	
	// tie this signal low
	assign VGA_SYNC_N = 0;
	
	
	
endmodule 