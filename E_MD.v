`timescale 1ns / 1ps
module E_MD(
	 input  [ 0:0] clk     , 
	 input  [ 0:0] reset   ,
    input  [ 0:0] WE      ,	 
	 input  [ 2:0] MDOp    ,
    input  [31:0] MDIn1   ,
    input  [31:0] MDIn2   ,
	 input  [ 0:0] MDAddrOp,
    output [31:0] MDRes   ,
	 output [ 3:0] busy
    );
	 
	 reg [31:0] lo      ;
	 reg [31:0] hi      ;
	 reg [31:0] loTemp  ;
	 reg [31:0] hiTemp  ;
	 reg [ 3:0] busyTemp;
	 
	 initial
	 begin
		lo       <= 0;
		hi       <= 0;
		loTemp   <= 0;
		hiTemp   <= 0;
		busyTemp <= 0;
	 end
	 
	 always @(posedge clk) 
	 begin
		if (reset) 
		begin
			lo       <= 0;
			hi       <= 0;
			loTemp   <= 0;
			hiTemp   <= 0;
			busyTemp <= 0;
		end 
		else 
		begin
			if (busy == 1) 
			begin
				lo       <= loTemp;
				hi       <= hiTemp;
				busyTemp <= 0     ;
			end 
			else if (busy > 1)
			begin
				busyTemp <= busyTemp - 1;
			end 
			else if (MDOp == 3'b001) 
			begin
				{hiTemp, loTemp} <= MDIn1 * MDIn2;
				busyTemp         <= 5            ;
			end 
			else if (MDOp == 3'b010) 
			begin
				{hiTemp, loTemp} <= $signed(MDIn1) * $signed(MDIn2);
				busyTemp         <= 5                              ;
			end 
			else if (MDOp == 3'b011) 
			begin
				loTemp   <= MDIn1 / MDIn2;
				hiTemp   <= MDIn1 % MDIn2;
				busyTemp <= 10           ;
			end 
			else if (MDOp == 3'b100) 
			begin
				loTemp   <= $signed(MDIn1) / $signed(MDIn2);
				hiTemp   <= $signed(MDIn1) % $signed(MDIn2);
				busyTemp <= 10                             ;
			end
			
			if (WE) 
			begin
				if (MDAddrOp) 
				begin
					hi <= MDIn1;
				end 
				else 
				begin
					lo <= MDIn1;
				end
			end
		end
	end
	
	assign MDRes = MDAddrOp ? hi : lo;
	assign busy  = busyTemp          ;

endmodule

