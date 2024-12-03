`timescale 1ns / 1ps
module D_Reg(
    input  [ 0:0] clk     ,
    input  [ 0:0] reset   ,
	 input  [ 0:0] freeze  ,
    input  [31:0] inInstr ,
    input  [31:0] inPc    ,
    output [31:0] outInstr,
    output [31:0] outPc
    );
	 
	 reg [31:0] instr;
	 reg [31:0] pc   ;
	 
	 initial
	 begin
		instr <= 0           ;
		pc    <= 32'h00003000;
	 end
	 
	 always @(posedge clk)
	 begin
		if (reset)
		begin
			instr <= 0           ;
			pc    <= 32'h00003000;
		end 
		else if (!freeze) 
		begin
			instr <= inInstr;
			pc    <= inPc   ;
		end
	 end
	 
	 assign outInstr = instr;
	 assign outPc    = pc   ;

endmodule

