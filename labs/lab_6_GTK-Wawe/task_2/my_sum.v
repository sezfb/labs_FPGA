module my_sum (Ain, Bin, Ci, Sout, Co);

    input  [3:0] Ain, Bin;
    input  Ci;

    output [3:0] Sout;
    output Co;

    wire [3:0] C;

    bitsum sum1 (Ain[0], Bin[0], Ci,   Sout[0], C[0]);
    bitsum sum2 (Ain[1], Bin[1], C[0], Sout[1], C[1]);
    bitsum sum3 (Ain[2], Bin[2], C[1], Sout[2], C[2]);
    bitsum sum4 (Ain[3], Bin[3], C[2], Sout[3], C[3]);

    assign Co = C[3];

endmodule


module bitsum (A, B, Cin, S, Cout);

    input A, B, Cin;
    output S, Cout;

    wire Res;
    wire c1, c2;

    xor (Res, A, B);
    and (c1, A, B);

    xor (S, Cin, Res);
    and (c2, Cin, Res);

    or (Cout, c1, c2);

endmodule