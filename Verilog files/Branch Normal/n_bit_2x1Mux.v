/*******************************************************************
*
* Module:n_bit_2x1Mux.v
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
// Create Date: 02/18/2020 12:17:22 PM
// Design Name: 
// Module Name: n_bit_2x1Mux
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


module n_bit_2x1Mux  #(parameter N=32)(input [N-1:0]A,[N-1:0]B,input Sel , output reg [N-1:0]Y);
//assign Y= Sel? A: B;

always @(*)
begin 
if (Sel)
Y<=A;
else 
Y<=B;

end
endmodule
