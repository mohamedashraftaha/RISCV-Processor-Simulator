
/*******************************************************************
*
* Module: Full_datapath.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module connects all other modules together to formour pipleined processor
*
* Change history: 04/23/20 - Implementing the module, bringing all modules together to form the single cycle processor
*                          -Implement multiplexers for JAL/JALR/AUIPC and ECALL
*                 04/29/20 - Implemented the module as pipelined and combined memory
*                 03/05/20 - Fixed some bugs of forwarding
-                 04/05/20 - Fixed some bugs in the hazard detection unit
-                 07/05/20 - There was a problem in the clock that we fixed using an assign statement by making memory out = nop when data mem is in use
-                 09/05/20 - Fixed ecall, since its mechanism was interrupted after fixing all the abovr bugs
*                 10/05/20 / FIxed error with the output of the hazard mux -> it was one bit
-                 10/05/20- The full data_ path module is complete and fully functioning 
**********************************************************************/
`timescale 1ns / 1ps
`include "defines.v"
module Full_datapath(input CLK, RST);
wire [31:0] PC_IN;
wire [31:0]WriteData;
wire clk_slow_out;
wire load;
assign load=1;
wire load_pc;
wire Pcsrc;
wire [6:0]outEXstageMUX;
wire [31:0] PC_OUT;
wire branch, memread,memtoReg,MemWrite,ALUsrc,RegWrite,Jal_R,AUIPC; 
wire [2:0] ALUop; //  conrol signal now -> 11 bits
wire [31:0] RD1;
reg load_if_id;
wire [31:0] RD2;
wire [31:0] Generator_out;
wire [31:0] ALUinp2;
wire [3:0] ALUSel;
wire [31:0] ALUOUT;
wire STALL;
wire [10:0]hazard_mux_out;
wire flush;
wire [31:0] ShiftLeft_Out;
wire [31:0] ADDER_OUT;
wire [31:0] PCplus4;
wire ANDresult;
reg ecall_sel;
wire [31:0]PCPLUS4_or0_out_MUX;
wire Flag_AND_inp2;
wire [31:0] WD_MUX_OUT;
wire [31:0] Address;
wire [31:0] Memory_Out;
wire [1:0] f1;
wire [1:0]f2;
wire [31:0] outF1Mux;
wire [31:0] outF2Mux;
assign Pcsrc= ANDresult?1:0;

always @(posedge CLK)
begin
if (flush==1)
load_if_id=0;
else
load_if_id=1;
//assign load_if_id=flush?0:1;

end
//IFID
wire [63:0] IF_ID_out;
wire [63:0]IF_ID;
wire [31:0]IF_ID_Pc;
wire [31:0]IF_ID_Dataout; 
wire [31:0] outIF_ID_Pc;
wire [31:0] outIF_ID_Dataout;

assign IF_ID_Pc=PC_OUT;
assign IF_ID_Dataout=!clk_slow_out? 32'b0000000_00000_00000_000_00000_0110011   : Memory_Out;  
assign IF_ID={IF_ID_Pc,IF_ID_Dataout};

assign {outIF_ID_Pc,outIF_ID_Dataout}=IF_ID_out;

Register #(64) IFID(IF_ID,CLK,load_if_id,~RST,IF_ID_out);

wire [159:0]ID_EX;
wire [159:0] ID_EX_out;
wire [10:0] ID_Ex_control_signals;//11
wire [31:0] ID_EX_PC;//32
wire [31:0] ID_EX_RegFile_out0;//32
wire [31:0] ID_EX_RegFile_out1;//32
wire [31:0] ID_EX_genOut;//32

wire [4:0] ID_EX_Instruction;//5
wire [4:0] ID_EX_shamt_RS2_24_20;//5
wire [4:0] ID_EX_RS1_19_15;//5
wire [4:0] ID_EX_Instruction1;//5
wire [10:0] outID_Ex_control_signals;
 wire [31:0] outID_EX_PC;
 wire [31:0] outID_EX_RegFile_out0;
 wire [31:0] outID_EX_RegFile_out1;
 wire [31:0] outID_EX_genOut;
wire [4:0] outID_EX_Instruction;
wire [4:0] outID_EX_shamt_RS2_24_20; // used for shift amount and forwarding
wire [4:0] outID_EX_RS1_19_15; // forwarding
wire [4:0] outID_EX_Instruction1;


assign ID_EX_shamt_RS2_24_20=outIF_ID_Dataout[`IR_rs2];
assign ID_EX_RS1_19_15=outIF_ID_Dataout[`IR_rs1];

