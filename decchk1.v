// validate "2 of 5" code input
// output "1" if bitcount(input) != 2
`default_nettype   none
module decchk1(i_value, o_check);

input wire [4:0] i_value;
output wire o_check;

wire a,b,c,d,e;
assign a=i_value[0];
assign b=i_value[1];
assign c=i_value[2];
assign d=i_value[3];
assign e=i_value[4];

assign o_check = ~(~a & ~b & ~c & (~d | ~e) |	// 0000- 000-0
	~a & ~d & ~e & (~b | ~c) |		// 00-00 0-000
	~b & ~c & ~d & ~e |			// -0000
	d & e & (b | c) |			// --111 -1-11
	b & c & (d | e) |			// -111- -11-1
	a & d & (c | e) |			// 1--11 1-11-
	a & c & (b | e) |			// 1-1-1 111--
	a & b & (d | e));			// 11-1- 11--1

endmodule
