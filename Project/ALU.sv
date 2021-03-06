// TCES330 Spring2021
// 05/25/21
// Jordan
// Project 1
// This module represents an ALU control module for a 16-bit processor


module ALU(A,B, Sel, Q);
    
    input [15:0] A,B; //16-bit inputs
    input [2:0] Sel; //Selection
    output [15:0] Q; //16-bit output

    reg [15:0] Result;

    always @(*)
    begin
        case(Sel)
        3'b000: // Zero case
           Result = 0; 
        3'b001: // Addition operation
           Result = (A + B) ;
	3'b010: // Subtraction operation
           Result = (A - B) ;
	3'b011: // Pass-through (value A)
           Result = (A);
	3'b100: // XOR Case
           Result = (A ^ B);
	3'b101: // OR Case
           Result = (A | B);
	3'b110: // AND case
           Result = (A & B) ;
	3'b111: // Add 1 case
           Result = (A + 1'b1) ;
	default: Result = 0;
        endcase
    end

    assign Q = Result; // ALU output assignment

endmodule

`timescale 1ns / 1ps  

module ALU_tb();

 reg[15:0] A,B; //input
 reg[2:0] ALU_Sel; //selection 

 wire[15:0] ALU_Out; //output

 integer i;
 ALU dut(
            A,
	    B,                 
            ALU_Sel,
            ALU_Out
     );
    initial begin
      A = 16'b1010111110101111;
      B = 8'b00001101;
      ALU_Sel = 3'b000;
	#10;
      for (i=0;i<=6;i=i+1)
      begin
       ALU_Sel = ALU_Sel + 3'b001; //add one to the select bit
       #10;
      end;
      
      A = 16'b1010111110101111;
      B = 8'b00001101;
      
    end
endmodule