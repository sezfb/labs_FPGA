module alu_8 (
    input  [7:0] A,
    input  [7:0] B,
    input  [1:0] select,
    output reg [7:0] Y
);

always @(*) begin
    case (select)

        // not (A + B)
        2'b00: Y = ~(A + B);

        // not (A * B)
        2'b01: Y = ~(A & B);

        // A + B + 1
        2'b10: Y = A + B + 8'd1;

        // (A + not B) + 1
        2'b11: Y = A + ~B + 8'd1;

    endcase
end

endmodule