// TCES330 Spring2021
// 06/03/21
// Jordan, James, Tatiana
// Project 1
// This module represents a program counter for a 16-bit processor


module PC(Clock, Clear, Up, Q);

	input Clock, Clear, Up;
	output [6:0] Q; //output for current program count
	reg [6:0] Q;
	

	always_ff @(posedge Clock) begin
	if(Clear) 
		begin
			Q <= 7'd0; //reset the program counter when clear is high
		end else if (!Clear && Up) //increment counter
		begin
			Q <= Q + 7'd1; //increment the program counter when up is high
		end else //maintain value if neither is high
		begin
			Q <= Q;
		end
	end
endmodule
//testbench
module PC_tb();

	reg Clock, Clear, Up;
	wire [6:0] Q; //output for current program count
	integer i;
	PC dut (Clock, Clear, Up, Q);

	always begin
		Clock = 1'b0; #10;
		Clock = 1'b1; #10;
	end

	initial begin
	Clear=1; #20;
	Clear=0; #15;
	Up = 1;
	$stop;
	end

endmodule