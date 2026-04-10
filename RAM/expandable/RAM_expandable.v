// explandable code variant

module RAM_expandable
#( 
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(   
    input  [WIDTH-1:0] d_in,
    input  [$clog2(DEPTH)-1:0] addr, // log2(16) = 4
    input                      w_e,
    input                      clk,

    output reg [WIDTH-1:0] d_out
);

    reg [WIDTH-1:0] ram [0:DEPTH-1];

    always @(posedge clk) begin
        if (w_e) begin
            ram[addr] <= d_in;
        end
        else begin 
            d_out <= ram[addr];
        end
    end

endmodule