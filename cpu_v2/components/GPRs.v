module GPRs(
    input  [15:0] write_data,
    input  [2:0]  read_addr1,
    input  [2:0]  read_addr2,
    input  [2:0]  write_addr,
    input         write_en,
    input         bypass_en,
    input         clk,
    input         reset,
    input  [15:0] input_port,
    output reg [15:0] output_port,
    output [15:0] read_data1,
    output [15:0] read_data2
);

    reg [15:0] R [0:5];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 6; i = i + 1)
                R[i] <= 16'b0;
            output_port <= 16'b0;
        end else if (write_en) begin
            case (write_addr)
                3'b000: R[0] <= write_data;
                3'b001: R[1] <= write_data;
                3'b010: R[2] <= write_data;
                3'b011: R[3] <= write_data;
                3'b100: R[4] <= write_data;
                3'b101: R[5] <= write_data;
                3'b111: output_port <= write_data;
                default: ;
            endcase
        end
    end

    assign read_data1 =
        (bypass_en && write_en && (write_addr == read_addr1) && (read_addr1 <= 3'b101)) ? write_data :
        (read_addr1 == 3'b000) ? R[0]       :
        (read_addr1 == 3'b001) ? R[1]       :
        (read_addr1 == 3'b010) ? R[2]       :
        (read_addr1 == 3'b011) ? R[3]       :
        (read_addr1 == 3'b100) ? R[4]       :
        (read_addr1 == 3'b101) ? R[5]       :
        (read_addr1 == 3'b110) ? input_port :
                                 16'b0;

    assign read_data2 =
        (bypass_en && write_en && (write_addr == read_addr2) && (read_addr2 <= 3'b101)) ? write_data :
        (read_addr2 == 3'b000) ? R[0]       :
        (read_addr2 == 3'b001) ? R[1]       :
        (read_addr2 == 3'b010) ? R[2]       :
        (read_addr2 == 3'b011) ? R[3]       :
        (read_addr2 == 3'b100) ? R[4]       :
        (read_addr2 == 3'b101) ? R[5]       :
        (read_addr2 == 3'b110) ? input_port :
                                 16'b0;

endmodule