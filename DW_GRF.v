`timescale 1ns / 1ps
module DW_GRF(
	 input  [31:0] pc      ,
	 input  [ 0:0] clk     ,
    input  [ 0:0] reset   ,
    input  [ 4:0] reg1    ,
    input  [ 4:0] reg2    ,
    input  [ 4:0] regAddr ,
	 input  [ 0:0] WE      ,
	 input  [31:0] regData ,
    output [31:0] regRead1,
    output [31:0] regRead2 
    );
	 
	 reg [31:0] register [0:31];
	 integer i;
	 
	 initial begin
		for (i = 0; i < 32; i = i + 1) begin
			register[i] <= 0;
		end
	 end
	 
	 always @(posedge clk) 
	 begin
		if (reset) 
		begin
			for (i = 0; i < 32; i = i + 1) begin
				register[i] <= 0;
			end
		end 
		else 
		begin
			if (WE && regAddr != 0) 
			begin
				register[regAddr] <= regData;
			end
		end
	 end
	 
	 assign regRead1 = register[reg1];
	 assign regRead2 = register[reg2];

endmodule
