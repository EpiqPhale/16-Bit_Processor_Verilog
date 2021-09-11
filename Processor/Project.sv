module Project(KEY, HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, SW, CLOCK_50, LEDG, LEDR);
	input CLOCK_50;
	input [2:1] KEY;
	input [17:15] SW;
	output [0:6] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0;
	output [17:15] LEDR;
	output [2:1] LEDG;
	
	assign LEDR = SW;
	assign LEDG = ~KEY;
	
	//wires probably
	wire [6:0] PC_Out;
	wire [15:0] IR_Out, ALU_A, ALU_B, ALU_Out;
 	wire [3:0] State, NextState;
	wire [3:0] HEX7_comb, HEX6_comb, HEX5_comb, HEX4_comb;
	wire Bout, Fout;

	ButtonSync BS(CLOCK_50, KEY[2], Bout);
	KeyFilter Filter(CLOCK_50, Bout, Fout);

	//Processor
	Processor processor(Fout, ~KEY[1], IR_Out, PC_Out, State, NextState, ALU_A, ALU_B, ALU_Out);
	
	Decoder unit3(HEX3, IR_Out[15:12]);
	Decoder unit2(HEX2, IR_Out[11:8]);
	Decoder unit1(HEX1, IR_Out[7:4]);
	Decoder unit0(HEX0, IR_Out[3:0]);
	
	outputSelect Selector(SW, State, NextState, PC_Out, ALU_A, ALU_B, ALU_Out, HEX7_comb, HEX6_comb, HEX5_comb, HEX4_comb);
	Decoder unit7(HEX7, HEX7_comb);
	Decoder unit6(HEX6, HEX6_comb);
	Decoder unit5(HEX5, HEX5_comb);
	Decoder unit4(HEX4, HEX4_comb);
	

	
endmodule
