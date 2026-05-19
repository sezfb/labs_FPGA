module alu_8_tb;

reg  [7:0] A, B;
reg  [1:0] select;
wire [7:0] Y;

alu_8 dut (
    .A(A),
    .B(B),
    .select(select),
    .Y(Y)
);

initial begin
    $display("Time A B select Y");
    $display("Time    A    B  sel   Y");
    $monitor("%4t   %3d %3d  %b   %3d", $time, A, B, select, Y);

    A = 8'd10; B = 8'd3;

    select = 2'b00; #50;
    select = 2'b01; #50;
    select = 2'b10; #50;
    select = 2'b11; #50;

    A = 8'd25; B = 8'd7;

    select = 2'b00; #50;
    select = 2'b01; #50;
    select = 2'b10; #50;
    select = 2'b11; #50;

    #50 $finish;
end

initial begin
    $dumpfile("alu_8.vcd");
    $dumpvars(0, alu_8_tb);
end

endmodule