// James Wedum
// TCES 330, Spring 2021
// 4/24/2021
// HW3, Question 1

/*  This module uses a case statement on a 3-bit wide input C to output the 7-seg code to Hex
*/
module Decoder(Hex, C);  // 
	input [3:0] C;
	output [0:6] Hex;
	
	always @(C) begin
		case(C)				// 01234567
			4'b0000 : Hex = 7'b0000001;  //0
			4'b0001 : Hex = 7'b1001111;  //1
			4'b0010 : Hex = 7'b0010010;  //2
			4'b0011 : Hex = 7'b0000110;  //3
			4'b0100 : Hex = 7'b1001100;  //4
			4'b0101 : Hex = 7'b0100100;  //5
			4'b0110 : Hex = 7'b0100000;  //6
			4'b0111 : Hex = 7'b0001111;  //7
			4'b1000 : Hex = 7'b0000000;  //8
			4'b1001 : Hex = 7'b0000100;  //9
			4'b1010 : Hex = 7'b0001000;  //A
			4'b1011 : Hex = 7'b1100000;  //B
			4'b1100 : Hex = 7'b0110001;  //C
			4'b1101 : Hex = 7'b1000010;  //D
			4'b1110 : Hex = 7'b0110000;  //E
			4'b1111 : Hex = 7'b0111000;  //F
			default : Hex = 7'b1111110;  //dash
		endcase
	end

endmodule
