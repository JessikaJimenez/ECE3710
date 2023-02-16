`timescale 1ns/1ns

// vga simulation test module
// designed for 640x480, 60Hz display
module tb_VGA #(
	parameter PERIOD = 40 // 40 ns = 25 MHz
) ();

	reg clk, reset;
	wire hsync, vsync, bright;
	wire [9:0] hCount, vCount;
	

	//instantiate vga timing module
	VGA_Timing vgatiming (
		.clk_50(clk), 
		.reset(reset),
		.hsync(hsync), 
		.vsync(vsync), 
		.bright(bright),
		.hCount(hCount),
		.vCount(vCount)
	);

	
	initial begin
		clk = 0;
		reset = 1;
		
		#PERIOD
		
		reset = 0;
		clk = 1;
		
		#PERIOD
		
		reset = 1;
		clk = 0;
	end
	
	always #PERIOD begin
		clk <= ~clk;
	end
	
	
	
/*
	always begin
		#50 clk_50 = 0;
		#50 clk_50 = 1;
	end

	
	initial begin
		reset = 0; // resest active low
		#500
		reset = 1; // reset off
		
		#500
		
		reset = 0; // resest active low
		#500
		reset = 1; // reset off
		
		#500
		
		reset = 0; // resest active low
		#500
		reset = 1; // reset off
		
		#500
		
		reset = 0; // resest active low
		#500
		reset = 1; // reset off
	end
*/

endmodule 