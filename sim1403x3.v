// simulate 1403 timing pulses
`default_nettype   none
module sim1403x3(i_clk, i_reset,
	i_low_speed_start, i_low_speed_stop,
	i_high_speed_start, i_high_speed_stop,
	i_print, i_hammer_fire,
	o_sense_amp_1, o_sense_amp_2,
	o_mag_emitter, o_slow_brushes, o_stop_brushes);
input wire i_clk;
input wire i_reset;
input wire i_low_speed_start;
input wire i_low_speed_stop;
input wire i_high_speed_start;
input wire i_high_speed_stop;
input wire i_print;
input wire [132:1] i_hammer_fire;
output reg o_sense_amp_1;
output wire o_sense_amp_2;
output wire o_mag_emitter;
output wire [11:0] o_slow_brushes;
output wire [11:0] o_stop_brushes;
//1ss=5500us	550
//2ss=9800us	980
//3ss=13800us	1380

parameter SCAN_TIME = 2368;
parameter SCAN_WIDTH = 190;
parameter SCANS_PER_HOME_PULSE = 48;	// should be 144
parameter LINES_PER_PAGE = 66;

localparam ST = (SCAN_TIME+4)/16;
localparam HP = SCANS_PER_HOME_PULSE * 24;
localparam SW = SCAN_WIDTH/2;
localparam INIT_STOP_POS = 0;
localparam INIT_SLOW_POS = ((INIT_STOP_POS-7)+LINES_PER_PAGE) % LINES_PER_PAGE;

localparam W=$clog2(ST);
localparam H=$clog2(HP);
localparam C = $clog2(SW);
localparam L = $clog2(LINES_PER_PAGE);

reg [W-1:0] scan_counter;
reg [H-1:0] home_counter;
reg [L-1:0] lpos;
reg [5:0] fpos;
reg jam;
reg [11:0] carriage_tape[0:(LINES_PER_PAGE-1)];
wire sense_amp_1;
wire sense_amp_2;
wire [L-1:0] slow_pos;
wire [6:0] next_fpos = 7'd1 + {1'b0, fpos};

wire ss1;
wire ss2;
wire ss3;
wire pass;
wire at_home;

time last_home_time;
reg [132:1] last_hammer_fire;
wire [7:0] hammer;

assign at_home = ~|home_counter;

assign slow_pos = (lpos >= LINES_PER_PAGE-7) ? (lpos+(7-LINES_PER_PAGE)) : lpos + 7;
initial begin
lpos <= INIT_STOP_POS;
fpos <= 6'h20;
jam <= 0;
move_state <= 0;
move_delay <= 0;
free_state <= 0;
end

genvar i;
generate for(i = 0; i < LINES_PER_PAGE; i = i + 1) begin
initial carriage_tape[i] = |(i % 5) ? 0 : (1<<(i % 12));
end
endgenerate

wire inpos = (fpos > 6'h13 && fpos < 6'h2c);
assign o_stop_brushes = jam ? (~12'b0) : ~gate_brushes ? 12'b0 : carriage_tape[lpos];
assign o_slow_brushes = jam ? (~12'b0) : ~gate_brushes ? 12'b0 : carriage_tape[slow_pos];
wire gate_brushes = (fpos > 6'h0a && fpos < 6'h36);

wire [132-1:0] ham1_bits[0:7];
generate for(i = 0; i < 8*132; i = i + 1) begin
assign ham1_bits[i&7][i>>3] = i_hammer_fire[1+(i>>3)] & |((1+(i>>3))&(1<<(i&7)));
end
endgenerate
generate for(i = 0; i < 8; i = i + 1) begin
assign hammer[i] = |ham1_bits[i];
end
endgenerate

wire low_speed_go;
wire high_speed_go;
wire low_high_jam;

assign low_speed_go = i_low_speed_start & ~i_low_speed_stop;
assign high_speed_go = i_high_speed_start & ~i_high_speed_stop;

assign low_high_jam = ~(i_low_speed_start ^ i_low_speed_stop) |
	~(i_high_speed_start ^ i_high_speed_stop);

reg [3:0] move_state;
reg [10:0] move_delay;
reg [10:0] shift_count;

task advance_fpos;
begin
	fpos <= next_fpos[5:0];
	if (~next_fpos[6])
		;
	else if (lpos >= (LINES_PER_PAGE-1))
		lpos <= 0;
	else
		lpos <= lpos + 1;
end
endtask

assign o_mag_emitter = move_state < 4 | ~inpos;

reg [1:0] free_state;
reg [31:0] free_count;

task move_carriage;
begin
	free_state <= free_state + 1;
	if (move_state != 0 && i_print)
		jam <= 1;
	case (free_state)
	0: free_count <= $random;
	default: free_count <= {free_count[23:0],free_count[31:24]};
	endcase
	if (jam)
		;
	else if (low_high_jam)
		jam <= 1;
	else if (move_delay) begin
		move_delay <= move_delay - 1;
		case (move_state)
		0:	// starting
		if (~low_speed_go & ~high_speed_go) begin
			jam <= 1;
		end
		1:	// settling
		if (low_speed_go | high_speed_go) begin
			jam <= 1;
		end
		endcase
	end else case (move_state)
	0: begin
		if (low_speed_go | high_speed_go) begin
			move_delay <= 150;
			move_state <= 2;
		end
	end
	1: begin	// done settling
		move_state <= 0;
		fpos <= 6'h20;
	end
	3,
	2: if (~low_speed_go & ~high_speed_go) begin
			move_delay = 400;
			move_state <= 1;
		end else begin
			move_delay <= 4 + |(free_count[1:0]) + {(move_state==3),2'b0};
			advance_fpos();
			shift_count <= 0;
			if (fpos == 'h12 && move_state == 2)
				move_state <= 3;
			else if (fpos == 'h0f && move_state == 3)
				move_state <= high_speed_go ? 5 : 4;
		end
	4:
		if (~low_speed_go & ~high_speed_go) begin
			move_delay <= 400;
			move_state <= 1;
		end else begin
			if (shift_count) shift_count <= shift_count - 1;
			if (high_speed_go) case(shift_count)
			0: shift_count <= 195;
			1: move_state <= 5;
			endcase
			move_delay <= 6 + ((free_count % 9) >= 1);
			advance_fpos();
		end
	5:
		if (~low_speed_go & ~high_speed_go) begin
			jam <= 1;
		end else begin
			if (shift_count) shift_count <= shift_count - 1;
			if (~high_speed_go) case(shift_count)
			0: shift_count <= 195;
			1: move_state <= 4;
			endcase
			move_delay <= 2 + ((free_count % 7) >= 5);
			advance_fpos();
		end
	default:
		jam <= 1;
	endcase
end
endtask

wire [7:0] cp2char[0:47];
assign cp2char[0] = "1";
assign cp2char[1] = "2";
assign cp2char[2] = "3";
assign cp2char[3] = "4";
assign cp2char[4] = "5";
assign cp2char[5] = "6";
assign cp2char[6] = "7";
assign cp2char[7] = "8";
assign cp2char[8] = "9";
assign cp2char[9] = "0";
assign cp2char[10] = "#";
assign cp2char[11] = "@";
assign cp2char[12] = "/";
assign cp2char[13] = "S";
assign cp2char[13] = "S";
assign cp2char[14] = "T";
assign cp2char[15] = "U";
assign cp2char[16] = "V";
assign cp2char[17] = "W";
assign cp2char[18] = "X";
assign cp2char[19] = "Y";
assign cp2char[20] = "Z";
assign cp2char[21] = "&";
assign cp2char[22] = ",";
assign cp2char[23] = "%";
assign cp2char[24] = "J";
assign cp2char[25] = "K";
assign cp2char[26] = "L";
assign cp2char[27] = "M";
assign cp2char[28] = "N";
assign cp2char[29] = "O";
assign cp2char[30] = "P";
assign cp2char[31] = "Q";
assign cp2char[32] = "R";
assign cp2char[33] = "-";
assign cp2char[34] = "$";
assign cp2char[35] = "*";
assign cp2char[36] = "A";
assign cp2char[37] = "B";
assign cp2char[38] = "C";
assign cp2char[39] = "D";
assign cp2char[40] = "E";
assign cp2char[41] = "F";
assign cp2char[42] = "G";
assign cp2char[43] = "H";
assign cp2char[44] = "I";
assign cp2char[45] = "+";
assign cp2char[46] = ".";
assign cp2char[47] = "<";

localparam LEADIN = SCAN_TIME/2-60;
localparam SSLEN = SCAN_TIME;
localparam KB = 0.0001407658;
localparam KC = 0.664414091;
localparam KD = 0.00150221;
localparam KE = 1.0022609819121447;
reg chain_state;
real chainpos;
time timescan;
assign timescan = (last_home_time - LEADIN);
time time_q;
time time_r;
real time_cpos;
real hammer_cpos;
reg [5:0] hammer_pos;
reg [7:0] hammer_char;
reg [132*8-1:0] print_line;

task compute_chain_state;
begin
	if (i_reset)
		chain_state <= 1'b0;
	else if (|scan_counter)
		;
	else if (home_counter[1])
		chain_state <= 0;
	else if (~|home_counter[H-1:2] | home_counter[2] & ~home_counter[1])
		chain_state <= 1;
end
endtask
task compute_chain_pos;
input t;
begin
	time_q = ($time - timescan) / SSLEN;
	time_r = ($time - timescan) % SSLEN;
	time_cpos = time_q/3.0 + time_r * KB + KD;
$display("T=%d f=%d time_pos=%g", $time, t, time_cpos);
end
endtask
task compute_hammer_pos;
begin
	last_hammer_fire <= i_hammer_fire;
	if (|{i_hammer_fire & ~last_hammer_fire}) begin
		compute_chain_pos(1'b1);
		hammer_cpos = time_cpos + (hammer-KE)*KC;
		hammer_pos = (hammer_cpos) % 48;
hammer_char = cp2char[hammer_pos];
$display("T=%d line=%d hammer=%d hammer_char=%g %d (%c)", $time, lpos, hammer, hammer_cpos, hammer_pos, hammer_char);
	print_line |= ({124'b0,hammer_char} << ((132-hammer) << 3));
	end
end
endtask
task display_print_line;
reg last_print;
integer j;
begin
last_print <= i_print;
if (i_print & ~last_print) begin
print_line = 0;
end else if (~i_print & last_print) begin
$display("T=%d line=%d print_line=<%s>", $time, lpos, print_line);
end
end
endtask

assign sense_amp_1 = chain_state;
assign sense_amp_2 = ~chain_state;

task ss;
input in;
output reg out;
reg [C-1:0] count;
begin
	if (i_reset) begin
		out <= 0;
		count <= 1;
	end else case (count)
	default:
		count <= count - 1;
	1:
		begin
			out <= 0;
			if (~in)
				count <= 0;
		end
	0:
		if (in) begin
			out <= 1;
			count <= SW;
		end
	endcase
end
endtask

task update_home_counter;
begin
	scan_counter <= scan_counter - 1;
	if (i_reset | ~|scan_counter)
		scan_counter <= ST-1;
	else
		scan_counter <= scan_counter - 1;
	if (i_reset)
		home_counter <= HP/24;
	else if (|scan_counter)
		;
	else if (~|home_counter)
		home_counter <= HP-1;
	else
		home_counter <= home_counter - 1;
end
endtask

task track_the_chain;
reg last_at_home;
begin
last_at_home <= at_home;
if (at_home & ~last_at_home) begin
	last_home_time = $time;
	compute_chain_pos(1'b0);
end
end
endtask

always @(posedge i_clk) compute_chain_state();
always @(posedge i_clk) compute_hammer_pos();
always @(posedge i_clk) update_home_counter();
always @(posedge i_clk) ss(sense_amp_1, o_sense_amp_1);
assign o_sense_amp_2 = ~o_sense_amp_1;
always @(posedge i_clk) move_carriage();
always @(posedge i_clk) track_the_chain();
always @(posedge i_clk) display_print_line();
endmodule
