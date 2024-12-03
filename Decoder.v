`timescale 1ns / 1ps
module Decoder(
    input  [5:0] op   ,
    input  [5:0] rb   ,
    output [0:0] add  ,
    output [0:0] sub  ,
	 output [0:0] andd , 
	 output [0:0] orr  , 
	 output [0:0] slt  , 
	 output [0:0] sltu , 
    output [0:0] lui  ,
	 output [0:0] addi , 
	 output [0:0] andi ,
    output [0:0] ori  ,	 
    output [0:0] lw   ,
	 output [0:0] lh   ,
	 output [0:0] lb   ,
    output [0:0] sw   ,
	 output [0:0] sh   ,
	 output [0:0] sb   ,
    output [0:0] beq  ,
	 output [0:0] bne  , 
    output [0:0] jal  ,
    output [0:0] jr   , 
	 output [0:0] mult , 
	 output [0:0] multu, 
	 output [0:0] div  , 
	 output [0:0] divu ,
    output [0:0] mfhi ,	 
	 output [0:0] mflo ,
	 output [0:0] mthi ,
	 output [0:0] mtlo ,
	 output [0:0] new
    );
	 
	 assign add   = op == 6'b000000 && rb == 6'b100000;
	 assign sub   = op == 6'b000000 && rb == 6'b100010;
	 assign andd  = op == 6'b000000 && rb == 6'b100100;
	 assign orr   = op == 6'b000000 && rb == 6'b100101;
	 assign slt   = op == 6'b000000 && rb == 6'b101010;
	 assign sltu  = op == 6'b000000 && rb == 6'b101011;
	 assign jr    = op == 6'b000000 && rb == 6'b001000;
	 assign mult  = op == 6'b000000 && rb == 6'b011000;
	 assign multu = op == 6'b000000 && rb == 6'b011001;
	 assign div   = op == 6'b000000 && rb == 6'b011010;
	 assign divu  = op == 6'b000000 && rb == 6'b011011;
	 assign mflo  = op == 6'b000000 && rb == 6'b010010;
	 assign mfhi  = op == 6'b000000 && rb == 6'b010000;
	 assign mtlo  = op == 6'b000000 && rb == 6'b010011;
	 assign mthi  = op == 6'b000000 && rb == 6'b010001;
	 assign new   = op == 6'b111111 && rb == 6'b111111;
	 assign ori   = op == 6'b001101                   ;
	 assign addi  = op == 6'b001000						  ;
	 assign andi  = op == 6'b001100						  ;
	 assign lw    = op == 6'b100011						  ;
	 assign lh    = op == 6'b100001						  ;
	 assign lb    = op == 6'b100000						  ;
	 assign sw    = op == 6'b101011						  ;
	 assign sh    = op == 6'b101001						  ;
	 assign sb    = op == 6'b101000						  ;
	 assign beq   = op == 6'b000100						  ;
	 assign bne   = op == 6'b000101						  ;
	 assign lui   = op == 6'b001111						  ;
	 assign jal   = op == 6'b000011						  ;
	 
endmodule
