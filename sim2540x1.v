// simulate 2540
`default_nettype   none
`timescale 10ns / 1ns
module sim2540x1(i_clk, i_reset,
	// from icu
	i_rpaddr, i_rpaddr_binary,
	i_read_feed, i_punch_feed,
	i_power_on_reset, i_mach_reset_rdr_pch,
	i_time_075_150, i_time_150_375,
	i_xfer_cy_req, i_unit_exception_rdr,
	i_pch_write, i_rdr_feed_command,
	i_punch_cycle, i_read_cycle,
	i_time_150_450, i_time_225_525,
	i_2821_rdr_ready_turn_off, i_2821_pch_ready_turn_off,
	i_punch_restart_gate, i_punch_decode,
	// to icu
	o_rd_1_row_bit, o_rd_2_row_bit,
	o_pch_chk_row_bit, o_pfr_row_bit,
	o_rdr_cl_lat_not_npro, o_pch_cl_lat_not_npro,
	o_gate_rd_complete_2540, o_4_bit_mod, o_pfr_unit_exception,
	o_punch_scan_cb, o_after_9_emitter, o_pch_clutch_set,
	o_unit_exception,
	o_punch_impulse_cb, o_pch_brush_cl_delay_int,
	o_die_cl_delay,
	o_punch_ready, o_reader_ready,
	o_read_impulse_cb, o_1400_unit_exception,
	// unit controls
	i_rdr_start_key,
	i_rdr_stop_key,
	i_rdr_end_of_file_key,
	i_pch_start_key,
	i_pch_stop_key,
	i_pch_end_of_file_key,
	i_strobe,		// extension, experimental
	i_cmd,			// extension, experimental
	// unit lights
	o_rdr_validity_check_light,
	o_stacker_light,
	o_rdr_ready_light,
	o_rdr_read_check_light,
	o_rdr_end_of_file_light,
	o_rdr_feed_stop_light,
	o_transport_light,
	o_chip_box_light,
	o_punch_check_light,
	o_pch_ready_light,
	o_pch_end_of_file_light,
	o_pch_feed_stop_light,
	o_ack			// extension, experimental
);

input wire i_clk;
input wire i_reset;

// rp bar
input wire [9:0] i_rpaddr;
input wire [6:0] i_rpaddr_binary;
// icu to rdr pch
input wire i_read_feed;
input wire i_punch_feed;
input wire i_power_on_reset;		//
input wire i_mach_reset_rdr_pch;	//
input wire i_time_075_150;		//
input wire i_time_150_375;		//
input wire i_xfer_cy_req;		//
input wire i_unit_exception_rdr;	//
input wire i_pch_write;			//
input wire i_rdr_feed_command;		//
input wire i_punch_cycle;
input wire i_read_cycle;		//
input wire i_time_150_450;		//
input wire i_time_225_525;		//
input wire i_2821_rdr_ready_turn_off;	//
input wire i_2821_pch_ready_turn_off;	//
input wire i_punch_restart_gate;	//
input wire i_punch_decode;
// row bit
output reg o_rd_1_row_bit;
output reg o_rd_2_row_bit;
output reg o_pch_chk_row_bit;
output reg o_pfr_row_bit;
output reg o_rdr_cl_lat_not_npro;
output reg o_pch_cl_lat_not_npro;
output reg o_gate_rd_complete_2540;
output reg o_4_bit_mod;			//
output reg o_pfr_unit_exception;	//
// rdr-pch to icu
output wire o_punch_scan_cb;
output reg o_after_9_emitter;
output reg o_pch_clutch_set;		//z
output reg o_unit_exception;
output wire o_punch_impulse_cb;
output wire o_pch_brush_cl_delay_int;	//Z
output reg o_die_cl_delay;		//
output reg o_punch_ready;
output reg o_reader_ready;
output wire o_read_impulse_cb;
output reg o_1400_unit_exception;
// unit switches
input wire i_rdr_start_key;
input wire i_rdr_stop_key;
input wire i_rdr_end_of_file_key;
input wire i_pch_start_key;
input wire i_pch_stop_key;
input wire i_pch_end_of_file_key;
input wire i_strobe;
input wire [7:0] i_cmd;
// unit lights
output wire o_rdr_validity_check_light;
output wire o_stacker_light;
output wire o_rdr_ready_light;
output wire o_rdr_read_check_light;
output reg o_rdr_end_of_file_light;
output wire o_rdr_feed_stop_light;
output wire o_transport_light;
output wire o_chip_box_light;
output wire o_punch_check_light;
output wire o_pch_ready_light;
output reg o_pch_end_of_file_light;
output wire o_pch_feed_stop_light;
output reg o_ack;

