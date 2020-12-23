/*******************************************************************
*
* Module: shifter.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module is for different shift instructions such as SLL, SRL and SRA
*
* Change history: 04/21/20 - Implementing SLL, SRL and SRA instructions
*                
*
**********************************************************************/
`timescale 1ns / 1ps
module shifter  (input [31:0]in, input [4:0]Shift_Amount,input [1:0]Alufun,output reg [31:0]  out);
always@(*)
begin
case(Alufun)
2'b00: out= in>>Shift_Amount;
2'b01: out= in<<Shift_Amount;
2'b10:out =$signed(in)>>>Shift_Amount;

//  11111111111101 >>>  01111111110
default:
out=0;
endcase
end
endmodule
