`default_nettype none
module tb;
	reg clk;
	reg rst;

	reg ls1;
	reg ls2;
	reg hs;
	reg stopped;
	wire out;

localparam T=130;
localparam P=5;

initial begin
$dumpfile("rlim4.vcd");
$dumpvars(0, u0);
end

	rlim4 #(.TS(T)
,.PREC(P)
,.LOWSPEED(8)
,.HIGHSPEED(24)
,.STOPPED(16)
,.THRESHOLD(6000)
,.HI(8191)
,.LO(1024)
) u0( .i_clk(clk), .i_reset(rst), .i_ls1(ls1),
		.i_ls2(ls2), .i_hs(hs), .i_stopped(stopped),.o_out(out));

	always #1 clk = ~clk;

	initial begin

		{clk, rst} <= 1;
	ls1 <= 0;
	ls2 <= 1;
	hs <= 1;
	stopped <= 0;
	#3 rst <= 0;
	$monitor("T=%3d hs=%b ls=%b,%b st=%b out=%b", $time,
		hs, ls1, ls2, stopped, out);
	#(3*T) ;
	stopped <= 1; hs <= 0;
	#(3*T) hs <= 1; ls2 <= 0;
	#(3*T/2) ls1 <= 1; stopped <= 0;
	#(6*T) hs <= 0; stopped <= 1;
	#(23*T/3) hs <= 1; ls1 <= 0;
	#(3*T) ls2 <= 1; stopped <= 0;
	#(9*T);

	#30;
		$finish;

	end
endmodule
