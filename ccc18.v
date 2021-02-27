`default_nettype   none
module ccc18(i_clk, i_reset,
	i_holes,
	o_ebcdic,
	o_bad);

/* verilator lint_off UNUSED */
input wire i_clk;
input wire i_reset;
/* verilator lint_on UNUSED */
input wire [11:0] i_holes;
output wire [7:0] o_ebcdic;
output wire o_bad;

// rcornwell hole assignment
// t 800  8 2   4 20	t=twelve top of card
// e 400  7 4   3 40	e = eleven
// 0 200  6 8   2 80
// 9 1    8 10  1 100	9 = bottom of card

// ref: 2_2821_ALD_text.pdf
// 32.20.61.1 - 32.20.66.1 (pdf pages 42-47)
// 32.31.10.1 (pdf page 66)

localparam xT = 11;	// 800
localparam xE = 10;	// 400
localparam x0 = 9;	// 200
localparam x1 = 8;	// 100
localparam x2 = 7;	// 80
localparam x3 = 6;	// 40
localparam x4 = 5;	// 20
localparam x5 = 4;	// 10
localparam x6 = 3;	// 8
localparam x7 = 2;	// 4
localparam x8 = 1;	// 2
localparam x9 = 0;	// 1

wire bT = i_holes[xT];
wire bE = i_holes[xE];
wire b0 = i_holes[x0];
wire b1 = i_holes[x1];
wire b2 = i_holes[x2];
wire b3 = i_holes[x3];
wire b4 = i_holes[x4];
wire b5 = i_holes[x5];
wire b6 = i_holes[x6];
wire b7 = i_holes[x7];
wire b8 = i_holes[x8];
wire b9 = i_holes[x9];

wire r0,r1,r2,r3,r4,r5,r6,r7;

assign o_ebcdic = {r0,r1,r2,r3,r4,r5,r6,r7};

	// 32.20.61.1
	wire bT_E = bT & bE;
	wire bT_0 = bT & b0;
	wire bE_0 = bE & b0;
	wire b2_zones = bT_E | bT_0 | bE_0;
	wire bnT_nE = ~bT & ~bE;
	wire bnT_n0 = ~bT & ~b0;
	wire bnE_n0 = ~bE & ~b0;
	wire bn2_zones = bnT_nE | bnT_n0 | bnE_n0;
	wire bn8_n9 = ~b8 & ~b9;
	// 32.20.62.1
	wire b234567 = b2 | b3 | b4 | b5 | b6 | b7;
	wire bn1_n234567 = ~b1 & ~b234567;
	wire b123456789 = b1 | b2 | b3 | b4 | b5 | b6 | b7 | b8 | b9;
	wire b_not_numeric = ~b123456789;
//	wire b_any_bit = b123456789 | b0 | bE | bT;
	wire b_TE9n0n8 = bT | bE | b9 | ~b0 | ~b8 ;

	// 32.20.63.1
	assign r0 = ~b0 & bn8_n9 & b1 |
		bn8_n9 & b234567 |
		b234567 & b2_zones & b8 |
		b0 & b2 & ~b9 |
		b8 & ~b9 & bn1_n234567 |
		bn1_n234567 & ~b8 & b9 |
		b8 & ~b9 & bT_E |
		b1 & bT_0 & ~b9 |
		~b9 & ~bT & bE_0 |
		b1 & ~b8 & bE_0 & ~bT |
		bn8_n9 & b0 & ~b1 & ~bE;

	// 32.20.64.1
	assign r1 = b234567 & b2_zones & b9 |
		~b1 & b2_zones & b8 & b9 |
		b1 & b2_zones & b9 & ~b8 |
		~b8 & bn1_n234567 & bn2_zones |
		bn2_zones & ~b9 |
		b_not_numeric;
	assign r2 = ~( bT & ~bE |
		bnE_n0 & b_not_numeric |
		bE & b123456789 & ~b0 |
		b_not_numeric & ~bT & bE_0 );

	// 32.20.65.1
	assign r3 = ~( ~bT & b0 & b123456789 |
		bT & ~bE & b123456789 |
		bT_0 & ~bE |
		b_not_numeric & bE & ~b0 |
		b_not_numeric & bnT_n0 );
	assign r4 =
		b9 & bn1_n234567 |
		bT_E & ~b0 & bn1_n234567 |
		bnT_nE & ~b2 & b8 |
		b2 & b8 & b9 |
		~bnT_nE & ~b1 & b8 |
		bnT_n0 & b8 |
		bnE_n0 & b8;

	// 32.20.66.1
	assign r5 = b4 | b5 | b6 | b7;
	assign r6 = (b3 | b6 | b7) |
		bT_E & bn8_n9 & ~b5 & ~b4 & ~b0 & ~b1 |
		b2 & b_TE9n0n8;
	assign r7 = b1 & ~b8 | b1 & bn2_zones |
		(b3 | b5 | b7) |
		~b2 & ~b4 & ~b6 & ~b8 & b9;

	// 32.31.10.1
	assign o_bad = b1 & b234567 |
		b2 & (b3 | b4 | b5 | b6 | b7) |
		b3 & r5 |
		b4 & (b5 | b6 | b7) |
		b5 & (b6 | b7) |
		b6 & b7;

endmodule
