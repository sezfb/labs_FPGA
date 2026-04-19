module CPU_tb;

    reg clk = 0;
    reg reset = 1;
    reg [15:0] input_port = 0;
    wire [15:0] output_port;

    CPU dut (
        .clk(clk),
        .reset(reset),
        .input_port(input_port),
        .output_port(output_port)
    );

    integer OP, DST, SRC1, SRC2;
    integer A, B;
    integer i;
    integer stop_pc;

    // clock
    always #5 clk = ~clk;

    initial begin
        $display("=== START ===");

        // +args
        if (!$value$plusargs("OP=%d", OP))     OP   = 0;
        if (!$value$plusargs("DST=%d", DST))   DST  = 0;
        if (!$value$plusargs("SRC1=%d", SRC1)) SRC1 = 0;
        if (!$value$plusargs("SRC2=%d", SRC2)) SRC2 = 1;
        if (!$value$plusargs("A=%d", A))       A    = 5;
        if (!$value$plusargs("B=%d", B))       B    = 3;

        input_port = A;

        // очистка программы
        for (i = 0; i < 16; i = i + 1)
            dut.instr_mem.ram[i] = 16'b0;

        // По умолчанию:
        // 0: LOADL R0, A
        // 1: LOADL R1, B
        // 2: test instruction
        // 3: COPY OUT, DST
        // stop when PC reaches 4
        dut.instr_mem.ram[0] = {2'b00, 3'b000, 1'b0, 2'b00, A[7:0]}; // LOADL R0, A
        dut.instr_mem.ram[1] = {2'b00, 3'b001, 1'b0, 2'b00, B[7:0]}; // LOADL R1, B
        dut.instr_mem.ram[3] = {2'b10, 3'b111, DST[2:0], 8'b0};      // COPY OUT, R[DST]
        stop_pc = 4;

        case (OP)
            // ALU ops: opcode=01, fields {01, dst, src1, src2, alu_op, 00}
            0:  dut.instr_mem.ram[2] = {2'b01, DST[2:0], SRC1[2:0], SRC2[2:0], 3'b000, 2'b00}; // ADD
            1:  dut.instr_mem.ram[2] = {2'b01, DST[2:0], SRC1[2:0], SRC2[2:0], 3'b001, 2'b00}; // SUB
            2:  dut.instr_mem.ram[2] = {2'b01, DST[2:0], SRC1[2:0], SRC2[2:0], 3'b010, 2'b00}; // AND
            3:  dut.instr_mem.ram[2] = {2'b01, DST[2:0], SRC1[2:0], SRC2[2:0], 3'b011, 2'b00}; // OR
            4:  dut.instr_mem.ram[2] = {2'b01, DST[2:0], SRC1[2:0], SRC2[2:0], 3'b100, 2'b00}; // XOR
            5:  dut.instr_mem.ram[2] = {2'b01, DST[2:0], SRC1[2:0], 3'b000,    3'b101, 2'b00}; // PASS
            6:  dut.instr_mem.ram[2] = {2'b01, DST[2:0], SRC1[2:0], 3'b000,    3'b110, 2'b00}; // SHL
            7:  dut.instr_mem.ram[2] = {2'b01, DST[2:0], SRC1[2:0], 3'b000,    3'b111, 2'b00}; // SHR

            // COPY: opcode=10, fields {10, dst, src, imm8}
            8:  dut.instr_mem.ram[2] = {2'b10, DST[2:0], SRC1[2:0], 8'b0}; // COPY DST, SRC1

            // immediate: opcode=00, fields {00, dst, imm_high, 00, imm8}
            9:  dut.instr_mem.ram[2] = {2'b00, DST[2:0], 1'b0, 2'b00, A[7:0]}; // LOADL
            10: dut.instr_mem.ram[2] = {2'b00, DST[2:0], 1'b1, 2'b00, A[7:0]}; // LOADH

            // LOAD full 16-bit = LOADL + LOADH
            11: begin
                dut.instr_mem.ram[0] = {2'b00, DST[2:0], 1'b0, 2'b00, A[7:0]}; // LOADL DST, A
                dut.instr_mem.ram[1] = {2'b00, DST[2:0], 1'b1, 2'b00, B[7:0]}; // LOADH DST, B
                dut.instr_mem.ram[2] = {2'b10, 3'b111,  DST[2:0], 8'b0};       // COPY OUT, DST
                dut.instr_mem.ram[3] = 16'b0;
                stop_pc = 3;
            end

            default: begin
                $display("ERROR: unsupported OP=%0d", OP);
                $finish;
            end
        endcase

        #50;
        reset = 0;
        $display("RESET OFF at t=%0t", $time);

        repeat (20) begin
            #10;
            $display(
                "t=%0t PC=%0d | R0=%0d R1=%0d R2=%0d R3=%0d R4=%0d R5=%0d OUT=%0d",
                $time,
                dut.pc_inst.d_out,
                dut.regs.R[0],
                dut.regs.R[1],
                dut.regs.R[2],
                dut.regs.R[3],
                dut.regs.R[4],
                dut.regs.R[5],
                output_port
            );

            if (dut.pc_inst.d_out == stop_pc) begin
                $display("=== RESULT ===");
                $display(
                    "R0=%0d R1=%0d R2=%0d R3=%0d R4=%0d R5=%0d OUT=%0d",
                    dut.regs.R[0],
                    dut.regs.R[1],
                    dut.regs.R[2],
                    dut.regs.R[3],
                    dut.regs.R[4],
                    dut.regs.R[5],
                    output_port
                );
                $finish;
            end
        end

        $display("TIMEOUT");
        $finish;
    end

endmodule

/*

- Testbench Control (vvp +args)

| Param | Meaning                               | Range[decimal] |
|------|----------------------------------------|----------------|
| OP   | Operation type                         | 0–10           |
| A    | Value A (IMM10 / IMM8)                 | 0–1023 / 0–255 |
| B    | Value B (for R1 init)                  | 0–1023 / 0–255 |
| DST  | Destination (0–5=R, 7=OUT)             | 0–7            |
| SRC1 | Source 1 (0–5=R, 6=IN, 7=special)      | 0–7            |
| SRC2 | Source 2 (0–5=R, 6=IN, 7=special)      | 0–7            |

---

IMM values are smaller than register width (16-bit) and are zero-extended before write  
Registers (R0–R5) and output_port store full 16-bit values (0–65535)  
input_port provides 16-bit data when (SRC = 6)  
output_port (DST = 7) writes directly to external output  
LOADL writes low 8 bits of register: `R[DST][7:0] <= IMM8`  
LOADH writes high 8 bits of register: `R[DST][15:8] <= IMM8`

- Operations (OP)

| OP | Name            | Effect                                      | Required Params |
|----|-----------------|---------------------------------------------|-----------------|
| 0  | ADD             | R[DST] = R[SRC1] + R[SRC2]                  | DST, SRC1, SRC2 |
| 1  | SUB             | R[DST] = R[SRC1] - R[SRC2]                  | DST, SRC1, SRC2 |
| 2  | AND             | R[DST] = R[SRC1] & R[SRC2]                  | DST, SRC1, SRC2 |
| 3  | OR              | R[DST] = R[SRC1] \| R[SRC2]                 | DST, SRC1, SRC2 |
| 4  | XOR             | R[DST] = R[SRC1] ^ R[SRC2]                  | DST, SRC1, SRC2 |
| 5  | PASS            | R[DST] = R[SRC1]                            | DST, SRC1       |
| 6  | SHL             | R[DST] = R[SRC1] << 1                       | DST, SRC1       |
| 7  | SHR             | R[DST] = R[SRC1] >> 1                       | DST, SRC1       |
| 8  | COPY            | DEST = SRC                                  | DST, SRC1       |
| 9  | LOADL           | R[DST][7:0] = A                             | DST, A          |
| 10 | LOADH           | R[DST][15:8] = A                            | DST, A          |
| 11 | LOAD (L+H)      | R[DST] = {B[7:0], A[7:0]}                   | DST, A, B       |

---

- Examples (dec)

| OP | Example Command                                   |
|----|---------------------------------------------------|
| 0  | vvp run +OP=0 +A=5   +B=3   +DST=2 +SRC1=0 +SRC2=1 |
|    | vvp run +OP=0 +A=10  +B=3   +DST=3 +SRC1=0 +SRC2=1 |
| 1  | vvp run +OP=1 +A=10  +B=4   +DST=2 +SRC1=0 +SRC2=1 |
|    | vvp run +OP=1 +A=10  +B=3   +DST=3 +SRC1=0 +SRC2=1 |
| 2  | vvp run +OP=2 +A=5   +B=3   +DST=2 +SRC1=0 +SRC2=1 |
|    | vvp run +OP=2 +A=240 +B=15  +DST=3 +SRC1=0 +SRC2=1 |
| 3  | vvp run +OP=3 +A=5   +B=3   +DST=2 +SRC1=0 +SRC2=1 |
|    | vvp run +OP=3 +A=8   +B=3   +DST=3 +SRC1=0 +SRC2=1 |
| 4  | vvp run +OP=4 +A=5   +B=3   +DST=2 +SRC1=0 +SRC2=1 |
|    | vvp run +OP=4 +A=255 +B=15  +DST=3 +SRC1=0 +SRC2=1 |
| 5  | vvp run +OP=5 +A=5          +DST=2 +SRC1=0         |
|    | vvp run +OP=5 +A=171        +DST=3 +SRC1=0         |
| 6  | vvp run +OP=6 +A=5          +DST=2 +SRC1=0         |
|    | vvp run +OP=6 +A=3          +DST=3 +SRC1=0         |
| 7  | vvp run +OP=7 +A=8          +DST=2 +SRC1=0         |
|    | vvp run +OP=7 +A=8          +DST=3 +SRC1=0         |
| 8  | vvp run +OP=8               +DST=2 +SRC1=0         |
|    | vvp run +OP=8               +DST=7 +SRC1=2         |
| 9  | vvp run +OP=9 +DST=0 +A=52                         |
|    | vvp run +OP=9 +DST=2 +A=52                         |
| 10 | vvp run +OP=10 +DST=0 +A=18                        |
|    | vvp run +OP=10 +DST=2 +A=18                        |
| 11 | vvp run +OP=11 +DST=0 +A=52 +B=18                  |
|    | vvp run +OP=11 +DST=2 +A=52 +B=18                  |

*/