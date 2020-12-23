/*******************************************************************
*
* Module: Clock_Divider.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module is used as a method to delay our stages so that it could be 2 instructions per cycle
*
* Change history: 04/29/20    - Implemented the clock divider
*                          
*                
**********************************************************************/
`timescale 1ns / 1ps
module Clk_divider( input clk ,rst, output reg out_clk );
always @(posedge clk)
begin
if (~rst)
     out_clk <= 1'b0;
else
     out_clk <= ~out_clk;	
end

always @(*)
begin
if(clk==0 && rst==0)
out_clk=0;
end

endmodule



