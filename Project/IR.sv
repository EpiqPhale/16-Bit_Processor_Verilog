// TCES330 Spring2021
// 06/03/21
// Jordan
// Project 1
// This module represents an instruction register for a 16-bit processor

module IR(Clk, ld, Instr_MEM, Instr_FSM);
   input ld, Clk;
   input [15:0] Instr_MEM; //instruction address from memory module
   output logic [15:0] Instr_FSM; //instruction address to the FSM


   always_ff @(posedge Clk) begin
	//writes to the register
		if (ld) Instr_FSM <= Instr_MEM;
		else Instr_FSM <= Instr_FSM;
    end
	

endmodule

module IR_tb();
	reg [15:0] Instr_MEM;
	wire [15:0] Instr_FSM;
	reg ld, clk;
	IR dut(clk, ld, Instr_MEM, Instr_FSM);
	
	always begin
		clk = 1'b0; #10;
		clk = 1'b1; #10;
	end

	initial begin;
	Instr_MEM = 0;
	ld = 0;  #60;	//longer delay here
	ld = 1;  #60;
	for(int i =0; i < 4; i++) begin
	@(posedge clk);
	Instr_MEM = Instr_MEM + 16'd1; #10;
	ld = ~ld; #50;
	Instr_MEM = Instr_MEM + 16'd1; #10;
	ld = ~ld; #50;
	Instr_MEM = Instr_MEM + 16'd2; #10;
	end
	$stop;
	end
	

	
	
endmodule