module mux (
    input  [7:0] operandA,
    input  [7:0] operandB,
    input        sel_in,
    output [7:0] out_mux
);

    assign out_mux = sel_in ? operandA : operandB; // 1 -> operandA, 0 -> operandB

endmodule