module TBirdTurnSignals (
	input wire clk, reset, left, right, hazard,
	output wire [6:0] sevsegLeft1, sevsegLeft2, sevsegLeft3, sevsegRight1, sevsegRight2, sevsegRight3
);
	wire en; //output from clock divider
	wire [5:0] state, nextState;
	
	wire [4:0] fsmOutLeft1, fsmOutLeft2, fsmOutLeft3, fsmOutRight1, fsmOutRight2, fsmOutRight3;
	
	
	ClockDivider clock  (.fastClk(clk), .slowClk(en));
	//assign en = clk; //temp clock for simulating
	
	FSM fsm 				  (.en(en),       .state(state),  .nextState(nextState), 
								.left(left),   .right(right),  .hazard(hazard),  			 .reset(reset),
								.outLeft1(fsmOutLeft1), 		 .outLeft2(fsmOutLeft2),    .outLeft3(fsmOutLeft3), 
								.outRight1(fsmOutRight1), 		 .outRight2(fsmOutRight2),  .outRight3(fsmOutRight3));	
	
	SevenSeg sevensegLeft1    (.hex_input(fsmOutLeft1),  .seven_seg(sevsegLeft1));
	SevenSeg sevensegLeft2    (.hex_input(fsmOutLeft2),  .seven_seg(sevsegLeft2));
	SevenSeg sevensegLeft3    (.hex_input(fsmOutLeft3),  .seven_seg(sevsegLeft3));
	
	SevenSeg sevensegRight1   (.hex_input(fsmOutRight1), .seven_seg(sevsegRight1));	
	SevenSeg sevensegRight2   (.hex_input(fsmOutRight2), .seven_seg(sevsegRight2));	
	SevenSeg sevensegRight3   (.hex_input(fsmOutRight3), .seven_seg(sevsegRight3));	
	
	// For buttons left to right:
	// Button 3 - Left Turn
	// Button 2 - Right Turn
	// Button 1 - Hazards
	// Button 0 - Reset

endmodule