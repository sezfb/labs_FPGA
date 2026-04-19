module calculator (
    input [7:0] operandA,
    input [7:0] operandB,
    input [2:0] opcode, // = MUX
    output reg [8:0] result
);

    always @(*) begin // asynch
        case (opcode)

            3'b000: result = operandA + operandB;
            3'b001: result = operandA - operandB;

            // [8 bit] == 0, result => 9 bit
            3'b010: result = {1'b0, (operandA & operandB)};
            3'b011: result = {1'b0, (operandA | operandB)};
            3'b100: result = {1'b0, (operandA ^ operandB)};

            // error code state ( == 0 )
            default: result = 9'd0;
        endcase
    end

endmodule