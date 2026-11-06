`timescale 1ns/10ps
module multiplier_tb;

   reg [3:0] A;
   reg [1:0] B;
   wire [3:0] p1;
   wire [4:0] p2_shifted;

   // Instantiate the 'multiplier' module, connecting the testbench signals to the module ports.
   multiplier UUT(.A(A) , .B(B) , .p1(p1) , .p2_shifted(p2_shifted));

   initial begin

      // Setup Value Change Dump (VCD) file for waveform viewing.
      $dumpfile("multiplier.vcd");
      $dumpvars(0, multiplier_tb);

      A = 4'b0000; B = 2'b00; #10
      A = 4'b0101; B = 2'b01; #10
      A = 4'b1010; B = 2'b10; #10
      A = 4'b1111; B = 2'b11; #10
      A = 4'b0011; B = 2'b01; #10
      A = 4'b1001; B = 2'b10; #10
      A = 4'b0110; B = 2'b10; #10
      A = 4'b1100; B = 2'b01; #10
      $finish;
   end

   initial begin

      // Continuous monitoring of inputs and outputs in the console.
      $monitor("Time=%0t | A=%b (%d), B=%b (%d) | p1=%b, p2_shifted=%b",$time, A, A, B, B, p1, p2_shifted);
    end
endmodule 
