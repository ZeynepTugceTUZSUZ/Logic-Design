module full_adder(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
);

    // Sum (S) calculation: S = A XOR B XOR Cin.
    assign S = A^B^Cin;

    // Carry-out (Cout) calculation: Cout = (A AND B) OR (A AND Cin) OR (B AND Cin).
    assign Cout = (A&B) | (A&Cin) | (B&Cin);
endmodule