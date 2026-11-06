`timescale 1ns/10ps
module five_bit_2x1_mux_tb;
	
	reg [4:0] In_0;
	reg [4:0] In_1;
	reg Select;
	wire [4:0] Out;

	// Instantiate the 'five_bit_2x1_mux' module, connecting the testbench signals to the module ports.
	five_bit_2x1_mux UUT(.In_0(In_0) , .In_1(In_1) , .Select(Select) , .Out(Out));

	initial begin

		// Setup Value Change Dump (VCD) file for waveform viewing.
		$dumpfile("five_bit_2x1_mux.vcd");
        $dumpvars(0, five_bit_2x1_mux_tb);

		// Continuous monitoring of inputs and output in the console.
		$monitor("Time=%0t | In_0=%b | In_1=%b | Select=%b | Out=%b",
                 $time, In_0, In_1, Select, Out);

		In_0 = 5'b00011; In_1 = 5'b10100; Select=0;
		#10;
		In_0 = 5'b11100; In_1 = 5'b01010; Select=0;
		#10;
		In_0 = 5'b00101; In_1 = 5'b11111; Select=1;
		#10;
		In_0 = 5'b10000; In_1 = 5'b00001; Select=1;
		#10;
		$finish;
	end
endmodule
