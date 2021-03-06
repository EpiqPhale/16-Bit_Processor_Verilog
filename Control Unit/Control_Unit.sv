// James Wedum
// TCES 330, Spring 2021
// 5/27/2021
// Project 1

/*
 * This module describes the Controller for the processor for the TCES 330 class project such that:
 *
 *	--Inputs--
 *	Clock = The 50 MHz system clock(?)
 *	Reset = Syncronous high-active reset.
 
 *	--Outputs--
 *	PC_Out = Current value of Program Counter.
 *	IR_Out = Current value of the Instruction Register.
 *	OutState = Current State of State Machine.
 *	NextState = Next State of State Machine.
 *	D_Addr = The 8-bit data memory address
 *	D_Wr = Data write enable bit.
 *	RF_s = 1-bit selector for 16-bit 2-to-1 multiplexer that chooses between the data memory and the ALU output
 *	RF_W_en = Register write enable bit.
 *	RF_Ra_Addr = 4-bit address for A-side register file.
 *	RF_Rb_Addr = 4-bit address for B-side register file.
 *	RF_W_Addr = 4-bit Register file write address.
 *	ALU_s0 = 3-bit ALU function select.  See ALU for opcodes.
 */
 
 module Control_Unit(Clock, Reset, PC_Out, IR_Out, OutState, NextState, 
		D_Addr, D_Wr,RF_s, RF_W_en, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr, ALU_s0);
	input Clock, Reset;
	
	output D_Wr, RF_s, RF_W_en;
	output [2:0] ALU_s0;
	output [3:0] OutState, NextState, RF_Ra_Addr, RF_Rb_Addr, RF_W_Addr;
	output [6:0] PC_Out;
	output [7:0] D_Addr;
	output [15:0] IR_Out;
	wire PC_up, FSM_to_PC_Reset, IR_ld;
	wire [15:0] data;
	
	//instruction memory
	InstructionMemory Imem(Clock, PC_Out, data);
	
	//Program Counter
	PC pc(Clock, FSM_to_PC_Reset, PC_up, PC_Out);
	
	//Instruction Register
	IR Instruction_Reg(Clock, IR_ld, data, IR_Out);
	
	//Controller/State Machine
	FSM controller(Clock, Reset, IR_Out, FSM_to_PC_Reset, IR_ld, PC_up, D_Addr, D_Wr, RF_s, 
					RF_Ra_Addr, RF_Rb_Addr, RF_W_en, RF_W_Addr, ALU_s0, OutState, NextState);
 endmodule
 
 //Testbench
 /*	Since all of the major outputs are connected only to the State Machine,
  *		testing of the outputs is redundant, since they are fully examined in the state machine.
  *	Therefor, the major focus of this testbench is on ensureing propper transition of states based on a program in memory.
  */
 `timescale 1 ps / 1 ps
module Control_Unit_tb();

	logic Clock, D_Wr, RF_W_en, RF_s, Reset;
	logic [2:0] ALU_s0;
	logic [3:0] RF_W_Addr, RF_Ra_Addr, RF_Rb_Addr, State, NextState;
	logic [6:0] PC_Out;
	logic [7:0] D_Addr;
	logic [15:0]IR_Out;
	
	localparam Init = 4'h0, Fetch = 4'h1, Decode = 4'h2, Halt = 4'h3, Sub = 4'h4, Add = 4'h5, 
				Store = 4'h6, Ld_A = 4'h7, Ld_B = 4'h8, Noop = 4'h9;
	
	Control_Unit DUT(.Clock(Clock), .Reset(Reset), .PC_Out(PC_Out), .IR_Out(IR_Out), .OutState(State), .NextState(NextState), 
		.D_Addr(D_Addr), .D_Wr(D_Wr), .RF_s(RF_s), .RF_W_en(RF_W_en), .RF_Ra_Addr(RF_Ra_Addr), .RF_Rb_Addr(RF_Rb_Addr), .RF_W_Addr(RF_W_Addr), .ALU_s0(ALU_s0));
	
	//50MHz clock input
	always begin
		Clock = 1'b0;	#10;
		Clock = 1'b1;	#10;
	end
	
	initial begin
		Reset = 1'b1; #20;
		Reset = 1'b0;
		//	Test 1:  The purpose of this test is to ensure that the controller initializes correctly.
		//	Assert initialization (PC and IR are zero)
			assert(State == Init) else $error("Incorrect state.  Expected 0, actual: %h", State);
			assert(PC_Out == 7'h0) else $error("Failed to initialize PC.  PC val: %d", PC_Out);
			#20;
			
		//	Test 2:	 The purpose of this test is to ensure that the controller can cycle through a basic program.
		//	increment and assert PC, and IR
			/*Instructions stored in Imem:
			1:	0000 0000 0000 0000; -> noop
			2:	0010 0000 1011 0001; -> Load D[B] to Reg[1]
			3:	0010 0001 1011 0010; -> Load D[1B] to Reg[2]
			4:	0010 0000 0110 0011; -> Load D[6] to Reg[3]
			5:	0010 1000 1010 0100; -> Load D[8A] to Reg[4]
			6:	0100 0001 0010 0101; -> Reg[5] = Reg[1] - Reg[2]
			7:	0100 0011 0100 0110; -> Reg[6] = Reg[3] - Reg[4]
			8:	0011 0101 0110 0000; -> Reg[0] = Reg[5] + Reg[6]
			9:	0001 0000 1100 1101; -> Store *Reg[0] to Dmem[CD]
			10:	0101 0000 0000 0000; -> Halt
			*/
			
			//	1:	0000 0000 0000 0000; -> noop
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			assert(PC_Out == 0)	else $error("Incorrect PC.	Expected 0, actual: %d", PC_Out);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 1)	else $error("Incorrect PC.	Expected 1, actual: %d", PC_Out);
			assert(IR_Out == 16'b0000000000000000) else $error("Incorrect IR value.	Expected 0000, actual: %h", IR_Out);
			#20;
			assert(State == Noop) else $error("Incorrect state.  Expected 9, actual: %h", State);
			#20;
			
			//	2:	0010 0001 1011 0010; -> Load D[1B] to Reg[2]
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 2)	else $error("Incorrect PC.	Expected 2, actual: %d", PC_Out);
			assert(IR_Out == 16'b0010000010110001) else $error("Incorrect IR value.	Expected 20B1, actual: %h", IR_Out);
			#20;
			
			#20;
			
			#20;
			
			//	3:	0010 0001 1011 0010; -> Load D[1B] to Reg[2]
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 3)	else $error("Incorrect PC.	Expected 3, actual: %d", PC_Out);
			assert(IR_Out == 16'b0010000110110010) else $error("Incorrect IR value.	Expected 21B2, actual: %h", IR_Out);
			#20;
			
			#20;
			
			#20;
			
			//	4:	0010 0000 0110 0011; -> Load D[6] to Reg[3]
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 4)	else $error("Incorrect PC.	Expected 4, actual: %d", PC_Out);
			assert(IR_Out == 16'b0010000001100011) else $error("Incorrect IR value.	Expected 2063, actual: %h", IR_Out);
			#20;
			
			#20;
			
			#20;
			
			
			//	5:	0010 1000 1010 0100; -> Load D[8A] to Reg[4]
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 5)	else $error("Incorrect PC.	Expected 5, actual: %d", PC_Out);
			assert(IR_Out == 16'b0010100010100100) else $error("Incorrect IR value.	Expected 28A4, actual: %h", IR_Out);
			#20;
			
			#20;
			
			#20;
			
			//	6:	0100 0001 0010 0101; -> Reg[5] = Reg[1] - Reg[2]
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 6)	else $error("Incorrect PC.	Expected 6, actual: %d", PC_Out);
			assert(IR_Out == 16'b0100000100100101) else $error("Incorrect IR value.	Expected 4125, actual: %h", IR_Out);
			#20;
			
			#20;
			
			//	7:	0100 0011 0100 0110; -> Reg[6] = Reg[3] - Reg[4]
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 7)	else $error("Incorrect PC.	Expected 7, actual: %d", PC_Out);
			assert(IR_Out == 16'b0100001101000110) else $error("Incorrect IR value.	Expected 4346, actual: %h", IR_Out);
			#20;
			
			#20;
			
			//	8:	0011 0101 0110 0000; -> Reg[0] = Reg[5] + Reg[6]
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 8)	else $error("Incorrect PC.	Expected 8, actual: %d", PC_Out);
			assert(IR_Out == 16'b0011010101100000) else $error("Incorrect IR value.	Expected 3560, actual: %h", IR_Out);
			#20;
			
			#20;
			
			
			//	9:	0001 0000 1100 1101; -> Store *Reg[0] to Dmem[CD]
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 9)	else $error("Incorrect PC.	Expected 9, actual: %d", PC_Out);
			assert(IR_Out == 16'b0001000011001101) else $error("Incorrect IR value.	Expected 10CD, actual: %h", IR_Out);
			#20;
			
			#20;
			
			//	10:	0101 0000 0000 0000; -> Halt
			assert(State == Fetch) else $error("Incorrect state.  Expected 1, actual: %h", State);
			#20;
			assert(State == Decode) else $error("Incorrect state.  Expected 2, actual: %h", State);
			assert(PC_Out == 10)	else $error("Incorrect PC.	Expected 10, actual: %d", PC_Out);
			assert(IR_Out == 16'b0101000000000000) else $error("Incorrect IR value.	Expected 5000, actual: %h", IR_Out);
			#20;
			assert(State == Halt) else $error("Incorrect state.  Expected 3, actual: %h", State);
			#100;
			assert(State == Halt) else $error("Incorrect state.  Expected 3, actual: %h", State);
			
		//	Test 3:	The purpose of this test is to ensure that the reset function opperates propperly
		//	Reset and assert IR and PC
			Reset = 1'b1;	#40;	//2 clocks to allow State and PC to clear
			assert(State == Init) else $error("Incorrect state.  Expected 0, actual: %h", State);
			assert(PC_Out == 7'h0) else $error("Reset failed to clear PC.  PC val: %h", PC_Out);
			Reset = 1'b0;	#40;	//2 clocks to propogate to IR
			assert(IR_Out == 16'h0) else $error("Reset failed to clear IR.  IR val: %h", IR_Out);
			
		$display("If no errors in console, all tests succeeded.");
			$stop;
	end
endmodule