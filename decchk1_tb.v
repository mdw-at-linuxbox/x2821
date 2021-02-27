`default_nettype none
module tb;

	reg clk;
	reg rst;

	reg [4:0] v;
	wire valid;

initial begin
$dumpfile("decchk1.vcd");
$dumpvars(0, tb);
end

	decchk1 #(3) u0( // .i_clk(clk), .i_reset(rst),
		.i_value(v),
		.o_check(valid));

	always #1 clk = ~clk;

	integer count;

	initial begin
		{clk, rst} <= 1;

	$monitor("T=%0t v=%x valid=%x", $time, v, valid);

	for (count = 0; count < 32; count = count + 1) begin
		#2 v = count;
	end
	#2;

	#30;
		$finish;

	end
endmodule
