// "2 of 5" decade counter.
// ald: 33.23.00.0
// based on sequence from pdf page 98
// of Y24-3503-0_2821_Field_Engineering_Maintenance_Diagrams_Dec68.pdf
//	abcde	xfer	daceb	hammer
//	10010	1	11000	4
//	10001	2	01010	7
//	01001	3	00011	0	set3
//	11000	4	01001	3
//	10100	5	01100	6
//	01100	6	00101	9	set6
//	01010	7	10001	2
//	00110	8	10100	5
//	00101	9	00110	8
//	00011	0	10010	1	set0
// pdf page 100 shows the intended binary interpretation
// on pdf page 98 (and many other places); observe the pentagram
//	"buffer ring stepping sequence".
//	vertices A B C D E mark 1 bits; connecting lines between any
//	two labelled with 0-9 indicating corresponding values.
// on pdf page 126 top left corner observe table w/ cols "pos" "2/5"
//	(turned 90 degrees clockwise)
// three "set" cases; i_set0 sets to value "0" (00011).
//	0	bnd	cne	abcdd
//	1	0	0	00011	set0	1
//	0	1	0	01001	set3	0
//	0	1	1	01100	set6	9
// in the ald, bnd is 'set 0 and 9', cne is 'set9'
`default_nettype   none
module decade14(i_clk,
	i_set0,
	i_setbnd,
	i_setcne,
	i_advance,
	o_output);

input wire i_clk;
input wire i_set0;
input wire i_setbnd;
input wire i_setcne;
input wire i_advance;

output reg [4:0] o_output;

reg last_advance;
wire [4:0] next_output;
wire a,b,c,d,e;
wire [4:0] out_plus_1;
wire set3;
wire set6;
wire advance;

assign {a,b,c,d,e} = o_output;
assign out_plus_1 = {
	d & (a | e) | b & (a | e),
	e & (a | b) | c & (a | b),
	a & (b | c) | d & (b | c),
	e & (c | d) | b & (c | d),
	a & (d | e) | c & (d | e)
};
assign set3 = i_setbnd;
assign set6 = i_setcne;
assign advance = i_advance & ~last_advance;

assign next_output = set6 ? 5'b1100 :
	set3 ? 5'b1001 :
	i_set0 ? 5'b11 :
	advance ? out_plus_1 :
	o_output;

always @(posedge i_clk) begin
	last_advance <= i_advance;
	o_output <= next_output;
end

endmodule
