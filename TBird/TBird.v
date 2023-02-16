// top level module for TBird tail lights signaling
module TBird (
	input wire clk, reset,
	input wire [2:0] sw,
	output reg L2, L1, L0,
	output reg R2, R1, R0
);

	wire en; // divided clk
	reg left, right, hazard;
	wire [2:0] left_lights, right_lights;
	
	
	// For the 4 left-most switches:
	// sw[3] - Reset 
	// sw[2] - Left  Turn
	// sw[1] - Right Turn
	// sw[0] - Hazard
	// L2 = LED9,  L1 = LED8,  L0 = LED7 (left turn)
	// R0 = LED2,  R1 = LED1,  R2 = LED0 (right turn)
	

	//instantiate clk divider
	ClockDivider clock  (
		.fastClk(clk), 
		.slowClk(en)
	);
	
	
	//instantiate new TBird FSM module
	FSM fsm (
		.clk(en), 
		.left(left), 
		.right(right), 
		.hazard(hazard), 
		.left_lights(left_lights), 
		.right_lights(right_lights)
	);
	
	
	//assigns 1'b registers left/right/hazard 
	// according to [2:0]sw (input switches)
	// sw[2]= left, sw[1]= right, sw[0]= hazard
	// 3'b(left)(right)(hazard)
	always @(*) begin
		if (~reset) begin
			left   <= 0;
			right  <= 0;
			hazard <= 0;
		end
		else begin
			case (sw)
				3'b100:	begin    // left
							left   <= 1;
							right  <= 0;
							hazard <= 0;
							end
				3'b010:	begin    // right
							left   <= 0;
							right  <= 1;
							hazard <= 0;
							end
				3'b001:	begin    // hazard
							left   <= 0;
							right  <= 0;
							hazard <= 1;
							end
				default: begin    // off
							left   <= 0;
							right  <= 0;
							hazard <= 0;
							end
			endcase 
		end
	end
	
	
	//assigns 3-bit left/right lights to output
	//  wires L2/L1/L0 & R0/R1/R2 for LEDs
	always @ (posedge en) begin
		//[2:0]left_lights: 3'b(L2)(L1)(L0)
		case (left_lights)
			3'b001:	begin    // L0
						L0	<= 1'b1;
						L1 <= 1'b0;
						L2 <= 1'b0;
						end		
			3'b011:	begin    // L1
						L0	<= 1'b1;
						L1 <= 1'b1;
						L2 <= 1'b0;
						end	
			3'b111:	begin    // L2
						L0	<= 1'b1;
						L1 <= 1'b1;
						L2 <= 1'b1;
						end
			default: begin    // off
						L0	<= 1'b0;
						L1 <= 1'b0;
						L2 <= 1'b0;
						end
		endcase 
		//[2:0]right_lights: 3'b(R0)(R1)(R2)
		case (right_lights)
			3'b001:	begin    // R0
						R0	<= 1'b1;
						R1 <= 1'b0;
						R2 <= 1'b0;
						end	
			3'b011:	begin    // R1
						R0	<= 1'b1;
						R1 <= 1'b1;
						R2 <= 1'b0;
						end
			3'b111:	begin    // R2
						R0	<= 1'b1;
						R1 <= 1'b1;
						R2 <= 1'b1;
						end
			default: begin    // off
						R0	<= 1'b0;
						R1 <= 1'b0;
						R2 <= 1'b0;
						end
		endcase 		
	end
	


endmodule 