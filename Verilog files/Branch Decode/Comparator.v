`timescale 1ns / 1ps

/*******************************************************************
*
* Module: Comparator.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module is used in the process of knowing the branch outcome early in the decode stage
*
* Change history: 05/10/20 - Implemented the module

*               
**********************************************************************/


module Comparator(input [31:0] RD1,RD2, input branch_signal, input [2:0] Function3, output branch_flag); 
reg beq, bne, blt,bge, bltu,bgeu;

always @(*)
begin
if (branch_signal==1)
begin
    case (Function3)
            3'b000: begin if ($signed(RD1)==$signed(RD2)) begin beq=1; bne=0; blt=0; bge=0; bltu=0; bgeu=0;end end// beq
            3'b001: begin  if ($signed(RD1)!= $signed(RD2)) begin beq=0; bne=1; blt=0; bge=0; bltu=0; bgeu=0;end end//bne
            3'b100: begin  if ($signed(RD1)<$signed(RD2)) begin beq=0; bne=0; blt=1; bge=0; bltu=0; bgeu=0;end end//blt
            3'b101: begin  if ($signed(RD1)>$signed(RD2)) begin beq=0; bne=0; blt=0; bge=1; bltu=0; bgeu=0;end end//bge
            3'b110: begin  if (RD1<RD2) begin beq=0; bne=0; blt=0; bge=0; bltu=1; bgeu=0;end end //bltu
            3'b111: begin  if (RD1>RD2) begin beq=0; bne=0; blt=0; bge=0; bltu=0; bgeu=1;end end//bgeu
            default: begin beq=0; bne=0; blt=0; bge=0; bltu=0; bgeu=0; end
            
     endcase
end
 else
     begin
     beq=0; bne=0; blt=0; bge=0; bltu=0; bgeu=0;
     end

     
     
 end
assign branch_flag= (beq || bne || blt || bge || bltu || bgeu); 


endmodule
