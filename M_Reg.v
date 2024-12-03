`timescale 1ns / 1ps
module M_Reg(
	 input  [ 0:0] clk        ,
    input  [ 0:0] reset      ,
	 input  [31:0] inInstr    ,
    input  [31:0] inPc       ,
	 input  [31:0] inRegRead1 ,
	 input  [31:0] inRegRead2 ,
    input  [31:0] inALURes   ,
	 input  [31:0] inImm      ,
	 input  [ 0:0] inRegWE    ,
	 input  [ 0:0] inCmpRes   ,
	 output [31:0] outInstr   ,
    output [31:0] outPc      ,
	 output [31:0] outRegRead1,
	 output [31:0] outRegRead2,
    output [31:0] outALURes  ,
	 output [31:0] outImm     ,
	 output [ 0:0] outRegWE   
    );
	 
	 reg [31:0] instr   ;
	 reg [31:0] pc      ;
	 reg [31:0] regRead1;
	 reg [31:0] regRead2;
	 reg [31:0] ALURes  ;
	 reg [31:0] imm     ;
	 reg [ 0:0] regWE   ;
	 
	 initial 
	 begin
	   instr    <= 0           ;
		pc       <= 32'h00003000;
		regRead1 <= 0           ;
		regRead2 <= 0           ;
		ALURes   <= 0           ;
		imm      <= 0           ;
		regWE    <= 0           ;
	 end
	 
	 always@ (posedge clk) 
	 begin
		if (reset) 
		begin
			instr    <= 0           ;
			pc       <= 32'h00003000;
			regRead1 <= 0           ;
			regRead2 <= 0           ;
			ALURes   <= 0           ;
			imm      <= 0           ;
			regWE    <= 0           ;
		end
		else 
		begin
			instr    <= inInstr   ;
			pc       <= inPc      ;
			regRead1 <= inRegRead1;
			regRead2 <= inRegRead2;
			ALURes   <= inALURes  ;
			imm      <= inImm     ;
			regWE    <= inRegWE   ;
		end
	 end
	 
	 assign outInstr    = instr   ;
	 assign outPc       = pc      ;
	 assign outRegRead1 = regRead1;
	 assign outRegRead2 = regRead2;
	 assign outALURes   = ALURes  ;
	 assign outImm      = imm     ;
	 assign outRegWE    = regWE   ;
	
endmodule
