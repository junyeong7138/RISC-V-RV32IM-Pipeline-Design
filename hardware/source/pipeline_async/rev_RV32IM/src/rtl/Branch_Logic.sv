module Branch_Logic(
    Branch,
    jal,
    jalr,
    funct3,
    N_flag,
    Z_flag,
    C_flag,
    V_flag,
    SrcB,
    PCSrc
);

input           Branch, jal, jalr, N_flag, Z_flag, C_flag, V_flag;
input [2:0]     funct3;
input [31:0]    SrcB;

output [1:0]    PCSrc;

reg Btaken;
reg [1:0]PCSrc_1;

always@(*) begin  
        if(funct3 == 3'b000 && Branch == 1'b1) begin
            if(Z_flag == 1'b1)                                              Btaken = 1'b1;  //BEQ
            else                                                            Btaken = 1'b0;   
       end
       else if(funct3 == 3'b001 && Branch == 1'b1) begin
            if(Z_flag != 1'b1)                                              Btaken = 1'b1;  //BNE
            else                                                            Btaken = 1'b0;
       end
        else if(funct3 == 3'b100 && Branch == 1'b1) begin
            if(N_flag!=V_flag)                                              Btaken = 1'b1;  //BLT
            else                                                            Btaken = 1'b0;
        end
        else if(funct3 == 3'b110 && Branch == 1'b1) begin
           if(((SrcB != 32'b0) && (C_flag == 1'b0)))                        Btaken = 1'b1;    //BLTU
            else                                                            Btaken = 1'b0;   
        end
        else if(funct3 == 3'b111 && Branch == 1'b1) begin
           if(((SrcB != 32'b0) && (C_flag == 1'b1)) || ((SrcB == 32'b0)))   Btaken = 1'b1;  //BGEU
            else                                                            Btaken = 1'b0;   
        end
        else if(funct3 == 3'b101 && Branch == 1'b1) begin
           if(N_flag == V_flag)                                             Btaken = 1'b1;   //BLT
            else                                                            Btaken = 1'b0;
        end
    else
         Btaken =1'b0 ;
    end

       always@ (*) begin
        if (Btaken == 1'b1)     PCSrc_1 = 2'b01;
        else if (jal == 1'b1)   PCSrc_1 = 2'b01;
        else if (jalr == 1'b1)  PCSrc_1 = 2'b10;
        else                    PCSrc_1 = 2'b00;
    end

    assign PCSrc = PCSrc_1;

endmodule