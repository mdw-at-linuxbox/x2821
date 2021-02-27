`default_nettype none

module barsim(i_clk, i_reset,
	i_bar_reset,
	i_bar_advance,
	o_bar_binary,
	o_bar_units,
	o_bar_tens,
	o_bar_100);

input wire i_clk;
input wire i_reset;
input wire i_bar_reset;
input wire i_bar_advance;

output wire [7:0] o_bar_binary;
output wire [4:0] o_bar_units;
output wire [4:0] o_bar_tens;
output wire o_bar_100;

assign o_bar_binary = bar_binary;
assign o_bar_units = bar_units;
assign o_bar_tens = bar_tens;
assign o_bar_100 = bar_100;

assign set_bar_to_000 = i_bar_reset;
assign addr_units_b = units_drive_bar[1];
assign addr_units_d = units_drive_bar[3];
assign addr_units_e = units_drive_bar[4];
assign x_bar_advance_100 = x_bar_advance_tens & bar_tens == 5'b00101;

wire x_bar_advance_100;

// 33.23.02.1
latch1 u_bar_100(i_clk,
	x_bar_advance_100,
	tens_set_reset_control,
	bar_100);

wire [11:0] bar_x;	// printer bar
wire [7:0] bar_binary;	// printer bar

assign bar_x = {1'b0, bar_100, bar_tens, bar_units};

dec2bin1 u_bar2bin(bar_x, bar_binary);

assign block_bar_adv = set_bar_to_000;

wire [4:0] bar_units;
wire [4:0] units_drive_bar;
wire [4:0] bar_tens;
wire x_bar_advance_units;
wire block_bar_adv;
wire tens_set_reset_control;
wire set_bar_to_000;
wire addr_units_e;
wire addr_units_d;
wire addr_units_b;
wire x_bar_advance_tens;
wire bar_100;

assign x_bar_advance_units = i_bar_advance;

assign tens_set_reset_control = set_bar_to_000;

decade7 u_bar_units(i_clk,
	tens_set_reset_control,
	1'b0,
	x_bar_advance_units,
	bar_units);

// 33.23.02.1
assign x_bar_advance_tens = i_bar_advance & bar_units[2] & bar_units[0];

// XXX omitting ce set tens logic here.
// 33.23.02.1
decade6 u_bar_tens(i_clk,
	tens_set_reset_control,
	x_bar_advance_tens,
	bar_tens);

endmodule

module tb;

	reg clk;
	reg rst;

	reg [8:0] v;
	reg reset;
	reg advance;
	reg compare;
	reg [132:1] result;
	wire valid;
	wire [7:0] bar;
	wire [4:0] bar_units;
	wire [4:0] bar_tens;
	wire bar_100;

initial begin
$dumpfile("d132x5.vcd");
$dumpvars(0, tb);
end

	barsim u1( .i_clk(clk), .i_reset(rst),
		.i_bar_reset(reset),
		.i_bar_advance(advance),
		.o_bar_binary(bar),
		.o_bar_units(bar_units),
		.o_bar_tens(bar_tens),
		.o_bar_100(bar_100));

	d132x5 #(3) u0( .i_clk(clk), .i_reset(rst),
		.i_bar_units(bar_units),
		.i_bar_tens(bar_tens),
		.i_bar_100(bar_100),
		.i_print_compare(compare),
		.o_hammer_fire(result));

	always #1 clk = ~clk;

	integer count;

	initial begin
		{clk, rst} <= 1;
	reset <= 0;
	advance <= 0;
	compare <= 0;
	#3 rst <= 0;
	#2 reset <= 1;
	#2 reset <= 0;
	#2 compare <= 1;

	$monitor("T=%0t bar=%d result=%x", $time, bar, result);

	for (count = 0; count < 132; count = count + 1) begin
		#2 advance <= 1;
		#2 advance <= 0;
	end
	#2 advance <= 0;
	#2;

	#30;
		$finish;

	end
endmodule
