module CPU(
    input         clk,
    input         reset,
    input  [15:0] input_port,
    output [15:0] output_port
);

    // PC / control flow
    wire [7:0] pc;
    wire       jump_en;
    wire [7:0] jump_addr;

    // instruction memory
    wire [15:0] instr;

    // decoder
    wire immediate, calculate, copy, condition;

    // instruction fields
    wire [2:0] dst        = instr[13:11];
    wire [2:0] src1       = instr[10:8];
    wire [2:0] src2       = instr[7:5];
    wire [2:0] alu_op     = instr[4:2];

    wire [7:0] imm8       = instr[7:0];
    wire       imm_high   = instr[10];

    wire [2:0] copy_src   = instr[10:8];
    wire [2:0] cond_reg   = instr[13:11];
    wire [2:0] cond_code  = instr[10:8];
    wire [7:0] cond_addr  = instr[7:0];

    // register file
    wire [15:0] reg1;
    wire [15:0] reg2;

    // ALU
    wire [15:0] alu_result;

    // write-back
    wire [15:0] write_data;
    wire        write_en;

    // condition
    reg cond_true;

    // ===== FIXED PC CONTROL =====
    assign jump_en = 1'b0;

    PC pc_inst(
        .clk(clk),
        .reset(reset),
        .increment(1'b1),
        .load(1'b0),
        .d_in(8'b0),
        .d_out(pc)
    );
        // ===== INSTRUCTION MEMORY =====
    RAM_expandable #(
        .WIDTH(16),
        .DEPTH(256)
    ) instr_mem (
        .d_in(16'b0),
        .addr(pc),
        .w_e(1'b0),
        .clk(clk),
        .d_out(instr)
    );

    // ===== DECODER =====
    decoder dec(
        .opcode(instr[15:14]),
        .immediate(immediate),
        .calculate(calculate),
        .copy(copy),
        .condition(condition)
    );

    // ===== REGISTERS =====
    GPRs regs(
        .write_data(write_data),
        .read_addr1(
            condition ? cond_reg :
            immediate ? dst      :
                        src1
        ),
        .read_addr2(src2),
        .write_addr(dst),
        .write_en(write_en),
        .bypass_en(calculate | copy),
        .clk(clk),
        .reset(reset),
        .input_port(input_port),
        .output_port(output_port),
        .read_data1(reg1),
        .read_data2(reg2)
    );

    // ===== ALU =====
    ALU alu(
        .in1(reg1),
        .in2(reg2),
        .instruction(alu_op),
        .out(alu_result)
    );

    // ===== WRITE BACK =====
    assign write_data =
        immediate ? (
            imm_high ? {imm8, reg1[7:0]} : {reg1[15:8], imm8}
        ) :
        calculate ? alu_result :
        (copy && (copy_src == 3'b111)) ? {{8{1'b0}}, imm8} :
        copy ? reg1 :
        16'b0;

    assign write_en = immediate | calculate | copy;

    // ===== CONDITION LOGIC =====
    always @(*) begin
        case (cond_code)
            3'b000: cond_true = 1'b0;
            3'b001: cond_true = (reg1 == 16'b0);
            3'b010: cond_true = reg1[15];
            3'b011: cond_true = reg1[15] | (reg1 == 16'b0);
            3'b100: cond_true = (reg1 != 16'b0);
            3'b101: cond_true = ~reg1[15];
            3'b110: cond_true = (~reg1[15]) & (reg1 != 16'b0);
            3'b111: cond_true = 1'b1;
            default: cond_true = 1'b0;
        endcase
    end

    assign jump_addr = cond_addr;

endmodule