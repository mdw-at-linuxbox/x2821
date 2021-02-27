`default_nettype   none
module ss1(i_clk, i_reset,
	i_in, o_out);

parameter N = 5;

input wire i_clk;
input wire i_reset;
input wire i_in;
output reg o_out;

reg [$clog2(N):0] count;

always @(posedge i_clk) begin
	if (i_reset)
		o_out <= 0;
	else begin
		o_out <= count != 0;
		if (i_in) begin
			count <= N;
			o_out <= 1;
		end else if (|count)
			count <= count - 1;
	end
end
endmodule