reg after_12_emitter;
reg punch_cam_digit_tooth;
reg reader_cam_digit_tooth;
reg rdr_run;
reg pch_run;

assign o_rdr_ready_light = o_reader_ready;
assign o_pch_ready_light = o_punch_ready;

wire punch_hammer = i_punch_decode & i_punch_cycle;

reg [15:0] vdata_ab;
wire [15:0] vdata_ba = 256 - vdata_ab;

reg [11:0] vdata[0:65535];

// sig Janssen upgrow monochromic myophore countersense congreve
wire [11:0] dat[0:60];
assign dat[0] = 'h680;
assign dat[1] = 'ha01;
assign dat[2] = 'ha04;
assign dat[3] = 'h000;
assign dat[4] = 'h500;
assign dat[5] = 'hb00;
assign dat[6] = 'hc10;
assign dat[7] = 'h680;
assign dat[8] = 'h680;
assign dat[9] = 'ha10;
assign dat[10] = 'hc10;
assign dat[11] = 'h000;
assign dat[12] = 'h620;
assign dat[13] = 'hc04;
assign dat[14] = 'ha04;
assign dat[15] = 'hc01;
assign dat[16] = 'hc08;
assign dat[17] = 'h608;
assign dat[18] = 'h000;
assign dat[19] = 'hc20;
assign dat[20] = 'hc08;
assign dat[21] = 'hc10;
assign dat[22] = 'hc08;
assign dat[23] = 'ha40;
assign dat[24] = 'ha02;
assign dat[25] = 'hc01;
assign dat[26] = 'hc08;
assign dat[27] = 'hc20;
assign dat[28] = 'ha01;
assign dat[29] = 'ha40;
assign dat[30] = 'h000;
assign dat[31] = 'hc20;
assign dat[32] = 'h602;
assign dat[33] = 'hc08;
assign dat[34] = 'hc04;
assign dat[35] = 'ha02;
assign dat[36] = 'hc08;
assign dat[37] = 'hc01;
assign dat[38] = 'ha10;
assign dat[39] = 'h000;
assign dat[40] = 'ha40;
assign dat[41] = 'hc08;
assign dat[42] = 'h620;
assign dat[43] = 'hc10;
assign dat[44] = 'h640;
assign dat[45] = 'ha10;
assign dat[46] = 'hc01;
assign dat[47] = 'h680;
assign dat[48] = 'ha10;
assign dat[49] = 'hc10;
assign dat[50] = 'h680;
assign dat[51] = 'ha10;
assign dat[52] = 'h000;
assign dat[53] = 'ha40;
assign dat[54] = 'hc08;
assign dat[55] = 'hc10;
assign dat[56] = 'ha04;
assign dat[57] = 'hc01;
assign dat[58] = 'ha10;
assign dat[59] = 'h610;
assign dat[60] = 'ha10;

wire [35:0] xyz = 36'h204202201;

task set_card_sequence;
input [15:0] base;
input [35:0] lbl;
input [15:0] sno;
reg [39:0] field;
begin
	$sformat(field, "%05d", sno);
	vdata[base+0] = lbl[35:24];
	vdata[base+1] = lbl[23:12];
	vdata[base+2] = lbl[11:0];
	vdata[base+3] = field[35:32]==0 ? 12'h200 : (12'h1<<(9-field[35:32]));
	vdata[base+4] = field[27:24]==0 ? 12'h200 : (12'h1<<(9-field[27:24]));
	vdata[base+5] = field[19:16]==0 ? 12'h200 : (12'h1<<(9-field[19:16]));
	vdata[base+6] = field[11:8]==0 ? 12'h200 : (12'h1<<(9-field[11:8]));
	vdata[base+7] = field[3:0]==0 ? 12'h200 : (12'h1<<(9-field[3:0]));
end
endtask

task set_card_data;
input [15:0] base;
inout [31:0] xx;
reg [7:0] oo;
integer xxx;
begin
	oo = 0;
	xxx = xx;
	while (oo < 71) begin
		vdata[base+oo] = dat[xxx];
		oo = oo + 1;
		if (xxx >= 60) xxx = 0;
		else xxx = xxx + 1;
	end
	xx = xxx;
	vdata[base+71] = 12'h000;	// " "
end
endtask

