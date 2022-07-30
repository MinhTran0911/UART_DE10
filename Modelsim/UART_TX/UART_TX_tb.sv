`timescale 1ns/1ps

module UART_TX_tb ();
	
	localparam CLK_HALF_T = 10;
	localparam CLK_FULL_T = CLK_HALF_T * 2;
	localparam BIT_DURATION = 8680;
	
 	logic clk, rstn, send, serial_dat_out, sending, send_bit, packet_done;
	logic [7:0] send_data;
	
	UART_TX DUT (.*);
	
	always #CLK_HALF_T clk = ~clk;
	
	initial begin
		clk <= 1'b0;
		rstn <= 1'b1;
		send_data <= 8'h62;
		send <= 1'b0;
		
		// Reset
		#CLK_FULL_T rstn <= 1'b0;
		#CLK_FULL_T rstn <= 1'b1;
		
		#CLK_FULL_T send <= 1'b1;
		#CLK_FULL_T send <= 1'b0;
		#(BIT_DURATION * 12) $finish;
	end
	
endmodule 