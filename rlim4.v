//
// try to model ibm fpz stacker rate limiter
// it is not clear what timescale is right.
//
`default_nettype   none
module rlim4(i_clk, i_reset,
	i_ls1, i_ls2,
	i_hs,
	i_stopped,
	o_out);

parameter TS=130;
parameter PREC = 5;
parameter LOWSPEED = 8; 
parameter HIGHSPEED = 24;
parameter STOPPED = 16;
parameter THRESHOLD = 6000;
parameter [W-1:0] HI = 8191;
parameter [W-1:0] LO = 1024;

localparam W = PREC + $clog2(TS);

input wire i_clk;
input wire i_reset;
input wire i_ls1;
input wire i_ls2;
input wire i_hs;
input wire i_stopped;
output reg o_out;

reg [W-1:0] charge;

wire [W-1:0] target;
wire [W-1:0] factor;

wire [2:0] ds = {~i_ls1 & ~i_ls2, ~i_hs, ~i_stopped};

assign target = (ds == 3'h4) ? LO : (ds == 3'h2) ? HI : 0;
assign factor = (ds == 3'h4) ? LOWSPEED :
		(ds == 3'h2) ? HIGHSPEED :
		(ds == 3'h1) ? STOPPED :
		0;

wire [2*W-1:0] incr;
assign incr = (target-$signed(charge)) * factor;

always @(posedge i_clk) begin
	if (i_reset)
		charge <= 0;
	else
		charge <= charge + incr[2*W-1:W];
	o_out = i_reset ? 1'b0 : charge >= THRESHOLD;
end
endmodule
