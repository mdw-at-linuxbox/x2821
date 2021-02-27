`default_nettype   none
`timescale 10ns / 1ns
module tb;
	reg clk, rst;

	localparam CSW_BIT_ATTN =31;
	localparam CSW_BIT_MOD  =30;
	localparam CSW_BIT_CUEND =29;
	localparam CSW_BIT_BUSY =28;
	localparam CSW_BIT_CHEND =27;
	localparam CSW_BIT_DVEND =26;
	localparam CSW_BIT_UC   =25;
	localparam CSW_BIT_UE   =24;

	localparam BT_DEVICE_END = (1<<CSW_BIT_DVEND-24);
	localparam BT_CHANNEL_END = (1<<CSW_BIT_CHEND-24);

	reg advance;
	reg clr;
	wire [4:0] count;

initial begin
$dumpfile("decade6.vcd");
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

	wire dec_adv;
	assign dec_adv = c2 & advance;

	decade6 u0( .i_clk(clk), .i_clear(clr),
		.i_advance(dec_adv),
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
	#40 advance <= 0;
	#8 advance <= 1;
	#8 advance <= 0;
	#2 clr <= 1;
	#2 clr <= 0;
	#2 advance <= 1;
	#50 advance <= 0;

	#30 $finish;
	end
endmodule
