module stage_F_D(
    //input
    clk,
    n_rst,
    en,
    clr,
    Instr_F,
    PC_F,
    PC_Plus4_F,

    //output
    Instr_D,
    PC_D,
    PC_Plus4_D
);
    input           clk,n_rst,en,clr;
    input [31:0]    Instr_F;
    input [31:0]    PC_F;
    input [31:0]    PC_Plus4_F;

    output [31:0]   Instr_D;
    output [31:0]   PC_D;
    output [31:0]   PC_Plus4_D;


    wire [31:0]     Instr_F1, PC_F1, PC_Plus4_F1;

    assign Instr_F1     = (clr == 1'b1)? 32'b0 : Instr_F;
    assign PC_F1        = (clr == 1'b1)? 32'b0 : PC_F;
    assign PC_Plus4_F1  = (clr == 1'b1)? 32'b0 : PC_Plus4_F;

    flopenr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0033) 
    ) u_flopenr_32bit_Instr_F_D ( 
        .clk(clk), 
        .reset(n_rst), 
        .en(en),
        .d(Instr_F1), 
        .q(Instr_D)
    );
    
    flopenr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h1000_0000)
    ) u_flopr_32bit_PC_F_D ( 
        .clk(clk), 
        .reset(n_rst), 
        .en(en),
        .d(PC_F1), 
        .q(PC_D)
    );

    flopenr #( 
        .WIDTH(32), 
        .RESET_VALUE(32'h0000_0000)
    ) u_flopr_32bit_PC_Plus4_F_D ( 
        .clk(clk), 
        .reset(n_rst), 
        .en(en),
        .d(PC_Plus4_F1),
        .q(PC_Plus4_D)
    );

endmodule