`timescale 1ns/1ps

module ALU_tb;
    reg [7:0] a;
    reg [7:0] b;
    reg [1:0] code;
    reg clk;
    wire [7:0] c;

    ALU uut (.clk(clk), .c(c), .a(a), .b(b), .code(code));

    initial begin
        a = 8'b11001100;
        b = 8'b11000011;
        clk = 0;
        code = 2'b00;
    end

    always #5 clk = ~clk;

    initial begin 
        repeat(4) begin
            #10;
            $display("code = %b, a = %b, b = %b, c = %b", code, a, b, c); 
            code++;
        end
        $finish;
    end
endmodule