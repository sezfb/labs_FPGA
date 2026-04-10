`timescale 1ns/1ps

module RAM_tb;

    parameter WIDTH = 8;
    parameter DEPTH = 16;

    reg  [WIDTH-1:0] d_in;
    reg  [$clog2(DEPTH)-1:0] addr;
    reg                      w_e;
    reg                      clk;

    wire [WIDTH-1:0] d_out;

    RAM_expandable #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .d_in(d_in),
        .addr(addr),
        .w_e(w_e),
        .d_out(d_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        w_e  = 1'b1; addr = 0; d_in = 8'h33; #10;
        w_e  = 1'b1; addr = 4; d_in = 20;    #10;

        w_e  = 1'b0; addr = 0;               #10;
        $display("Address: %b, d_out = %b, %d", addr, d_out, d_out);

        w_e  = 1'b0; addr = 4;               #10;
        $display("Address: %b, d_out = %b, %d", addr, d_out, d_out);

        $finish;
    end

endmodule