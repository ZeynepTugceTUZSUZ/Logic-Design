module multiplier (
    input [3:0] A,
    input [1:0] B,
    output [3:0] p1,
	output [4:0] p2_shifted
);

    // Internal wire to hold the unshifted second partial product (A * B[1]).
    wire [3:0] p2;

    // Calculate the first partial product (p1): A multiplied by B[0].
    assign p1 = (B[0]==1'b1) ? A : 4'b0000;

    // Calculate the unshifted second partial product (p2): A multiplied by B[1].
    assign p2 = (B[1]==1'b1) ? A : 4'b0000;

    // Shift the second partial product (p2) one position to the left.
    assign p2_shifted = {p2,1'b0};
endmodule  
