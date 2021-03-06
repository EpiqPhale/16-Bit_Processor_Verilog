//TCES330 Spring2021
//RAM reading all cells



module Memory(Clk, Reset, W_data, D_wr, R_data);
	input Clk, Reset, D_wr;
	input [15:0]W_data;
	output [15:0]R_data;
	
	logic [7:0] Addr;
	
	AlteraDmem unit0(
	.address(Addr),
	.clock(Clk),
	.data(W_data),
	.wren(D_wr),
	.q(R_data));

	always_ff@(posedge Clk) begin
		if(Reset)
			Addr <= 8'd0;
		else if (Addr != 8'd255)
				Addr <= Addr + 1'b1;
			else
				Addr <= 8'b0;
			
	end
	
	
endmodule


//testbench
 timescale 1ns/1ns
module Memory_tb();

	logic Clk, Reset, D_Wr;
	logic [15:0]W_data;
	logic [15:0]R_data;
	
	Memory dut(Clk, Reset W_data, D_wr, R_data);

	always begin
		Clk = 0; #10;
		Clk = 1; #10;
	end
	
	initial begin
		Reset = 1'b1; #53; //address = 0;
		Reset = 1'b0;
		for (int i = 0; i <256; i++) begin
			@(posedge Clk);
			#5 $display(i, $time, R_data);
		end
		$stop;
	end
	



endmodule

