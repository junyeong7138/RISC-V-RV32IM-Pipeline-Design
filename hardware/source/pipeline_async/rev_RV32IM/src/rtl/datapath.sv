module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem

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
    Csr,
    
    Instr_D,
    PC,            // for imem
    ALUResult,     // for dmem
    WriteData,
    ByteEnable,
    MemWrite_out
);

parameter   RESET_PC  = 32'h1000_0000;

    //input
    input           clk, n_rst, ALUSrcB, RegWrite, Csr, Branch, jal, jalr, MemWrite;
    input [31:0]    Instr, ReadData;
    input [1:0]     ResultSrc, ALUSrcA;
    input [2:0]     ImmSrc;
    input [4:0]     ALUControl;
    //output
    output [31:0]   Instr_D;
    output [31:0]   PC, ALUResult;
    output [31:0]   WriteData;
    output [3:0]    ByteEnable;
    output          MemWrite_out;

    wire            N_flag;
    wire            Z_flag;
    wire            C_flag;
    wire            V_flag;

    wire [1:0]      PCSrc;
    wire [31:0]     PC_target;
    wire [31:0]     ImmExt;
    wire [31:0]     SrcA, SrcB;
    wire [31:0]     bef_SrcA, bef_SrcB;
    wire [31:0]     Result;
    wire [31:0]     BE_WD, BE_RD;


    assign WriteData = BE_WD;
    
    // ==================== Fetch Signal ========================
    wire [31:0] PCNext, PC_Plus4_F;
    
    // ==================== Decode Signal =======================
    wire [1:0]  ResultSrc_D;
    wire [4:0]  RdD;
    wire [31:0] Instr_D, PC_D, PC_Plus4_D, ImmExt_D, RD1D, RD2D, RD1E_H, RD2E_H, RD1D_H, RD2D_H;
    
    // ==================== Execute Signal ======================
    wire        Branch_E, jalE, jalrE, MemWrite_E, ALUSrcBE, RegWrite_E;
    wire [1:0]  ALUSrcAE, ResultSrc_E;
    wire [4:0]  Rs1E, Rs2E, RdE, ALUControl_E;
    wire [31:0] ImmExt_E, RDE, PC_E, RD1E, RD2E, ALUResult_E, Instr_E, PC_Plus4_E;
    
    // ==================== Memory Signal =======================
    wire [1:0]  ResultSrc_M;
    wire [31:0] ALUResult_M, Instr_M, PC_Plus4_M, WriteData_M;
    
    // =================== Write Back Signal ====================
    wire        RegWrite_W;
    wire [1:0]  ResultSrc_W;
    wire [31:0] ALUResult_W, Instr_W, PC_Plus4_W, ReadData_W;
    
    // =================== Hazard Unit ==========================
    wire [1:0]  ForwardA, ForwardB, ForwardAD, ForwardBD;
    wire        StallF, StallD, FlushE, FlushD;
    
    // ================== CSR ===================================
    wire [31:0] tohost_csr;
    wire        Csr_E;

    // ==================== Fetch Stage ========================

    mux3 u_pc_mux2(
        .in0(PC_Plus4_F),
        .in1(PC_target),
        .in2(ALUResult_E),
        .sel(PCSrc),
        .out(PCNext)
    );
    
    flopenr #( 
        .WIDTH(32),
        .RESET_VALUE(32'h1000_0000) 
        ) u_pc_register (
         .clk(clk), 
         .reset(n_rst), 
         .en(!StallF),
         .d(PCNext), 
         .q(PC)
        );

    adder u_pc_plus4(
        .a(PC), 
        .b(32'h4), 
        .ci(1'b0), 
        .sum(PC_Plus4_F),
        .N(),
        .Z(),
        .C(),
        .V()
    );

    stage_F_D u_stage_F_D (
        //input
        .clk                (clk),
        .n_rst              (n_rst),

        // Hazard controll
        .en                 (!StallD),
        .clr                (FlushD),

        .Instr_F            (Instr),
        .PC_F               (PC),
        .PC_Plus4_F         (PC_Plus4_F),
        
        //output
        .Instr_D            (Instr_D),
        .PC_D               (PC_D),
        .PC_Plus4_D         (PC_Plus4_D)
    );

    // ==================== Decode Stage =======================

   extend u_Extend(
        .ImmSrc             (ImmSrc),
        .in                 (Instr_D[31:7]),
        .out                (ImmExt_D)
    );

    reg_file_async rf (
        .clk                (clk),
        .clkb               (clk),
        .we                 (RegWrite_W),
        .ra1                (Instr_D[19:15]),
        .ra2                (Instr_D[24:20]),
        .wa                 (Instr_W[11:7]),
        .wd                 (Result),
        .rd1                (RD1D),
        .rd2                (RD2D)
    );

    mux3 u_result_rd1_mux3(
        .in0                (RD1D),
        .in1                (Result),
        .in2                (ALUResult_M),
        .sel                (ForwardAD),
        .out                (RD1D_H)
    );


    mux3 u_result_rd2_mux3(
        .in0                (RD2D),
        .in1                (Result),
        .in2                (ALUResult_M),
        .sel                (ForwardBD),
        .out                (RD2D_H)
    );


    stage_D_E u_stage_D_E(
        //input
        .clk                (clk),
        .n_rst              (n_rst),

        .clr                (FlushE),
        .Branch_D           (Branch),
        .jalD               (jal),
        .jalrD              (jalr),
        .ResultSrc_D        (ResultSrc),
        .MemWriteD          (MemWrite),
        .ALUControl_D       (ALUControl),
        .ALUSrcAD           (ALUSrcA),
        .ALUSrcBD           (ALUSrcB),
        .RegWrite_D         (RegWrite),
        .Csr_D              (Csr),

        .Instr_D            (Instr_D),
        .RD1D               (RD1D_H),
        .RD2D               (RD2D_H),
        .PC_D               (PC_D),
        .ImmExt_D           (ImmExt_D),
        .PC_Plus4_D         (PC_Plus4_D),

        //output
        .Branch_E           (Branch_E),
        .jalE               (jalE),
        .jalrE              (jalrE),
        .ResultSrc_E        (ResultSrc_E),
        .MemWrite_E         (MemWrite_E),
        .ALUControl_E       (ALUControl_E),
        .ALUSrcAE           (ALUSrcAE),
        .ALUSrcBE           (ALUSrcBE),
        .RegWrite_E         (RegWrite_E),
        .Csr_E              (Csr_E),

        .Instr_E            (Instr_E),
        .RD1E               (RD1E),
        .RD2E               (RD2E),
        .PC_E               (PC_E),
        .ImmExt_E           (ImmExt_E),
        .PC_Plus4_E         (PC_Plus4_E)

    );

    // ==================== Execute Stage ======================


    mux3 u_result_bef_SrcA_mux3(
        .in0                (RD1E),
        .in1                (Result),
        .in2                (ALUResult_M),
        .sel                (ForwardA),
        .out                (RD1E_H)
    );

    mux3 u_result_bef_SrcB_mux3(
        .in0                (RD2E),
        .in1                (Result),
        .in2                (ALUResult_M),
        .sel                (ForwardB),
        .out                (RD2E_H)
    );


    Branch_Logic u_branch_logic(
        .Branch             (Branch_E),
        .jal                (jalE),
        .jalr               (jalrE),
        .funct3             (Instr_E[14:12]),
        .N_flag             (N_flag),
        .Z_flag             (Z_flag),
        .C_flag             (C_flag),
        .V_flag             (V_flag),
        .SrcB               (SrcB),
        .PCSrc              (PCSrc)
    );

    adder u_pc_target(
        .a                  (PC_E), 
        .b                  (ImmExt_E), 
        .ci                 (1'b0), 
        .sum                (PC_target),
        .N                  (),
        .Z                  (),
        .C                  (),
        .V                  ()
    );

    mux2 u_alu_mux_srcb(
        .in0                (RD2E_H),
        .in1                (ImmExt_E),
        .sel                (ALUSrcBE),
        .out                (SrcB)
    );

    mux3 u_alu_mux_srca(
        .in0                (RD1E_H),
        .in1                (PC_E),
        .in2                (32'b0),
        .sel                (ALUSrcAE),
        .out                (SrcA)
    );


    alu u_ALU(
        .a_in               (SrcA),
        .b_in               (SrcB),
        .ALUControl         (ALUControl_E),
        .result             (ALUResult_E),
        .aN                 (N_flag),
        .aZ                 (Z_flag),
        .aC                 (C_flag),
        .aV(                V_flag)

    );

    stage_E_M u_stage_E_M(
        .clk                (clk),
        .n_rst              (n_rst),

        .ResultSrc_E        (ResultSrc_E),
        .MemWrite_E         (MemWrite_E),
        .RegWrite_E         (RegWrite_E),
        .Instr_E            (Instr_E),
        .ALUResult_E        (ALUResult_E),
        .WriteData_E        (RD2E_H),
        .PC_Plus4_E         (PC_Plus4_E),

        .ResultSrc_M        (ResultSrc_M),
        .MemWrite_M         (MemWrite_M),
        .RegWrite_M         (RegWrite_M),
        .Instr_M            (Instr_M),
        .ALUResult_M        (ALUResult_M),
        .WriteData_M        (WriteData_M),
        .PC_Plus4_M         (PC_Plus4_M)
    );

    // ==================== Memory Stage =======================

    assign MemWrite_out = MemWrite_M;
    assign ALUResult    = ALUResult_M;

    stage_M_W u_stage_M_W(
        //input
        .clk                (clk),
        .n_rst              (n_rst),

        .ResultSrc_M        (ResultSrc_M),
        .RegWrite_M         (RegWrite_M),
        .ALUResult_M        (ALUResult_M),
        .PC_Plus4_M         (PC_Plus4_M),
        .Instr_M            (Instr_M),
        .ReadData           (ReadData),

        //output
        .ResultSrc_W        (ResultSrc_W),
        .RegWrite_W         (RegWrite_W),
        .ALUResult_W        (ALUResult_W),
        .PC_Plus4_W         (PC_Plus4_W),
        .Instr_W            (Instr_W),
        .ReadData_W         (ReadData_W)
    );

    // =================== Write Back Stage ====================

    be_logic u_be_logic_wd (
        .AddrLast2          (ALUResult_M[1:0]),
        .funct3             (Instr_M[14:12]),
        .WD                 (WriteData_M),
        .RD                 (),
        .BE_WD              (BE_WD),
        .BE_RD              (),
        .ByteEnable         (ByteEnable)
    );

    be_logic u_be_logic_rd (
        .AddrLast2          (ALUResult_W[1:0]),
        .funct3             (Instr_W[14:12]),
        .WD                 (),
        .RD                 (ReadData_W),
        .BE_WD              (),
        .BE_RD              (BE_RD),
        .ByteEnable         ()
    );

    mux3 u_result_mux4(
        .in0                (ALUResult_W),
        .in1                (BE_RD),
        .in2                (PC_Plus4_W),
        .sel                (ResultSrc_W),
        .out                (Result)
    );

    //==========================================================

    // ================= CSR ====================
    csr u_tohost_csr(
        .clk                    (clk),
        .n_rst                  (n_rst),
        .Csr                    (Csr_E),
        .RD1_path               (RD1E_H),
        .ImmExt_path            (ImmExt_E),
        .instr                  (Instr_E),
        .tohost_csr             (tohost_csr)
    );

    // ================ Hazard Unit ==============
    hazard_unit u_hazard_unit(
        .Instr_D                (Instr_D),
        .Instr_E                (Instr_E),
        .Instr_M                (Instr_M),
        .Instr_W                (Instr_W),
        .RegWrite_M             (RegWrite_M),
        .RegWrite_W             (RegWrite_W),
        .ResultSrc_E0           (ResultSrc_E[0]),
        .PCSrcE                 (PCSrc),

        .ForwardA               (ForwardA),
        .ForwardB               (ForwardB),
        .ForwardAD              (ForwardAD),
        .ForwardBD              (ForwardBD),
        .StallF                 (StallF),
        .StallD                 (StallD),
        .FlushE                 (FlushE),
        .FlushD                 (FlushD)
);

endmodule
