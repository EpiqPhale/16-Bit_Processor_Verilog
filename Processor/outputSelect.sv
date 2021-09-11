// James Wedum
// TCES 330, Spring 2021
// 6/4/2021
// Project 1

module outputSelect(Sw, CurrentState, NextState, PC, ALU_A, ALU_B, ALU_Out, Hex7, Hex6, Hex5, Hex4);
	input [2:0] Sw;
	input [3:0] CurrentState, NextState;
	input [6:0] PC;
	input [15:0] ALU_A, ALU_B, ALU_Out;
	
	output [3:0] Hex7, Hex6, Hex5, Hex4;
	logic [3:0] Zero;
	
	assign Zero = 4'h0;
	
	always_comb begin
		case(Sw)
			3'd0:	begin
						Hex7 = {1'b0, PC[6:4]};
						Hex6 = PC[3:0];
						Hex5 = Zero;
						Hex4 = CurrentState;
					end
					
			3'd1:	begin
						Hex7 = ALU_A[15:12];
						Hex6 = ALU_A[11:8];
						Hex5 = ALU_A[7:4];
						Hex4 = ALU_A[3:0];
					end
					
			3'd2:	begin
						Hex7 = ALU_B[15:12];
						Hex6 = ALU_B[11:8];
						Hex5 = ALU_B[7:4];
						Hex4 = ALU_B[3:0];
					end
					
			3'd3:	begin
						Hex7 = ALU_Out[15:12];
						Hex6 = ALU_Out[11:8];
						Hex5 = ALU_Out[7:4];
						Hex4 = ALU_Out[3:0];
					end
					
			3'd4:	begin
						Hex7 = Zero;
						Hex6 = Zero;
						Hex5 = Zero;
						Hex4 = NextState;
					end
					
			default:	begin
							Hex7 = Zero;
							Hex6 = Zero;
							Hex5 = Zero;
							Hex4 = Zero;
						end
		endcase
	end
	
endmodule
