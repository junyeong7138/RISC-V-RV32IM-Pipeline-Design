module stage_D_E(
    input               clk,
    input               n_rst,

    input               clr,
    input               Branch_D,
    input               jalD,
    input               jalrD,
    input   [1:0]       ResultSrc_D,
    input               MemWriteD,
    input   [4:0]       ALUControl_D,
    input   [1:0]       ALUSrcAD,
    input               ALUSrcBD,
    input               RegWrite_D,
    input               Csr_D,
    
    input   [31:0]      Instr_D,
    input   [31:0]      RD1D,
    input   [31:0]      RD2D,
    input   [31:0]      PC_D,
    input   [31:0]      ImmExt_D,
    input   [31:0]      PC_Plus4_D,
 
    output              Branch_E,
    output              jalE,
    output              jalrE,
    output   [1:0]      ResultSrc_E,
    output              MemWrite_E,
    output   [4:0]      ALUControl_E,
    output   [1:0]      ALUSrcAE,
    output              ALUSrcBE,
    output              RegWrite_E,
    output              Csr_E,

    output   [31:0]     Instr_E,
    output   [31:0]     RD1E,
    output   [31:0]     RD2E,
    output   [31:0]     PC_E,
    output   [31:0]     ImmExt_E,
    output   [31:0]     PC_Plus4_E
);


    reg            Branch_D1, jalD1 , jalrD1, MemWriteD1, ALUSrcBD1, RegWrite_D1, Csr_D1;
    reg  [1:0]     ResultSrc_D1, ALUSrcAD1;
    reg  [4:0]     ALUControl_D1;
    reg  [31:0]    Instr_D1, RD1D1, RD2D1, PC_D1, ImmExt_D1, PC_Plus4_D1;


    always @(*) begin
        if (clr == 1'b1) begin
            Branch_D1       =   1'b0;
            jalD1           =   1'b0;
            jalrD1          =   1'b0;
            ResultSrc_D1    =   2'b0;
            MemWriteD1      =   1'b0;
            ALUControl_D1   =   5'b0;
            ALUSrcAD1       =   2'b0;
            ALUSrcBD1       =   1'b0;
            RegWrite_D1     =   1'b0;
            Csr_D1          =   1'b0;

            Instr_D1        =   32'b0;
            RD1D1           =   32'b0;
            RD2D1           =   32'b0;
            PC_D1            =   32'b0;
            ImmExt_D1       =   32'b0;
            PC_Plus4_D1     =   32'b0;
        end
        else begin
            Branch_D1       =   Branch_D;
            jalD1           =   jalD;
            jalrD1          =   jalrD;
            ResultSrc_D1    =   ResultSrc_D;
            MemWriteD1      =   MemWriteD;
            ALUControl_D1   =   ALUControl_D;
            ALUSrcAD1       =   ALUSrcAD;
            ALUSrcBD1       =   ALUSrcBD;
            RegWrite_D1     =   RegWrite_D;
            Csr_D1          =   Csr_D;

            Instr_D1        =   Instr_D;
            RD1D1           =   RD1D;
            RD2D1           =   RD2D;
            PC_D1            =   PC_D;
            ImmExt_D1       =   ImmExt_D;
            PC_Plus4_D1     =   PC_Plus4_D;
        end
    end


    flopr #( 
        .WIDTH(1), 
        .RESET_VALUE(1'h0) 
    ) u_flopenr_1bit_Branch2 ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(Branch_D1), 
        .q(Branch_E) 
    );

    flopr #( 
        .WIDTH(1), 
        .RESET_VALUE(1'h0) 
    ) u_flopenr_1bit_jal2 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(jalD1), 
        .q(jalE) 
    );

    flopr #( 
        .WIDTH(1), 
        .RESET_VALUE(1'h0) 
    ) u_flopenr_1bit_jalr2 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(jalrD1), 
        .q(jalrE) 
    );

    flopr #( 
        .WIDTH(2), 
        .RESET_VALUE(2'h0) 
    ) u_flopenr_2bit_ResultSrc2 ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(ResultSrc_D1), 
        .q(ResultSrc_E) 
    );

    flopr #(
        .WIDTH(1), 
        .RESET_VALUE(1'h0) 
    ) u_flopenr_1bit_MemWrite2 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(MemWriteD1), 
        .q(MemWrite_E) 
    );

    flopr #( 
        .WIDTH(5), 
        .RESET_VALUE(5'h00) 
    ) u_flopenr_5bit_ALUControl2 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(ALUControl_D1), 
        .q(ALUControl_E) 
    );

    flopr #( 
        .WIDTH(2), 
        .RESET_VALUE(2'h0) 
    ) u_flopenr_2bit_ALUSrcA2 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(ALUSrcAD1), 
        .q(ALUSrcAE)
    );

    flopr #( 
        .WIDTH(1), 
        .RESET_VALUE(1'h0) 
    ) u_flopenr_1bit_ALUSrcB2 ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(ALUSrcBD1), 
        .q(ALUSrcBE) 
    );

    flopr #( 
        .WIDTH(1), 
        .RESET_VALUE(1'h0) 
    ) u_flopenr_1bit_RegWrite2 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(RegWrite_D1), 
        .q(RegWrite_E) 
    );

    flopr #( 
        .WIDTH(1), 
        .RESET_VALUE(1'h0)
    ) u_flopenr_1bit_Csr2 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(Csr_D1), 
        .q(Csr_E)
    );

    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0033)
    ) u_flopenr_32bit_Instr2 ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(Instr_D1), 
        .q(Instr_E)
    );

    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0000)
    ) u_flopenr_32bit_RD2 ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(RD1D1), 
        .q(RD1E)
    );

    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0000)
     ) u_flopenr_32bit_RD22 ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(RD2D1), 
        .q(RD2E)
    );

    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h1000_0000)
    ) u_flopenr_32bit_PC2 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(PC_D1), 
        .q(PC_E)
    );

    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0000)
    ) u_flopenr_32bit_ImmExt2 ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(ImmExt_D1), 
        .q(ImmExt_E)
    );

    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0000)
    ) u_flopenr_32bit_PCPlus42 ( 
        .clk(clk), 
        .reset(n_rst),  
        .d(PC_Plus4_D1), 
        .q(PC_Plus4_E)
    );

endmodule