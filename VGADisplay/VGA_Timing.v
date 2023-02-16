module VGA_Timing (
	input wire clk, 
	input wire clk_25,
	input wire reset, 
	output reg hSync, 
	output reg vSync, 
	output reg bright, 
	output reg [9:0] hCount, 
	output reg [9:0] vCount
);
		
	parameter hSyncLow = 10'd655;
	parameter hSyncHigh = 10'd752;
	parameter vSyncLow = 10'd489;
	parameter vSyncHigh = 10'd492;
	parameter hCountEnd = 10'd799;
	parameter vCountEnd = 10'd521;
	parameter hDisplay = 10'd640;
	parameter vDisplay = 10'd480;
	
	
//	always@(negedge reset, posedge clk) begin
	always @(negedge reset, posedge clk) begin
		if(~reset) begin
			hCount <= hSyncLow;
			vCount <= vSyncLow;
			bright <= 0;
			hSync <= 0;
			vSync <= 0;
		end
		else if(clk_25) begin	
			if(hCount <= hCountEnd) begin
				hCount <= hCount + 10'd1;
				if((hCount > hSyncLow) && (hCount < hSyncHigh)) 
					hSync <= 0;
				else 
					hSync <= 1'd1;
				if((vCount < vCountEnd) && (hCount == hCountEnd)) begin
					vCount <= vCount + 10'd1;
					if((vCount > vSyncLow) && (vCount < vSyncHigh)) 
						vSync <= 0;
					else 
						vSync <= 1'd1;
				end
				else if(vCount == vCountEnd) begin
					vCount <= 0;
				end
				else 
					vCount <= vCount;
			end
			else 
				hCount <= 0;
			
			if((hCount < hDisplay && vCount < vDisplay)) 
				bright <= 1'd1;
			else 
				bright <= 0;
		end
		else 
			hCount <= hCount;
	end
	
	
endmodule 