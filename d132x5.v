// decode dual decimal address (1-132) and set one hot output.
//
// Y24-3503-0_2821_Field_Engineering_Maintenance_Diagrams_Dec68.pdf
//	page 50
// 33.33.48.1 - 33.33.49.1
// 33.33.04.1 - 33.33.13.1
`default_nettype   none
module d132x5(i_clk, i_reset,
	i_bar_units,
	i_bar_tens,
	i_bar_100,
	i_print_compare,
	o_hammer_fire);
/* verilator lint_off UNUSED */
input wire i_clk;
input wire i_reset;
/* verilator lint_on UNUSED */

input wire [4:0] i_bar_units;	// 2 of 5
input wire [4:0] i_bar_tens;	// 2 of 5
input wire i_bar_100;
input wire i_print_compare;	// enable hammer
output wire [132:1] o_hammer_fire;

wire print_compare;
wire [4:0] bar_units;
wire [4:0] bar_tens;
wire bar_100;
assign print_compare = i_print_compare;
assign bar_units = i_bar_units;
assign bar_tens = i_bar_tens;
assign bar_100 = i_bar_100;

genvar i;

wire [9:0] bar_units_decoded;
wire [13:0] bar_tens_decoded;
assign bar_units_decoded[0] = bar_units[1] & bar_units[0];
assign bar_units_decoded[1] = bar_units[4] & bar_units[1];
assign bar_units_decoded[2] = bar_units[4] & bar_units[0];
assign bar_units_decoded[3] = bar_units[3] & bar_units[0];
assign bar_units_decoded[4] = bar_units[4] & bar_units[3];
assign bar_units_decoded[5] = bar_units[4] & bar_units[2];
assign bar_units_decoded[6] = bar_units[3] & bar_units[2];
assign bar_units_decoded[7] = bar_units[3] & bar_units[1];
assign bar_units_decoded[8] = bar_units[2] & bar_units[1];
assign bar_units_decoded[9] = bar_units[2] & bar_units[0];
assign bar_tens_decoded[0] = bar_tens[1] & bar_tens[0] & ~bar_100;
assign bar_tens_decoded[1] = bar_tens[4] & bar_tens[1] & ~bar_100;
assign bar_tens_decoded[2] = bar_tens[4] & bar_tens[0] & ~bar_100;
assign bar_tens_decoded[3] = bar_tens[3] & bar_tens[0] & ~bar_100;
assign bar_tens_decoded[4] = bar_tens[4] & bar_tens[3] & ~bar_100;
assign bar_tens_decoded[5] = bar_tens[4] & bar_tens[2] & ~bar_100;
assign bar_tens_decoded[6] = bar_tens[3] & bar_tens[2] & ~bar_100;
assign bar_tens_decoded[7] = bar_tens[3] & bar_tens[1] & ~bar_100;
assign bar_tens_decoded[8] = bar_tens[2] & bar_tens[1] & ~bar_100;
assign bar_tens_decoded[9] = bar_tens[2] & bar_tens[0] & ~bar_100;
assign bar_tens_decoded[10] = bar_tens[1] & bar_tens[0] & bar_100;
assign bar_tens_decoded[11] = bar_tens[4] & bar_tens[1] & bar_100;
assign bar_tens_decoded[12] = bar_tens[4] & bar_tens[0] & bar_100;
assign bar_tens_decoded[13] = bar_tens[3] & bar_tens[0] & bar_100;
generate for (i = 1; i <= 132; i = i + 1) begin
	assign o_hammer_fire[i] = bar_units_decoded[i%10] &
		bar_tens_decoded[i/10] &
		print_compare;
end

endgenerate
endmodule