assign ID_Ex_control_signals=hazard_mux_out;
//assign ID_Ex_control_signals={AUIPC,Jal_R,RegWrite,memtoReg,branch,memread,MemWrite,ALUop,
// ALUsrc};
 assign ID_EX_PC=outIF_ID_Pc;


assign ID_EX_RegFile_out0= RD1;
assign ID_EX_RegFile_out1= RD2;

assign ID_EX_genOut= Generator_out;

assign ID_EX_Instruction={outIF_ID_Dataout[30],outIF_ID_Dataout[25],outIF_ID_Dataout[14:12]};


assign ID_EX_Instruction1=outIF_ID_Dataout[11:7];

  assign  ID_EX={ID_EX_RS1_19_15,ID_EX_shamt_RS2_24_20,ID_Ex_control_signals,ID_EX_PC,ID_EX_RegFile_out0,
  ID_EX_RegFile_out1,ID_EX_genOut,ID_EX_Instruction,ID_EX_Instruction1};

  
  assign {outID_EX_RS1_19_15,outID_EX_shamt_RS2_24_20,outID_Ex_control_signals,outID_EX_PC,outID_EX_RegFile_out0,
    outID_EX_RegFile_out1,outID_EX_genOut,outID_EX_Instruction,outID_EX_Instruction1}=ID_EX_out;
    
Register #(160)IDEX(ID_EX,CLK,load,~RST,ID_EX_out);




//EXMEM
wire [111:0] EX_MEM;
wire [6:0] Ex_Mem_control_signals;
wire [31:0] Ex_Mem_adder;
wire Ex_Mem_zeroflag;
wire [31:0] Ex_Mem_ALUresult;
wire [31:0] Ex_Mem_RegFile_out1;
wire [4:0]Ex_Mem_Instruction1;

wire [111:0] EX_MEM_Out;

wire [2:0] EX_MEM_Func3;

wire [2:0] outEX_MEM_Func3;

wire [6:0]outEx_Mem_control_signals;
wire [31:0] outEx_Mem_adder;
wire outEx_Mem_zeroflag;
wire [31:0] outEx_Mem_ALUresult;
wire [31:0] outEx_Mem_RegFile_out1;
wire [4:0]outEx_Mem_Instruction1;

//EX/MEM


assign EX_MEM_Func3=outID_EX_Instruction[2:0];
assign Ex_Mem_control_signals= outEXstageMUX;
//assign Ex_Mem_control_signals= outID_Ex_control_signals[10:4];

assign Ex_Mem_adder=ADDER_OUT;

assign Ex_Mem_zeroflag=Flag_AND_inp2;

assign Ex_Mem_ALUresult=ALUOUT;

assign Ex_Mem_RegFile_out1=outID_EX_RegFile_out1;

assign Ex_Mem_Instruction1=outID_EX_Instruction1;

assign EX_MEM= {EX_MEM_Func3,Ex_Mem_control_signals,Ex_Mem_adder,Ex_Mem_zeroflag,Ex_Mem_ALUresult
,outF2Mux,Ex_Mem_Instruction1};

assign  {outEX_MEM_Func3,outEx_Mem_control_signals
,outEx_Mem_adder,outEx_Mem_zeroflag,outEx_Mem_ALUresult
,outEx_Mem_RegFile_out1,outEx_Mem_Instruction1}=EX_MEM_Out;

Register #(112) EXMEM(EX_MEM,CLK,load,~RST,EX_MEM_Out);
//MEM/WB

wire [72:0] MEM_WB;
wire [3:0] Mem_Wb_control_signals;
wire [31:0] Mem_WB_dataout;
wire [31:0] Mem_WB_ALuresult;
wire [4:0] Mem_Wb_Instruction1;
wire [72:0] MEM_WB_out;

wire [3:0] outMem_Wb_control_signals;
wire [31:0] outMem_WB_dataout;
wire [31:0] outMem_WB_ALuresult;
wire [4:0] outMem_Wb_Instruction1;

//MEM/WB

assign Mem_Wb_control_signals=outEx_Mem_control_signals[6:3];

assign Mem_WB_dataout=Memory_Out;

assign Mem_WB_ALuresult=outEx_Mem_ALUresult;

assign Mem_Wb_Instruction1=outEx_Mem_Instruction1;

assign MEM_WB={Mem_Wb_control_signals,Mem_WB_dataout,Mem_WB_ALuresult,Mem_Wb_Instruction1};

assign {outMem_Wb_control_signals,outMem_WB_dataout,outMem_WB_ALuresult,outMem_Wb_Instruction1}=MEM_WB_out;