wire punch_impulse_cb;
	ss2 #(500) u_pch_scan_cb(i_clk, i_reset, punch_cam_digit_tooth, o_punch_scan_cb);
	ss2 #(500) u_pch_brush_impulse(i_clk, i_reset, ~punch_cam_digit_tooth, o_punch_impulse_cb);
// XXX turns out pch_brush_cl_delay_int needs to come true
//  when evaluating final value of xu/xl for hole count check.
// NB 1402_Reader-Punch_Wiring_Diagram.pdf pdf page 20 has
//  a picture of the raw punch cam timings (for the 1402).
wire wrong_pch_brush_cl_delay_int = o_punch_impulse_cb & pch_chk_impulse_gate;
assign o_pch_brush_cl_delay_int = o_after_9_emitter;
reg [11:0] punch_data[0:1][0:80];
reg [12:0] punch_mask;
wire [11:0] punch_row_mask, pchchk_row_mask;
assign punch_row_mask = punch_mask[12:1];
assign pchchk_row_mask = punch_mask[11:0];
reg [31:0] punch_clock;
reg punch_ab;
wire punch_ba = punch_ab ^ 1'b1;
localparam PCH_TSCANON = 6300;
localparam PCH_ESCANON = 8550;
localparam PCH_0SCANON = 10800;
localparam PCH_1SCANON = 13050;
localparam PCH_2SCANON = 15300;
localparam PCH_3SCANON = 17550;
localparam PCH_4SCANON = 19800;
localparam PCH_5SCANON = 22050;
localparam PCH_6SCANON = 24300;
localparam PCH_7SCANON = 26550;
localparam PCH_8SCANON = 28800;
localparam PCH_9SCANON = 31150;
localparam PCH_9EMITON = 33300;	// must be true for at least 1 scan cycle
localparam PCH_9EMITOFF = 35300;	// so that col_80 can come true
localparam PCH_MAX = 36000;
localparam PCH_SCANDLY = 2000;
localparam PCH_CLUTCHDLY = 900;
//localparam PCH_CLUTCHDLY2 = 932;
localparam PCH_1CLUTCHON = 1000;
localparam PCH_2CLUTCHON = 10500;
localparam PCH_3CLUTCHON = 18500;
localparam PCH_4CLUTCHON = 27500;
reg [6:0] i;

