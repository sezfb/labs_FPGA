module PC(
    input        clk,
    input        reset,
    input        increment,
    input        load,
    input  [7:0] d_in,
    output [7:0] d_out
);

    reg [7:0] pc;

    always @(posedge clk) begin
        if (reset)
            pc <= 8'b0;
        else if (load)
            pc <= d_in;
        else if (increment)
            pc <= pc + 8'd1;
    end

    assign d_out = pc;

endmodule
