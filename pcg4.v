// Y24-3503-0_2821_Field_Engineering_Maintenance_Diagrams_Dec68.pdf
`default_nettype   none
module pcg4(i_clk,
	i_reset,
	i_advance_by_1,
	i_advance_by_2,
	o_pcg);

input wire i_clk;
input wire i_reset;
input wire i_advance_by_1;
input wire i_advance_by_2;
output wire [5:0] o_pcg;

//////// page 93
//////// sld-41 print character generator
//////// 5083

wire pcg_1;
wire pcg_2;
wire pcg_4;
wire pcg_8;
wire pcg_a;
wire pcg_b;
wire x_12_not_4;
wire x_2_not_14;
wire x_124;
wire x_48;
wire x_821;

wire reset_pcg;

assign o_pcg = { pcg_b, pcg_a, pcg_8, pcg_4, pcg_2, pcg_1 };

assign reset_pcg = i_reset;

reg last_advance_by_1;
reg last_advance_by_2;

always @(posedge i_clk) begin
	last_advance_by_1 = i_advance_by_1;
	last_advance_by_2 = i_advance_by_2;
end

wire advance_by_1;
wire advance_by_2;
assign advance_by_1 = i_advance_by_1 & ~last_advance_by_1;
assign advance_by_2 = i_advance_by_2 & ~last_advance_by_2;

latch1 u1(i_clk,
	~pcg_1 & advance_by_1,
	reset_pcg | pcg_1 & advance_by_1,
	pcg_1);

latch1 u2(i_clk,
	~pcg_2 & pcg_1 & advance_by_1 |
	~pcg_2 & advance_by_2,
	reset_pcg | pcg_2 & advance_by_2 |
	pcg_1 & advance_by_1 & pcg_2,
	pcg_2);

assign x_12_not_4 = pcg_1 & pcg_2 & ~pcg_4;
assign x_2_not_14 = pcg_2 & ~pcg_1 & ~pcg_4 | pcg_2 & ~pcg_4 & ~pcg_8;
assign x_124 = pcg_1 & pcg_2 & pcg_4 | pcg_4 & pcg_8;
assign x_48 = pcg_4 & pcg_8 | pcg_2 & pcg_4;
assign x_821 = pcg_8 & pcg_2 & pcg_1 | pcg_8 & pcg_4;

latch1 u4(i_clk,
	x_12_not_4 & advance_by_1 |
	x_2_not_14 & advance_by_2,
	reset_pcg | x_124 & advance_by_1 |
	x_48 & advance_by_2,
	pcg_4);

latch1 u8(i_clk,
	pcg_1 & pcg_2 & pcg_4 & advance_by_1 |
	pcg_2 & pcg_4 & advance_by_2,
	reset_pcg | pcg_8 & pcg_4 & advance_by_1 |
	x_821 & advance_by_2,
	pcg_8);

latch1 ua(i_clk,
	~pcg_a & pcg_8 & pcg_4 & advance_by_1 |
	~pcg_a & x_821 & advance_by_2,
	reset_pcg | pcg_a & pcg_8 & pcg_4 & advance_by_1 |
	pcg_a & x_821 & advance_by_2,
	pcg_a);

latch1 ub(i_clk,
	~pcg_b & pcg_a & pcg_8 & pcg_4 & advance_by_1 |
	~pcg_b & pcg_a & x_821 & advance_by_2,
	reset_pcg | pcg_b & pcg_a & pcg_8 & pcg_4 & advance_by_1 |
	pcg_b & pcg_a & x_821 & advance_by_2,
	pcg_b);

endmodule
