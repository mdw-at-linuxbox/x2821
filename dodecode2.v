// 1 of 12 priority encoder
// input: {bit1 bit2 ... bit12}
//	output binary value of right-most bit set.
// note: that's ibm bit ordering, 1 origin.
`default_nettype   none
module dodecode2(i_in, o_out, o_match);

input wire [11:0] i_in;
output wire [3:0] o_out;	// binary encoding (1-12)
output wire o_match;

wire i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12;
assign {i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12} = i_in;

assign o_out[3] = i12 | i11 | i10 | i9 | i8;
assign o_out[2] = i12 | (~i11 & ~i10 & ~i9 & ~i8) & (i7 | i6 | i5 | i4);
assign o_out[1] = ~i12 & (i11 | i10) | (~i12 & ~i9 & ~i8 & (i7 | i6)) |
	(~i12 &  ~i9 & ~i8 & ~i5 & ~i4 & (i3 | i2));
assign o_out[0] = (~i12 & i11) | (~i12 & ~i10 & i9) |
	(~i12 & ~i10 & ~i8 & i7) | (~i12 & ~i10 & ~i8 & ~i6 & i5) |
	(~i12 & ~i10 & ~i8 & ~i6 & ~i4 & i3) |
	(~i12 & ~i10 & ~i8 & ~i6 & ~i4 & ~i2 & i1);
assign o_match = |{i_in};
endmodule
