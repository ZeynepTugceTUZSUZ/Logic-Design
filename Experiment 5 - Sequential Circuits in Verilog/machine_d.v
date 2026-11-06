module machine_d(
    input wire x,
    input wire CLK,
    input wire RESET,
    output wire F,
    output wire [2:0] S
);

    // State wires
    wire A, B, C;

    // Inverted signals
    wire nA, nB, nC, nx;
    not (nA, A);
    not (nB, B);
    not (nC, C);
    not (nx, x);

    // d2:
    wire d2_t1, d2_t2, d2_t3;
    wire d2;

    and (d2_t1, A, nB, nC);
    and (d2_t2, nB, C, x);
    and (d2_t3, nA, B, C, nx);
    or  (d2, d2_t1, d2_t2, d2_t3);

    // d1:
    wire d1_t1, d1_t2, d1_t3;
    wire d1;

    and (d1_t1, A, nB, nC, nx);
    and (d1_t2, nA, nC, x);
    and (d1_t3, nA, B, C);
    or  (d1, d1_t1, d1_t2, d1_t3);

    // d0:
    wire d0_t1, d0_t2;
    wire d0;

    and (d0_t1, nA, nC);
    and (d0_t2, nB, nC, x);
    or  (d0, d0_t1, d0_t2);

    // State registers implemented using D flip-flops
    dff dffA (.D(d2), .CLK(CLK), .RESET(RESET), .Q(A));
    dff dffB (.D(d1), .CLK(CLK), .RESET(RESET), .Q(B));
    dff dffC (.D(d0), .CLK(CLK), .RESET(RESET), .Q(C));

    // Output F:
    and (F, A, B, nC);

    // State Output S:
    buf (S[2], A);
    buf (S[1], B);
    buf (S[0], C);

endmodule
