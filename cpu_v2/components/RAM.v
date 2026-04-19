module RAM_expandable
#(
    parameter WIDTH = 16,
    parameter DEPTH = 256
)
(
    input  [WIDTH-1:0]              d_in,
    input  [$clog2(DEPTH)-1:0]      addr,
    input                           w_e,
    input                           clk,
    output [WIDTH-1:0]              d_out
);

    reg [WIDTH-1:0] ram [0:DEPTH-1];
    integer i;

    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            ram[i] = {WIDTH{1'b0}};
    end

    always @(posedge clk) begin
        if (w_e)
            ram[addr] <= d_in;
    end

    assign d_out = ram[addr];

endmodule
