module stage_E_M(
    input           clk,
    input           n_rst,

    input [1:0]     ResultSrc_E,
    input           MemWrite_E,
    input           RegWrite_E,
    input [31:0]    Instr_E,
    input [31:0]    ALUResult_E,
    input [31:0]    WriteData_E,
    input [31:0]    PC_Plus4_E,

    output [1:0]    ResultSrc_M,
    output          MemWrite_M,
    output          RegWrite_M,
    output [31:0]   Instr_M,
    output [31:0]   ALUResult_M,
    output [31:0]   WriteData_M,
    output [31:0]   PC_Plus4_M

);

flopr #( .WIDTH(2), .RESET_VALUE(2'h0) ) u_flopr_2bit_ResultSrc3 ( .clk(clk), .reset(n_rst), .d(ResultSrc_E), .q(ResultSrc_M) );
flopr #( .WIDTH(1), .RESET_VALUE(1'h0) ) u_flopr_1bit_MemWrite3 ( .clk(clk), .reset(n_rst), .d(MemWrite_E), .q(MemWrite_M) );
flopr #( .WIDTH(1), .RESET_VALUE(1'h0) ) u_flopr_1bit_RegWrite3 ( .clk(clk), .reset(n_rst), .d(RegWrite_E), .q(RegWrite_M) );

flopr #( .WIDTH(32), .RESET_VALUE(32'h0000_0033) ) u_flopr_32bit_Instr3 ( .clk(clk), .reset(n_rst), .d(Instr_E), .q(Instr_M) );
flopr #( .WIDTH(32), .RESET_VALUE(32'h0000_0000) ) u_flopr_32bit_ALUResult3 ( .clk(clk), .reset(n_rst), .d(ALUResult_E), .q(ALUResult_M) );
flopr #( .WIDTH(32), .RESET_VALUE(32'h0000_0000) ) u_flopr_32bit_WriteData3 ( .clk(clk), .reset(n_rst), .d(WriteData_E), .q(WriteData_M) );
flopr #( .WIDTH(32), .RESET_VALUE(32'h0000_0000) ) u_flopr_32bit_PCPlus43 ( .clk(clk), .reset(n_rst), .d(PC_Plus4_E), .q(PC_Plus4_M) );

endmodule