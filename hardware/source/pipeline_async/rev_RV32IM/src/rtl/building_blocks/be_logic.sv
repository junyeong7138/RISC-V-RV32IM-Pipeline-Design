module be_logic(
    WD,
    RD,
    AddrLast2,
    funct3,
    BE_WD,
    BE_RD,
    ByteEnable
);
    input      [31:0]  WD,RD;
    input      [1:0]   AddrLast2;
    input      [2:0]   funct3;
    output reg [31:0]  BE_WD,BE_RD;
    output reg [3:0]   ByteEnable; 

    always@(*) begin
        if(funct3 == 3'b000)  begin//lb
            if(AddrLast2 == 2'b00) 
                BE_RD = {{24{RD[7]}}, RD[7:0]};
            else if(AddrLast2 == 2'b01)
                BE_RD = {{24{RD[15]}}, RD[15:8]};
            else if(AddrLast2 == 2'b10) 
                BE_RD = {{24{RD[23]}}, RD[23:16]};
            else if(AddrLast2 == 2'b11)
                BE_RD = {{24{RD[31]}}, RD[31:24]};
            else 
                BE_RD = 32'b0;
        end

        else if (funct3 == 3'b001) begin
            if(AddrLast2 == 2'b00 || AddrLast2 == 2'b01)
                BE_RD = {{16{RD[15]}}, RD[15:0]};
            else if(AddrLast2 == 2'b10 || AddrLast2 == 2'b11)
                BE_RD = {{16{RD[31]}}, RD[31:16]};
            else 
                BE_RD = 32'b0;    
        end


        else if (funct3 == 3'b100) begin
            if(AddrLast2 == 2'b00)
                BE_RD = {24'b0, RD[7:0]};
            else if(AddrLast2 == 2'b01)
                BE_RD = {24'b0, RD[15:8]};
            else if(AddrLast2 == 2'b10)
                BE_RD = {24'b0, RD[23:16]};
            else if(AddrLast2 == 2'b11)
                BE_RD = {24'b0, RD[31:24]};
            else 
                BE_RD = 32'b0;    
        end

        else if (funct3 == 3'b101) begin
            if(AddrLast2 == 2'b00 || AddrLast2 == 2'b01)
                BE_RD = {16'b0, RD[15:0]};
            else if(AddrLast2 == 2'b10 || AddrLast2 == 2'b11)
                BE_RD = {16'b0, RD[31:16]};
            else 
                BE_RD = 32'b0;    
        end
  
        else if (funct3 == 3'b010)
            BE_RD = RD;    
        else
            BE_RD = 32'b0;
    end

   
    always@(*)begin
        if (funct3 == 3'b000) begin //sb
            if(AddrLast2 == 2'b00) 
                BE_WD = {24'b0, WD[7:0]};
            else if(AddrLast2 == 2'b01) 
                BE_WD = {16'b0, WD[7:0], 8'b0};
            else if(AddrLast2 == 2'b10) 
                BE_WD = {8'b0, WD[7:0], 16'b0};
            else if(AddrLast2 == 2'b11) 
                BE_WD = {WD[7:0], 24'b0};
            else 
                BE_WD = 32'b0;
            
        end

        else if (funct3 == 3'b001)begin //sh
            if(AddrLast2 == 2'b00 || AddrLast2 == 2'b01) 
                BE_WD = {16'b0, WD[15:0]};
            else if(AddrLast2 == 2'b10 || AddrLast2 == 2'b11) 
                BE_WD = {WD[15:0], 16'b0};
            else 
                BE_WD = 32'b0;
        end

        else if (funct3 == 3'b010)  //sw
            BE_WD = WD;
        else 
            BE_WD = 32'b0;
    end

    always@(*)begin
        if (funct3==3'b000) begin
            if(AddrLast2==2'b00)                        ByteEnable=4'b0001;
            else if(AddrLast2==2'b01)                   ByteEnable=4'b0010;
            else if(AddrLast2==2'b10)                   ByteEnable=4'b0100;
            else if(AddrLast2==2'b11)                   ByteEnable=4'b1000;
            else                                        ByteEnable=4'b1111;   
        end

        else if (funct3==3'b001)begin
            if(AddrLast2==2'b00||AddrLast2==2'b01)      ByteEnable=4'b0011;
            else if(AddrLast2==2'b10||AddrLast2==2'b11) ByteEnable=4'b1100;
            else                                        ByteEnable=4'b1111;   
        end

        else if (funct3==3'b010)                        ByteEnable=4'b1111;   
        else                                            ByteEnable=4'b1111;   
    end

endmodule
