`timescale 1ns / 1ps
`define op    31:26
`define rb    5 : 0
`define rs    25:21
`define rt    20:16
`define rd    15:11 
`define ra    10: 6
`define imm   15: 0
`define index 25: 0 
module mips(
    input  [ 0:0] clk          ,
    input  [ 0:0] reset        ,
    input  [31:0] i_inst_rdata ,
    input  [31:0] m_data_rdata , 
    output [31:0] i_inst_addr  ,
    output [31:0] m_data_addr  ,
    output [31:0] m_data_wdata ,
    output [ 3:0] m_data_byteen, 
    output [31:0] m_inst_addr  ,
    output [ 0:0] w_grf_we     ,           
    output [ 4:0] w_grf_addr   ,
    output [31:0] w_grf_wdata  , 
    output [31:0] w_inst_addr
);
	 
	 wire [ 0:0] freeze      ;
	 wire [31:0] F_nextPc    ;
	 wire [31:0] F_nowPc     ;
	 wire [31:0] F_instr     ;
	 wire [31:0] D_instr     ;
	 wire [31:0] D_nowPc     ;
	 wire [31:0] E_instr     ;
	 wire [31:0] E_nowPc     ;
	 wire [31:0] M_nowPc     ;
	 wire [31:0] M_instr     ;
	 wire [31:0] W_nowPc     ;
	 wire [31:0] W_instr     ;
	 wire [ 1:0] E_fwAddrOp  ;
	 wire [ 4:0] E_fwAddr    ;
	 wire [ 1:0] E_fwDataOp  ;
	 wire [31:0] E_fwData    ;
	 wire [ 1:0] M_fwAddrOp  ;
	 wire [ 4:0] M_fwAddr    ;
	 wire [ 1:0] M_fwDataOp  ;
	 wire [31:0] M_fwData    ;
	 wire [ 1:0] W_fwAddrOp  ;
	 wire [ 4:0] W_fwAddr    ;
	 wire [ 1:0] W_fwDataOp  ;
	 wire [31:0] W_fwData    ;
	 wire [ 1:0] D_pcOp      ;
	 wire [ 2:0] D_cmpOp     ;
	 wire [ 0:0] D_extOp     ;
	 wire [ 1:0] D_rsTuse    ;
	 wire [ 1:0] D_rtTuse    ;
	 wire [ 0:0] D_regWE     ;
	 wire [ 0:0] D_MD        ;
	 wire [ 0:0] D_cmpRes    ;
	 wire [ 0:0] D_new       ;
	 wire [ 2:0] E_ALUOp     ;
	 wire [ 0:0] E_ALUIn2Op  ;
	 wire [ 2:0] E_MDOp      ;
	 wire [ 0:0] E_MDAddrOp  ;
	 wire [ 0:0] E_regWE     ;
	 wire [ 0:0] E_resOp     ;
	 wire [ 0:0] E_MDWE      ;
    wire [ 3:0] E_busy      ;	 
	 wire [ 1:0] E_Tnew      ;
	 wire [ 0:0] E_new       ;
	 wire [ 2:0] M_memLoadOp ;
	 wire [ 2:0] M_memStoreOp; 
	 wire [ 0:0] M_regWE     ;
	 wire [ 1:0] M_Tnew      ;
	 wire [ 0:0] M_new       ;
	 wire [ 0:0] W_regWE     ;
	 wire [ 1:0] W_Tnew      ;
	 wire [ 0:0] W_new       ;
	 wire [31:0] D_rsData    ;
	 wire [31:0] D_rtData    ;
	 wire [31:0] E_rsData    ;
	 wire [31:0] E_rtData    ;
	 wire [31:0] M_rsData    ;
	 wire [31:0] M_rtData    ;
	 wire [31:0] W_rsData    ;
	 wire [31:0] W_rtData    ;
	 wire [31:0] D_regRead1  ;
	 wire [31:0] D_regRead2  ;
	 wire [31:0] D_imm       ;
	 wire [31:0] E_regRead1  ;
	 wire [31:0] E_regRead2  ;
	 wire [31:0] E_ALURes    ;
	 wire [31:0] E_MDRes     ;
	 wire [31:0] E_imm       ;
	 wire [31:0] M_regRead1  ;
	 wire [31:0] M_regRead2  ;
	 wire [31:0] M_ALURes    ;
	 wire [31:0] M_memRead   ;
	 wire [31:0] M_imm       ;
	 wire [31:0] W_regRead1  ;
	 wire [31:0] W_regRead2  ;
	 wire [31:0] W_ALURes    ;
	 wire [31:0] W_memRead   ;
	 wire [31:0] W_imm       ; 
	 
	 assign F_nextPc = freeze ? F_nowPc :
						    D_pcOp == 2'b01 && D_cmpRes ? D_nowPc + (D_imm << 2) + 4:
						    D_pcOp == 2'b10 && D_cmpRes ? {{4{1'b0}}, {D_instr[`index]}, {2{1'b0}}}:
						    D_pcOp == 2'b11 && D_cmpRes ? D_rsData : 
						    F_nowPc + 4;
	 
	 F_PC F_PC_instance(
	                    .clk   (clk)     ,
							  .reset (reset)   ,
							  .nextPc(F_nextPc),
							  .nowPc (F_nowPc) 
    );
	 
	 assign i_inst_addr = F_nowPc;
	 assign F_instr = i_inst_rdata;
	 
	 assign freeze =   (D_rsTuse == 2'b00 && E_Tnew == 2'b10 && D_instr[`rs] == E_fwAddr && D_instr[`rs] && E_regWE)
	                 ||(D_rsTuse == 2'b00 && E_Tnew == 2'b01 && D_instr[`rs] == E_fwAddr && D_instr[`rs] && E_regWE)
	                 ||(D_rsTuse == 2'b00 && M_Tnew == 2'b01 && D_instr[`rs] == M_fwAddr && D_instr[`rs] && M_regWE)
	                 ||(D_rsTuse == 2'b01 && E_Tnew == 2'b10 && D_instr[`rs] == E_fwAddr && D_instr[`rs] && E_regWE)
	                 ||(D_rtTuse == 2'b00 && E_Tnew == 2'b10 && D_instr[`rt] == E_fwAddr && D_instr[`rt] && E_regWE)
	                 ||(D_rtTuse == 2'b00 && E_Tnew == 2'b01 && D_instr[`rt] == E_fwAddr && D_instr[`rt] && E_regWE)
	                 ||(D_rtTuse == 2'b00 && M_Tnew == 2'b01 && D_instr[`rt] == M_fwAddr && D_instr[`rt] && M_regWE)
	                 ||(D_rtTuse == 2'b01 && E_Tnew == 2'b10 && D_instr[`rt] == E_fwAddr && D_instr[`rt] && E_regWE)
						  ||(D_MD && (E_busy || E_MDOp));
						  
	 D_Reg D_Reg_instance(
								 .clk     (clk)    , 
								 .reset   (reset)  , 
								 .freeze  (freeze) , 
								 .inInstr (F_instr),
								 .inPc    (F_nowPc),
								 .outInstr(D_instr),
								 .outPc   (D_nowPc)
	 );
								
	 D_CU D_CU_instance(
							  .op    (D_instr[`op]), 
							  .rb    (D_instr[`rb]), 
							  .pcOp  (D_pcOp)      ,			
							  .cmpOp (D_cmpOp)     , 
							  .extOp (D_extOp)     ,
							  .rtTuse(D_rtTuse)    , 
							  .rsTuse(D_rsTuse)    ,
							  .new   (D_new)       ,
							  .regWE (D_regWE)     ,
							  .MD    (D_MD)
    );
	 
	 assign D_imm = D_extOp ? {{16{D_instr[15]}}, D_instr[`imm]} : {{16{1'b0}}, D_instr[`imm]};
	 
	 DW_GRF DW_GRF_instance(
									.clk     (clk)         , 
									.reset   (reset)       , 
									.reg1    (D_instr[`rs]), 
									.reg2    (D_instr[`rt]),
									.regRead1(D_regRead1)  ,
									.regRead2(D_regRead2)  ,
									.pc      (W_nowPc)     , 
									.regAddr (W_fwAddr)    ,
									.regData (W_fwData)    , 
									.WE      (W_regWE)
	 );
	 
	 assign w_grf_we    = W_regWE ;
	 assign w_grf_addr  = W_fwAddr;
	 assign w_grf_wdata = W_fwData;
	 assign w_inst_addr = W_nowPc ;
	 
	 assign D_rsData = D_instr[`rs] == E_fwAddr && D_instr[`rs] && E_regWE && E_Tnew == 2'b00 ? E_fwData :
							 D_instr[`rs] == M_fwAddr && D_instr[`rs] && M_regWE && M_Tnew == 2'b00 ? M_fwData :
							 D_instr[`rs] == W_fwAddr && D_instr[`rs] && W_regWE && W_Tnew == 2'b00 ? W_fwData :
					  		 D_regRead1;
									
	 assign D_rtData = D_instr[`rt] == E_fwAddr && D_instr[`rt] && E_regWE && E_Tnew == 2'b00 ? E_fwData :
							 D_instr[`rt] == M_fwAddr && D_instr[`rt] && M_regWE && M_Tnew == 2'b00 ? M_fwData :
							 D_instr[`rt] == W_fwAddr && D_instr[`rt] && W_regWE && W_Tnew == 2'b00 ? W_fwData :
							 D_regRead2;
	 
	 D_Cmp D_Cmp_instance(
								 .cmpIn1(D_rsData),
								 .cmpIn2(D_rtData), 
								 .cmpOp (D_cmpOp) ,
								 .cmpRes(D_cmpRes)
	 );
	 
	 assign E_fwAddr = E_fwAddrOp == 2'b00 ? E_instr[`rd] :
							 E_fwAddrOp == 2'b01 ? E_instr[`rt] :
							 E_fwAddrOp == 2'b10 ? 5'b11111     :
							 5'b00000;
	 
	 assign E_fwData = E_nowPc + 8;
	 
	 E_Reg E_Reg_instance(
								 .clk        (clk)            	 ,
								 .reset      (reset || freeze)	 ,
								 .inInstr    (D_instr)       		 , 
								 .inPc       (D_nowPc)       		 , 
								 .inRegRead1 (D_rsData)           ,
								 .inRegRead2 (D_rtData)           , 
								 .inImm      (D_imm)              ,
								 .inRegWE    (D_regWE && D_cmpRes),
								 .outPc      (E_nowPc)				 ,
								 .outInstr   (E_instr)				 , 
								 .outRegRead1(E_regRead1)			 ,
								 .outRegRead2(E_regRead2)			 ,
								 .outImm     (E_imm)					 ,
								 .outRegWE   (E_regWE)
	 );
	 
	 E_CU E_CU_instance(
							  .op      (E_instr[`op]),
							  .rb      (E_instr[`rb]),
							  .ALUOp   (E_ALUOp)     , 
							  .ALUIn2Op(E_ALUIn2Op)  ,
							  .Tnew    (E_Tnew)      , 
							  .fwAddrOp(E_fwAddrOp)  , 
							  .fwDataOp(E_fwDataOp)  ,
							  .new     (E_new)       ,
							  .MDOp    (E_MDOp)      ,
							  .MDAddrOp(E_MDAddrOp)  ,
							  .MDWE    (E_MDWE)      ,
							  .resOp   (E_resOp)
	 );
	 
	 assign E_rsData = E_instr[`rs] == M_fwAddr && E_instr[`rs] && M_regWE && M_Tnew == 2'b00 ? M_fwData :
							 E_instr[`rs] == W_fwAddr && E_instr[`rs] && W_regWE && W_Tnew == 2'b00 ? W_fwData :
							 E_regRead1;
	 
	 assign E_rtData = E_instr[`rt] == M_fwAddr && E_instr[`rt] && M_regWE && M_Tnew == 2'b00 ? M_fwData :
							 E_instr[`rt] == W_fwAddr && E_instr[`rt] && W_regWE && W_Tnew == 2'b00 ? W_fwData :
							 E_regRead2;
	 
	 E_ALU E_ALU_instance(
	                      .ALUIn1(E_rsData)                     , 
								 .ALUIn2(E_ALUIn2Op ? E_imm : E_rtData), 
								 .ALUOp (E_ALUOp)                      , 
								 .ALURes(E_ALURes)
	 );	
		
	 E_MD E_MD_instance(
							  .clk     (clk)       ,
							  .reset   (reset)     ,
							  .MDOp    (E_MDOp)    ,
							  .MDIn1   (E_rsData)  , 
							  .MDIn2   (E_rtData)  ,
							  .busy    (E_busy)    ,
							  .WE      (E_MDWE)    ,
							  .MDAddrOp(E_MDAddrOp),
							  .MDRes   (E_MDRes)
	 );
		
	 assign M_fwAddr = M_fwAddrOp == 2'b00 ? M_instr[`rd] :
							 M_fwAddrOp == 2'b01 ? M_instr[`rt] :
							 M_fwAddrOp == 2'b10 ? 5'b11111     :
							 5'b00000;
	  
	 assign M_fwData = M_fwDataOp == 2'b00 ? M_ALURes    :
							 M_fwDataOp == 2'b10 ? M_nowPc + 8 : 
							 32'b0;
	
	 assign M_rsData = M_instr[`rs] == W_fwAddr && M_instr[`rs] && W_regWE && W_Tnew == 2'b00 ? W_fwData :
							 M_regRead1;
	 
	 assign M_rtData = M_instr[`rt] == W_fwAddr && M_instr[`rt] && W_regWE && W_Tnew == 2'b00 ? W_fwData :
							 M_regRead2;
							 
	 M_Reg M_Reg_instance(
	                      .clk        (clk)     						    , 
								 .reset      (reset)     				 		 ,
								 .inPc       (E_nowPc)   						 , 
								 .inInstr    (E_instr)   						 , 
								 .inALURes   (E_resOp ? E_MDRes : E_ALURes),
								 .inRegRead1 (E_rsData) 						 ,
								 .inRegRead2 (E_rtData)  						 ,
								 .inImm      (E_imm)     						 ,
								 .inRegWE    (E_regWE)   						 ,
								 .outPc      (M_nowPc)   						 ,
								 .outInstr   (M_instr)   						 ,  
								 .outALURes  (M_ALURes)  						 ,
								 .outRegRead1(M_regRead1)						 ,
								 .outRegRead2(M_regRead2)						 ,
								 .outImm     (M_imm)     						 ,
								 .outRegWE   (M_regWE)
	 );
	 
	 M_CU M_CU_instance(
	                    .op        (M_instr[`op]), 
							  .rb        (M_instr[`rb]), 
							  .fwAddrOp  (M_fwAddrOp)  , 
							  .fwDataOp  (M_fwDataOp)  ,
							  .Tnew      (M_Tnew)      ,
							  .new       (M_new)       ,
							  .memStoreOp(M_memStoreOp),
							  .memLoadOp (M_memLoadOp)
	 );
	 
	 M_SBE M_SBE_instance(
	                      .memStoreOp (M_memStoreOp) , 
								 .lowBit     (M_ALURes[1:0]), 
								 .data_byteen(m_data_byteen), 
								 .inMemData  (M_rtData)     ,
								 .outMemData (m_data_wdata)
	 );
	 
	 M_LBE M_LBE_instance(
	                      .lowBit    (M_ALURes[1:0]),
								 .memLoadOp (M_memLoadOp)  ,
								 .inMemData (m_data_rdata) ,
								 .outMemData(M_memRead)
	 ); 
	 
	 assign m_data_addr = M_ALURes;
	 assign m_inst_addr = M_nowPc ;
	 
	 assign W_fwAddr = W_fwAddrOp == 2'b00 ? W_instr[`rd] :
							 W_fwAddrOp == 2'b01 ? W_instr[`rt] :
							 W_fwAddrOp == 2'b10 ? 5'b11111     : 
							 5'b00000;
	 
	 assign W_fwData = W_fwDataOp == 2'b00 ? W_ALURes    :
							 W_fwDataOp == 2'b01 ? W_memRead   :
							 W_fwDataOp == 2'b10 ? W_nowPc + 8 :
							 32'b0;
	 
	 assign W_rsData = W_regRead1;
	 
	 assign W_rtData = W_regRead2;
	 
	 W_Reg W_Reg_instance(
								 .clk        (clk)       , 
								 .reset      (reset)     , 
								 .inInstr    (M_instr)   , 
								 .inPc       (M_nowPc)   , 
								 .inMemRead  (M_memRead) , 
								 .inALURes   (M_ALURes)  , 
								 .inRegWE    (M_regWE)   ,
								 .inRegRead1 (M_rsData)  ,
								 .inRegRead2 (M_rtData)  ,
								 .inImm      (M_imm)     ,
								 .outPc      (W_nowPc)   , 
								 .outInstr   (W_instr)   ,  
								 .outRegWE   (W_regWE)   ,
								 .outMemRead (W_memRead) , 
								 .outALURes  (W_ALURes)  ,
								 .outRegRead1(W_regRead1),
								 .outRegRead2(W_regRead2),
								 .outImm     (W_imm)
	 );
	 
	 W_CU W_CU_instance(
	                    .op      (W_instr[`op]),
							  .rb      (W_instr[`rb]), 
							  .fwAddrOp(W_fwAddrOp)  , 
							  .fwDataOp(W_fwDataOp)  , 
							  .Tnew    (W_Tnew)      ,
							  .new     (W_new) 
	 );
	 
endmodule

