// James Wedum
// TCES 330, Spring 2021
// 6/3/2021
// Project 1

/*
 * This module describes the Finite State Machine (controller) for the TCES 330 class project.
 *
 *	--Inputs--
 *	Clk = The 50 MHz system clock(?)
 *	Reset = Syncronous high-active reset.
 *	IR = 16-bit connection to instruction register;
 *
 *	--Outputs--
 *	PC_clr = Program counter (PC) clear command.
 *	IR_ld = Instruction load command
 *	PC_up = PC increment command
 *	D_addr = Datamemory address (8 bits)
 *	D_wr = Data memory write enable
 *	RF_s = Mux selectline
 *	RF_Ra_addr = Register file A-side read address (4 bits)
 *	RF_Rb_addr = Registerfile B-side read address (4 bits)
 *	RF_W_en = Register file write enable
 *	RF_W_Addr = Register file write address (4 bits)
 *	ALU_s0 = ALU function select (3 bits)
 *	CurrentState = The current state of the FSM
 *	NextState = The next state of the FSM;
 */
module FSM(Clk, Reset, IR, PC_clr, IR_ld, PC_up, D_addr, D_wr, RF_s, 
		RF_Ra_addr, RF_Rb_addr, RF_W_en, RF_W_Addr, ALU_s0, CurrentState, NextState);

	input Clk, Reset;
	input [15:0] IR;
	
	output logic PC_clr = 0, IR_ld = 0, PC_up = 0, D_wr = 0, RF_s = 0, RF_W_en = 0;
	output logic [2:0] ALU_s0 = 0;
	output logic [3:0] RF_Ra_addr = 0, RF_Rb_addr = 0, RF_W_Addr = 0;
	output logic [7:0] D_addr = 0;
	
	output logic [3:0] CurrentState = 4'h0, NextState = 4'h0;
	
	//assign PC_clr = Reset;
	
	//named states
	localparam Init = 4'h0, Fetch = 4'h1, Decode = 4'h2, Halt = 4'h3, Sub = 4'h4, Add = 4'h5, 
				Store = 4'h6, Ld_A = 4'h7, Ld_B = 4'h8, Noop = 4'h9;
	
	always_comb begin
		case(CurrentState)
			Init:	begin
						PC_clr = 1'b1;
						NextState = Fetch;
					end
			
			Fetch:	begin
						PC_clr = 1'b0;
						D_wr = 1'b0;
						RF_W_en = 1'b0;
						
						IR_ld = 1'b1;
						PC_up = 1'b1;
						NextState = Decode;
					end
			
			Decode:	begin
						IR_ld = 1'b0;
						PC_up = 1'b0;
			
						if(IR[15:12] == 4'b0000) NextState = Noop;
						else if(IR[15:12] == 4'b0010) NextState = Ld_A;
						else if(IR[15:12] == 4'b0001) NextState = Store;
						else if(IR[15:12] == 4'b0011) NextState = Add;
						else if(IR[15:12] == 4'b0100) NextState = Sub;
						else if(IR[15:12] == 4'b0101) NextState = Halt;
						else NextState = Halt;	//Unknown opcode = HCF
					end
			
			Halt:	NextState = Halt;
			
			Sub:	begin
						RF_W_Addr = IR[3:0];
						RF_W_en = 1'b1;
						RF_Ra_addr = IR[11:8];
						RF_Rb_addr = IR[7:4];
						ALU_s0 = 3'd2;
						RF_s = 1'b0;
						NextState = Fetch;
					end
			
			Add:	begin
						RF_W_Addr = IR[3:0];
						RF_W_en = 1'b1;
						RF_Ra_addr = IR[11:8];
						RF_Rb_addr = IR[7:4];
						ALU_s0 = 3'd1;
						RF_s = 1'b0;
						NextState = Fetch;
					end
					
			Store:	begin
						D_addr = IR[7:0];
						D_wr = 1'b1;
						RF_Ra_addr = IR[11:8];
						NextState = Fetch;
					end
			
			Ld_A:	begin
						D_addr = IR[11:4];
						RF_s = 1'b1;
						RF_W_Addr = IR[3:0];
						NextState = Ld_B;
					end
			
			Ld_B:	begin
						D_addr = IR[11:4];
						RF_s = 1'b1;
						RF_W_Addr = IR[3:0];
						RF_W_en = 1'b1;
						NextState = Fetch;
					end
			
			Noop:	begin
						NextState = Fetch;
					end
			
			default NextState = Init;
		endcase
	end
	
	always_ff@(posedge Clk) begin
		CurrentState <= NextState;
	end
	
	
endmodule

module FSM_tb();
	logic Clk, Reset, PC_clr, IR_ld, PC_up, D_wr, RF_s, RF_W_en;
	logic [15:0] IR;
	logic [2:0] ALU_s0;
	logic [3:0] RF_Ra_addr, RF_Rb_addr, RF_W_Addr, CurrentState, NextState;
	logic [7:0] D_addr;
	
	localparam Init = 4'h0, Fetch = 4'h1, Decode = 4'h2, Halt = 4'h3, Sub = 4'h4, Add = 4'h5, 
			Store = 4'h6, Ld_A = 4'h7, Ld_B = 4'h8, Noop = 4'h9;
	
	FSM DUT (.Clk(Clk), .Reset(Reset), .IR(IR), .PC_clr(PC_clr), .IR_ld(IR_ld), .PC_up(PC_up), 
		.D_addr(D_addr), .D_wr(D_wr), .RF_s(RF_s), .RF_Ra_addr(RF_Ra_addr), .RF_Rb_addr(RF_Rb_addr), 
		.RF_W_en(RF_W_en), .RF_W_Addr(RF_W_Addr), .ALU_s0(ALU_s0), .CurrentState(CurrentState), 
		.NextState(NextState));
		
	
	always begin
		Clk = 1'b0; #10;
		Clk = 1'b1; #10;
	end
	
	initial begin
		Reset = 1'b0;
		//Test 1: Init, Fetch, Decode(partial), and Noop
		$display($time,,"Test 1: Init. Set IR to zeros.  This should Init then cycle Fetch -> Decode -> Noop.");
		IR = 16'd0;	//initialize IR to zero
		assert(CurrentState == Init) else $error("Init Failed"); #15;
		assert (CurrentState == Fetch) else $error("Init -> Fetch failed"); #20;
		assert (CurrentState == Decode) else $error("Fetch -> Decode failed"); #20;
		assert (CurrentState == Noop) else $error("Decode -> Noop failed"); #20;
		assert (CurrentState == Fetch) else $error("Noop -> Fetch failed");
		$display($time,,"If no errors, Test 1 successful.");
		
		//Test 2: Decode(partial), Ld_A, and Ld_B
		wait(CurrentState == Fetch);
		$display($time,,"Test 2: Load. Set IR to 0010 0000 0000 1010.  This should cycle Fetch -> Decode -> Ld_A -> Ld_B.  RF_s active in Ld_A and RF_W_en in Ld_B.");
		IR = 16'b0010000000001010;
		assert (CurrentState == Fetch) else $error("Fetch failed"); #20;
		assert (CurrentState == Decode) else $error("Fetch -> Decode failed"); #20;
		assert (CurrentState == Ld_A) else $error("Decode -> Ld_A failed"); 
		assert (RF_s) else $error("RF_s not latched");
		assert (RF_W_Addr == IR[3:0]) else $error("RF_W_Addr incorrect");
		assert (D_addr == IR[11:4]) else $error("D_addr incorrect");#20;
		assert (CurrentState == Ld_B) else $error("Ld_A -> Ld_B failed"); 
		assert (RF_W_en) else $error("RF_W_en not latched");#20;
		assert (CurrentState == Fetch) else $error("Ld_B -> Fetch failed");
		$display($time,,"If no errors, Test 2 successful.");
		
		//Test 3: Decode(partial), Store
		wait(CurrentState == Fetch);
		$display($time,,"Test 3: Store. Set IR to 0001 1001 0000 0000.  This should cycle Fetch -> Decode -> Store.  Should activate D_wr and RF_Ra_addr.");
		IR = 16'b0001100100000000;
		assert (CurrentState == Fetch) else $error("Fetch failed"); #20;
		assert (CurrentState == Decode) else $error("Fetch -> Decode failed"); #20;
		assert (CurrentState == Store) else $error("Decode -> Store failed"); 
		assert (D_wr) else $error("D_wr not latched");
		assert (RF_Ra_addr == IR[11:8]) else $error("RF_Ra_addr incorrect");
		assert (D_addr == IR[7:0]) else $error("D_addr incorrect");#20;
		assert (CurrentState == Fetch) else $error("Store -> Fetch failed");
		$display($time,,"If no errors, Test 3 successful.");
		
		//Test 4: Decode(partial), Add
		wait(CurrentState == Fetch);
		$display($time,,"Test 4: Add. Set IR to 0011 0011 0100 1101. This should cycle Fetch -> Decode -> Add. Values can be extrapolated from IR.");
		IR = 16'b0011001101001101;
		assert (CurrentState == Fetch) else $error("Fetch failed"); #20;
		assert (CurrentState == Decode) else $error("Fetch -> Decode failed"); #20;
		assert (CurrentState == Add) else $error("Decode -> Add failed"); 
		assert (RF_W_en) else $error("RF_W_en not latched");
		assert (ALU_s0 == 3'b1) else $error("ALU_s0 Incorrect Operation");
		assert (RF_Ra_addr == IR[11:8]) else $error("RF_Ra_addr incorrect");
		assert (RF_Rb_addr == IR[7:4]) else $error("RF_Rb_addr incorrect");
		assert (RF_W_Addr == IR[3:0]) else $error("RF_W_Addr incorrect"); #20;
		assert (CurrentState == Fetch) else $error("Add -> Fetch failed");
		$display($time,,"If no errors, Test 4 successful.");
		
		//Test 5: Decode(partial), Sub
		$display($time,,"Test 5: Sub. Set IR to 0100 0100 0011 0001. This should cycle Fetch -> Decode -> Sub. Values can be extrapolated from IR.");
		wait(CurrentState == Fetch);
		IR = 16'b0100010000110001;
		assert (CurrentState == Fetch) else $error("Fetch failed"); #20;
		assert (CurrentState == Decode) else $error("Fetch -> Decode failed"); #20;
		assert (CurrentState == Sub) else $error("Decode -> Sub failed"); 
		assert (RF_W_en) else $error("RF_W_en not latched");
		assert (ALU_s0 == 3'd2) else $error("ALU_s0 Incorrect Operation");
		assert (RF_Ra_addr == IR[11:8]) else $error("RF_Ra_addr incorrect");
		assert (RF_Rb_addr == IR[7:4]) else $error("RF_Rb_addr incorrect");
		assert (RF_W_Addr == IR[3:0]) else $error("RF_W_Addr incorrect"); #20;
		assert (CurrentState == Fetch) else $error("Sub -> Fetch failed");
		$display($time,,"If no errors, Test 5 successful.");
		
		//Test 6: Halt
		$display($time,,"Test 6: Halt. Set IR to 0101 0000 0000 0000.  Should drop into halt after decode and stay there.");
		wait(CurrentState == Fetch);
		IR = 16'b0101000000000000;
		assert (CurrentState == Fetch) else $error("Fetch failed"); #20;
		assert (CurrentState == Decode) else $error("Fetch -> Decode failed"); #20;
		assert (CurrentState == Halt) else $error("Decode -> Halt failed"); 
		#123;
		assert (CurrentState == Halt) else $error("FSM left Halt after entering"); 
		$display($time,,"If no errors, Test 6 successful.");
		$display($time,,"If no errors, all test successful.");
		$stop;
	end
	
endmodule