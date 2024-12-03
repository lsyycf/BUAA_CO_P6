`timescale 1ns / 1ps
module M_LBE(
    input  [ 1:0] lowBit    ,
    input  [31:0] inMemData ,
    input  [ 2:0] memLoadOp ,
    output [31:0] outMemData
    );

	assign outMemData = (memLoadOp == 3'b000) ? inMemData :
							  (memLoadOp == 3'b001) ? ((lowBit == 2'b00) ? {{16{inMemData[15]}}, inMemData[15: 0]}:
																(lowBit == 2'b10) ? {{16{inMemData[31]}}, inMemData[31:16]}:
																32'b0)   :
							  (memLoadOp == 3'b010) ? ((lowBit == 2'b00) ? {{24{inMemData[ 7]}}, inMemData[ 7: 0]}:
									                     (lowBit == 2'b01) ? {{24{inMemData[15]}}, inMemData[15: 8]}:
																(lowBit == 2'b10) ? {{24{inMemData[23]}}, inMemData[23:16]}:
																(lowBit == 2'b11) ? {{24{inMemData[31]}}, inMemData[31:24]}:
																32'b0)   :
							  32'b0;

endmodule
