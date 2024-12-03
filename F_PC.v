`timescale 1ns / 1ps
module F_PC(
    input  [31:0] nextPc,
    input  [ 0:0] clk   ,
    input  [ 0:0] reset ,
    output [31:0] nowPc
    );
	 
	 reg [31:0] pc;
	 
	 initial begin
		pc <= 32'h00003000;
	 end
	 
	 always @(posedge clk) 
	 begin
		if (reset) 
		begin
			pc <= 32'h00003000;
		end 
		else 
		begin
			pc <= nextPc      ;
		end
	 end
	 
	 assign nowPc = pc;

endmodule

