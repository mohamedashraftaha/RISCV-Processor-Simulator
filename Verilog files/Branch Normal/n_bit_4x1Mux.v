/*******************************************************************
*
* Module:n_bit_4x1Mux.v
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
// Create Date: 04/09/2020 10:03:15 PM
// Design Name: 
// Module Name: n_bit_4x1Mux
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


module n_bit_4x1Mux  #(parameter N=32)(input [N-1:0]A,[N-1:0]B, [N-1:0]C,[N-1:0]D,input[1:0] Sel , output reg [N-1:0]Y);
//assign Y= Sel? A: B;

always @(*)
begin 
if (Sel==2'b00)
Y=A;
else if (Sel==2'b01)
Y=B;
else if (Sel==2'b10)
Y=C;
else
Y=D;

end
endmodule