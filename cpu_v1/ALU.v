module ALU(
    input [15:0] in1, in2,
    input [2:0] instruction,
    output reg [15:0] out
);

    always @(*) begin
        out = 16'b0;

        case (instruction)
            3'b000: out = in1 | in2;
            3'b001: out = ~(in1 & in2);
            3'b010: out = ~(in1 | in2);
            3'b011: out = in1 & in2;
            3'b100: out = in1 + in2;
            3'b101: out = in1 - in2;
            3'b110: out = in1 ^ in2;
            3'b111: out = in1;
        endcase
    end

endmodule