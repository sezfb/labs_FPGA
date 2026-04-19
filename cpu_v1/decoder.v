module decoder(
    input [1:0] opcode, // instr[15:14]

    output immediate,
    output calculate,
    output copy,
    output condition
);

    // one-hot decode
    assign {condition, copy, calculate, immediate} = 4'b0001 << opcode;

endmodule
