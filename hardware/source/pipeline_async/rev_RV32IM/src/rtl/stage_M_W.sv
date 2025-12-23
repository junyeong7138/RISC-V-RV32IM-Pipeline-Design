module stage_M_W(
    input           clk,
    input           n_rst,

    input [1:0]     ResultSrc_M,
    input           RegWrite_M,
    input [31:0]    ALUResult_M,
    input [31:0]    PC_Plus4_M,
    input [31:0]    Instr_M,
    input [31:0]    ReadData,

    output [1:0]    ResultSrc_W,
    output          RegWrite_W,
    output [31:0]   ALUResult_W,
    output [31:0]   PC_Plus4_W,
    output [31:0]   Instr_W,
    output [31:0]   ReadData_W
);

    flopr #( 
        .WIDTH(2), 
        .RESET_VALUE(2'h0) 
    ) u_flopr_2bit_ResultSrc_M_W ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(ResultSrc_M), 
        .q(ResultSrc_W) 
    );

    flopr #( 
        .WIDTH(1), 
        .RESET_VALUE(1'h0) 
    ) u_flopr_1bit_RegWrite_M_W ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(RegWrite_M), 
        .q(RegWrite_W) 
    );
    
    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0000) 
    ) u_flopr_32bit_ALUResult_M_W ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(ALUResult_M), 
        .q(ALUResult_W) 
    );

    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0000) 
    ) u_flopr_32bit_ReadData_M_W ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(ReadData), 
        .q(ReadData_W)
    );
    
    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0000) 
    ) u_flopr_32bit_PCPlus4_M_W ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(PC_Plus4_M), 
        .q(PC_Plus4_W)
    );
    
    flopr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0033) 
    ) u_flopr_32bit_Instr_M_W ( 
        .clk(clk), 
        .reset(n_rst), 
        .d(Instr_M), 
        .q(Instr_W) 
    );

endmodule