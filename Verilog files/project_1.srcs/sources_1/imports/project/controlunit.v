/*******************************************************************
*
* Module: controlunit.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module specifies the control signals based on the opcode of each instrucion
*
* Change history: 04/21/20 - Added Immediates opcode and specified the control signals
*                 04/22/20 - Added ecall opcode and specified the control signals
*                           - Added custom Fence and FecneI Opcode and specified the control signals
*                           - Added LUI instruction opcode and specified its control signals
*                           - Added AUIPC instruction opcode and specified its control signals 
*                           - increased the number of bits of the opcode to be 3 bits instead of two bits
**********************************************************************/
`timescale 1ns / 1ps
`include "defines.v"
module controlunit(input [6:2] InstOp, output reg branch,memread,memtoReg,output reg[2:0]ALUop, output reg MemWrite,ALUsrc, RegWrite,Jal_R,AUIPC );

// ALUop 3 bits -> 7 combinations-> more instructions
// we have (OLD -> 2bits)
// 10 -> arithmetic R                            ->
// 00 -> lw/sw// jal/ jalr/ auipc
// 01 -> BEQ
// 11 -> immediates/ecall/ fence/ fenceI

// 3bits
// 010 ? 2 in decimal -> Arithmetic R
// 000 ? 0 in decimal ? lw/sw/jal/jalr/ auipc
// 001 ? 1 in decimal ? BEQ
// 011 ? 3 in decimal ? immediates //ecall/ fence/ fenceI
//#ADDED
// 100 ? 4 in decimal ? LUI

//Not used
// 101 ? 5 in decimal
// 110 ? 6 in decimal
// 111 ? 7 in decimal
always @(*)
    begin
        case (InstOp) //add //sub //and //or //Kol el R format
        `OPCODE_Arith_R:begin
        branch=0;
        memread=0;
        memtoReg=0;
        ALUop=3'b010;
        MemWrite=0;
        ALUsrc=0;
        RegWrite=1;
        Jal_R=0;
        AUIPC=0;
        end
        `OPCODE_Load:begin //LW // I format
        branch=0;
        memread=1;
        memtoReg=1;
        ALUop=3'b000;
        MemWrite=0;
        ALUsrc=1;
        RegWrite=1;
        Jal_R=0;
        AUIPC=0;
        end
        
        `OPCODE_Store: begin //SW // S-format
        branch=0;
        memread=0;
        memtoReg=0;
        ALUop=3'b000;
        MemWrite=1;
        ALUsrc=1;
        RegWrite=0;
        Jal_R=0;
        AUIPC=0;
        end
        
       `OPCODE_Branch:    begin //BEQ // SB- format
        branch=1;
        memread=0;
        memtoReg=0;
        ALUop=3'b001;
        MemWrite=0;
        ALUsrc=0;
        RegWrite=0;
        Jal_R=0;
        AUIPC=0;       
        end
        
        
         `OPCODE_Arith_I:    begin // Immediates 
         branch=0;
         memread=0;
         memtoReg=0;
         ALUop=3'b011;
         MemWrite=0;
         ALUsrc=1;
         RegWrite=1;
         Jal_R=0;
         AUIPC=0;        
          end
             
        `OPCODE_SYSTEM: //ecall //csr as nop
         begin  
         branch=0;
         memread=0;
         memtoReg=0;
         ALUop=3'b011;
         MemWrite=0;
         ALUsrc=0;
         RegWrite=0;
         Jal_R=0;
         AUIPC=0;
         end
              5'b00011: //Fence and Fence i
                  begin  
         branch=0;
         memread=0;
         memtoReg=0;
         ALUop=3'b011;
         MemWrite=0;
         ALUsrc=0;
         RegWrite=0;
         Jal_R=0;
         AUIPC=0;
                  end
         `OPCODE_JAL:
         begin  
         branch=0;
         memread=0;
         memtoReg=0;
         ALUop=3'b000;
         MemWrite=0;
         ALUsrc=1;
         RegWrite=1;
         Jal_R=1;
         AUIPC=0;
           end
  
           `OPCODE_JALR:
            begin  
          branch=0;
          memread=0;
          memtoReg=0;
          ALUop=3'b000;
          MemWrite=0;
          ALUsrc=1;
          RegWrite=1;
          Jal_R=1;
          AUIPC=0;
             end
         `OPCODE_AUIPC:
            begin  
          branch=0;
          memread=0;
          memtoReg=0;
          ALUop=3'b000;
          MemWrite=0;
          ALUsrc=0;
          RegWrite=1;
          Jal_R=0;
          AUIPC=1;
            end
           
         `OPCODE_LUI:
               begin  
             branch=0;
             memread=0;
             memtoReg=0;
             ALUop=3'b100;
             MemWrite=0;
             ALUsrc=1;
             RegWrite=1;
             Jal_R=0;
             AUIPC=0;
               end
            
         
                     
               
         
        default :  //nothing 
        begin  
        branch=0;
        memread=0;
        memtoReg=0;
        ALUop=3'b000;
        MemWrite=0;
        ALUsrc=0;
        RegWrite=0;
           Jal_R=0;
             AUIPC=0;
end
        endcase
    
    
    
    end
endmodule