`timescale 1ns/1ps

module RAMF_tb;

    reg  [7:0] d_in;
    reg  [3:0] addr;
    reg        w_e;
    reg        clk;

    wire [7:0] d_out;

    RAM uut (
        .clk(clk),
        .d_in(d_in),
        .addr(addr),
        .w_e(w_e),
        .d_out(d_out)
    );

    initial begin
        clk = 0;
    end

    always #5 clk = ~clk;

    initial begin
        w_e  = 1'b1; addr = 4'b0000; d_in = 8'b00110011; #10;
        w_e  = 1'b1; addr = 4'b0100; d_in = 8'd20; #10;

        w_e  = 1'b0; addr = 4'b0000; #10;
        $display("Address: %b, d_out = %b, %d", addr, d_out, d_out);

        w_e  = 1'b0; addr = 4'b0100; #10;
        $display("Address: %b, d_out = %b, %d", addr, d_out, d_out);

        $finish;
    end

endmodule