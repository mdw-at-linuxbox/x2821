`default_nettype none
module tb;
	reg clk;
	reg rst;

//	parameter W=16;
//	parameter K='hb400;
	parameter W=1;
	parameter K='h12000;

	reg [W-1:0] data1;

	reg [W-1:0] data2;
	wire [W-1:0] out;
	wire [W-1:0] nout;

	reg setgate, acset, dcset;
	reg resetgate, acreset, dcreset;

initial begin
$dumpfile("trigger2.vcd");
$dumpvars(0, tb);
end

	trigger2 u0( .i_clk(clk),
		.i_set_gate(setgate), .i_ac_set(acset),
		.i_dc_set(dcset), .i_reset_gate(resetgate),
		.i_ac_reset(acreset), .i_dc_reset(dcreset),
		.o_out(out), .o_nout(nout));

	initial data1 = 0;
	always #1 clk = ~clk;

	initial begin
		{clk, rst} <= 1;
	setgate <= 0;
	acset <= 0;
	dcset <= 1;
	dcreset <= 1;
	acreset <= 0;
	resetgate <= 0;

	$monitor("T=%0t sg=%x as=%x ds=%x rg=%x ar=%x dr=%x o=%x n=%x",
		$time,
		setgate, acset, dcset,
		resetgate, acreset, dcreset,
		out, nout);
	#3 rst <= 0;

	#8 setgate <= 1;
	#4 acset <= 1;
	#4 acset <= 0;
	#4 setgate <= 0;
	resetgate <= 1;
	#4 acreset <= 1;
	#4 acreset <= 0;
	#4 dcset <= 0;
	#4 dcreset <= 0;

	#8 $finish;

	end
endmodule
