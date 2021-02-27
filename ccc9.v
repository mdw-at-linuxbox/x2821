`default_nettype   none
module ccc9(i_clk, i_reset,
	i_ebcdic,
	o_holes);

input wire i_clk;
input wire i_reset;
input wire [7:0] i_ebcdic;
output reg [11:0] o_holes;

// rcornwell hole assignment
// t 800  8 2   4 20	t=twelve top of card
// e 400  7 4   3 40	e = eleven
// 0 200  6 8   2 80
// 9 1    8 10  1 100	9 = bottom of card

// ref: A24-3373-2_Model_30_Operating_Guide_Dec66.pdf
// page 42: Figure 14A. Extended Binary Coded Decimal Interchange Code

// e1 & 61 swap values; note-13 note-14
wire b7_61e1;
assign b7_61e1 = i_ebcdic[7] ^ (i_ebcdic[6:0]==7'h61);

wire hxa,hx9,qn88,hxnz,hx0,v0x,v1x,v3x,v4x,v5x,v6x,v8x,v9x,vax,vbx,vcx,vdx,vex,c6a;
assign hxa=i_ebcdic[3] && (i_ebcdic[2] || i_ebcdic[1]);	// [0-f][a-f]
assign hx9 = (i_ebcdic[3] && |i_ebcdic[2:0]);	// [0-f][9-f]
assign qn88 = (~i_ebcdic[3] || ~i_ebcdic[7]);	// all but [8-f][8-f]
assign hxnz = |i_ebcdic[3:0];			// [f-f][1-f]
assign hx0 = ~hxnz;				// [0-f]0
assign v0x = (i_ebcdic[7:4] == 0);		// 0[0-f]
assign v1x = (i_ebcdic[7:4] == 1);		// 1[0-f]
assign v3x = (i_ebcdic[7:4] == 3);		// 3[0-f]
assign v4x = (i_ebcdic[7:4] == 4);		// 4[0-f]
assign v5x = (i_ebcdic[7:4] == 5);		// 5[0-f]
assign v6x = (i_ebcdic[7:4] == 6);		// 6[0-f]
assign v8x = (i_ebcdic[7:4] == 8);		// 8[0-f]
assign v9x = (i_ebcdic[7:4] == 9);		// 9[0-f]
assign vax = (i_ebcdic[7:4] == 10);		// a[0-f]
assign vbx = (i_ebcdic[7:4] == 11);		// b[0-f]
assign vcx = (i_ebcdic[7:4] == 12);		// c[0-f]
assign vdx = (i_ebcdic[7:4] == 13);		// d[0-f]
assign vex = (i_ebcdic[7:4] == 14);		// e[0-f] except 61 not e1
assign c6a = (i_ebcdic == 'h6a);		// just 6a note-15

reg hT,hE,h0,h1,h2,h3,h4,h5,h6,h7,h8,h9;

reg [11:0] next_holes;
always @(i_ebcdic) begin
	hT = v0x | (v4x&~hx0) | v8x | v9x | vbx | vcx | c6a |
		(hx0 & (v1x | v3x)) |		// 10 30
		(i_ebcdic[6] & i_ebcdic[4] & (b7_61e1 ?
			hxa			// [df][a-f]
			: ~hx9			// [57][0-8]
		));
	hE= v1x | (v5x & ~hx0) | v9x | vax | vbx | vdx | c6a |
		(hx0 & i_ebcdic[7:5]==1) |		// [12]0
		(b7_61e1 ? (hxa & &i_ebcdic[6:5])	// [ef][a-f]
		: (~hx9& i_ebcdic[5] && i_ebcdic[6]));	// [67][0-8]
	h0= hx0 ? &{	// [0-9a-f]0
		~v6x,						// except 60
		~&{~i_ebcdic[6], ~i_ebcdic[5], i_ebcdic[4] },	// 10 90
		~&{~i_ebcdic[7], i_ebcdic[6]&~i_ebcdic[5] }}	// 40 50
	: ((~c6a&i_ebcdic[5] & ~i_ebcdic[4])|v8x|vbx)
		|(i_ebcdic[7] ? (	// 80-ff
			hxa ?		// [8-f][a-f]
				(i_ebcdic[6] & (i_ebcdic[5] | ~|i_ebcdic[5:4]))	// [cef][a-f]
			:
				i_ebcdic[6:4] == 6		// e[0-9]
		)
		: ( ~hx9 && i_ebcdic[6] && !(i_ebcdic[4] ^ i_ebcdic[5]))	// [47][0-8]
		);
	h1=(i_ebcdic[0]&~i_ebcdic[1]&~i_ebcdic[2]&qn88)	// [8-f][19]
		| (~i_ebcdic[6]&hx0);			// [0-38-b]0
	h2=(~i_ebcdic[0]&i_ebcdic[1]&~i_ebcdic[2]&!c6a)	// [0-f][2a] except 6a
		| (vex&hx0);				// e0
	h3=(i_ebcdic[0]&i_ebcdic[1]&~i_ebcdic[2]); // 0&1&~2
	h4=(~i_ebcdic[0]&~i_ebcdic[1]&i_ebcdic[2]); // ~0&~1&2
	// 4 [5]
	h5=(i_ebcdic[0]&~i_ebcdic[1]&i_ebcdic[2]); // 0&~1&2
	// 3 [6]
	h6= (~i_ebcdic[0]&i_ebcdic[1]&i_ebcdic[2]); // ~0&1&2
	// 2 [7]
	h7=(i_ebcdic[0]&i_ebcdic[1]&i_ebcdic[2]); // 0&1&2
	// 1 [8]
	h8 =
	hx0 ? (~i_ebcdic[6] | vex)		// [0-38-be]0
		: b7_61e1 ? (hxa		// [8-f][a-f]
		| hx0				// [8-f]0
		| (i_ebcdic[3]			// [8-f][8]
			& (~i_ebcdic[0])))	// but not [8-f]9
		: (i_ebcdic[3] & ~c6a);		// [8-f][89],[0-7][8-f] except 6a
	// 0 [9]
	h9 = b7_61e1 ?
		hxa ?
			i_ebcdic[6] 		// [c-f][a-f]
		:	(i_ebcdic[3:0] == 9)	// [8-f]9
	: hx9 ?
		~i_ebcdic[6]			// [0-3][9-f]
	: (hxnz | ~i_ebcdic[6]);	// [0-7][1-8] || [0-3]0

	next_holes = {hT,hE,h0,h1,h2,h3,h4,h5,h6,h7,h8,h9};
end

always @(posedge i_clk)
	if (i_reset) begin
		o_holes <= 0;
	end else begin
		o_holes <= next_holes;
	end

endmodule
