`default_nettype   none
`timescale 10ns / 1ns
module tb;
	reg clk, rst;

	reg clr;
	reg advance_by_2, advance_by_1;
	wire [5:0] count;

initial begin
$dumpfile("pcg4.vcd");
$dumpvars(0, tb);
end

	reg ena;
	wire x;
	reg [3:0] pctr;
	always @(posedge clk)
		if (ena)
			pctr <= pctr + 1;
	assign x = pctr[3];

	pcg4 u0( .i_clk(clk), .i_reset(clr),
		.i_advance_by_1(advance_by_1 & x),
		.i_advance_by_2(advance_by_2 & x),
		.o_pcg(count));

	wire print_buffer_b_bit;
	wire print_buffer_a_bit;
	wire print_buffer_8_bit;
	wire print_buffer_4_bit;
	wire print_buffer_2_bit;
	wire print_buffer_1_bit;

	assign { print_buffer_b_bit,
		print_buffer_a_bit,print_buffer_8_bit,print_buffer_4_bit,
		print_buffer_2_bit,print_buffer_1_bit } =
			count;
wire unprintable_character_gate_ucb = 1'b1;
wire unprintable_character;
wire gnd_tie_off_ucb = 1'b0;
wire x_line_full_and_end_scan = 1'b1;

assign unprintable_character = unprintable_character_gate_ucb &
	(~print_buffer_4_bit & ~print_buffer_1_bit & ~print_buffer_2_bit &
		~print_buffer_8_bit & x_line_full_and_end_scan |
	(print_buffer_2_bit | print_buffer_1_bit) & ~gnd_tie_off_ucb &
		print_buffer_8_bit &
		print_buffer_4_bit & x_line_full_and_end_scan);

	always #1 clk = ~clk;

	initial begin
$monitor("T=%d add1=%b add2=%b clear=%b out=%o", $time, advance_by_1, advance_by_2, clr, count);
		{clk,rst} <= 1;
	ena <= 0;
	pctr <= 0;
	advance_by_2 <= 0;
	advance_by_1 <= 0;
	clr <= 0;

	#3 rst <= 0;

	#2 clr <= 1;
	#20 clr <= 0;

	ena <= 1;
	#2 advance_by_1 <= 1;
	#2048 advance_by_1 <= 0;
	#20 advance_by_1 <= 1;
	#8 advance_by_1 <= 0;
	#20 clr <= 1;
	#20 clr <= 0;
	#2 advance_by_2 <= 1;
	#2048 advance_by_2 <= 0;
	#20 clr <= 1;
	ena <= 0;
	pctr <= 0;
	#20 clr <= 0;
	ena <= 1;
	#20 advance_by_1 <= 1;
	#20 advance_by_1 <= 0;
	#20 advance_by_2 <= 1;
	#2048 advance_by_2 <= 0;

	#30 $finish;
	end
endmodule
