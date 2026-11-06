module five_bit_2x1_mux(In_1, In_0, Select, Out);
	input [4:0] In_1;
	input [4:0] In_0;
	input Select;
	output [4:0] Out;
	
	// Uses the conditional operator to implement the MUX logic.
	// If 'Select' is 1, 'Out' is assigned 'In_1'.
	// Otherwise, 'Out' is assigned 'In_0'.
	assign Out = (Select == 1) ? In_1 : In_0;
endmodule
