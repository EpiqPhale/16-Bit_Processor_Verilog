//Tatiana Franco
//TCES 330, Spring 2021
//5/28/2021
//Project 1 - MUX2_to_1 dataflow style

module Mux2_to_1(R_data, ALU_out, RF_s, W_data); //input and output signals

	output [15:0] W_data; //output
	input [15:0] R_data, ALU_out; //2 16-bit input signals
	input RF_s; //input

	assign W_data=(RF_s)?R_data:ALU_out; //High:R_data  Low:ALU_out
endmodule


//testbench
module Mux2_to_1_tb();
	wire[15:0] out;
	reg [15:0] r, alu;
	reg s;

Mux2_to_1 DUT(.W_data(out), .R_data(r), .ALU_out(alu), .RF_s(s));

initial begin
	r=16'hFFFF;
	alu=16'hAAAA;
	s=1'b0;
	#2;

	s=1'b1;
	#2;

	r=16'h5555;
	#2;

	s=1'b0;
	#2;
	
end

endmodule