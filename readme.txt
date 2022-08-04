This project is an implementation of UART communication protocol on the 
Terasic DE-10 Standard FPGA Board.

Data is send/receive via the Terminal software (Terminal.exe) <-> UART Adapter <-> GPIO[1:0].
UART parameters such as Baud Rate, total number of bits in 1 packet, ... can be setup inside the top level
module. Default values are: Baud Rate 115,200, total no. of bits 10 (1 start - 8 data - 0 parity - 1 stop)

Quartus Projects are ready to be re-compile.
Project in the UART_Top folder are ready to be re-run on the Terasic DE-10 Standard FPGA Board.

Modelsim Projects are ready to be re-compile and re-run. 
Designs that are tested using automatic testbench are in folders denoted as [module_name]_auto,
	these testbench automatically check the simulation result with expected outputs stored in text files
	in the same simulation folder and print any error or discrepancies to the console.
Designs in [module_name]_manual folders must be verified manually.

** Operation ** 
The character sent from the Terminal software will be display on 2 digits of the onboard 7-seg LEDs,
representing the ASCII equivalent in 8-bit Hexadecimal format.

8-bit ASCII Data sending to the Terminal software can be selected using onboard Switches[7:0]. 
Initiate the Send command by pressing Key 3 (Left-most). The equivalent character will appear on the software.

Reset system by pressing Key 0 (Right-most).


