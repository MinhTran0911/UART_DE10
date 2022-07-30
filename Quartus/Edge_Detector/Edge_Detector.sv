module Edge_Detector (clk, rstn, sig, pe, ne);
	
	input logic clk, rstn, sig;
	output logic pe, ne;
	
	logic prev_sig;
	
	always_ff @(posedge clk) begin
		prev_sig <= sig;
	end
	
	assign pe = ~prev_sig & sig;
	assign ne = prev_sig & ~sig;
	
endmodule 