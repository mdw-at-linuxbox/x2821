`default_nettype none
module tb;

localparam eNL = 'h15;
localparam eSP = 'h40;
localparam e_a = 'h81;
localparam e_A = 'hc1;
localparam e_0 = 'hf0;
	reg clk;
	reg rst;

	reg [11:0] data;
	wire [3:0] out;
	wire match;

initial begin
$dumpfile("dodecode2.vcd");
$dumpvars(0, u0);
end

	dodecode2 #(3) u0(
		.i_in(data),
		.o_out(out),
		.o_match(match));

	always #1 clk = ~clk;

	initial begin
		{clk, rst} <= 1;

	$monitor("T=%0t data=%x out=%d match=%b",
		$time, data, out, match);

	repeat(2) @(posedge clk);
		rst <= 0;

	#2 data <= 0;
	#2 data <= 1;
	#8 data <= 2;
	#8 data <= 4;
	#8 data <= 8;
	#8 data <= 16;
	#8 data <= 32;
	#8 data <= 64;
	#8 data <= 128;
	#8 data <= 256;
	#8 data <= 512;
	#8 data <= 1024;
	#8 data <= 2048;
	#8 data <= 4095;
	#8 data <= 4094;
	#8 data <= 4092;
	#8 data <= 4088;
	#8 data <= 4080;
	#8 data <= 4064;
	#8 data <= 4032;
	#8 data <= 3968;
	#8 data <= 3840;
	#8 data <= 3584;
	#8 data <= 3072;
	#8 data <= 2048;
	#8 data <= 0;
	#8 data <= 4095;
	#8 data <= 2047;
	#8 data <= 1023;
	#8 data <= 511;
	#8 data <= 255;
	#8 data <= 127;
	#8 data <= 63;
	#8 data <= 31;
	#8 data <= 15;
	#8 data <= 7;
	#8 data <= 3;
	#8 data <= 0;
	#8 data <= 1;
	#8 data <= 'h900;	// should be 4
	#8 data <= 'h240;	// should be 6
	#8 data <= 'h190;	// should be 8
	#8 data <= 'h410;	// should be 8
	#8 data <= 'h124;	// should be 10
	#8 data <= 'h181;	// should be 12
	#8 data <= 'h201;	// should be 12
	#8 data <= 'h90;	// should be 8
	#30;
		$finish;

	end
endmodule
