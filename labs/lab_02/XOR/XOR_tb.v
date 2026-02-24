`timescale 1ns / 1ns

module XOR_tb;
    reg X0;
    reg X1;
    wire Y;

    XOR uut_inst (.X0(X0), .X1(X1), .Y(Y));

    initial begin
        $dumpfile("XOR_tb.vcd");
        $dumpvars(0, XOR_tb);
        $display("Time\tX0 X1 | Y");
        $display("----------------");
        X0 = 0; X1 = 0; #10;
        $display("%0t\t%b  %b  | %b", $time, X0, X1, Y);
        X0 = 0; X1 = 1; #10;
        $display("%0t\t%b  %b  | %b", $time, X0, X1, Y);
        X0 = 1; X1 = 0; #10;
        $display("%0t\t%b  %b  | %b", $time, X0, X1, Y);
        X0 = 1; X1 = 1; #10;
        $display("%0t\t%b  %b  | %b", $time, X0, X1, Y);
        $display("Test complete");
        $finish;
    end
endmodule
