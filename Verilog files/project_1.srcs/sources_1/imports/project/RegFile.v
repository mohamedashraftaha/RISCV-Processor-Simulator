/*******************************************************************
*
* Module:RegFile.v
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
// Create Date: 02/25/2020 01:18:13 PM
// Design Name: 
// Module Name: RegFile
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

//module Register #(parameter n=8) 
//(
//input [n-1:0] D,
//input clk,  
//input load,
//input rst,
//output [n-1:0] Q);

module  RegFile #(parameter N=32)(
     input [4:0] RAddr1, //input [N-1:0] RAddr1,
     input [4:0] RAddr2,//input [N-1:0] RAddr2,
     input [N-1:0] WriteData,
     input clk ,
     input rst,
     input RegWrite_Signal,
     input [4:0] WAddr,
     output  [N-1:0]  out0, 
     output  [N-1:0]  out1
 );
 reg [N-1:0]load;
 wire [N-1:0] q [N-1:0];

///READ PART
 genvar i;
 generate  
    for (i=0; i<N;i=i+1)
        begin: gen
        Register #(N)w(WriteData,clk,load[i],rst,q[i]); 
        end
 endgenerate
 assign out0=q[RAddr1];
 assign out1=q[RAddr2];
 
// always@(*)
//    begin
//        case(RAddr1)
//        5'b00000:out0=q[0];
//        5'b00001:out0=q[1];
//        5'b00010:out0=q[2];
//        5'b00011:out0=q[3];
//        5'b00100:out0=q[4];
//        5'b00101:out0=q[5]; 
//        5'b00110:out0=q[6];
//        5'b00111:out0=q[7];
//        5'b01000:out0=q[8];
//        5'b01001:out0=q[9];
//        5'b01010:out0=q[10];
//        5'b01011:out0=q[11];
//        5'b01100:out0=q[12];   
//        5'b01101:out0=q[13];
//        5'b01110:out0=q[14];
//        5'b01111:out0=q[15];
//        5'b10000:out0=q[16];
//        5'b10001:out0=q[17];
//        5'b10010:out0=q[18];
//        5'b10011:out0=q[19];
//        5'b10100:out0=q[20];
//        5'b10101:out0=q[21];
//        5'b10110:out0=q[22];
//        5'b10111:out0=q[23];
//        5'b11000:out0=q[24];
//        5'b11001:out0=q[25];
//        5'b11010:out0=q[26];
//        5'b11011:out0=q[27];
//        5'b11100:out0=q[28];
//        5'b11101:out0=q[29];
//        5'b11110:out0=q[30];
//        5'b11110:out0=q[31];
//        default:out0=0;         
//        endcase 
//    end
    
//    always@(*)
//        begin
//            case(RAddr2)
//            5'b00000:out1=q[0];
//            5'b00001:out1=q[1];
//            5'b00010:out1=q[2];
//            5'b00011:out1=q[3];
//            5'b00100:out1=q[4];
//            5'b00101:out1=q[5]; 
//            5'b00110:out1=q[6];
//            5'b00111:out1=q[7];
//            5'b01000:out1=q[8];
//            5'b01001:out1=q[9];
//            5'b01010:out1=q[10];
//            5'b01011:out1=q[11];
//            5'b01100:out1=q[12];   
//            5'b01101:out1=q[13];
//            5'b01110:out1=q[14];
//            5'b01111:out1=q[15];
//            5'b10000:out1=q[16];
//            5'b10001:out1=q[17];
//            5'b10010:out1=q[18];
//            5'b10011:out1=q[19];
//            5'b10100:out1=q[20];
//            5'b10101:out1=q[21];
//            5'b10110:out1=q[22];
//            5'b10111:out1=q[23];
//            5'b11000:out1=q[24];
//            5'b11001:out1=q[25];
//            5'b11010:out1=q[26];
//            5'b11011:out1=q[27];
//            5'b11100:out1=q[28];
//            5'b11101:out1=q[29];
//            5'b11110:out1=q[30];
//            5'b11110:out1=q[31];  
//        default:out1=0;         
//            endcase 
//        end
        
        //WRITE
        always@(*)
        begin
       if(RegWrite_Signal==1)
       begin
       load=0;
                    case(WAddr)
                    5'b00000:load[0]= 1'b0;
                    5'b00001:load[1]= 1'b1;
                    5'b00010:load[2]= 1'b1;
                    5'b00011:load[3]= 1'b1;
                    5'b00100:load[4]= 1'b1;
                    5'b00101:load[5]= 1'b1;
                    5'b00110:load[6]= 1'b1;
                    5'b00111:load[7]= 1'b1;
                    5'b01000:load[8]= 1'b1;
                    5'b01001:load[9]= 1'b1;
                    5'b01010:load[10]=1'b1;
                    5'b01011:load[11]=1'b1;
                    5'b01100:load[12]=1'b1;
                    5'b01101:load[13]=1'b1;
                    5'b01110:load[14]=1'b1;
                    5'b01111:load[15]=1'b1;
                    5'b10000:load[16]=1'b1;
                    5'b10001:load[17]=1'b1;
                    5'b10010:load[18]=1'b1;
                    5'b10011:load[19]=1'b1;
                    5'b10100:load[20]=1'b1;
                    5'b10101:load[21]=1'b1;
                    5'b10110:load[22]=1'b1;
                    5'b10111:load[23]=1'b1;
                    5'b11000:load[24]=1'b1;
                    5'b11001:load[25]=1'b1;
                    5'b11010:load[26]=1'b1;
                    5'b11011:load[27]=1'b1;
                    5'b11100:load[28]=1'b1;
                    5'b11101:load[29]=1'b1;
                    5'b11110:load[30]=1'b1;
                    5'b11110:load[31]=1'b1;      
                    endcase 
                end
        else load=0;
        end
 endmodule