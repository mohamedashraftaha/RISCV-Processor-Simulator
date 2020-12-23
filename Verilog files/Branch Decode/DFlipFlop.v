/*******************************************************************
*
* Module:DFlipFlop.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
*
* Change history:Done in the lab - CSCE3302
*                 - No additional modifications in this MS of the project
*                
*
**********************************************************************/
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2020 12:16:16 PM
// Design Name: 
// Module Name: DFlipFlop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DFlipFlop (input clk, input rst, input D, output reg Q);
 always @ (posedge clk or posedge rst)
 if (rst) begin
 Q <= 1'b0;
 end else begin
 Q <= D;
 end
endmodule 

