`default_nettype   none
module delay2(i_clk, i_reset,
	i_in, o_out);

parameter N = 5;

input wire i_clk;
input wire i_reset;
input wire i_in;
output reg o_out;

reg [$clog2(N):0] count;

always @(posedge i_clk) begin
	if (i_reset) begin
		o_out <= 0;
		count <= 0;
	end else case (count)
	default:
		count <= count - 1;
	1:
		begin
			if (~i_in) begin
				count <= 0;
				o_out <= 0;
			end else
				o_out <= 1;
		end
	0:
		if (i_in) begin
			count <= N;
		end
	endcase
end
endmodule
