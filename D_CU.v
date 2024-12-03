`timescale 1ns / 1ps
module D_CU(
    input  [5:0] op    , 
	 input  [5:0] rb    ,
	 output [0:0] regWE ,
	 output [1:0] pcOp  ,
    output [2:0] cmpOp ,
    output [0:0] extOp , 
	 output [0:0] MD    ,
    output [1:0] rsTuse,	 
	 output [1:0] rtTuse,
	 output [0:0] new   
    );
	 
	 wire add  ;
    wire sub  ;
	 wire andd ;
	 wire orr  ;
	 wire slt  ;
	 wire sltu ;
    wire ori  ;
	 wire lui  ;
	 wire addi ;
	 wire andi ;
    wire lw   ;
	 wire lh   ;
	 wire lb   ;
    wire sw   ;
	 wire sh   ;
	 wire sb   ;
    wire beq  ;
	 wire bne  ;
    wire jal  ;
    wire jr   ;
	 wire mult ;
	 wire multu;
	 wire div  ;
	 wire divu ;
	 wire mflo ;
	 wire mfhi ;
	 wire mtlo ;
	 wire mthi ;
	 wire ne   ;
	 
	 Decoder Decoder_instance(
									  .op   (op)   ,
									  .rb   (rb)   , 
									  .add  (add)  , 
									  .sub  (sub)  ,
									  .andd (andd) ,
									  .orr  (orr)  ,
									  .lui  (lui)  , 
									  .slt  (slt)  ,
									  .sltu (sltu) ,
									  .ori  (ori)  ,
									  .addi (addi) ,
									  .andi (andi) ,
									  .mfhi (mfhi) ,
									  .mflo (mflo) ,
 									  .mthi (mthi) ,
									  .mtlo (mtlo) ,
									  .mult (mult) ,
									  .multu(multu),
									  .div  (div)  ,
									  .divu (divu) ,
									  .lw   (lw)   ,
									  .lh   (lh)   ,
									  .lb   (lb)   ,
									  .sw   (sw)   ,
									  .sh   (sh)   ,
									  .sb   (sb)   ,
									  .beq  (beq)  ,
									  .bne  (bne)  ,
									  .jal  (jal)  ,
									  .jr   (jr)   ,
									  .new  (ne)
    );
	 
	 
	 assign pcOp = beq || bne ? 2'b01 :
						  jal ? 2'b10 :
						  jr ? 2'b11 : 
						  2'b00; 
						
	 assign cmpOp = beq ? 3'b010 :
							bne ? 3'b011 : 
							jal || jr ? 3'b001 : 
							3'b001; 
	
	 assign extOp = sw || sh || sb || lw || lh || lb || addi || beq || bne; 
	 
	 assign regWE = add || sub || andd || orr || slt || sltu || ori || addi || andi || lw || lh || lb || lui || jal || mflo || mfhi;
	 
	 assign rtTuse = add || sub || andd || orr || slt || sltu || mult || multu || div || divu ? 2'b01 : 
							lw || lh || lb || sw || sh || sb ? 2'b10 :
							beq || bne ? 2'b00 : 
							2'b11; 
	 
	 assign rsTuse = add || sub || andd || orr || slt || sltu || ori || addi || andi || lw || lh || lb || sw || sh || sb || mult || multu || div || divu || mthi || mtlo ? 2'b01 :
							beq || bne || jr ? 2'b00 :
							2'b11;
							
	 assign MD = mult || multu || div || divu || mfhi || mflo || mthi || mtlo;
	 
	 assign new = ne;
	 
endmodule

