module UART_RX (clk, rstn, serial_dat_in, get_bit, packet_done, data);
	
	parameter BAUD_COUNT_WIDTH = 9;
	parameter FULL_BAUD_COUNT_TOP = 434;
	parameter HALF_BAUD_COUNT_TOP = 217;
	parameter BIT_COUNT_WIDTH = 4;
	parameter BIT_COUNT_TOP = 10;
	
	input logic clk, rstn, serial_dat_in;
	
	output logic [7:0] data;
	output logic get_bit;
	output logic packet_done;
	
	typedef enum {IDLE, RX, LOAD} States;
	
	logic [1:0] state, next_state;
	logic [9:0] shift_reg;
	logic idling;
	logic receiving;
	
	assign idling = ~receiving;
	
	
	UART_Counter Counter (	.clk(clk), 
									.rstn(rstn), 
									.cnt_reset(idling), 
									.half_bit_flag(get_bit), 
									.full_bit_flag(), 
									.packet_done(packet_done)
									);
	
	defparam 	Counter.BAUD_COUNT_WIDTH = BAUD_COUNT_WIDTH;
	defparam	Counter.FULL_BAUD_COUNT_TOP = FULL_BAUD_COUNT_TOP;
	defparam	Counter.HALF_BAUD_COUNT_TOP = HALF_BAUD_COUNT_TOP;
	defparam	Counter.BIT_COUNT_WIDTH = BIT_COUNT_WIDTH;
	defparam	Counter.BIT_COUNT_TOP = BIT_COUNT_TOP;
	
	always_ff @(posedge clk) begin
		if (!rstn) state <= IDLE;
		else state <= next_state;
	end // end always_ff @(posedge clk)
	
	
	always_comb begin
		case (state)
			IDLE:
				begin
					if (serial_dat_in == 1'b0) next_state = RX;
					else next_state = IDLE;
				end // end case IDLE
			
			RX:
				begin
					if (packet_done) next_state = LOAD;
					else next_state = RX;
				end // end case RX
				
			LOAD:
				begin
					next_state = IDLE;
				end // end case LOAD
			
			default: next_state = IDLE;
			
		endcase
	end // end always_comb
	
	
	always_comb begin
		if (state == RX) receiving = 1'b1;
		else receiving = 1'b0;
	end // end always_comb
	
	
	always_ff @(posedge clk) begin
		if (!rstn) begin
			shift_reg <= 10'd0;
			data <= 8'd0;
		end // end if (!rstn)
		else begin
			if (state == RX && get_bit) shift_reg <= {serial_dat_in, shift_reg[9:1]};
			if (state == LOAD) data <= shift_reg[8:1];
		end // end else (!rstn)
	end // end always_ff
	
endmodule 