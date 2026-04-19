module CPU(
    input clk,
    input reset
);

    // PC
    wire [7:0] pc;
    wire       jump_en;
    wire [7:0] jump_addr;

    // instruction memory
    wire [15:0] instr;

    // decoder
    wire immediate, calculate, copy, condition;

    // fields
    wire [2:0] dst, src1, src2, alu_op;
    wire [7:0] imm;

    // register file
    wire [7:0] reg1, reg2;

    // ALU
    wire [7:0] alu_result;

    // write-back
    wire [7:0] write_data;
    wire       write_en;

    // condition
    reg cond_true;

    // * PC
    PC pc_inst(
        .clk(clk),
        .reset(reset),
        .increment(~jump_en), // +2 if no jump
        .load(jump_en),       // load jump address if branch taken
        .d_in(jump_addr),
        .d_out(pc)
    );

    // * 16-bit instruction memory
    RAM_expandable #(
        .WIDTH(16),
        .DEPTH(16)
    ) instr_mem (
        .d_in(16'b0),
        .addr(pc[4:1]),   // word addressing: pc = 0, 2, 4,... => addr = 0, 1, 2,...
        .w_e(1'b0),
        .clk(clk),
        .d_out(instr)
    );

    // * decoder
    decoder dec(
        .opcode(instr[15:14]),
        .immediate(immediate),
        .calculate(calculate),
        .copy(copy),
        .condition(condition)
    );

    // * field split
    assign dst    = instr[13:11];
    assign src1   = instr[10:8];
    assign src2   = instr[7:5];
    assign alu_op = instr[4:2];
    assign imm    = instr[7:0];

    // * GPRs
    GPRs regs(
        .write_data(write_data),
        .read_addr1(src1),
        .read_addr2(src2),
        .write_addr(dst),
        .write_en(write_en),
        .clk(clk),
        .reset(reset),
        .read_data1(reg1),
        .read_data2(reg2)
    );

    // * ALU
    ALU alu(
        .in1(reg1),
        .in2(reg2),
        .instruction(alu_op),
        .out(alu_result)
    );

    // * write-back
    assign write_data =
        immediate ? imm        :
        calculate ? alu_result :
        copy      ? reg1       :
        8'b0;

    assign write_en = immediate | calculate | copy;

    // * condition logic
    always @(*) begin
        cond_true = 1'b0;

        case (alu_op)
            3'b000: cond_true = 1'b0;                          // False
            3'b001: cond_true = (reg1 == 8'b0);               // == 0
            3'b010: cond_true = reg1[7];                      // < 0
            3'b011: cond_true = reg1[7] | (reg1 == 8'b0);     // <= 0
            3'b100: cond_true = (reg1 != 8'b0);               // != 0
            3'b101: cond_true = ~reg1[7];                     // >= 0
            3'b110: cond_true = (~reg1[7]) & (reg1 != 8'b0);  // > 0
            3'b111: cond_true = 1'b1;                         // True
        endcase
    end

    // * jump logic
    assign jump_en   = condition & cond_true;
    assign jump_addr = {imm[7:1], 1'b0}; // force even instruction address

endmodule
