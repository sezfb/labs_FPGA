module decoder(
    input  [1:0] opcode,
    output       immediate,
    output       calculate,
    output       copy,
    output       condition
);

    assign {condition, copy, calculate, immediate} = 4'b0001 << opcode;

endmodule
