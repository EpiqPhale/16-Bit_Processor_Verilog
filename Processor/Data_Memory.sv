//TCES330 Spring2021
//RAM reading all cells



module Data_Memory(Clk, Addr, W_data, D_wr, R_data);
	input Clk, D_wr;
	input [15:0]W_data;
	output [15:0]R_data;
	
	input logic [7:0] Addr;
	
	AlteraDmem unit0(
	.address(Addr),
	.clock(Clk),
	.data(W_data),
	.wren(D_wr),
	.q(R_data));

//	always_ff@(posedge Clk) begin
//		if(Reset)
//			Addr <= 8'd0;
//		else if (Addr != 8'd255)
//			Addr <= Addr + 1'b1;
//		else
//			Addr <= 8'b0;
//			
//	end
	
	
endmodule


