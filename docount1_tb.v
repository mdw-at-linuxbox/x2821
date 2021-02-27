`default_nettype   none
`timescale 10ns / 1ns
module tb;
	reg clk, rst;

	reg advance;
	reg clr;
	wire [5:0] count;

initial begin
$dumpfile("docount1.vcd");
$dumpvars(0, tb);
end

	reg c2;

	always @(posedge clk) begin
		if (rst) begin
			c2 <= 0;
		end else begin
			c2 <= ~c2;
		end
	end

	wire count_adv;
	assign count_adv = c2 & advance;

	docount1 u0( .i_clk(clk), .i_clear(clr),
		.i_advance(count_adv),
		.o_output(count));

	always #1 clk = ~clk;

	initial begin
$monitor("T=%d advance=%b clear=%b out=%x", $time, advance, clr, count);
		{clk,rst} <= 1;

	advance <= 0;
	clr <= 0;

	#3 rst <= 0;

	#4 clr <= 1;
	#2 clr <= 0;

	#2 advance <= 1;
	#48 advance <= 0;
	#8 advance <= 1;
	#8 advance <= 0;
	#2 clr <= 1;
	#2 clr <= 0;
	#2 advance <= 1;
	#50 advance <= 0;

	#30 $finish;
	end
endmodule
