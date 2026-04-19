module GPRs(
    input [7:0] write_data,
    input [2:0] read_addr1,
    input [2:0] read_addr2,
    input [2:0] write_addr,
    input write_en,
    input clk,
    input reset,

    output [7:0] read_data1,  // async read
    output [7:0] read_data2   // async read
);

    reg [7:0] R [0:7];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                R[i] <= 8'b0; // full reset
        end else begin
            if (write_en)
                R[write_addr] <= write_data; // sync write
        end
    end

    assign read_data1 = (write_en && (write_addr == read_addr1)) ? write_data : R[read_addr1]; // bypass
    assign read_data2 = (write_en && (write_addr == read_addr2)) ? write_data : R[read_addr2]; // bypass

endmodule


/*
    value next tact

            if (load && addr < 5)
                R[addr] <= value;
            if (upload && addr < 5)
                out <= R[addr];
*/
