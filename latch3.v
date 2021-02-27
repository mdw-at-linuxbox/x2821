`default_nettype   none
module latch3(i_clk, i_set,
	i_clear, o_out);

parameter W=1;

input wire i_clk;
input wire [W-1:0] i_set;
input wire i_clear;
output wire [W-1:0] o_out;
reg [W-1:0] saved;

genvar i;
generate for (i = 0; i < W; i = i + 1) begin
assign o_out[i] = i_set[i] ? 1'b1 : i_clear ? 1'b0 : saved[i];
always @(posedge i_clk)
	saved[i] <= o_out[i];
end
endgenerate

endmodule
