module UART_TX (clk, rstn, send, send_data, serial_dat_out);
	
	parameter BAUD_COUNT_WIDTH = 9;
	parameter FULL_BAUD_COUNT_TOP = 434;
	parameter HALF_BAUD_COUNT_TOP = 217;
	parameter BIT_COUNT_WIDTH = 4;
	parameter BIT_COUNT_TOP = 10;
	
	input logic clk, rstn, send;
	input logic [7:0] send_data;
	
	output logic serial_dat_out;
	
	typedef enum {IDLE, TX} States;
	
	logic [9:0] shift_reg;
	
	logic state, next_state;
	logic sending, idling;
	logic packet_done;
	logic send_bit;
	
	assign idling = ~sending;
	
	UART_Counter Counter (	.clk(clk), 
							.rstn(rstn), 
							.cnt_reset(idling), 
							.half_bit_flag(), 
							.full_bit_flag(send_bit), 
							.packet_done(packet_done)
							);
	
	defparam BAUD_COUNT_WIDTH = BAUD_COUNT_WIDTH;
	defparam FULL_BAUD_COUNT_TOP = BIT_COUNT_TOP;
	defparam HALF_BAUD_COUNT_TOP = HALF_BAUD_COUNT_TOP;
	defparam BIT_COUNT_WIDTH = BIT_COUNT_WIDTH;
	defparam BIT_COUNT_TOP = BIT_COUNT_TOP;
	
	// FSM
	always_ff @(posedge clk) begin
		if (!rstn) state <= IDLE;
		else state <= next_state;
	end // end always_ff @(posedge clk)
	
	
	// Comb block to determine next state
	always_comb begin
		case (state)
			IDLE:
				begin
					if (send) next_state = TX;
					else next_state = IDLE;
				end // end case IDLE
			
			TX:
				begin
					if (packet_done) next_state = IDLE;
					else next_state = TX;
				end // end case TX
				
			default: next_state = IDLE;
		
		endcase
	end // end always_comb
	
	assign sending = (state == TX) ? 1'b1 : 1'b0;
	
	// Sequential Block to update shift register
	always_ff @(posedge clk) begin
		if (!rstn) begin
			shift_reg <= {10{1'b1}};
		end // end if (!rstn)
		
		else if (state == IDLE && send) shift_reg <= {1'b1, send_data, 1'b0};
		else if (state == TX && send_bit) begin
			shift_reg <= {1'b1, shift_reg[9:1]};
		end // end else (state == TX && send_bit)
	end // end always_ff
	
	// Send the data bit by bit
	always_ff @(posedge clk) begin
		if (!rstn) serial_dat_out <= 1'b1;
		else serial_dat_out <= shift_reg[0];
	end // end always_ff @(posedge clk)
	
endmodule 