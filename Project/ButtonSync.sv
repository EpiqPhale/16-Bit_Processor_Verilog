// James Wedum
// TCES 330, Spring 2021
// 6/4/2021
// Project 1

//Primarily uses source code from ButtonSyncRegReg.sv By Dr. Jie Sheng from the University of Washington
module ButtonSync(Clk, Bin, Bout);
	input Clk, Bin;
	output logic Bout;
	
	logic Bin_, Bin__;
	logic [1:0] State, NextState;
	
	localparam 	S_A = 2'h0, S_B = 2'h1, S_C = 2'h2;

  
  always_comb begin
  
    Bout = 0;
    NextState = State;
	 
    case (State)
      
      S_A:	begin
					if (Bin__) NextState = S_B;  // button push detected
				end
      
      S_B: 	begin
					Bout = 1; // turn output ON for one clock cycle
					if (Bin__) NextState = S_C; 
					else NextState = S_A;
				end
      
      S_C: 	begin
					if (~Bin__) NextState = S_A;  // back to A, otherwise stay in C
				end
      
      default:	NextState = S_A;
		
    endcase
  end
    
  // StateReg
  always_ff @(posedge Clk) begin
    Bin_ <= Bin;   // to fend of meta-stability (two stages)
    Bin__ <= Bin_;
    State <= NextState;   // go to the state we set
  end
	
endmodule
