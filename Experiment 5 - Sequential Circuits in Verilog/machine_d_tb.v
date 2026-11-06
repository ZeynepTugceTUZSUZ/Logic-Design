`timescale 1ns / 1ps

module machine_d_tb;

    reg CLK;
    reg RESET;
    wire F;
    wire [2:0] S;

    // Instantiate the Design Under Test (DUT)
    machine_d uut (.x(x), .CLK(CLK), .RESET(RESET), .F(F), .S(S));

    // The clock toggles every 10 ns, resulting in a 20 ns clock period
    always #10 CLK = ~CLK;

    initial begin

        // Create a VCD file to view signal changes in waveform viewers
        $dumpfile("machine_d.vcd");
        $dumpvars(0,machine_d_tb);

        CLK = 0;
        RESET = 1;
        x = 0;

        #100 RESET = 0;
        #60 x = 1;
        #40 x = 0;
        #60 x = 1;
        #20 x = 0;
        #40 x = 1;
        #60 x = 0;
        #120;
        $finish;

    end
endmodule