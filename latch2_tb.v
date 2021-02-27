`default_nettype none
module tb;
	reg clk;
	reg rst;

//	parameter W=16;
//	parameter K='hb400;
	parameter W=4;
	parameter K='h12000;

	reg [W-1:0] data1;

	reg [W-1:0] data2;
	wire [W-1:0] out;

initial begin
$dumpfile("latch2.vcd");
$dumpvars(0, tb);
end

	latch2 #(W) u0( .i_clk(clk), .i_rst(rst), .i_set(data1), .i_clear(data2), .o_out(out));

	initial data1 = 0;
	always #1 clk = ~clk;

	initial begin
		{clk, rst} <= 1;
	data1 <= 0;
	data2 <= 0;

	$monitor("T=%0t set=%x clear=%x out=%x", $time, data1, data2, out);
	#3 rst <= 0;
	#2 data1 <= 8;
	#4 data1 <= 12;
	#4 data1 <= 6;
	#4 data1 <= 3;
	#4 data1 <= 1;
	#4 data1 <= 0;
	#4 data2 <= 4;
	#4 data2 <= 2;
	#4 data2 <= 1;
	#4 data2 <= 8;
	#4 data2 <= 0;
	#2 data1 <= 1;	data2 <= 8;
	#2 data1 <= 3;	data2 <= 0;
	#2 data1 <= 6;
	#2 data1 <= 12;	data2 <= 1;
	#2 data1 <= 9;	data2 <= 2;
	#2 data1 <= 3;	data2 <= 4;
	#2 data1 <= 6;	data2 <= 8;
	#2 data1 <= 9;	data2 <= 1;
	#2 data1 <= 12;	data2 <= 2;
	#2 data1 <= 1;	data2 <= 4;
	#2 data1 <= 2;	data2 <= 8;
	#2 data1 <= 4;	data2 <= 1;
	#2 data1 <= 8;	data2 <= 2;
	#2 data1 <= 8;	data2 <= 4;
	#2 data1 <= 0; data2 <= 8;
	#2	data2 <= 1;
	#2 data2 <= 0;
	
	#8 $finish;

	end
endmodule
