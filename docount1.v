// x2821 row counter 1 - 12
// Y24-3503-0_2821_Field_Engineering_Maintenance_Diagrams_Dec68.pdf
// read counter encoding on page 8
//	A	9	ABCDE	5	DEF	1
//	AB	8	ABCDEF	4	EF	10
//	ABC	7	BCDEF	3	F	11
//	ABCD	6	CDEF	2	-	12
// punch counter encoding on page 10
//	A	12	ABCDE	2	DEF	6
//	AB	11	ABCDEF	3	EF	7
//	ABC	10	BCDEF	4	F	8
//	ABCD	1	CDEF	5	-	9
`default_nettype   none
module docount1(i_clk,
	i_clear,
	i_advance,
	o_output);

input wire i_clk;
input wire i_clear;
input wire i_advance;
output wire [5:0] o_output;

reg a,b,c,d,e,f;

assign o_output = {a,b,c,d,e,f};

wire [5:0] next_count;
assign next_count = {~f, a, b, c, d, e};

always @(posedge i_clk) begin
	if (i_clear)
		{a,b,c,d,e,f} <= 6'b0;
	else if (i_advance)
		{a,b,c,d,e,f} <= next_count;
end

endmodule
