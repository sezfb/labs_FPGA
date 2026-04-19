module ALU(
    input  [15:0] in1,
    input  [15:0] in2,
    input  [2:0]  instruction,
    output reg [15:0] out
);

    always @(*) begin
        case (instruction)
            3'b000: out = in1 + in2;   // ADD
            3'b001: out = in1 - in2;   // SUB
            3'b010: out = in1 & in2;   // AND
            3'b011: out = in1 | in2;   // OR
            3'b100: out = in1 ^ in2;   // XOR
            3'b101: out = in1;         // PASS
            3'b110: out = in1 << 1;    // SHL
            3'b111: out = in1 >> 1;    // SHR
            default: out = 16'b0;
        endcase
    end

endmodule
