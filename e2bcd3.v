// ebcdic to bcd(chain printer order) conversion
// chain order:
// A24-3312-7_2821_Component_Descr_Nov69.pdf
//	AN print chain
//	pages 48-49 (pdf pages 48-50)
// character bit assignment:
// SY22-2851-1_360FE_Aug70.pdf
//	figure "2821 hex to bcd translation" on page 02-04 (pdf 48)
// the 2821 is described here,
// Y24-3503-0_2821_Field_Engineering_Maintenance_Diagrams_Dec68.pdf
// my notes on encoding: wp/s360.56
`default_nettype   none
module e2bcd3(i_clk, i_reset,
	i_ebcdic,
	o_bcd,
	o_space,
	o_unassigned);

// verilator lint_off UNUSED
input wire i_clk;
input wire i_reset;
// verilator lint_on UNUSED

input wire [7:0] i_ebcdic;
output wire [5:0] o_bcd;	// bcd encoding
output wire o_space;		// nul or space (or 80 or c0)
output wire o_unassigned;	// no print graphic assigned

// bcd encoding: 1 of 48 values.  {b,a,8,4,2,1}
//	bits 1,2,4,8: binary value: range: 0001-1100
//	bits a,b: binary value 00-11
//	0001 0010 0011 0100 0101 0110 0111 1000 1001 1010 1011 1100
// 00	  1    2    3    4    5    6    7    8    9    0    #    @
// 01	  /    S    T    U    V    W    X    Y    Z    &    ,    %
// 10	  J    K    L    M    N    O    P    Q    R    -    $    *
// 11	  A    B    C    D    E    F    G    H    I    +    .    <
// dual encodings:
//	7b 7e (#=) -> 001011	7c 7d (@') -> 001100
//	6c 4d (%() -> 011100	4c 5d (<)) -> 111100
// 4c usually prints as a square lozenge on AN.

wire rB,rA,r8,r4,r2,r1;
wire e0,e1,e2,e3,e4,e5,e6,e7;

wire z4567;
wire z04567;

assign o_bcd = {rB,rA,r8,r4,r2,r1};

assign {e0,e1,e2,e3,e4,e5,e6,e7} = i_ebcdic;

assign o_space = /* ~e0 & */ ~e2 & ~e3 & ~e4 & ~e5 & ~e6 & ~e7;

assign o_unassigned = o_space | ~(
		e0 & e1 & e2 & e3 & ~e4 |		// 01234567
/*(*/		~e0 & e1 & e3 & e4 & e5 & ~e6 |		// *)@'
		~e0 & e1 & e2 & e3 & e4 & e5 & ~e7 |	// @=
		~e0 & e1 & ~e2 & ~e3 & e4 & e5 & ~e7 |	// <+
		~e0 & e1 & ~e2 & e4 & e5 & ~e6 |	// <(*)
		~e0 & e1 & e2 & ~e3 & ~e4 & ~e5 & ~e6 |	// -/
		~e0 & e1 & ~e2 & e3 & ~e4 & ~e5 & ~e6 & ~e7 |	// &
		~e0 & e1 & e4 & ~e5 & e6 & e7 |		// .$,#
		~e0 & e1 & e4 & e5 & ~e6 & ~e7 |	// <*%@
		e0 & ~e2 & ~e4 & e7 |			// acegjlnpACEGJLNP
		e0 & (e1 | ~e2 | ~e3) & e4 & ~e5 & ~e6 |// 89HIQRYZhiqryz
		e0 & (~e2 | ~e3) & ~e4 & (e5 | e6)	// BCDEFGKLMNOPSTUVWXbcdefgklmnopstuvwx
		);

assign r1 = e2 & e4 & e5 & e6 |		// =
	(~e5 | ~e4) & e7 |		// .$/,#acijlrtzACIJLRTZ139
					// /acegjlnptvxACEGJLNPTVX1357
	e2 & ~e3 & e7 |			// /,tvxzTVXZ
	e6 & e7;			// .$,#cglptxCGLPTX37
assign r2 = ~( ~e6 & (e4 | e5 | e7) |
	~e0 & ~e2 & ~e3 & ~e6 |		// <(
/*)*/		e0 & e2 & ~e3 & ~e6		// uvyzUVYZ
);
assign r4 = ~(	(e2 | ~e3) & e4 & e6 & ~e7 |	// +=
	~e5				// .&$-/,#abchijklqrstyzABCHIJKLQRSTYZ012389
	);
assign r8 = e0 & ~e2 & ~e5 & ~e6 & ~e7 |	// hqHQ
	~e0 & e2 & ~e5 & ~e6 & ~e7 |	// -
	e3 & ~e5 & ~e6 & ~e7 |		// &qQ08
	e4;				// .<(+$*),%#@'=hiqryzHIQRYZ89
assign rA = ~e0 & ~e2 & ~e4 & ~e5 & ~e6 & ~e7 |	// &
	e0 & ~e1 & ~e2 & e4 & ~e5 & e6 & e7 |	// 
	~e2 & e4 &e5 & ~e6 & e7 |		// ()
	~e3 & (e7 | e6 | e5 | e4 | e0);	// %(+,./<ABCDEFGHISTUVWXYZabcdefghistuvwxyz
assign rB = ~e0 & ~e3 & ~e4 & ~e5 & ~e6 & ~e7 |	// -
	~e2 & e3 & (e0 | e7) |			// jklmnopqrJKLMNOPQR
						// $)jlnprJLNPR
	~e2 & e4 & ~e7 |			// <+*hqHQ
	~e2 & ~e5 & e7 |			// .$acijlrACIJLR
	~e2 & ~e4 & e5 |			// defgmnopDEFGMNOP
	~e2 & e6;				// .+$bcfgklopBCFGKLOP

endmodule
