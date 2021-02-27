// 1 of 12 decoder
`default_nettype   none
module dod2(i_clk, i_reset, i_in, o_out, o_match);

/* verilator lint_off UNUSED */
input wire i_clk;
input wire i_reset;
/* verilator lint_on UNUSED */

input wire [11:0] i_in;
output wire [3:0] o_out;	// binary encoding
output wire o_match;

dodecode2 u0(i_in, o_out, o_match);

endmodule
