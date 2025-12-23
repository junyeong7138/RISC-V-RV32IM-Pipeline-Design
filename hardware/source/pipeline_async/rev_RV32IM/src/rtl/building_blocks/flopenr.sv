/*
module flopenr(
	clk,
	n_rst,
	en,
	d,
	q
);
	input clk, n_rst, en;
	input [31:0] d;
	output reg [31:0] q;	

	always@(posedge clk or negedge n_rst) begin 
		if(!n_rst) begin
			q <= 32'h0;
		end
		else begin
			if(en)
				q <= d;
		end		
	end

endmodule
*/

`timescale 1ns/100ps

module flopenr #(
  parameter WIDTH = 32,
  parameter RESET_VALUE = 0
)
(
    input clk,
    input reset,
	input en,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk or negedge reset)begin
        if(!reset) q<=RESET_VALUE;
        else begin
			if(en)
				q <= d;
		end		
	end

endmodule