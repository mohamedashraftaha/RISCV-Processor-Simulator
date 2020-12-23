/*******************************************************************
*
* Module: prv32_ALU.v
* Project: CSCE330_TermProject_MO
* Author: Mohamed Ashraf Taha - mohammedashraf@aucegypt.edu
          Omar Sherif Mahdy - omarmahdy122@aucegypt.edu
* Description: This module controls the operations done inside the ALU
*
* Change history: 04/21/20 - Implementing branch instructions
*                 04/22/20 - Implementing the Multiplication, Division and Remainder Instructions
*
**********************************************************************/
module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,
	input  wire [2:0] Function3,
	output  reg  [31:0] r,
	input   wire [3:0]  alufn,
	output reg Flag_input_ANDgate
);
wire  cf, vf, sf,zf;
    reg [63:0] MULout,MUL, MULH, MULHSU,MULHU; // register for MUltiplication // 64 bits as we have upper and lower bits in multiplication
    reg [31:0]DIVout, DIV, DIVU;   // register for Division
    reg [31:0] REMout, REM, REMU;
    
    reg beq, bne, blt,bge, bltu,bgeu;
    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    always @(*)
    begin
            //BRANCH
                if(alufn==4'b00_01) begin
                case (Function3 )
                3'b000: begin beq=1; bne=0; blt=0; bge=0; bltu=0; bgeu=0;end // beq
                3'b001: begin beq=0; bne=1; blt=0; bge=0; bltu=0; bgeu=0;end //bne
                3'b100: begin beq=0; bne=0; blt=1; bge=0; bltu=0; bgeu=0;end //blt
                3'b101: begin beq=0; bne=0; blt=0; bge=1; bltu=0; bgeu=0;end //bge
                3'b110: begin beq=0; bne=0; blt=0; bge=0; bltu=1; bgeu=0;end //bltu
                3'b111: begin beq=0; bne=0; blt=0; bge=0; bltu=0; bgeu=1;end //bgeu
                endcase  
                end
    // MULTIPLICATION, 
            if(alufn==4'b00_10)
            begin 
            case(Function3)
            3'b000: begin MUL= $signed(a) * $signed(b); MULout = MUL[31:0];       end // MUL // SIGNED
            3'b001: begin MULH=  $signed(a) * $signed(b); MULout= MULH[63:32];end// MULH
            3'b010: begin MULHSU= $signed(a) * b; MULout= MULHSU[63:32]; end // MULHSU // Multiply High signed unsigned
            3'b011: begin MULHU =  a * b ; MULout= MULHU[63:32]; end// MULHU
            endcase
            end
        
        // DIVISION
            if (alufn== 4'b01_10)
            begin case (Function3) 
            3'b100: begin DIV= $signed(a)/$signed(b); DIVout= DIV; end //DIV // signed
            3'b101: begin DIVU= a / b; DIVout= DIVU; end// DIVU // UNSIGNED
            endcase
            end
        //REMAINDER
            if (alufn== 4'b1011)
           begin case (Function3)
            3'b110: begin REM= $signed(a) % $signed(b); REMout= REM; end //REM // SIGNED
            3'b111: begin REMU= a % b; REMout= REMU; end //REMU
            endcase
            end
      end
      always@(*)begin
    if(beq==1 || bne==1 ||blt==1 || bge==1 || bltu==1 ||bgeu==1 )
     Flag_input_ANDgate= ((zf & beq ) || ( !zf & bne) || ((sf!=vf)& blt) || ((sf==vf)& bge) || 
                               (!cf & bltu) || (cf& bgeu));
     else       
     Flag_input_ANDgate=0;                  
         end
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
 
    wire[31:0] sh;
    shifter shifter0(a, shamt, alufn[1:0],  sh);
    
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            4'b00_00 : r = add;//add
            4'b00_01 : r = add;//sub
            4'b00_11 : r = b;//LUI
            // logic 
            4'b01_00:  r = a | b;//or
            4'b01_01:  r = a & b;//and
            4'b01_11:  r = a ^ b;//xor
            // shift
            4'b10_00:  r=sh;//shift right logical SRl
            4'b10_01:  r=sh;//shift left logical SLL
            4'b10_10:  r=sh;//shift right aretmtic SRA
            // slt & sltu
           4'b11_01:  r = {31'b0,(sf != vf)};// SLT
           4'b11_11:  r = {31'b0,(~cf)};//SLTU
           
          // MUL
           4'b00_10: r = MULout;           
           // DIV
           4'b01_10: r=DIVout; // DIV
           //REM
           4'b1011: r = REMout; // REM
           
                  	
        endcase
        
    end
endmodule