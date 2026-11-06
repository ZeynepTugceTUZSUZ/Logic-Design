`timescale 1 ns/10 ps
module full_adder_tb;

    reg A;
    reg B;
    reg Cin;
    wire S;
    wire Cout;

    // Instantiate the 'full_adder' module, connecting the testbench signals to the module ports.
    full_adder UUT(.A(A) , .B(B) , .Cin(Cin) , .S(S) , .Cout(Cout));

    initial begin

        // Setup Value Change Dump (VCD) file for waveform viewing.
        $dumpfile("full_adder.vcd");
        $dumpvars(0,full_adder_tb);

        // Continuous monitoring of inputs and outputs in the console.
        $monitor("Time=%0t | A=%b | B =%b | Cin=%b | S=%b | Cout=%b",$time,A,B,Cin,S,Cout);

        A=0; B=0; Cin=0;
        #10;
        A=0; B=0; Cin=1;
        #10;
        A=0; B=1; Cin=0;
        #10;
        A=0; B=1; Cin=1;
        #10;
        A=1; B=0; Cin=0;
        #10;
        A=1; B=0; Cin=1;
        #10;
        A=1; B=1; Cin=0;
        #10;
        A=1; B=1; Cin=1;
        #10;
        $finish;
    end

endmodule