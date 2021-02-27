// implement ibm trigger with extender for set and reset
// in this implementation:
// with dc inputs: in this implementation, if both active,
//	gate will oscillate.
// Note that "off" gate is true and "on" gate is complement.
`default_nettype   none
module trigger3(i_clk,
	i_set_gate, i_ac_set, i_dc_set,
	i_reset_gate, i_ac_reset, i_dc_reset,
	i_set_gate2, i_ac_set2,
	i_reset_gate2, i_ac_reset2,
	o_out, o_nout);

input wire i_clk;
input wire i_set_gate;	// enables ac_set
input wire i_ac_set;	// active if positive pulse
input wire i_dc_set;	// active low
input wire i_reset_gate;	// enables ac_reset
input wire i_ac_reset;	// active if positive pulse
input wire i_dc_reset;	// active low
input wire i_set_gate2;	// enables ac_set
input wire i_ac_set2;	// active if positive pulse
input wire i_reset_gate2;	// enables ac_reset
input wire i_ac_reset2;	// active if positive pulse
output wire o_out;	// complementary	("off" output)
output wire o_nout;	// outputs		("on" output)

assign o_out = state;
assign o_nout = ~state;

reg state;
reg last_ac_set;
reg last_ac_reset;
reg last_ac_set2;
reg last_ac_reset2;
wire ac_set = i_set_gate & i_ac_set & ~last_ac_set |
	i_set_gate2 & i_ac_set2 & ~last_ac_set2;
wire ac_reset = i_reset_gate & i_ac_reset & ~last_ac_reset |
	i_reset_gate2 & i_ac_reset2 & ~last_ac_reset2;

initial begin
	last_ac_set <= 1'b0;
	last_ac_reset <= 1'b0;
	last_ac_set2 <= 1'b0;
	last_ac_reset2 <= 1'b0;
//	state <= 1'b0;
end

always @(posedge i_clk) begin
	last_ac_set <= i_ac_set;
	last_ac_reset <= i_ac_reset;
	last_ac_set2 <= i_ac_set2;
	last_ac_reset2 <= i_ac_reset2;
//	if (~i_dc_set & ~i_dc_reset) begin end else
	if (state) begin
		state <= i_dc_reset & ~(ac_reset);
	end else begin
		state <= ~i_dc_set | ac_set;
	end
end

endmodule
