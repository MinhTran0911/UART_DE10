module HEX_Disp (hex_digit, segments);
	
	input logic [3:0] hex_digit;
	output logic [6:0] segments;
	
	typedef enum logic [6:0] {	ZERO = 7'b100_0000, ONE = 7'b111_1001, TWO = 7'b010_0100, THREE = 7'b011_0000,
										FOUR = 7'b001_1001, FIVE = 7'b001_0010, SIX = 7'b000_0010, SEVEN = 7'b111_1000,
										EIGHT = 7'b000_0000, NINE = 7'b001_0000, A = 7'b000_1000, B = 7'b000_0011,
										C = 7'b100_0110, D = 7'b010_0001, E = 7'b000_0110, F = 7'b000_1110, DASH = 7'b011_1111	} Patterns;
	always_comb begin
		case (hex_digit)
			4'd0: segments = ZERO;
			4'd1: segments = ONE;
			4'd2: segments = TWO;
			4'd3: segments = THREE;
			4'd4: segments = FOUR;
			4'd5: segments = FIVE;
			4'd6: segments = SIX;
			4'd7: segments = SEVEN;
			4'd8: segments = EIGHT;
			4'd9: segments = NINE;
			4'd10: segments = A;
			4'd11: segments = B;
			4'd12: segments = C;
			4'd13: segments = D;
			4'd14: segments = E;
			4'd15: segments = F;
			default: segments = DASH;
		endcase
	end // end always_comb
	
endmodule 