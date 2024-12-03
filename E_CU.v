`timescale 1ns / 1ps
module E_CU(
	 input  [5:0] op       ,
	 input  [5:0] rb       ,
    output [2:0] ALUOp    ,
	 output [2:0] MDOp     ,
	 output [0:0] MDWE     ,
	 output [0:0] resOp    ,
	 output [0:0] MDAddrOp ,
    output [0:0] ALUIn2Op ,
	 output [1:0] fwAddrOp , 
	 output [1:0] fwDataOp ,
	 output [1:0] Tnew     ,
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
	 
	assign ALUOp =       add || addi || lw || lh || lb || sw || sh || sb ? 3'b000 : 
								sub ? 3'b001  :
								ori || orr ? 3'b010 : 
								lui ? 3'b011  :
								andd || andi ? 3'b100 : 
								slt ? 3'b101  :
								sltu ? 3'b110 : 
								3'b111;
								
	 assign ALUIn2Op = lui || sw || sh || sb || lw || lh || lb || ori || addi || andi ? 1'b1 : 1'b0;
	 
	 assign Tnew = add || sub || andd || orr || slt || sltu || ori || addi || andi || lui || mflo || mfhi ? 2'b01 :
						lw || lh || lb ? 2'b10 :
						jal ? 2'b00 :
						2'b11; 
						
	 assign fwAddrOp = add || sub || orr || andd || slt || sltu || mfhi || mflo ? 2'b00 :
								ori || andi || addi || lw || lh || lb || lui ? 2'b01 : 
								jal ? 2'b10 : 
								2'b11;
								
	 assign fwDataOp = add || sub || andd || orr || slt || sltu || lui || ori || addi || andi || mfhi || mflo ? 2'b00 : 
								lw || lh || lb ? 2'b01 : 
								jal ? 2'b10 : 
								2'b11; 
								
	 assign MDOp = multu ? 3'b001 :
					   mult ? 3'b010 :
						divu ? 3'b011 :
						div ? 3'b100 : 0;
	 
	 assign MDWE = mthi || mtlo;
	 
	 assign MDAddrOp = mfhi || mthi;
	 
	 assign resOp = mfhi || mflo; 
	 
	 assign new = ne;

endmodule

