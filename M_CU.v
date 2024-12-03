`timescale 1ns / 1ps
module M_CU(
    input  [5:0] op        ,
    input  [5:0] rb        ,
	 output [1:0] Tnew      , 
	 output [1:0] fwAddrOp  , 
	 output [1:0] fwDataOp  ,
	 output [2:0] memStoreOp,
	 output [2:0] memLoadOp ,
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
	 
	 assign Tnew = add || sub || andd || orr || slt || sltu || ori || addi || andi || lui || jal || mfhi || mflo ? 2'b00 :
						lw || lh || lb ? 2'b01 :
						2'b11;
	 
	 assign fwAddrOp = add || sub || andd || orr || slt || sltu || mfhi || mflo ? 2'b00 : 
								ori || addi || andi || lw || lh || lb || lui ? 2'b01 :
								jal ? 2'b10 :
								2'b11;
	
	 assign fwDataOp = add || sub || andd || orr || slt || sltu || lui || ori || addi || andi || mfhi || mflo ? 2'b00 : 
								lw || lh || lb ? 2'b01 : 
								jal ? 2'b10 : 
								2'b11; 
								
	 assign memStoreOp = sb ? 3'b001 :
								sh ? 3'b010 :
								sw ? 3'b011 : 
								3'b000;
									
	 assign memLoadOp = lw ? 3'b000 :
							  lh ? 3'b001 :
							  lb ? 3'b010 :
							  3'b111;
	 assign new = ne;		

endmodule