reg screw_next_pchchk;
reg pch_screw_tripped;
wire pch_pervert_bit = (screw_next_pchchk & (i_rpaddr_binary == 5) & (punch_row_mask == 'h100));
reg [2:0] punch_path;
wire pch_chk_station = punch_path[0];
wire punch_station = punch_path[1];
wire pfr_station = punch_path[2];
wire pch_chk_impulse_gate = pch_chk_station & |pchchk_row_mask;

wire [2:0] next_punch_path = {x_punch_feed & ~o_pch_end_of_file_light, pfr_station, punch_station};

wire [11:0] vdata_debug_out = vdata[vdata_ab + i_rpaddr_binary];
wire [11:0] punch_data_debug_out = punch_data[punch_ab][i_rpaddr_binary] &
	{12{i_rpaddr_binary != 0}};
wire [11:0] punch_data_debug_out2 = punch_data[punch_ab][1];

wire x_punch_feed = (!o_punch_ready & pch_run) | i_punch_feed;

task advance_punch_clock;
begin
		if (i_reset || punch_clock >= PCH_MAX) begin
			punch_clock <= 0;
		end else if (!pch_run && !punch_clock) begin
			o_punch_ready <= 0;
		end else if (pch_run && !punch_clock & pfr_station & ~o_punch_ready) begin
			o_punch_ready <= 1;
		end else if (x_punch_feed && !punch_clock) begin
$display("T=%d start punch feed %d", $time, next_punch_path);
			punch_path <= next_punch_path;
			punch_ab <= punch_ba;
			punch_clock <= 1;
			punch_mask <= 13'h000;
		end else if (punch_clock && punch_clock < PCH_MAX)
			punch_clock <= punch_clock + 1;
		case (punch_clock)
		PCH_9EMITON: begin
			o_after_9_emitter <= 1;
			punch_mask <= {1'b0, punch_mask[12:1]};
		end
		PCH_9EMITOFF: begin
			punch_mask <= 0;
if (pch_screw_tripped) begin
pch_screw_tripped <= 0;
screw_next_pchchk <= 0;
end
$display("T=%d end punch feed %d", $time, punch_path);
if (punch_station) for (i = 1; i <= 80; i = i + 16) begin
$display("%d: %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x",
	i,
	punch_data[punch_ab][i], punch_data[punch_ab][i+1],
	punch_data[punch_ab][i+2], punch_data[punch_ab][i+3],
	punch_data[punch_ab][i+4], punch_data[punch_ab][i+5],
	punch_data[punch_ab][i+6], punch_data[punch_ab][i+7],
	punch_data[punch_ab][i+8], punch_data[punch_ab][i+9],
	punch_data[punch_ab][i+10], punch_data[punch_ab][i+11],
	punch_data[punch_ab][i+12], punch_data[punch_ab][i+13],
	punch_data[punch_ab][i+14], punch_data[punch_ab][i+15]);
end
			o_after_9_emitter <= 0; end
		PCH_TSCANON,PCH_ESCANON,PCH_0SCANON,PCH_1SCANON,
		PCH_2SCANON,PCH_3SCANON,PCH_4SCANON,PCH_5SCANON,
		PCH_6SCANON,PCH_7SCANON,PCH_8SCANON,PCH_9SCANON: begin
			punch_mask <= {punch_clock == PCH_TSCANON,punch_mask[12:1]};
			punch_cam_digit_tooth <= 1;
		end
		PCH_TSCANON+PCH_SCANDLY,PCH_ESCANON+PCH_SCANDLY,
		PCH_0SCANON+PCH_SCANDLY,PCH_1SCANON+PCH_SCANDLY,
		PCH_2SCANON+PCH_SCANDLY,PCH_3SCANON+PCH_SCANDLY,
		PCH_4SCANON+PCH_SCANDLY,PCH_5SCANON+PCH_SCANDLY,
		PCH_6SCANON+PCH_SCANDLY,PCH_7SCANON+PCH_SCANDLY,
		PCH_8SCANON+PCH_SCANDLY,PCH_9SCANON+PCH_SCANDLY:
			punch_cam_digit_tooth <= 0;
		endcase
		case (punch_clock)
		PCH_1CLUTCHON, PCH_2CLUTCHON,
		PCH_3CLUTCHON, PCH_4CLUTCHON:
			o_pch_clutch_set <= 1;
		PCH_1CLUTCHON+PCH_CLUTCHDLY,
		PCH_2CLUTCHON+PCH_CLUTCHDLY,
		PCH_3CLUTCHON+PCH_CLUTCHDLY,
		PCH_4CLUTCHON+PCH_CLUTCHDLY: begin
			o_pch_clutch_set <= 0;
		end
//		PCH_1CLUTCHON+PCH_CLUTCHDLY2,
//		PCH_2CLUTCHON+PCH_CLUTCHDLY2,
//		PCH_3CLUTCHON+PCH_CLUTCHDLY2,
//		PCH_4CLUTCHON+PCH_CLUTCHDLY2:
		endcase
		if (!i_punch_cycle)
			o_pch_chk_row_bit <= 0;
		else if (~|i_rpaddr_binary) begin
//$display("T=%d i_punch_cycle but no rpaddr?", $time);
		end else
		if (~|{punch_row_mask | pchchk_row_mask}) begin
// XXX control unit does punch cycles at start of card cycle, ignore these.
if (punch_clock > PCH_TSCANON && punch_clock < PCH_9EMITOFF)
$display("T=%d i_punch_cycle but no row mask?", $time);
		end else begin
		if (|punch_row_mask) begin
if (punch_row_mask == 12'h100 &&
punch_data[punch_ab][i_rpaddr_binary] & punch_row_mask && ~(punch_hammer))
begin
$display("T=%d clearing %d,%x", $time, i_rpaddr_binary, punch_row_mask);
end
			punch_data[punch_ab][i_rpaddr_binary] <=
				punch_row_mask &
					{12{punch_hammer}} |
				~punch_row_mask &
					punch_data[punch_ab][i_rpaddr_binary];
		end
		if (|pchchk_row_mask) begin
			o_pch_chk_row_bit <= (|{(punch_data[punch_ba]
				[i_rpaddr_binary]) & pchchk_row_mask}
				^ pch_pervert_bit)
				& pch_chk_station & (i_rpaddr_binary != 0);
if (pch_pervert_bit & ~pch_screw_tripped) begin pch_screw_tripped <= 1;
$display("T=%d perverted pch_chk bit @ %d; %x -> %x", $time,
i_rpaddr_binary,
punch_data[punch_ba][i_rpaddr_binary],
pch_chk_station ^ punch_data[punch_ba][i_rpaddr_binary]);
end
		end
		end
	end
endtask

reg [11:0] reader_row_mask;
reg [31:0] reader_clock;
localparam RDR_9SCANON = 6300;
localparam RDR_8SCANON = 8550;
localparam RDR_7SCANON = 10800;
localparam RDR_6SCANON = 13050;
localparam RDR_5SCANON = 15300;
localparam RDR_4SCANON = 17550;
localparam RDR_3SCANON = 19800;
localparam RDR_2SCANON = 22050;
localparam RDR_1SCANON = 24300;
localparam RDR_0SCANON = 26550;
localparam RDR_ESCANON = 28800;
localparam RDR_TSCANON = 31150;
localparam RDR_12EMITON = 33300;	// vestigial
localparam RDR_12EMITOFF = 35300;	// (mostly) vestigial
localparam RDR_MAX = 36000;
localparam RDR_SCANDLY = 2000;

reg screw_next_rd2;
reg screw_next_rdr_inv;
reg rdr_screw_tripped;
wire rdr_pervert_bit = (screw_next_rd2 & (i_rpaddr_binary == 5) & (reader_row_mask == 'h100));
reg [2:0] reader_path;
wire stk_station = reader_path[0];
wire rdr2_station = reader_path[1];
wire rdr1_station = reader_path[2];

wire [2:0] next_reader_path = {x_reader_feed & ~o_rdr_end_of_file_light,
	rdr1_station, rdr2_station};
wire x_reader_feed = (~o_reader_ready & rdr_run) | i_read_feed;

task advance_reader_clock;
begin
		if (i_reset || reader_clock >= RDR_MAX) begin
			reader_clock <= 0;
		end else if (!rdr_run && !reader_clock) begin
			o_reader_ready <= 0;
		end else if (rdr_run && !reader_clock && rdr2_station && ~o_reader_ready) begin
			o_reader_ready <= 1;
		end else if (x_reader_feed && !reader_clock) begin
$display("T=%d start reader feed %d", $time, reader_path);
			reader_path <= next_reader_path;
			reader_clock <= 1;
			reader_row_mask <= 12'h000;
			vdata_ab <= vdata_ba;
		end else if (reader_clock && reader_clock < RDR_MAX)
			reader_clock <= reader_clock + 1;
		case (reader_clock)
		3: begin
			set_card_data(vdata_ab+1, dataoff);
			seqno = seqno + 1;
			set_card_sequence(vdata_ab + 1 + 72, xyz, seqno);
if (screw_next_rdr_inv) begin
screw_next_rdr_inv <= 0;
$display("T=%d invalid bit @ %d; %x -> %x; seqno=%0d", $time,
7'sd3,
vdata[vdata_ab + 1 + 3],
vdata[vdata_ab + 1 + 3] | 12'h030, seqno);
vdata[vdata_ab + 1 + 3] =
vdata[vdata_ab + 1 + 3] | 12'h030;
end
		end
		RDR_12EMITON:
			after_12_emitter <= 1;
		RDR_12EMITOFF: begin
$display("T=%d end reader feed %d", $time, reader_path);
if (rdr_screw_tripped) begin
rdr_screw_tripped <= 0;
screw_next_rd2 <= 0;
end
			after_12_emitter <= 0; end
		RDR_TSCANON,RDR_ESCANON,RDR_0SCANON,RDR_1SCANON,
		RDR_2SCANON,RDR_3SCANON,RDR_4SCANON,RDR_5SCANON,
		RDR_6SCANON,RDR_7SCANON,RDR_8SCANON,RDR_9SCANON: begin
			reader_row_mask <= {reader_row_mask[10:0],
				reader_clock == RDR_9SCANON};
			reader_cam_digit_tooth <= 1;
		end
		RDR_TSCANON+RDR_SCANDLY,RDR_ESCANON+RDR_SCANDLY,
		RDR_0SCANON+RDR_SCANDLY,RDR_1SCANON+RDR_SCANDLY,
		RDR_2SCANON+RDR_SCANDLY,RDR_3SCANON+RDR_SCANDLY,
		RDR_4SCANON+RDR_SCANDLY,RDR_5SCANON+RDR_SCANDLY,
		RDR_6SCANON+RDR_SCANDLY,RDR_7SCANON+RDR_SCANDLY,
		RDR_8SCANON+RDR_SCANDLY,RDR_9SCANON+RDR_SCANDLY:
			reader_cam_digit_tooth <= 0;
		endcase
		if (!i_read_cycle) begin
o_rd_1_row_bit <= 0;
o_rd_2_row_bit <= 0;
		end else if (~|i_rpaddr_binary | ~|reader_row_mask) begin
//$display("T=%d reader_cycle but no rpaddr/mask?", $time);
		end else begin
// set o_rd_1_row_bit
// set o_rd_2_row_bit
o_rd_1_row_bit <= |{vdata[vdata_ab + i_rpaddr_binary] & reader_row_mask};
if (rdr2_station) begin
o_rd_2_row_bit <= |{vdata[vdata_ba + i_rpaddr_binary] & reader_row_mask}
	^ rdr_pervert_bit;
if (rdr_pervert_bit & ~rdr_screw_tripped) begin rdr_screw_tripped <= 1;
$display("T=%d perverted rd2 bit @ %d; %x -> %x", $time,
i_rpaddr_binary,
vdata[vdata_ba + i_rpaddr_binary],
reader_row_mask ^ vdata[vdata_ba + i_rpaddr_binary]);
end
end else
o_rd_2_row_bit <= 0;
//	parms: i_rpaddr_binary
//	reader_row_mask
		end
	end
endtask

	ss2 #(80) u_rdr_scan_cb(i_clk, i_reset, reader_cam_digit_tooth,
		o_read_impulse_cb);

task do_switches;
begin
	if (!o_reader_ready & i_rdr_start_key)
		rdr_run <= 1;
	if (!o_punch_ready & i_pch_start_key)
		pch_run <= 1;
	if (o_reader_ready & (i_rdr_stop_key | i_2821_rdr_ready_turn_off))
	begin
		rdr_run <= 0;
		o_rdr_end_of_file_light <= 0;
	end
	if (o_punch_ready & (i_pch_stop_key | i_2821_pch_ready_turn_off))
	begin
		pch_run <= 0;
		o_pch_end_of_file_light <= 0;
	end
	if (o_reader_ready && i_rdr_end_of_file_key && ~o_rdr_end_of_file_light)
		o_rdr_end_of_file_light <= 1;
	if (o_punch_ready && i_pch_end_of_file_key && ~o_pch_end_of_file_light)
		o_pch_end_of_file_light <= 1;
end
endtask

task do_commands;
reg busy;
begin
	if (i_reset) begin
		busy <= 0;
		o_ack <= 0;
	end else case({i_strobe, busy})
	0:
		;
	1: begin
		busy <= 0;
		o_ack <= 0;
	end
	2: begin
		busy <= 1;
		o_ack <= 1;
		case (i_cmd)
		"r":
			screw_next_rd2 <= 1;
		"i":
			screw_next_rdr_inv <= 1;
		"p":
			screw_next_pchchk <= 1;
		endcase
	end
	3: ;
	endcase
		
end
endtask

task do_init;
begin
// $monitor("T=%d cycle_clutch=%b cycle_counter", $time, cycle_clutch, cycle_counter);
punch_clock <= 0;
o_punch_ready <= 0;
o_reader_ready <= 0;
o_after_9_emitter <= 0;
after_12_emitter <= 0;
o_rd_1_row_bit <= 0;
o_rd_2_row_bit <= 0;
o_pfr_row_bit <= 0;
o_rdr_cl_lat_not_npro <= 0;
o_pch_cl_lat_not_npro <= 0;
o_pch_clutch_set <= 0;
punch_cam_digit_tooth <= 0;
reader_cam_digit_tooth <= 0;
punch_ab <= 1'b0;
o_gate_rd_complete_2540 <= 1;
o_die_cl_delay <= 1'b1;
o_4_bit_mod <= 1'b0;
o_pfr_unit_exception <= 1'b0;
punch_path <= 0;
reader_path <= 0;
rdr_run <= 0;
pch_run <= 0;
o_pch_end_of_file_light <= 0;
o_rdr_end_of_file_light <= 0;
screw_next_rd2 <= 0;
screw_next_rdr_inv <= 0;
screw_next_pchchk <= 0;
pch_screw_tripped <= 0;
rdr_screw_tripped <= 0;

	// initial reset
	end
endtask

integer dataoff;
reg [15:0] seqno;

always @(posedge i_clk) advance_punch_clock();
always @(posedge i_clk) advance_reader_clock();
always @(posedge i_clk) do_switches();
always @(posedge i_clk) do_commands();
initial begin
	do_init();
	dataoff = 0;
	seqno = 0;
	vdata_ab <= 0;
end
endmodule
