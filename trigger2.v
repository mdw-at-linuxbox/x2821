// implement "adc" style ibm trigger
// double width sms: 3 low speed poewr triggers 1 w/ expanded inputs.
// the ibm trigger has a full complement of ac and dc inputs,
// according to the ibm documentation, last activate event wins.
// in this implementation:
// with dc inputs: in this implementation, if both active,
//	gate will oscillate.
// Note that "off" gate is true and "on" gate is complement.
`default_nettype   none
module trigger2(i_clk,
	i_set_gate, i_ac_set, i_dc_set,
	i_reset_gate, i_ac_reset, i_dc_reset,
	o_out, o_nout);

input wire i_clk;
input wire i_set_gate;	// enables ac_set
input wire i_ac_set;	// active if positive pulse
input wire i_dc_set;	// active low
input wire i_reset_gate;	// enables ac_reset
input wire i_ac_reset;	// active if positive pulse
input wire i_dc_reset;	// active low
output wire o_out;	// complementary	("off" output)
output wire o_nout;	// outputs		("on" output)

// adc:
//	set	ac	dc	dc	ac	reset	on	off
//	gate	set	set	reset	reset	gate	output	output
// #1	u	s	p	y	q	r	t	n
// #2	l	k	x	v	d	c	g	w
// #3	b	7	x	3	y	z	g	w
// #4	m	h	b	g	e	f	(extends 3)
//	set_gate	dc_set		ac_reset	nout
//		ac_set		dc_reset	reset_gate	out

assign o_out = state;
assign o_nout = ~state;

reg state;
reg last_ac_set;
reg last_ac_reset;
wire ac_set = i_ac_set & ~last_ac_set;
wire ac_reset = i_ac_reset & ~last_ac_reset;

initial begin
	last_ac_set <= 1'b0;
	last_ac_reset <= 1'b0;
//	state <= 1'b0;
end

always @(posedge i_clk) begin
	last_ac_set <= i_ac_set;
	last_ac_reset <= i_ac_reset;
//	if (~i_dc_set & ~i_dc_reset) begin end else
	if (state) begin
		state <= i_dc_reset & ~(i_reset_gate & ac_reset);
	end else begin
		state <= ~i_dc_set | i_set_gate & ac_set;
	end
end

endmodule
