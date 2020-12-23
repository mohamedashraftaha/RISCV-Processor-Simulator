/*******************************************************************
*
* Module: HazardDetectionUnit.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module tempts to solve load use hazards
*
* Change history: 05/03/20 - Implemented the Hazard detection unit unit module
*                          
*                 
*                   
**********************************************************************/
`timescale 1ns / 1ps



module HazardDetectionUnit(input [4:0]IFID_Rs1, IFID_Rs2, IDEX_Rd, input IDEX_Memread, output reg stall);

always @(*)
begin
    if (((IFID_Rs1==IDEX_Rd )||(IFID_Rs2==IDEX_Rd))&& (IDEX_Memread==1)&&(IDEX_Rd!=0))
    stall=1;
    else
    stall=0;

end
endmodule
