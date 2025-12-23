`timescale 1ns/100ps

module flopr #(
  parameter WIDTH = 32,
  parameter RESET_VALUE = 0
)
(
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    always @(posedge clk or negedge reset)
        if(!reset) q<=RESET_VALUE;
        else      q<=d;

endmodule