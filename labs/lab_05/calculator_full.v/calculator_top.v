module calculator_top (

    input  [7:0] operandA,
    input  [7:0] operandB,
    input  [2:0] opcode,

    // intirenal result of the calculator (9 bit)
    output [8:0] result,

    // 3 seven-segment displays for hundreds, tens, and ones
    output [6:0] seg_hundreds,
    output [6:0] seg_tens,
    output [6:0] seg_ones
);

    wire [8:0] calc_result;

    wire [3:0] hundreds;
    wire [3:0] tens;
    wire [3:0] ones;

    calculator calc (
        .operandA(operandA),
        .operandB(operandB),
        .opcode(opcode),
        .result(calc_result)
    );

    // output result to the top-level port
    assign result = calc_result;

    // extract hundreds, tens, and ones digits from the 9-bit result
    assign hundreds = calc_result / 100;
    assign tens     = (calc_result % 100) / 10;
    assign ones     = calc_result % 10;
    /*
                                * in stead of % and / ( better for synthesis in FPGA )
    bin9_to_bcd bcd_conv (
        .bin(calc_result),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );
    */

    seg7_decoder segH (
        .digit(hundreds),
        .seg(seg_hundreds)
    );

    seg7_decoder segT (
        .digit(tens),
        .seg(seg_tens)
    );

    seg7_decoder segO (
        .digit(ones),
        .seg(seg_ones)
    );

endmodule