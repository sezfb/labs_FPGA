// fixed_size code variant

module RAM(
    input  [7:0] d_in,
    input  [3:0] addr,
    input         w_e,
    input         clk,

    output reg [7:0] d_out
);
    reg [7:0] ram [0:15]; // 16 cells 8 bit each
    always @(posedge clk) begin
        if (w_e) begin
            ram[addr] <= d_in;
        end
        else begin 
            d_out <= ram[addr];
        end
    end
endmodule
