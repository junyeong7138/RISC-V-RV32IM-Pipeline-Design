module aludec(
    opcode,
    funct3,
    funct7,
    ALUop,
    ALUControl
);
    // input
    input [6:0] opcode;
    input [2:0] funct3;
    input [1:0] ALUop;
    input [6:0] funct7;
    // output
    output reg [4:0] ALUControl;

    always@(*)begin                // ALU decoder
        if(ALUop == 2'b00)
            ALUControl = 5'b00000;    // lw, sw, lbu
        
        else if(ALUop == 2'b01) begin //Branch
            ALUControl = (funct3 == 3'b000 ||              // BEQ
                          funct3 == 3'b001 ||              // BNE
                          funct3 == 3'b100 ||              // BLT
                          funct3 == 3'b101) ?              // BGE
                                    5'b00001 : 
                                    5'b01010;    // BLTU, BGEU
        end
        
        else if(ALUop == 2'b10) begin
            // ====================== RV32M ==========================
            if (opcode == 7'b011_0011 && funct7 == 7'b0000001) begin
                case (funct3)
                    3'b000: ALUControl = 5'b10000; // MUL
                    3'b001: ALUControl = 5'b10001; // MULH
                    3'b010: ALUControl = 5'b10010; // MULHSU
                    3'b011: ALUControl = 5'b10011; // MULHU
                    3'b100: ALUControl = 5'b10100; // DIV
                    3'b101: ALUControl = 5'b10101; // DIVU
                    3'b110: ALUControl = 5'b10110; // REM
                    3'b111: ALUControl = 5'b10111; // REMU
                endcase
            end
            // ======================================================

            // ====================== RV32I ==========================
            else if (opcode == 7'b011_0111 || opcode == 7'b110_0111)  // lui, jarl
                ALUControl = 5'b00000;
            else if (funct3 == 3'b000 && ({opcode[5], funct7[5]} == 2'b00 || {opcode[5], funct7[5]} == 2'b01 || {opcode[5], funct7[5]} == 2'b10))  // add
                ALUControl = 5'b00000;
            else if (funct3 == 3'b000 && {opcode[5], funct7[5]} == 2'b11)  // sub
                ALUControl = 5'b00001;
            
            else if (funct3 == 3'b001)  //sll, slli
                ALUControl = 5'b00110;
            
            else if (funct3 == 3'b010)  // slt
                ALUControl = 5'b00101;

            else if (funct3 == 3'b011)  // sltu
                ALUControl = 5'b01001;
            
            else if (funct3 == 3'b100)  // xor
                ALUControl = 5'b00100;
            
            else if ((funct3 == 3'b101) && (funct7[5] == 1'b0))
                ALUControl = 5'b00111;  // srl
            
            else if ((funct3 == 3'b101) && (funct7[5] == 1'b1))
                ALUControl = 5'b01000;  // sra, srai

            else if (funct3 == 3'b110)  // or
                ALUControl = 5'b00011;
            
            else if (funct3 == 3'b111)  // and
                ALUControl = 5'b00010;
            
            else 
                ALUControl = 5'hx;
        end
    end
        

endmodule
