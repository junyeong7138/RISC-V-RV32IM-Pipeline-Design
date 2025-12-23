module hazard_unit(
    Instr_D,
    Instr_E,
    Instr_M,
    Instr_W,
    RegWrite_M,
    RegWrite_W,
    ResultSrc_E0,
    PCSrcE,

    ForwardA,
    ForwardB,
    ForwardAD,
    ForwardBD,
    StallF,
    StallD,
    FlushE,
    FlushD
);

    input       [31:0]      Instr_D, Instr_E, Instr_M, Instr_W;
    input                   RegWrite_M, RegWrite_W, ResultSrc_E0;
    input       [1:0]       PCSrcE;

    output reg  [1:0]       ForwardA, ForwardB, ForwardAD, ForwardBD;
    output                  StallF, StallD, FlushE, FlushD;

    reg lwStall;

    wire    [4:0]   Rs1D;
    wire    [4:0]   Rs2D;
    wire    [4:0]   Rs1E;
    wire    [4:0]   Rs2E;
    wire    [4:0]   RdE;
    wire    [4:0]   RdM;
    wire    [4:0]   RdW;

    // ================= Decode Stage ==============
    assign Rs1D          = Instr_D[19:15];
    assign Rs2D          = Instr_D[24:20];
    // ================= Execute Stage =============
    assign Rs1E          = Instr_E[19:15];
    assign Rs2E          = Instr_E[24:20];
    assign RdE           = Instr_E[11:7];

    // ================= Memory Stage  ==============
    assign RdM           = Instr_M[11:7];

    // ================ WriteBack Stage =============
    assign RdW           = Instr_W[11:7];

    always @(*) begin
        if (((Rs1E == RdM) && RegWrite_M == 1'b1) && Rs1E != 5'h00)         ForwardA = 2'b10;
        else if (((Rs1E == RdW) && RegWrite_W == 1'b1) && Rs1E != 5'h00)    ForwardA = 2'b01;
        else                                                                ForwardA = 2'b00;
    end

    always @(*) begin
        if (((Rs2E == RdM) && RegWrite_M == 1'b1) && (Rs2E != 5'h00))       ForwardB = 2'b10;
        else if (((Rs2E == RdW) && RegWrite_W == 1'b1) && (Rs2E != 5'h00))  ForwardB = 2'b01;
        else                                                                ForwardB = 2'b00;
    end

    always @(*) begin
        if (((Rs1D == RdM) && RegWrite_M == 1'b1) && Rs1D != 5'h00)         ForwardAD = 2'b10;
        else if (((Rs1D == RdW) && RegWrite_W == 1'b1) && Rs1D != 5'h00)    ForwardAD = 2'b01;
        else                                                                ForwardAD = 2'b00;
    end

    always @(*) begin
        if (((Rs2D == RdM) && RegWrite_M == 1'b1) && Rs2D != 5'h00)         ForwardBD = 2'b10;
        else if (((Rs2D == RdW) && RegWrite_W == 1'b1) && Rs2D != 5'h00)    ForwardBD = 2'b01;
        else                                                                ForwardBD = 2'b00;
    end

    assign lwStall = (((Rs1D == RdE) || (Rs2D == RdE)) && ResultSrc_E0);

    assign StallF = lwStall;
    assign StallD = lwStall;
    assign FlushE = lwStall || PCSrcE;
    assign FlushD = (PCSrcE == 2'b00)? 1'b0 : 1'b1;

endmodule