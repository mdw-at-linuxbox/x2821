`default_nettype   none
module pdetect1(i_clk, v, o);

input wire i_clk;
input wire v;
output wire o;
reg lastv;

assign o = v & ~lastv;

always @(posedge i_clk)
	lastv = v;

endmodule
