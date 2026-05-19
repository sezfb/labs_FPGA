module ref_sum (Ain, Bin, Ci, Sout, Co);

    input  [3:0] Ain, Bin;
    input  Ci;

    output [3:0] Sout;
    output Co;

    reg [4:0] S;

    always @(*) begin
        S = Ain + Bin + Ci;
    end

    assign Sout = S[3:0];
    assign Co   = S[4];

endmodule