`timescale 1 ns/10 ps
module five_bit_rca_tb;

  reg [4:0] A;
  reg [4:0] B;
  reg Cin;
  wire [4:0] S;
  wire Cout;

  // Instantiate the 'five_bit_rca' module, connecting the testbench signals to the module ports.
  five_bit_rca UUT (.A(A) , .B(B) , .Cin(Cin) , .S(S) , .Cout(Cout));

  initial begin
    
    // Setup Value Change Dump (VCD) file for waveform viewing.
    $dumpfile("five_bit_rca.vcd");
    $dumpvars(0,five_bit_rca_tb);

    // Continuous monitoring of inputs and outputs in the console.
    $monitor("Time=%0t | A=%b | B=%b | Cin=%b | S=%b | Cout=%b",$time,A,B,Cin,S,Cout);

    A=5'b00001; B=5'b00010; Cin=0;
    #10;
    A=5'b00100; B=5'b00011; Cin=0;
    #10;
    A=5'b01010; B=5'b00101; Cin=0;
    #10;
    A=5'b00000; B=5'b11111; Cin=1;
    #10;
    A=5'b00011; B=5'b10101; Cin=1;
    #10;
    A=5'b01100; B=5'b01010; Cin=1;
    #10;
    A=5'b11100; B=5'b00001; Cin=1;
    #10;
    $finish;
  end
endmodule