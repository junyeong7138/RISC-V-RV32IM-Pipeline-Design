module maindec(
    opcode,

    Branch,
    jal,
    jalr,
    ResultSrc,
    MemWrite,
    ALUop,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegWrite,
    Csr
);
    // input
    input [6:0] opcode;
    // output
    output reg       MemWrite, ALUSrcB, RegWrite, jal, jalr;
    output reg [1:0] ResultSrc, ALUSrcA;
    output reg [1:0] ALUop;
    output reg [2:0] ImmSrc;
    output reg       Branch, Csr;

    always@(*) begin
        if(opcode == 7'b111_0011) Csr = 1'b1;
        else                      Csr = 1'b0;
    end

    always@(*) begin    // main decoder
        case(opcode)
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b1_xxx_00_0_0_00_0_10_0_0;     // R-type
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b1_000_00_1_0_00_0_10_0_0;     // I-type ALU
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b1_000_00_1_0_01_0_00_0_0;     // I-type Load
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b0_001_00_1_1_00_0_00_0_0;     // S-type
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b0_010_00_0_0_00_1_01_0_0;     // B-type
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b1_011_00_0_0_10_0_00_1_0;     // jal
            7'b110_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b1_000_00_1_0_10_0_10_0_1;     // jarl 
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b1_100_10_1_0_00_0_00_0_0;     // U-type(lui)
            7'b001_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b1_100_01_1_0_00_0_00_0_0;     // auipc
            7'b111_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'b1_101_00_1_0_00_0_10_0_0;     // csrrw, csrrwi
            default : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, jal, jalr} = 15'h0;
        endcase
    end


endmodule