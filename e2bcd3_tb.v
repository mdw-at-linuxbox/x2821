`default_nettype none
module tb;

localparam eNL = 'h15;
localparam eSP = 'h40;
localparam e_a = 'h81;
localparam e_A = 'hc1;
localparam e_0 = 'hf0;
	reg clk;
	reg rst;

	reg [7:0] data;
	wire [5:0] bcd_out;
	wire space, bad;

initial begin
$dumpfile("e2bcd3.vcd");
$dumpvars(0, u0);
end

	e2bcd3 #(3) u0( .i_clk(clk), .i_reset(rst),
		.i_ebcdic(data),
		.o_bcd(bcd_out),
		.o_space(space),
		.o_unassigned(bad));

	always #1 clk = ~clk;

	initial begin
		{clk, rst} <= 1;

	$monitor("T=%0t data=%x bcd_out=%0o space=%b unprintable=%b",
		$time, data, bcd_out, space, bad);

	repeat(2) @(posedge clk);
		rst <= 0;

	#2 data <= e_0;
	#8 data <= eNL;
	#8 data <= eSP;
	#8 data <= e_A;
	#8 data <= e_a;
	#8 data <= 'hf1;	// 1
	#8 data <= 'h61;	// /
	#8 data <= 'he7;	// X
	#8 data <= 'h98;	// q
	#8 data <= 'hc4;	// D
	#8 data <= 'h7b;	// #
	#8 data <= 'h7c;	// @
	#8 data <= 'h6c;	// %
	#8 data <= 'h4c;	// < square
	#8 data <= 'h7e;	// =
	#8 data <= 'h7d;	// '
	#8 data <= 'h4d;	// (
	#8 data <= 'h5d;	// )
	#30;
		$finish;

	end
endmodule
