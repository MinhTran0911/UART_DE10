`timescale 1ns/1ps

module UART_RX_tb ();
	
	localparam CLK_HALF_T = 10;
	localparam CLK_FULL_T = CLK_HALF_T * 2;
	localparam BIT_DURATION = 8680;
	
	localparam DATA_SENT = 8'h61;
	
	logic clk, rstn, serial_dat_in, get_bit, packet_done;
	logic [7:0] data;
	
	UART_RX DUT (.*);
	
	always #CLK_HALF_T clk = ~clk;
	
	initial begin
		clk <= 1'b0;
		rstn <= 1'b1;
		serial_dat_in <= 1'b1;
		
		#CLK_FULL_T rstn <= 1'b0;
		#CLK_FULL_T rstn <= 1'b1;
		
		#CLK_FULL_T;
		
		// Simulate Data Sent from a UART Transmitter
		serial_dat_in <= 1'b0; // Start Bit
		#BIT_DURATION; 	
		for (int i = 0; i < 8; i++) begin
			serial_dat_in <= DATA_SENT[i];
			#BIT_DURATION;
		end
		serial_dat_in <= 1'b1; // Stop Bit
		#BIT_DURATION;
		
		#BIT_DURATION;
		#CLK_FULL_T;
		
		$display("Data send is: %2h", DATA_SENT);
		$display("At %0g ns", $time);
		$display("Data received is: %2h", data);
		
		if (data == DATA_SENT) $display("<< Correct Data Received >>");
		else $display("!! Incorrect Data Received !!");
		#2000 $finish;
	end
	
endmodule 