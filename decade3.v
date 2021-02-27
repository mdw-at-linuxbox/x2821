// "2 of 5" decade counter.
// based on sequence from pdf page 100
// of Y24-3503-0_2821_Field_Engineering_Maintenance_Diagrams_Dec68.pdf
// {a,b,c,d,e}:
//	10010	1	01100	6
//	10001	2	01010	7
//	01001	3	00110	8
//	11000	4	00101	9
//	10100	5	00011	0
// also on pdf page 98 (and many other places); observe the pentagram
//	"buffer ring stepping sequence".
//	vertices A B C D E mark 1 bits; connecting lines between any
//	two labelled with 0-9 indicating corresponding values.
// also on pdf page 126 top left corner observe table w/ cols "pos" "2/5"
//	(turned 90 degrees clockwise)
// one "set" input; i_clear sets to value "1" (10010).
`default_nettype   none
module decade3(i_clk,
	i_clear,
	i_advance,
	o_output);

input wire i_clk;
input wire i_clear;

input wire i_advance;
output wire [4:0] o_output;

wire a,b,c,d,e;

latch1 u_a(i_clk,
	i_clear | i_advance & e & (b | d),
	i_advance & a & (c | e),
	a);

latch1 u_b(i_clk,
	i_advance & a & (c | e),
	i_clear | i_advance & b & (a | d),
	b);

latch1 u_c(i_clk,
	i_advance & b & (a | d),
	i_clear | i_advance & c & (b | e),
	c);

latch1 u_d(i_clk,
	i_clear | i_advance & c & (b | e),
	i_advance & d & (a | c),
	d);

latch1 u_e(i_clk,
	i_advance & d & (a | c),
	i_clear | i_advance & e & (b | d),
	e);

assign o_output = {a,b,c,d,e};

endmodule
