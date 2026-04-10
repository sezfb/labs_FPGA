module ALU(
    input  [7:0] a,
    input  [7:0] b,
    input  [1:0] code,
    input        clk,
    
    output [7:0] c
);
    reg [7:0] temp;
    always @(posedge clk) begin
        case (code)
            2'b00: temp <= a | b;     // OR
            2'b01: temp <= a & b;     // AND
            2'b10: temp <= ~(a | b);  // NOR
            2'b11: temp <= ~(a & b);  // NAND
        endcase
    end
    assign c = temp;
endmodule

"
module ALU(
    input  [7:0] a,
    input  [7:0] b,
    input  [1:0] code,
    input        clk,
    output [7:0] c
);
    reg [7:0] temp;
    always @(posedge clk) begin
        case (code)
            2'b00: temp <= a | b;     // OR
            2'b01: temp <= a & b;     // AND
            2'b10: temp <= ~(a | b);  // NOR
            2'b11: temp <= ~(a & b);  // NAND
        endcase
    end
    assign c = temp;
endmodule

------------------
synchronous logic

 a[7:0] ----\
             \
              >---[ ALU logic: OR / AND / NOR / NAND ]---[ register temp ]--- c[7:0]
             /                                              ^
 b[7:0] ----/                                               |
                                                           clk
 code[1:0] -----------------------------------------------/

"

"
module ALU(
    input  [7:0] a,
    input  [7:0] b,
    input  [1:0] code,
    output reg [7:0] c
);

    always @(*) begin
        case (code)
            2'b00: c = a | b;     // OR
            2'b01: c = a & b;     // AND
            2'b10: c = ~(a | b);  // NOR
            2'b11: c = ~(a & b);  // NAND
            default: c = 8'b00000000;
        endcase
    end
endmodule

-------------------
combinatorial logic

 a[7:0] ----\
             \
              >---[ ALU logic: OR / AND / NOR / NAND ]--- c[7:0]
             /
 b[7:0] ----/

 code[1:0] ------(choose operation)

"