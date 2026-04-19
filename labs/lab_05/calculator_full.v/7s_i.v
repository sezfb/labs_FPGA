/* 

7-segment decoder for decimal digits
seg[6:0] = {a, b, c, d, e, f, g}
                1 -> segment ON
                0 -> segment OFF
 --a--
|     |
f     b
|     |
 --g--
|     |
e     c
|     |
 --d--

*/


module seg7_decoder (
    input  [3:0] digit,
    output reg [6:0] seg
);

    always @(*) begin
        case (digit)
            4'd0: seg = 7'b1111110; // 0
            4'd1: seg = 7'b0110000; // 1
            4'd2: seg = 7'b1101101; // 2
            4'd3: seg = 7'b1111001; // 3
            4'd4: seg = 7'b0110011; // 4
            4'd5: seg = 7'b1011011; // 5
            4'd6: seg = 7'b1011111; // 6
            4'd7: seg = 7'b1110000; // 7
            4'd8: seg = 7'b1111111; // 8
            4'd9: seg = 7'b1111011; // 9

            // if input is not a decimal digit, turn display OFF
            default: seg = 7'b0000000;
        endcase
    end

endmodule