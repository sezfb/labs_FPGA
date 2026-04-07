`timescale 1ns/1ps

module cntSignal_tb;

reg x1, x2, x3, x4;
wire y2, y1, y0;

cntSignal uut (
    .x1(x1),
    .x2(x2),
    .x3(x3),
    .x4(x4),
    .y2(y2),
    .y1(y1),
    .y0(y0)
);

initial begin
    $dumpfile("cntSignal.vcd");
    $dumpvars(0, cntSignal_tb);

    $display("x1 x2 x3 x4 | y2 y1 y0");

    for (integer i = 0; i < 16; i = i + 1) begin
        {x1, x2, x3, x4} = i;
        #10;
        $display("%b  %b  %b  %b  |  %b  %b  %b", x1, x2, x3, x4, y2, y1, y0);
    end

    $finish;
end

endmodule