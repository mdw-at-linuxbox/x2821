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
// one "set" input; i_set0 sets to value "0" (00011).
`default_nettype   none
module decade7(i_clk,
	i_set0,
	i_set9,
	i_advance,
	o_output);

input wire i_clk;
input wire i_set0;
input wire i_set9;
input wire i_advance;

output reg [4:0] o_output;

reg last_set0, last_set9, last_advance;
wire [4:0] next_output;
wire a,b,c,d,e;
wire [4:0] out_plus_1;

assign {a,b,c,d,e} = o_output;
assign out_plus_1 = {
	d & (a | e) | b & (a | e),
	e & (a | b) | c & (a | b),
	a & (b | c) | d & (b | c),
	e & (c | d) | b & (c | d),
	a & (d | e) | c & (d | e)
};

assign next_output = (i_set9 & ~last_set9) ? 5'b101 :
	(i_set0 & ~last_set0) ? 5'b11 :
	(i_advance & ~last_advance) ? out_plus_1 :
	o_output;

always @(posedge i_clk) begin
	last_set0 <= i_set0;
	last_set9 <= i_set9;
	last_advance <= i_advance;
	o_output <= next_output;
end

endmodule
