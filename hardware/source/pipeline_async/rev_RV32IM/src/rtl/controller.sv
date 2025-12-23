module controller(
    //input
    opcode,
    funct3,
    funct7,

    //output
    Branch,
    jal,
    jalr,
    ResultSrc,
    MemWrite,
    ALUControl,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegWrite,
    Csr
);
    // input
    input [6:0] opcode;
    input [2:0] funct3;
    input [6:0] funct7;

    // output
    output          MemWrite, ALUSrcB, RegWrite, jal, jalr;
    output [1:0]    ResultSrc,ALUSrcA;
    output [2:0]    ImmSrc;
    output [4:0]    ALUControl;
    output          Branch;
    output          Csr;

    wire [1:0] ALUop;

    maindec mdec(
        //input
        .opcode         (opcode),

        //output
        .ResultSrc      (ResultSrc),
        .MemWrite       (MemWrite),
        .ALUSrcA        (ALUSrcA),
        .ALUSrcB        (ALUSrcB),
        .ImmSrc         (ImmSrc),
        .RegWrite       (RegWrite),
        .ALUop          (ALUop),
        .Branch         (Branch),
        .jal            (jal),
        .jalr           (jalr),
        .Csr            (Csr)
    );

    aludec adec(
        .opcode         (opcode),
        .funct3         (funct3),
        .funct7         (funct7),
        .ALUop          (ALUop),
        .ALUControl     (ALUControl)
    );

endmodule
