/*******************************************************************
*
* Module:Register.v
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
// Create Date: 02/18/2020 12:21:00 PM
// Design Name: 
// Module Name: Register
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


module Register #(parameter n=32) 
(
input [n-1:0] D,
input clk,  
input  load,
input rst,
output [n-1:0] Q);
wire [n-1:0] F;

genvar i;
generate
 for (i=0; i<n; i=i+1)
          begin: gen1
          n_bit_2x1Mux #(1) a(D[i],Q[i],load,F[i]);
          DFlipFlop b(clk, rst, F[i],Q[i]);
          end
  endgenerate
endmodule
