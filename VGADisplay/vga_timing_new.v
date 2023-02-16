// vga timing module
// designed for 640x480, 60Hz display
module vga_timing_new (
	input wire clk, reset, // 50MHz clk input
	output hsync, vsync, bright,
	output reg [9:0] hCount, vCount
);

	parameter H_DISPLAY = 640; // horizontal display area
	parameter HS_START = 16; // hSync start (end of front porch)
	parameter HS_END = 16 + 96; // hSync end (start of back porch)
	parameter HA_START = 16 + 96 + 48; // end of back porch
	parameter H_RETRACE_START = 640 + 16; // start horizontal retrace
	parameter H_RETRACE_END = 640 + 16 + 96; // end horizontal retrace
	
	parameter LINE = 799; // Length of entire line
	parameter FRAME = 524; // Length of entire frame	

	parameter V_DISPLAY = 480; // vertical display area
	parameter VS_START = 480 + 10; // vSync start (end of front porch)
	parameter VS_END = 480 + 10 + 2; // vSync end (start of back porck)
	parameter VA_START = 0; 
	parameter V_RETRACE_START = 480 + 10; // start vertical retrace
	parameter V_RETRACE_END = 480 + 10 + 2; // end vertical retrace
	
		
	// Horizontal: 640 displayed pixels, 16 front porch pixels, 48 back porch pixels, and 96 "pulse" pixels
	// Vertical:   480 displayed pixels, 10 front porch pixels, 33 back porch pixels, and 2  "pulse" pixels
	

	assign hsync = ~((hCount >= 10'd656) && (hCount < 10'd752));
	assign vsync = ~((vCount >= 10'd490) && (vCount < 10'd492));
	assign bright = ((hCount < 10'd640) && (vCount < 10'd480));			

	reg clk_25 = 0;
	always @(negedge clk) begin //generate pixel clock at 25MHz
		 clk_25 = ~clk_25;
	end
	
	// states:
	`define vertical_sync 4'd0
	`define vertical_front_porch 4'd1
	`define vertical_back_porch 4'd2
	`define horizontal_sync 4'd3
	`define horizontal_front_porch 4'd4
	`define pixels_driving 4'd5
	`define horizontal_back_porch 4'd6
	
	// Values
	`define max_pulse_count 10'd799
	`define max_line_count 10'd524
	`define max_vertical_sync_count 10'd1
	`define max_vertical_front_porch_count 10'd34
	`define max_vertical_c_count 10'd514
	`define max_vertical_back_porch_count 10'd524
	`define max_horizontal_sync_count 10'd95
	`define max_horizontal_front_porch_count 10'd143
	`define max_pixels_driving_count 10'd783
	`define max_horizontal_back_porch_count 10'd798
	
	
	
	reg [3:0] next_state;
	
	always @(negedge clk) begin
		if (clk_25) begin	
			if (~reset) begin
			   next_state <= `vertical_sync;
				hCount <= 10'd0;  //pulse_count
				vCount <= 10'd0;  //line_count
			end		
			else begin
				//hsync <= 1'b1; //vga_hs
            //vsync <= 1'b1; //vga_vs
	
				if (hCount == 799) begin
					hCount <= 10'd0;
					if (vCount == 524) 
						vCount <= 10'd0;
					else 
						vCount <= vCount + 10'd1;
				end 
				else 
					hCount <= hCount + 10'd1;
					
					
				case (next_state)
			`vertical_sync: begin
									  //vsync <= 1'b0;
									  if (vCount == 10'd2 && hCount == 10'd799)
											next_state <= `vertical_front_porch;
								 end
  `vertical_front_porch: begin
									  if (vCount == 10'd35 && hCount == 10'd799)
											next_state <= `horizontal_sync;
								 end
		 `horizontal_sync: begin
									  //hsync <= 1'b0;
									  if (hCount == 10'd96)
											next_state <= `horizontal_front_porch;
								 end
`horizontal_front_porch: begin
									  if (hCount == 10'd144)
											next_state <= `pixels_driving;
								 end
		  `pixels_driving: begin
									  if (hCount == 10'd784)
											next_state <= `horizontal_back_porch;
								 end
 `horizontal_back_porch: begin
									  if (hCount == 10'd799)
											if (vCount == 10'd515)
												 next_state <= `vertical_back_porch;
											else
												 next_state <= `horizontal_sync;
								 end
	`vertical_back_porch: begin
									  if (vCount == 10'd524 && hCount == 10'd799)
											next_state <= `vertical_sync;
								 end
				endcase	
			end
		end
	end

	
	
	
	
	
/*
	// Kinda working counter
	always @(negedge clk) begin
		if (clk_25) begin	
			if (~reset) begin
				hCount <= 0;
				vCount <= 0;
			end
			if (hCount == LINE) begin
				hCount <= 0;
				if (vCount == FRAME) 
					vCount <= 0;
				else 
					vCount <= vCount + 1'b1;
				end 
			else 
			   hCount <= hCount + 1'b1;
			  
		 end
	end	
*/


	//do during display (bright) time!!
	//96+48+640+16 = 800 line
	//hcount 0 to 639
	//96+48 then start hcount
	//referring to slides, start hcount at left dotteed line Tdisp VGA-2022.ppt
	
	
	// h_count_reg = hCount,  h_count_next = hCount_next
	// v_count_reg = vCount,  v_count_next = vCount_next
	// hsync_reg   = hsync,   hsync_next   = hsync_next 
	// vsync_reg   = vsync,   vsync_next   = vsync_next 
/*	
	reg [10:0] hCount_next, vCount_next;
	wire hsync_next, vsync_next;
	
		
	always @(negedge clk) begin
		if (clk_25) begin
			if (~reset) begin
				hCount <= 0;
				vCount <= 0;
				hsync  <= 0; 
				vsync  <= 0;
			end
			else begin
				hCount <= hCount_next;
				vCount <= vCount_next;                    
				hsync <= hsync_next;
				vsync <= vsync_next;
			end
		end
	end
	
	always @(negedge clk) begin
		if (clk_25) begin
		
			hCount_next = hCount == LINE ? 0 : hCount + 1;
				
			vCount_next = hCount == LINE ? (vCount == FRAME ? 0 : vCount + 1) : vCount;
			
		end
	end
*/
	

endmodule 