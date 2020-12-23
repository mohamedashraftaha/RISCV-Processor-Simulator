/*******************************************************************
*
* Module: ALU_Control_unit.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module produces the selection signals by which the ALU can operate or do specific operation according to the signal sent
*
* Change history: 04/21/20 - case on the custom aluop assigned for the immediates
*                          - sent out the signals according to the ALUop and function3 of each operation
*                 04/22/20 - added a case for LUI opcode to send out the selection as ALU_PASS which sends the second input as the result
*                          - added bit 25 as a new input to the module to be able to differentiate between add, sub,... and MUL, DIV,... since they differ in bit 25
**********************************************************************/
`timescale 1ns / 1ps
`include "defines.v"
module ALU_Control_unit(input [2:0]ALUOp, input Bit30, input Bit25, input [2:0] Fun3, output reg [3:0] ALUsel );
   // need 3 special selection lines for ? mul, div, REM
   // so far we have
   // 0000 ? (0)10 ? add//0
   // 0001 ? (1)10 ? Sub//1
   // 0101 ? (5)10 ? AND
   // 0100 ? (4)10 ? OR
   // 0111 ? (7)10 ? XOR
   // 1000 ? (8)10 ? SRL
   // 1001 ? (9)10 ? SLL
   // 1010 ? (10)10 ? SRA
   // 1101 ? (13)10 ?SLT
   // 1111 ? (15)10 ?SLTU
   // 0011 ?  (3)10 ? PASS
   
// Available to use
// 4'b0010 -(2)- ALU_MUL
// 4'b0110 ?(6) -ALU_DIV
// 4'b1011 ? (11)ALU_REM
// 4'b0111 ?
   //AVAILABLE TO USE 
   
   wire [3:0] inst={Bit30,Fun3};
    always @(*)
        begin
            case (ALUOp)
            3'b000: ALUsel=`ALU_ADD; //SW/LW/ JAL/ JALR/ AUIPC
            //________________________________________________
            3'b001: ALUsel= `ALU_SUB;  // BEQ/BNE/ BLT/ BLTU/ BGE/BGEU    
            //_________________________________________________
            3'b010: // Arithmetic_R
                    begin
                    if (Bit25==0)
                    begin
                            case(inst)
                            4'b0000:ALUsel=`ALU_ADD; // ADD
                            4'b1000:ALUsel=`ALU_SUB; // SUB
                            4'b0111:ALUsel=`ALU_AND; // AND
                            4'b0110:ALUsel=`ALU_OR; // OR
                            4'b0100:ALUsel=`ALU_XOR; // XOR
                            4'b0101:ALUsel=`ALU_SRL; //SRL
                            4'b0001:ALUsel=`ALU_SLL; //SLL
                            4'b1101:ALUsel=`ALU_SRA; //SRA
                            4'b0010:ALUsel=`ALU_SLT; //SLT
                            4'b0011:ALUsel=`ALU_SLTU; //SLTU
                            default:ALUsel=0;
                            endcase
                        end
                        else if (Bit25==1)
                            begin
                                case (Fun3)
                                3'b000: ALUsel= `ALU_MUL; //MUL
                                3'b001: ALUsel= `ALU_MUL; //MULH
                                3'b010: ALUsel= `ALU_MUL; //MULHSU
                                3'b011: ALUsel= `ALU_MUL; //MULHU                                
                                3'b100: ALUsel= `ALU_DIV; //DIV
                                3'b101: ALUsel= `ALU_DIV; //DIVU
                                3'b110: ALUsel = `ALU_REM; // REM
                                3'b111: ALUsel = `ALU_REM; // REMU
                                endcase
                            
                            end
                        
                        
                        
                    end
                    //___________________________________________________
               3'b011: //#special opcode for Immediates// ecall/ fence// fencei 
                    begin 
                    // IMMEDIATES
                           case(Fun3)
                    3'b000: ALUsel=`ALU_ADD; //ADDI
                    3'b010: ALUsel=`ALU_SLT; //SLTI
                    3'b011: ALUsel=`ALU_SLTU; //SLTIU
                    3'b100:ALUsel= `ALU_XOR;//XORI
                    3'b110:ALUsel= `ALU_OR; //ORI
                    3'b111:ALUsel= `ALU_AND; //ANDI
                    endcase
                    // Shifting
                    case(inst)
                    4'b0001:ALUsel=`ALU_SLL; // SLLI
                    4'b0101:ALUsel=`ALU_SRL; // SRLI
                    4'b1101:ALUsel=`ALU_SRA; // SRAI
              
                   endcase
                    end
                    //____________________________________________
               //#Special opcode for LUI
               3'b100:ALUsel=`ALU_PASS; // LUI   

            default:ALUsel=0;
        
            
            
            endcase
        
        
        
        
        
        
        end
endmodule

