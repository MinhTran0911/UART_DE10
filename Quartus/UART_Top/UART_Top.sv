module UART_Top (clk, rstn, serial_in, send, data_send, serial_out, HEX);
	
	input logic clk, rstn, serial_in, send;
	input logic [7:0] data_send;
	
	output logic [6:0] HEX [0:1];
	output logic serial_out;
	
	logic [7:0] data_out;
	logic send_negedge;
	
	
	Edge_Detector Send_Negedge_Detector (.clk(clk),
														.rstn(rstn),
														.sig(send),
														.pe(),
														.ne(send_negedge)
														);
														
	UART_RX UART_Receiver (	.clk(clk),
									.rstn(rstn),
									.serial_dat_in(serial_in), 
									.data(data_out)
									);
									
	UART_TX UART_Transmitter (	.clk(clk), 
										.rstn(rstn), 
										.send(send_negedge), 
										.send_data(data_send), 
										.serial_dat_out(serial_out)
										);
											
	HEX_Disp HEX_Disp_1 (.hex_digit(data_out[7:4]), .segments(HEX[1]));
	
	HEX_Disp HEX_Disp_2 (.hex_digit(data_out[3:0]), .segments(HEX[0]));
	
endmodule 