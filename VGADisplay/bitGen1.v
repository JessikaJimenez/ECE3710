// top level module for vga synthesis
// designed for 640x480, 60Hz display
module bitGen1  (
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
	
/*
	reg clk_tick, clk_25;
	//setup for "derived" 25 MHz pixel clk
	always @ (posedge clk_50) begin
		clk_tick <= ~clk_tick;
		
		//logical clk_25 MHz: 1 at 1/2 tick of clk_50 MHz, 0 otherwise
		if (clk_tick == 0)
			clk_25 <= 1;
		else
			clk_25 <= 0;
	end
	
	//instantiate vga timing module
	VGA_Timing vgatiming (
		.clk_50(clk_50), 
		.reset(reset),
		.hsync(hsync), 
		.vsync(vsync), 
		.bright(bright),
		.hCount(hCount),
		.vCount(vCount)
	);
*/

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
	
	
	//assigns 1'b registers red/blue/green 
	// according to [2:0]sw (input switches)
	// 3'b(red)(green)(blue)
	always @(*) begin
		if (~reset) begin
			red   <= 1'b0;
			green <= 1'b0;
			blue  <= 1'b0;
		end
		else begin	
			case (sw)
				3'b001:	begin    // BLUE
							red   <= 1'b0;
							green <= 1'b0;
							blue  <= 1'b1;
							end
				3'b010:	begin    // GREEN
							red   <= 1'b0;
							green <= 1'b1;
							blue  <= 1'b0;
							end
				3'b011:	begin    // CYAN
							red   <= 1'b0;
							green <= 1'b1;
							blue  <= 1'b1;
							end
				3'b100:	begin    // RED
							red   <= 1'b1;
							green <= 1'b0;
							blue  <= 1'b0;
							end
				3'b101:	begin    // MAGENTA
							red   <= 1'b1;
							green <= 1'b0;
							blue  <= 1'b1;
							end
				3'b110:	begin    // YELLOW
							red   <= 1'b1;
							green <= 1'b1;
							blue  <= 1'b0;
							end
				3'b111:	begin    // WHITE
							red   <= 1'b1;
							green <= 1'b1;
							blue  <= 1'b1;
							end
				default: begin    // BLACK
							red   <= 1'b0;
							green <= 1'b0;
							blue  <= 1'b0;
							end
			endcase				
		end
	end
	
	
	//checks 1'b registers red/green/blue to assign VGA red/green/blue values
	//checks if in display area
	always @(negedge clk) begin
		if (clk_25) begin
			if (bright) begin		
				if (red == 1'b0 && green == 1'b0 && blue == 1'b1) begin // BLUE
					vga_red   <= 8'b00000000;
					vga_green <= 8'b00000000;
					vga_blue  <= 8'b11111111;
				end 
				else if (red == 1'b0 && green == 1'b1 && blue == 1'b0) begin // GREEN
					vga_red   <= 8'b00000000;
					vga_green <= 8'b11111111;
					vga_blue  <= 8'b00000000;
				end 
				else if (red == 1'b0 && green == 1'b1 && blue == 1'b1) begin // CYAN
					vga_red   <= 8'b00000000;
					vga_green <= 8'b11111111;
					vga_blue  <= 8'b11111111;
				end 
				else if (red == 1'b1 && green == 1'b0 && blue == 1'b0) begin // RED
					vga_red   <= 8'b11111111;
					vga_green <= 8'b00000000;
					vga_blue  <= 8'b00000000;
				end 
				else if (red == 1'b1 && green == 1'b0 && blue == 1'b1) begin // MAGENTA
					vga_red   <= 8'b11111111;
					vga_green <= 8'b00000000;
					vga_blue  <= 8'b11111111;
				end 
				else if (red == 1'b1 && green == 1'b1 && blue == 1'b0) begin // YELLOW
					vga_red   <= 8'b11111111;
					vga_green <= 8'b11111111;
					vga_blue  <= 8'b00000000;
				end 
				else if (red == 1'b1 && green == 1'b1 && blue == 1'b1) begin // WHITE
					vga_red   <= 8'b11111111;
					vga_green <= 8'b11111111;
					vga_blue  <= 8'b11111111;
				end 
				else begin														 			 // BLACK
					vga_red   <= 8'b00000000;
					vga_green <= 8'b00000000;
					vga_blue  <= 8'b00000000;
				end
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