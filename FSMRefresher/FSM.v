module FSM #(
    parameter S0 = 6'b000000,
    parameter S1 = 6'b001000,
    parameter S2 = 6'b011000,
	 parameter S3 = 6'b111000,
    parameter S4 = 6'b000100,
    parameter S5 = 6'b000110,
    parameter S6 = 6'b000111,
	 parameter S7 = 6'b111111
	 )	(
	 input wire en, reset, left, right, hazard, clk,
	 output reg [4:0] outLeft1, outLeft2, outLeft3, outRight1, outRight2, outRight3,
	 output reg [5:0] state, nextState);
	
	//wire noLights; 	
	//assign noLights = ~(left | right | hazard);
	
	// changes state on clock cycle
	//always @ (posedge en, negedge reset) begin
   always @ (posedge clk) begin
		// if (reset)
		if (reset) begin
			state <= S0; 
		end
		// if (en)
		else begin
			state <= nextState; 
		end
	end
	
	
	// changes state based on my state diagram pic
	always @(*) begin	
		case (state)
			//initial
			S0: begin
				//if (~(left | right | hazard)) begin
				//	nextState = S0;
				//end
				if (left) begin
					nextState = S1;
				end
				else if (right) begin
					nextState = S4;
				end
				else 
					nextState = S7;
				end	
				
			//left
			S1: begin
				nextState = S2;
				end
			S2: begin
				nextState = S3;
				end
			S3: begin
				nextState = S1;
				end
			
			//right
			S4: begin
				nextState = S5;
				end
			S5: begin
				nextState = S6;
				end
			S6: begin
				nextState = S4;
				end
			
			//hazard
			S7: begin
				nextState = S0;
				end		
			
			default: nextState = S0;
		endcase
	end
	
	
	// state decoder for left lights that sets hex to seven seg lights 
	// (I wanted to show number "0" when each light is turned on the display on the board)
	// for left light 1 (--0 --- on hex-7-seg disp)
	always @(*) begin
		case (state)			
			S0: outLeft1 = 5'h10; 		//--- ---
			S1: outLeft1 = 5'h0; 		//--0 ---
			S2: outLeft1 = 5'h0;  		//--0 ---
			S3: outLeft1 = 5'h0;	 		//--0 ---
			S7: outLeft1 = 5'h0;  		//--0 ---
			default: outLeft1 = 5'h10; //--- ---
		endcase
	end
	// for left light 2 (-0- --- on hex-7-seg disp)
	always @(*) begin
		case (state)			
			S0: outLeft2 = 5'h10; 		//--- ---
			S1: outLeft2 = 5'h10; 		//--- ---
			S2: outLeft2 = 5'h0;  		//-0- ---
			S3: outLeft2 = 5'h0;	 		//-0- ---
			S7: outLeft2 = 5'h0;  		//-0- ---
			default: outLeft2 = 5'h10; //--- ---
		endcase
	end
	// for left light 3 (0-- --- on hex-7-seg disp)
	always @(*) begin
		case (state)			
			S0: outLeft3 = 5'h10; 		//--- ---
			S1: outLeft3 = 5'h10; 		//--- ---
			S2: outLeft3 = 5'h10;  		//--- ---
			S3: outLeft3 = 5'h0;	 		//0-- ---
			S7: outLeft3 = 5'h0;  		//0-- ---
			default: outLeft3 = 5'h10; //--- ---
		endcase
	end
	
	// state decoder for right lights that sets hex to seven seg lights
	// for right light 1 (--- 0-- on hex-7-seg disp)
	always @(*) begin 
		case (state)	
			S0: outRight1 = 5'h10; 		//--- ---
			S4: outRight1 = 5'h0; 		//--- 0--
			S5: outRight1 = 5'h0;		//--- 0--
			S6: outRight1 = 5'h0;		//--- 0--
			S7: outRight1 = 5'h0;		//--- 0--
			default: outRight1 = 5'h10;//--- ---
		endcase
	end
	// for right light 2 (--- -0- on hex-7-seg disp)
	always @(*) begin
		case (state)	
			S0: outRight2 = 5'h10; 		//--- --- 		
			S4: outRight2 = 5'h10; 		//--- ---
			S5: outRight2 = 5'h0;		//--- -0-
			S6: outRight2 = 5'h0;		//--- -0-
			S7: outRight2 = 5'h0;		//--- -0-
			default: outRight2 = 5'h10;//--- ---
		endcase
	end
	// for right light 3 (--- --0 on hex-7-seg disp)
	always @(*) begin 
		case (state)	
			S0: outRight3 = 5'h10; 		//--- --- 
			S4: outRight3 = 5'h10; 		//--- ---
			S5: outRight3 = 5'h10;		//--- ---
			S6: outRight3 = 5'h0;		//--- --0
			S7: outRight3 = 5'h0;		//--- --0
			default: outRight3 = 5'h10;//--- ---
		endcase
	end
	
endmodule