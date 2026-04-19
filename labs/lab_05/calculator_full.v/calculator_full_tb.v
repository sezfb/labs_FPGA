`timescale 1ns/1ps

module calculator_full_tb;

    reg [7:0] operandA;
    reg [7:0] operandB;
    reg [2:0] opcode;

    wire [8:0] result;
    wire [6:0] seg_hundreds;
    wire [6:0] seg_tens;
    wire [6:0] seg_ones;

    calculator_top uut (
        .operandA(operandA),
        .operandB(operandB),
        .opcode(opcode),
        .result(result),
        .seg_hundreds(seg_hundreds),
        .seg_tens(seg_tens),
        .seg_ones(seg_ones)
    );

initial begin
    $display("");
    $display("time |  op |    A |    B |   res |   seg_h |   seg_t |   seg_o");
    $display("----------------------------------------------------------------|");

    // TEST 1: 15 + 3 = 18
    operandA = 8'd15;
    operandB = 8'd3;
    opcode   = 3'b000;
    #1;
    $display("%4t | %3b | %4d | %4d | %5d | %7b | %7b | %7b",
             $time/1000, opcode, operandA, operandB, result,
             seg_hundreds, seg_tens, seg_ones);

    // TEST 2: 15 - 3 = 12
    #9;
    opcode = 3'b001;
    #1;
    $display("%4t | %3b | %4d | %4d | %5d | %7b | %7b | %7b",
             $time/1000, opcode, operandA, operandB, result,
             seg_hundreds, seg_tens, seg_ones);

    // TEST 3: 15 AND 3 = 3
    #9;
    opcode = 3'b010;
    #1;
    $display("%4t | %3b | %4d | %4d | %5d | %7b | %7b | %7b",
             $time/1000, opcode, operandA, operandB, result,
             seg_hundreds, seg_tens, seg_ones);

    // TEST 4: 15 OR 3 = 15
    #9;
    opcode = 3'b011;
    #1;
    $display("%4t | %3b | %4d | %4d | %5d | %7b | %7b | %7b",
             $time/1000, opcode, operandA, operandB, result,
             seg_hundreds, seg_tens, seg_ones);

    // TEST 5: 15 XOR 3 = 12
    #9;
    opcode = 3'b100;
    #1;
    $display("%4t | %3b | %4d | %4d | %5d | %7b | %7b | %7b",
             $time/1000, opcode, operandA, operandB, result,
             seg_hundreds, seg_tens, seg_ones);

    // TEST 6: 255 + 1 = 256
    #9;
    operandA = 8'd255;
    operandB = 8'd1;
    opcode   = 3'b000;
    #1;
    $display("%4t | %3b | %4d | %4d | %5d | %7b | %7b | %7b",
             $time/1000, opcode, operandA, operandB, result,
             seg_hundreds, seg_tens, seg_ones);

    // TEST 7: 255 + 255 = 510
    #9;
    operandA = 8'd255;
    operandB = 8'd255;
    opcode   = 3'b000;
    #1;
    $display("%4t | %3b | %4d | %4d | %5d | %7b | %7b | %7b",
             $time/1000, opcode, operandA, operandB, result,
             seg_hundreds, seg_tens, seg_ones);

    $display("----------------------------------------------------------------|");
    $finish;
end

endmodule