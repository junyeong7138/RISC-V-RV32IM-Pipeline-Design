module rv32im_cpu(
	clk,
	n_rst,
	PC,
	Instr,
	MemWrite,
	ALUResult,
	WriteData,
	ReadData,
    ByteEnable
);

	parameter   RESET_PC = 32'h1000_0000;

    //input
    input           clk, n_rst;
    input [31:0]    Instr, ReadData;

    //output
    output          MemWrite;
    output [31:0]   PC, ALUResult, WriteData;
    output [3:0]    ByteEnable;

    wire            N_flag, Z_flag, C_flag, V_flag;
    wire            ALUSrc, RegWrite, branch, Csr, MemWrite_in;  
    wire [1:0]      ResultSrc, ALUSrcA;
    wire [1:0]      PCSrc;
    wire [2:0]      ImmSrc;
    wire [4:0]      ALUControl;
    wire [31:0]     SrcB, Instr_D;

    controller u_controller(
        //input
        .opcode         (Instr_D[6:0]),
        .funct3         (Instr_D[14:12]),
        .funct7         (Instr_D[31:25]),

        //output
        .Branch         (Branch),
        .jal            (jal),
        .jalr           (jalr),
        .ResultSrc      (ResultSrc),
        .MemWrite       (MemWrite_in),
        .ALUControl     (ALUControl),
        .ALUSrcA        (ALUSrcA),
        .ALUSrcB        (ALUSrcB),
        .ImmSrc         (ImmSrc),
        .RegWrite       (RegWrite),
        .Csr            (Csr)
    );


	datapath #(
		.RESET_PC(RESET_PC)
	) i_datapath(
        //input
		 .clk           (clk),
        .n_rst          (n_rst),
        .Instr          (Instr),
        .ReadData       (ReadData),

        .Branch         (Branch),
        .jal            (jal),
        .jalr           (jalr),
        .ResultSrc      (ResultSrc),
        .MemWrite       (MemWrite_in),
        .ALUControl     (ALUControl),
        .ALUSrcA        (ALUSrcA),
        .ALUSrcB        (ALUSrcB),
        .ImmSrc         (ImmSrc),
        .RegWrite       (RegWrite),
        .Csr            (Csr),

        //output
        .Instr_D        (Instr_D),
        .PC             (PC),
        .ALUResult      (ALUResult),
        .WriteData      (WriteData),
        .ByteEnable     (ByteEnable),
        .MemWrite_out   (MemWrite)
	);


endmodule
