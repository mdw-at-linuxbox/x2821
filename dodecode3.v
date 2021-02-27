// 1 of 12 encoder
// for encoding carriage control slow and stop brushes.
// see
// Y24-3529-0_2025_Processing_Unit_FE_Maintenance_Diagrams_Feb69.pdf
// page 4-212 (pdf 145) figure 4-212 c4
// carriage compare and channel latches 1,9,12
// inputs to "carr brush reg"
// output when than one input bit is set will be mapped to
// some other output code -- in many cases that will be
// "out of range", which in 1403 land probably means it
// behaves the same as a space.
//
// input: {bit1 bit2 ... bit12}
//	output binary value of right-most bit set.
// note: that's ibm bit ordering, 1 origin.
`default_nettype   none
module dodecode3(i_in, o_out, o_match);

input wire [11:0] i_in;
output wire [3:0] o_out;	// binary encoding (1-12)
output wire o_match;

wire i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12;
assign {i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12} = i_in;

assign o_out[3] = i12 | i11 | i10 | i9 | i8;
assign o_out[2] = i12 | i7 | i6 | i5 | i4;
assign o_out[1] = i11 | i10 | i7 | i6 | i3 | i2;
assign o_out[0] = i11 | i9 | i7 | i5 | i3 | i1;
assign o_match = |{i_in};
endmodule
