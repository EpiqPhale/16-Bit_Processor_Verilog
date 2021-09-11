// TCES330 Spring2021
// 06/01/21
// Jordan
// Project 1
// This is a top-level module for instatiation an instruction memory (ROM)


module InstructionMemory(Clk, Addr, Dout);
	input Clk;
	output [15:0] Dout; 

	input logic [6:0] Addr;
	//read-only module for instructions
	AlteraROM unit1 (
	.address(Addr),
	.clock(Clk),
	.q(Dout));
	

endmodule

