/*******************************************************************
*
* Module: ForwardingUnit_BranchDecode.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module tempts to solve hazards of moving the branch target to the decode stage
*
* Change history: 05/03/20 - Implemented the forwarding unit module
*                          
*                 
*                   
**********************************************************************/
//add x4,x3,x2

//beq x4,
`timescale 1ns / 1ps
module ForwardingUnit_BranchDecode(input [4:0] Rs1,[4:0] Rs2,[4:0]Ex_mem_RegistarRd,
input exmem_Regwrite, input branchSignal,output reg f1,reg f2 );

always@(*)
begin
if(branchSignal==1)begin
if(exmem_Regwrite==1 && Ex_mem_RegistarRd!=0 && Ex_mem_RegistarRd==Rs1 )
f1=1'b1;
else 
f1=1'b0;


 if(exmem_Regwrite==1 && Ex_mem_RegistarRd!=0 && Ex_mem_RegistarRd==Rs2 )
f2=1'b1;
 else 
 f2=1'b0;

end
else
f1=1'b0;
f2=1'b0;

end
endmodule
