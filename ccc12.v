`default_nettype   none
module ccc12(i_clk, i_reset,
	i_holes,
	o_ebcdic,
	o_bad);

input wire i_clk;
input wire i_reset;
input wire [11:0] i_holes;
output reg [7:0] o_ebcdic;
output reg o_bad;

// rcornwell hole assignment
// t 800  8 2   4 20	t=twelve top of card
// e 400  7 4   3 40	e = eleven
// 0 200  6 8   2 80
// 9 1    8 10  1 100	9 = bottom of card

// ref: A24-3373-2_Model_30_Operating_Guide_Dec66.pdf
// page 42: Figure 14A. Extended Binary Coded Decimal Interchange Code

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

wire digit8,digit9,digit1,zone8,zone9;
wire is_282,is_d02,is_701,is_300;
wire r7,r6,r5,r4,r3,r2,r1,r0;
wire Z0,Z1,Z2,Z3,Z4,Z5,Z6,Z7;
assign Z0=!bT&!bE&!b0;	// 000 -
assign Z1 = !bT&!bE&b0;	// 200 0
assign Z2 = !bT&bE&!b0;	// 400 E
assign Z3 = !bT&bE&b0;	// 600 E0
assign Z4 = bT&!bE&!b0;	// 800 T
assign Z5 = bT&!bE&b0;	// a00 T0
assign Z6 = bT&bE&!b0;	// c00 TE
assign Z7 = bT&bE&b0;	// e00 TE0

wire Dzero = ~|i_holes[x1:x9];
wire Done = &{i_holes[x0],~i_holes[x1:x9]};
assign is_282 = i_holes == 12'h282;
assign is_d02 = i_holes == 12'hd02;
assign is_701 = i_holes == 12'h701;
assign is_300 = i_holes == 12'h300;

wire next_bad = |{&{|{b1,b3,b5,b7},|{b2,b4,b6}},
		&{|{b2,b3,b6,b7},|{b1,b4,b5}},
		&{|{b4,b5,b6,b7},|{b1,b2,b3}}};
wire sets_one = |{b3,b5,b7};			// 357
wire sets_two = !is_282 & |{b2,b3,b6,b7};	// 2367
wire sets_four = |{b4,b5,b6,b7};		// 4567
wire [7:0] next_ebcdic;
assign next_ebcdic = {r7,r6,r5,r4,r3,r2,r1,r0};
assign digit8 = &{~i_holes[x1:x7],b8};		// [^1-7]*8
wire digit9_t =  &{~i_holes[x1:x8],b9};		// [^1-8]*9
assign digit9 = digit9_t | &{b1&zone8&|{Z0,Z1,Z2,Z4}};	// 18
assign digit1 = &{b1,~i_holes[x2:x9]};		// 1[^1-9]*
assign zone8 = b8 & ~digit8;
assign zone9 = b9 & ~digit9_t;
assign r0 = |{ sets_one				// 357
		, digit1			// non-zone 1
		, digit9			// non-zone 9
		, (zone8 && !is_d02 && Done)	// [^0]18[^9]
		, (!zone8 && zone9 && b1) };
assign r1 = |{ sets_two , (Dzero & Z6) };	// any of 2367 or just TE
assign r2 = sets_four;			// 4567
assign r3 = |{ digit8 , digit9		// either 8,9
		, (Dzero & Z6)		// just TE
		, (zone8 &		// 8
			((!is_282 & !b1)	// not 282 and not 1
			| (!is_d02 & Done))) };	// 1 except TE18

assign r7 = (Dzero) ? |{Z1 , Z3 , Z5}
	: !zone8 ? ((!zone9) ? !is_300 : is_701)
	: !zone9 ? |{(Z1 & is_282),Z3,Z5,Z6,Z7}
		: (!b1 & |{Z3, Z5, Z6, Z7});
assign r6 = Dzero |
	(!zone9 ? |({Z0,Z1,Z2,Z4})
	: ((!zone8 | !b1) & |{Z3,Z5,Z6,Z7}));
assign r5=(Dzero) ? |{Z1,Z2,Z6,Z7} : (|{Z0,Z1,Z3,Z7});
assign r4=(Dzero) ? |{Z1,Z3,Z4,Z7} : (|{Z0,Z2,Z6,Z7});

always @(posedge i_clk)
	if (i_reset) begin
		o_ebcdic <= 0;
		o_bad <= 1;
	end else begin
		o_ebcdic <= next_ebcdic;
		o_bad <= next_bad;
	end

endmodule
