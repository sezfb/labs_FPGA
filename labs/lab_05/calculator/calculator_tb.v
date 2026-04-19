`timescale 1ns/1ps

module calculator_tb;

    reg [7:0] operandA;
    reg [7:0] operandB;
    reg [2:0] opcode;

    wire [8:0] result;

    calculator uut (
        .operandA(operandA),
        .operandB(operandB),
        .opcode(opcode),
        .result(result)
    );

    initial begin

        // header
        $display("\ntime(ns)\topcode\tA\tB\tresult");

        // 15 + 3 = 18
        operandA = 8'd15;
        operandB = 8'd3;
        opcode   = 3'b000;
        #1;
        $display("%0t\t\t%b\t%0d\t%0d\t%0d", $time/1000, opcode, operandA, operandB, result);

        // 15 - 3 = 12
        #9;
        opcode = 3'b001;
        #1;
        $display("%0t\t\t%b\t%0d\t%0d\t%0d", $time/1000, opcode, operandA, operandB, result);


        // 15 AND 3 = 3
        #9;
        opcode = 3'b010;
        #1;
        $display("%0t\t\t%b\t%0d\t%0d\t%0d", $time/1000, opcode, operandA, operandB, result);

        // 15 OR 3 = 15
        #9;
        opcode = 3'b011;
        #1;
        $display("%0t\t\t%b\t%0d\t%0d\t%0d", $time/1000, opcode, operandA, operandB, result);


        // 15 XOR 3 = 12
        #9;
        opcode = 3'b100;
        #1;
        $display("%0t\t\t%b\t%0d\t%0d\t%0d", $time/1000, opcode, operandA, operandB, result);


        // 255 + 1 = 256 ( overflow test )
        #9;
        operandA = 8'd255;
        operandB = 8'd1;
        opcode   = 3'b000;
        #1;
        $display("%0t\t\t%b\t%0d\t%0d\t%0d", $time/1000, opcode, operandA, operandB, result);
        $display("--------------------------------------------------|");
        $finish;
    end

endmodule