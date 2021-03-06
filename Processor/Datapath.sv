// James Wedum
// TCES 330, Spring 2021
// 6/1/2021
// Project 1

/*
 * This module describes the Datapath for the processor for the TCES 330 class project such that:
 *
 *	--Inputs--
 *	Clock = The 50 MHz system clock(?)
 *	D_Addr = The 8-bit data memory address
 *	D_Wr = Data write enable bit.
 *	RF_s = 1-bit selector for 16-bit 2-to-1 multiplexer that chooses between the data memory and the ALU output
 *	RF_W_Addr = 4-bit Register file write address.
 *	RF_W_en = Register write enable bit.
 *	RF_Ra_Addr = 4-bit address for A-side register file.
 *	RF_Rb_Addr = 4-bit address for B-side register file.
 *	ALU_s0 = 3-bit ALU function select.  See ALU for opcodes.
 *
 *	--Outputs--
 *	ALU_inA = 16-bit A-side data input for ALU.
 *	ALU_inB = 16-bit B-side data input for ALU.
 *	ALU_out = 16-bit ALU output.
 */
module Datapath(Clock, D_Addr, D_Wr, RF_s, RF_W_Addr, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, ALU_s0, ALU_inA, ALU_inB, ALU_out);
	input Clock, D_Wr, RF_W_en, RF_s;
	input [2:0] ALU_s0;
	input [3:0] RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr;
	input [7:0] D_Addr;
	
	output [15:0] ALU_inA, ALU_inB, ALU_out;
	wire [15:0] W_data, R_data;
   
   //data memory
   Data_Memory Dmem(Clock, D_Addr, ALU_inA, D_Wr,  R_data);
   
   /* MUX:  Selects between R_data(read from data memory) and ALU_out (previous output of ALU) on RF_s (Read From).
	*	S High: R_data
	*	S Low:	ALU_out
   */
   Mux2_to_1 MUX(R_data, ALU_out, RF_s, W_data);
   
   //Reg:	The set of 16, 16-bit registers.
   Register Reg(Clock, RF_W_en, RF_W_Addr, W_data, RF_Ra_Addr, ALU_inA, RF_Rb_Addr, ALU_inB);
   
   /*ALU:	Selects operation based on ALU_s0.  Reads from A-side and B-side to produce output ALU_out.
   */
   ALU Alu(ALU_inA, ALU_inB, ALU_s0, ALU_out);
   
   
endmodule

module Datapath_tb();
	logic Clock, D_Wr, RF_W_en, RF_s;
	logic [2:0] ALU_s0;
	logic [3:0] RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr;
	logic [7:0] D_Addr;
	logic [15:0] ALU_inA, ALU_inB, ALU_out;
	
	Datapath DUT(.Clock(Clock), .D_Addr(D_Addr), .D_Wr(D_Wr), .RF_s(RF_s), 
		.RF_W_Addr(RF_W_Addr), .RF_W_en(RF_W_en), .RF_Ra_Addr(RF_Ra_Addr), 
		.RF_Rb_Addr(RF_Rb_Addr), .ALU_s0(ALU_s0), .ALU_inA(ALU_inA), .ALU_inB(ALU_inB), .ALU_out(ALU_out));
	
	//50MHz clock input
	always begin
		Clock = 1'b1;	#10;
		Clock = 1'b0;	#10;
	end
	
	/*	Test 1:  The purpose of this test is to ensure that the 
	 *
	 */
	
endmodule