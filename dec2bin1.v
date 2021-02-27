// decode hundreds (0,1,2,3) + tens (2 of 5) + units (2 of 5) address
// as binary output (0-240)
`default_nettype   none
module dec2bin1(i_in, o_out);

input wire [11:0] i_in;
output wire [7:0] o_out;	// binary encoding

wire ua,ub,uc,ud,ue;
wire ta,tb,tc,td,te;
wire h1,h2;
wire [3:0] u,t;
wire [1:0] h;
assign h2 = i_in[11];
assign h1 = i_in[10];
assign ta = i_in[9];
assign tb = i_in[8];
assign tc = i_in[7];
assign td = i_in[6];
assign te = i_in[5];
assign ua = i_in[4];
assign ub = i_in[3];
assign uc = i_in[2];
assign ud = i_in[1];
assign ue = i_in[0];

assign u[0] = ua & uc | ua & ud | ub & ud | ub & ue | uc & ue;
assign u[1] = ua & ue | ub & uc | ub & ud | ub & ue;
assign u[2] = ua & uc | ub & ud | ua & ub | ub & uc;
assign u[3] = uc & ud | uc & ue;

assign t[0] = ta & tc | ta & td | tb & td | tb & te | tc & te;
assign t[1] = ta & te | tb & tc | tb & td | tb & te;
assign t[2] = ta & tc | tb & td | ta & tb | tb & tc;
assign t[3] = tc & td | tc & te;
assign h = {h2,h1};

assign o_out = h * 8'sd100 + t * 8'sd10 + u;

endmodule
