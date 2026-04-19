`timescale 1ns/1ps

module mux_tb;

    reg  [7:0] operandA;
    reg  [7:0] operandB;
    reg        sel_in;

    wire [7:0] out_mux;

    mux uut (
        .operandA(operandA),
        .operandB(operandB),
        .sel_in(sel_in),
        .out_mux(out_mux)
    );

    initial begin
        
        // header
        $display("\ntime\tA\tB\tsel\tout");
        $monitor("%0t\t%0d\t%0d\t%b\t%0d\n", $time, operandA, operandB, sel_in, out_mux);

        // sel_in = 0 
        operandA = 8'd15;
        operandB = 8'd3;
        sel_in   = 1'b0;
        #10;
        sel_in   = 1'b1;

        $finish;
    end

endmodule