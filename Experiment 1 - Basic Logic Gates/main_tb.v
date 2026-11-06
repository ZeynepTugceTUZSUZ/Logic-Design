`timescale 1ns/1ps
module main_tb;
    
    reg [3:0] A;
    reg [1:0] B;
    reg multiply;
    wire [4:0] Result;
    wire Cout;

    // Instantiate the 'main' module, connecting the testbench signals to the module ports.
    main dut (.A(A), .B(B), .multiply(multiply), .Result(Result), .Cout(Cout));

    initial begin
        
        // Setup Value Change Dump (VCD) file for waveform viewing.
        $dumpfile("main.vcd");
        $dumpvars(0,main_tb);

        // Continuous monitoring of inputs and outputs in the console.
        $monitor("Time=%0t | A=%b | B=%b | multiply=%b | Result=%b | Cout=%b",$time,A,B,multiply,Result,Cout);

        A=4'b1111; B=2'b00; multiply=1;
        #10;
        A=4'b1111; B=2'b01; multiply=1;
        #10;
        A=4'b1111; B=2'b10; multiply=1;
        #10;
        A=4'b1111; B=2'b11; multiply=1;
        #10;
        A=4'b1010; B=2'b00; multiply=0;
        #10;
        A=4'b1010; B=2'b01; multiply=0;
        #10; 
        A=4'b1010; B=2'b10; multiply=0;
        #10;
        A=4'b1010; B=2'b11; multiply=0;
        #10;
        $finish;
    end
endmodule
