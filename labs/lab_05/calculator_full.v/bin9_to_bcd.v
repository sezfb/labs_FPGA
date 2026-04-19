module bin9_to_bcd (
    input  [8:0] bin,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);

    integer i;

    // temporary registers
    reg [3:0] h;
    reg [3:0] t;
    reg [3:0] o;

    always @(*) begin
        // init digits to 0
        h = 0;
        t = 0;
        o = 0;

        // process each bit (from MSB to LSB)
        for (i = 8; i >= 0; i = i - 1) begin

            // if digit >= 5 → add 3
            if (h >= 5) h = h + 3;
            if (t >= 5) t = t + 3;
            if (o >= 5) o = o + 3;

            // shift left:
            // {h, t, o} = {h, t, o} << 1, and insert next bit of bin
            h = {h[2:0], t[3]};
            t = {t[2:0], o[3]};
            o = {o[2:0], bin[i]};
        end

        // assign outputs
        hundreds = h;
        tens     = t;
        ones     = o;
    end

endmodule