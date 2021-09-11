// TCES330 Spring2021
// 05/25/21
// Jordan, James, Tatiana
// Project 1
// This module represents a register for a 16-bit processor

module Register
  (input clk,
   input write,
   input [3:0] wrAddr,
   input [15:0] wrData,
   input [3:0] rdAddrA,
   output [15:0] rdDataA,
   input [3:0] rdAddrB,
   output [15:0] rdDataB);

   reg [15:0] 	 regfile [0:15];
   //reads the register values
   assign rdDataA = regfile[rdAddrA];
   assign rdDataB = regfile[rdAddrB];

   integer 	 i;
   always @(posedge clk) begin
	//writes to the register
	 if (write) regfile[wrAddr] <= wrData;
      end
endmodule