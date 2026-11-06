module jkff (
    input J,      // Data input
    input K,      // Data input
    input CLK,    // Clock input
    input RESET,  // Asynchronous reset, active high
    output reg Q  // Output
);
    // This always block is triggered on: the rising edge of the clock (posedge CLK)
    //or the rising edge of the reset signal (posedge RESET)
    always @(posedge CLK or posedge RESET) begin
       Q <= RESET ? 1'b0 : (J & ~Q) | (~K & Q);
    end
endmodule