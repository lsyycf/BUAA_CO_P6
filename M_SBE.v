`timescale 1ns / 1ps
module M_SBE(
    input  [ 2:0] memStoreOp ,
    input  [ 1:0] lowBit     ,
	 input  [31:0] inMemData  ,
    output [ 3:0] data_byteen, 
	 output [31:0] outMemData
    );
	 
	 assign data_byteen = (memStoreOp == 3'b000) ? 4'b0000  :
								 (memStoreOp == 3'b001) ? ((lowBit == 2'b00) ? 4'b0001 :
									                        (lowBit == 2'b01) ? 4'b0010 :
																   (lowBit == 2'b10) ? 4'b0100 :
																   (lowBit == 2'b11) ? 4'b1000 :
																   4'b0000):
								 (memStoreOp == 3'b010) ? ((lowBit == 2'b00) ? 4'b0011 :
																   (lowBit == 2'b10) ? 4'b1100 :
																   4'b0000):
								 (memStoreOp == 3'b011) ? 4'b1111  :
								 4'b0000;
	 
	 assign outMemData = (memStoreOp == 3'b000) ? 32'b0     :
								(memStoreOp == 3'b001) ? ((lowBit == 2'b00) ? {24'b0, inMemData[7:0]}        :
									                       (lowBit == 2'b01) ? {16'b0, inMemData[7:0],  8'b0} :
																  (lowBit == 2'b10) ? { 8'b0, inMemData[7:0], 16'b0} :
																  (lowBit == 2'b11) ? {inMemData[7:0], 24'b0}        :
																  32'b0)   :
								(memStoreOp == 3'b010) ? ((lowBit == 2'b00) ? {16'b0, inMemData[15:0]}       :
																  (lowBit == 2'b10) ? {inMemData[15:0], 16'b0}       :
																  32'b0)   :
								(memStoreOp == 3'b011) ? inMemData :
								32'b0;

endmodule

