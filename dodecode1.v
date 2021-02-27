// 1 of 12 decoder
`default_nettype   none
module dodecode1(i_in, o_out, o_match);

input wire [11:0] i_in;
output wire [3:0] o_out;	// binary encoding
output wire o_match;

wire i11,i10,i9,i8,i7,i6,i5,i4,i3,i2,i1,i0;
assign {i11,i10,i9,i8,i7,i6,i5,i4,i3,i2,i1,i0} = i_in;

assign o_out[3] = i11 | i10 | i9 | i8;
assign o_out[2] = (~i11 & ~i10 & ~i9 & ~i8) & (i7 | i6 | i5 | i4);
assign o_out[1] = i11 | i10 | (~i9 & ~i8 & (i7 | i6)) | (~i5 & ~i4 & (i3 | i2));
assign o_out[0] = i11 | (~i10 & i9) | (~i8 & i7) | (~i6 & i5) | (~i4 & i3) | (~i2 & i1);
assign o_match = |{i_in};
endmodule
