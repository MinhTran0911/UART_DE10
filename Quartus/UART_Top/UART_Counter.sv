module UART_Counter (clk, rstn, cnt_reset, half_bit_flag, full_bit_flag, packet_done);
	
	// 
	localparam BAUD_COUNT_WIDTH = 9;
	localparam FULL_BAUD_COUNT_TOP = 434;
	localparam HALF_BAUD_COUNT_TOP = 217;
	localparam BIT_COUNT_WIDTH = 4;
	localparam BIT_COUNT_TOP = 10;
	
	input logic clk, rstn, cnt_reset;
	
	output logic half_bit_flag, full_bit_flag, packet_done;
	
	// Internal logic
	logic [BAUD_COUNT_WIDTH-4'd1:0] baud_count;
	logic [BIT_COUNT_WIDTH-4'd1:0] bit_count;
	
	// Count the time to receive 1 bit
	always_ff @(posedge clk) begin
		if (!rstn) baud_count <= 9'd0;
		else if (cnt_reset) baud_count <= 9'd0;
		else if (baud_count == FULL_BAUD_COUNT_TOP) baud_count <= 9'd0;
		else baud_count <= baud_count + 9'd1;
	end // end always_ff @(posedge clk)
	
	assign half_bit_flag = (baud_count == HALF_BAUD_COUNT_TOP) ? 1'b1 : 1'b0;
	assign full_bit_flag = (baud_count == FULL_BAUD_COUNT_TOP) ? 1'b1 : 1'b0;
	
	// Count the number of bits received
	always_ff @(posedge clk) begin
		if (!rstn) bit_count <= 4'd0;
		else if (bit_count == BIT_COUNT_TOP) bit_count <= 4'd0;
		else if (half_bit_flag) bit_count <= bit_count + 4'd1;
	end // end always_ff @(posedge clk)
	
	assign packet_done = (bit_count == 4'd10) ? 1'b1 : 1'b0;
	
endmodule 