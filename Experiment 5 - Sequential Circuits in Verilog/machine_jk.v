module machine_jk(
    input wire x,
    input wire CLK,
    input wire RESET,
    output wire F,
    output wire [2:0] S
);

    // State wires
    wire A, B, C;

    // JK inputs
    wire JA, KA, JB, KB, JC, KC;

    // Inverted signals
    wire nA, nB, nC, nx;
    not (nA, A);
    not (nB, B);
    not (nC, C);
    not (nx, x);

    // JA = (B & C & ~x) | (~B & C & x) :
    wire JA_t1, JA_t2;
    and (JA_t1, B, C, nx);
    and (JA_t2, nB, C, x);
    or  (JA, JA_t1, JA_t2);

    // KA = B | C :
    or (KA, B, C);

    // JB = (A & ~C & ~x) | (~A & ~C & x) :
    wire JB_t1, JB_t2;
    and (JB_t1, A, nC, nx);
    and (JB_t2, nA, nC, x);
    or  (JB, JB_t1, JB_t2);

    // KB = A | ~C :
    or (KB, A, nC);

    // JC = (~A) | (~B & x) :
    wire JC_t1;
    and (JC_t1, nB, x);
    or  (JC, nA, JC_t1);

    // KC = 1 :
    wire VCC;
    buf (VCC, 1'b1);
    buf (KC, VCC);

    // State registers implemented using JK flip-flops
    jkff Ajk (.J(JA), .K(KA), .CLK(CLK), .RESET(RESET), .Q(A));
    jkff Bjk (.J(JB), .K(KB), .CLK(CLK), .RESET(RESET), .Q(B));
    jkff Cjk (.J(JC), .K(KC), .CLK(CLK), .RESET(RESET), .Q(C));

    //  Output F = A & B & ~C :
    and (F, A, B, nC);

    //  State Output S :
    buf (S[2], A);
    buf (S[1], B);
    buf (S[0], C);

endmodule
