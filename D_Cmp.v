`timescale 1ns / 1ps
module D_Cmp(
    input  [31:0] cmpIn1,
    input  [31:0] cmpIn2,
    input  [ 2:0] cmpOp ,
    output [ 0:0] cmpRes
    );
	 
	 assign cmpRes = (cmpOp == 3'b000)? 1'b0            :
						  (cmpOp == 3'b001)? 1'b1            :
						  (cmpOp == 3'b010)? cmpIn1 == cmpIn2:
						  (cmpOp == 3'b011)? cmpIn1 != cmpIn2:
						  1'b1;

						  
endmodule
