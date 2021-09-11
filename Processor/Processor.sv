// James Wedum
// TCES 330, Spring 2021
// 6/1/2021
// Project 1

/*
 * This module describes the Processor for the TCES 330 class project such that:
 *
 *	--Inputs--
 *	Clk = The 50 MHz system clock(?)
 *	Reset = Syncronous high-active reset.
 
 *	--Outputs--
 *	PC_Out = Current value of Program Counter.
 *	IR_Out = Current value of the Instruction Register.
 *	State = Current State of State Machine.
 *	NextState = Next State of State Machine.
 *	ALU_A = A-side input of ALU
 *	ALU_B = B-side input of ALU
 *	ALU_Out = Output of ALU
 */

module Processor(Clk, Reset, IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);
	input Clk, Reset;

	output [3:0] State, NextState;
	output [6:0] PC_Out;
	output [15:0] IR_Out, ALU_A, ALU_B, ALU_Out;
	
	wire D_Wr, RF_s, RF_W_en;
	wire [2:0] ALU_s0;
	wire [3:0] RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;
	wire [7:0] D_Addr;

	//Control Unit
	Control_Unit Controller(Clk, ~Reset, PC_Out, IR_Out, State, NextState, D_Addr, D_Wr, RF_s, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, ALU_s0);
	
	//Datapath
	Datapath Data_Path(Clk, D_Addr, D_Wr, RF_s, RF_W_Addr, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, ALU_s0, ALU_A, ALU_B, ALU_Out);
	
endmodule