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

`timescale 1 ps / 1 ps
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
		Clock = 1'b0;	#10;
		Clock = 1'b1;	#10;
	end
	
	initial begin
		//	Test 1:  The purpose of this test is to ensure that data can move from Dmem to Register
		//	Load D[6] into reg[0] and D[B] into reg[1]
			D_Addr = 8'h06;		// Dmem address
			RF_s = 1'b1;		// mux select to Dmem line
			RF_W_Addr = 4'h0;	// register to write to
			RF_W_en = 1'b1;		// register write enable
			#45;
			
			
			D_Addr = 8'h0B;
			RF_W_Addr = 4'h1;
			#40;
			
			RF_W_en = 1'b0;
			
		//	Test 2:	 The purpose of this test is to ensure that data can move through the ALU, the Mux, and back to Reg
		//	Add reg[0] and reg[1], store to reg[2]
			RF_W_Addr = 4'h2;	// register to write to
			RF_Ra_Addr = 4'h0;	// register for a-side data for ALU
			RF_Rb_Addr = 4'h1;	// register for b-side data for ALU
			RF_W_en = 1'b1;
			ALU_s0 = 3'b1;		// set ALU to add function
			RF_s = 1'b0;		// mux select to ALU line
			#20;
			
			assert(ALU_inA == 16'h10AC) else $error("A-side ALU error. A-side value: %h\tExpected: 10AC", ALU_inA);
			assert(ALU_inB == 16'hCC05) else $error("B-side ALU error. B-side value: %h\tExpected: CC05", ALU_inB);
			assert(ALU_out == 16'hDCB1) else $error("ALU output error. Output value: %h\tExpected: DCB1", ALU_out);
			
			RF_W_en = 1'b0;
			
		//	Test 3:  The purpose of this test is to ensure that data can move from Reg to Dmem.
		//	save reg[2] to D[0]
			D_Addr = 8'h00;		// Dmem target
			D_Wr = 1'b1;		// Dmem write enable
			RF_Ra_Addr = 4'h2;	// register addr for ALU a-side (connected to W_data on Dmem)
			#20;
			
		//	Test 4:	The purpose of this test is to ensure that the memory was written to
		//	load D[0] into reg[3], then send reg[3] to a-side of ALU
			D_Wr = 1'b0;
			RF_s = 1'b1;
			RF_W_Addr = 4'h3;
			RF_W_en = 1'b1;		// register write enable
			#20;
			
			RF_Ra_Addr = 4'h3;
			assert(ALU_inA == 16'hDCB1) else $error("A-side ALU error. A-side value: %h\tExpected: DCB1", ALU_inA);
			#60;
			
			$stop;
			
	end
	
endmodule