Register#(73) MEMWB(MEM_WB,CLK,load,~RST,MEM_WB_out);

always@(negedge clk_slow_out)

begin
if(Memory_Out[`IR_opcode] == `OPCODE_SYSTEM && Memory_Out[`IR_funct3]==3'b000 )//ecall
begin
ecall_sel=0;
end
else
ecall_sel=1;
end

assign flush=  STALL | Pcsrc;


assign load_pc=STALL?0:1;


Clk_divider Clock_Divider( CLK ,RST,clk_slow_out );

Register  PC (PC_IN,clk_slow_out ,load_pc,~RST,PC_OUT);

n_bit_2x1Mux #(32) IM_DM_MUX(PC_OUT , outEx_Mem_ALUresult, clk_slow_out, Address );

Memory SingleMem(clk_slow_out,CLK,outEx_Mem_control_signals[1], outEx_Mem_control_signals[0],outEX_MEM_Func3
, Address, outEx_Mem_RegFile_out1, Memory_Out );

controlunit ControlUnit(outIF_ID_Dataout[`IR_opcode],branch, memread,memtoReg, ALUop, MemWrite
,ALUsrc,RegWrite,Jal_R,AUIPC);

//AUIPC,Jal_R,RegWrite,memtoReg,branch,memread,MemWrite,ALUop,
//// ALUsrc
n_bit_4x1Mux Jal_WD_PC4_MUX(WriteData,outEx_Mem_adder,PCplus4,0, 
{outMem_Wb_control_signals[2],outMem_Wb_control_signals[3]},WD_MUX_OUT);

n_bit_4x1Mux JALR_PC4_B_MUX(PCplus4,outEx_Mem_adder,outEx_Mem_ALUresult,0,{outEx_Mem_control_signals[5],ANDresult}
,PC_IN);

RegFile RegisterFile(outIF_ID_Dataout[`IR_rs1],outIF_ID_Dataout[`IR_rs2],WD_MUX_OUT,~CLK,~RST
,outMem_Wb_control_signals[1],  outMem_Wb_Instruction1  , RD1,RD2);

rv32_ImmGen ImmediateGenerator( outIF_ID_Dataout,Generator_out);

n_bit_2x1Mux ALU_Mux(outID_EX_genOut,outF2Mux, outID_Ex_control_signals[0],ALUinp2);

ALU_Control_unit ALU_Control_Unit(outID_Ex_control_signals[3:1],outID_EX_Instruction[4]
,outID_EX_Instruction[3],outID_EX_Instruction[2:0],ALUSel);


prv32_ALU ALU(outF1Mux,ALUinp2,outID_EX_genOut[4:0],outID_EX_Instruction[2:0]
,ALUOUT,ALUSel, Flag_AND_inp2);


n_bit_2x1Mux DataMemoryMux(outMem_WB_dataout, outMem_WB_ALuresult,outMem_Wb_control_signals[0], WriteData);

Shift_Left ShiftL(outID_EX_genOut,ShiftLeft_Out);

n_bit_2x1Mux Ecall_MUX(32'd4,32'd0,ecall_sel,PCPLUS4_or0_out_MUX);

assign ADDER_OUT= outID_EX_PC+ShiftLeft_Out;

assign PCplus4 = PC_OUT+PCPLUS4_or0_out_MUX;

			
assign ANDresult= outEx_Mem_control_signals[2] & outEx_Mem_zeroflag; 

forwarding_unit ForwardingUnit(outID_EX_RS1_19_15,outID_EX_shamt_RS2_24_20,outEx_Mem_Instruction1
,outMem_Wb_Instruction1,outEx_Mem_control_signals[4],outMem_Wb_control_signals[1],f1,f2);

n_bit_4x1Mux   ForwardA(outID_EX_RegFile_out0,WriteData,outEx_Mem_ALUresult,0,f1,outF1Mux);
n_bit_4x1Mux   ForwardB(outID_EX_RegFile_out1,WriteData,outEx_Mem_ALUresult,0,f2,outF2Mux);

n_bit_2x1Mux #(11) Hazard_mux( 0,{AUIPC,Jal_R,RegWrite,memtoReg,branch,memread,MemWrite,ALUop, ALUsrc},flush,hazard_mux_out);

HazardDetectionUnit  Hazard_detection_unit(IF_ID_out[19:15],IF_ID_out[24:20],outID_EX_Instruction1,outID_Ex_control_signals[5],STALL);

n_bit_2x1Mux #(8) ExecuteStageMux(0,outID_Ex_control_signals[10:4],Pcsrc,outEXstageMUX);

endmodule





