`timescale 1ns / 1ns

module summator_tb;
    reg a;
    reg b;
    reg c;
    wire s;
    wire h_c;

    integer i;

    // Unit Under Test
    summator uut_inst (
        .a(a),
        .b(b),
        .c(c),
        .s(s),
        .h_c(h_c)
    );

    initial begin
        $dumpfile("summator_tb.vcd");
        $dumpvars(0, summator_tb);

        $display("Time\tA B C | S C_out");
        $display("------------------------");

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, c} = i;
            #10;
            $display("%0t\t%b %b %b | %b   %b", $time, a, b, c, s, h_c);
        end

        $display("Test complete");
        $finish;
    end
endmodule