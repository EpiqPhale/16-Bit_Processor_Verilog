// TCES 330, Spring 2021
// James Wedum
// Project 1

//Source code from KeyFilter.sv By Dr. Jie Sheng from the University of Washington
module KeyFilter(Clk, In, Out);

	input Clk, In;// Input signal
	
	output logic Out;// A filtered version of In (one cycle on)
	
	localparam DUR = 5_000_000 - 1;
	
	reg[32:0] Countdown = 0;
	
	always @(posedge Clk) begin
	
		Out <= 0;
		
		if (Countdown == 0) begin
		
			if (In) begin Out <= 1;
				Countdown <= DUR;
			end
			
		end else begin
			Countdown <= Countdown -1;
		end
		
	end
	
endmodule
