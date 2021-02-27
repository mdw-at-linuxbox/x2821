// Y24-3503-0_2821_Field_Engineering_Maintenance_Diagrams_Dec68.pdf
`default_nettype   none
module x2821(i_clk, i_reset,
	i_bus_out, o_bus_in,
	i_address_out, i_command_out, i_service_out, i_data_out,
	o_address_in, o_status_in, o_service_in, o_data_in, o_disc_in,
	i_operational_out, i_select_out, i_hold_out, i_suppress_out,
	o_operational_in, o_select_in, o_request_in,
	// 2540
	i_rd_1_row_bit,
	i_rd_2_row_bit,
	i_pch_chk_row_bit,
	i_pfr_row_bit,
	i_rdr_cl_lat_not_npro,
	i_pch_cl_lat_not_npro,
	i_gate_rd_complete_2540,
	i_4_bit_mod_pull_on,
	i_pfr_unit_exception_gate,
	i_punch_scan_cb,
	i_after_9_emitter,
	i_pch_clutch_set,
	i_unit_exception,
	i_pch_brush_impulse,
	i_pch_brush_cl_delay_int,	// !
	i_die_cl_delay,
	i_punch_ready,
	i_reader_ready,
	i_read_impulse_cb,
	i_1400_unit_exception_gate,
	o_rpaddr,
	o_rpaddr_binary,
	o_read_feed,
	o_punch_feed,
	o_power_on_reset,
	o_mach_reset_rdr_pch,
	o_time_075_150,
	o_time_150_375,
	o_xfer_cy_req,
	o_unit_exception_rdr,
	o_pch_write,
	o_rdr_feed_command,
	o_punch_cycle,
	o_read_cycle,
	o_time_150_450,
	o_time_225_525,
	o_2821_rdr_ready_turn_off,
	o_2821_pch_ready_turn_off,
	o_punch_restart_gate,
	o_punch_decode,
	o_2540_reader_check,
	o_read_val_chk,
	// 1403
	i_sense_amp_1,
	i_sense_amp_2,
	i_slow_brushes,
	i_stop_brushes,
	i_mag_emitter,
	i_60_volt_sense,	// indicates hammer fired
	i_gate_interlock,	// gate open or no print train
	i_carriage_interlock,	// brush intlk, shift intlk
	i_forms_check_or_carr_stop,
	i_end_of_forms,
	i_restore_key,
	i_prt_stop_key,
	i_single_cycle_key,
	i_prt_start_key,
	i_space_key,
	o_print,
	o_hammer_fire,
	o_low_speed_start,
	o_low_speed_stop,
	o_high_speed_start,
	o_high_speed_stop,
	o_paper_damper_mag_drive,
	o_print_ready_ind_ce,
	o_forms_check_ind,
	o_print_check_ind,
	o_sync_check_ind,
	o_end_of_forms_ind,
	// ce
	o_data_enter_no,
	o_punch_xlate_check_light,
	o_pfr_val_light,
	i_data_enter_sw,
	i_data_enter_0_7,
	i_burst_sw_on,
	i_one_byte_sw_on,
	i_load_and_single_cycle_sw,
	i_ce_2540_off_line_sw,
	i_ce_mach_reset,
	i_sync_recycle_jumper,
	i_home_gate_jumper,
	i_pss_trig_jumper,
	i_check_reset);


input wire i_clk;
input wire i_reset;

	input wire [8:0] i_bus_out;
	output wire [8:0] o_bus_in;
	input wire i_address_out;
	input wire i_command_out;
	input wire i_service_out;
	input wire i_data_out;
	output wire o_address_in;
	output wire o_status_in;
	output wire o_service_in;
	output wire o_data_in;
	output wire o_disc_in;
/* verilator lint_off UNUSED */
	input wire i_operational_out;
/* verilator lint_on UNUSED */
	input wire i_suppress_out;
	input wire i_select_out;
	input wire i_hold_out;
	output wire o_operational_in;
	output wire o_select_in;
	output wire o_request_in;

// 2540
//	row bit
input wire i_rd_1_row_bit;	// as addressed by rpaddr
input wire i_rd_2_row_bit;	// as addressed by rpaddr
input wire i_pch_chk_row_bit;	// as addressed by rpaddr
input wire i_pfr_row_bit;	// as addressed by rpaddr
input wire i_rdr_cl_lat_not_npro;
input wire i_pch_cl_lat_not_npro;
input wire i_gate_rd_complete_2540;
input wire i_4_bit_mod_pull_on;
input wire i_pfr_unit_exception_gate;
//	rdr-pch to icu
input wire i_punch_scan_cb;
input wire i_after_9_emitter;
input wire i_pch_clutch_set;
input wire i_unit_exception;
input wire i_pch_brush_impulse;
input wire i_pch_brush_cl_delay_int;
input wire i_die_cl_delay;
input wire i_punch_ready;
input wire i_reader_ready;
input wire i_read_impulse_cb;
input wire i_1400_unit_exception_gate;
// real 2540 punch drive is "just" par_tens, par_units & punch_hammer
output wire [9:0] o_rpaddr;
output wire [6:0] o_rpaddr_binary;
//	icu to rdr pch
output wire o_read_feed;
output wire o_punch_feed;
output wire o_power_on_reset;
output wire o_mach_reset_rdr_pch;
output wire o_time_075_150;
output wire o_time_150_375;
output wire o_xfer_cy_req;
output wire o_unit_exception_rdr;
output wire o_pch_write;
output wire o_rdr_feed_command;
output wire o_punch_cycle;
output wire o_read_cycle;
output wire o_time_150_450;
output wire o_time_225_525;
output wire o_2821_rdr_ready_turn_off;
output wire o_2821_pch_ready_turn_off;
output wire o_punch_restart_gate;
output wire o_punch_decode;	// as addressed by rpaddr
output wire o_2540_reader_check;	// "y" logic 12.11.87.1
output wire o_read_val_chk;	// "y" logic: 12.11.87.1

output wire o_punch_xlate_check_light;
output wire o_pfr_val_light;
output wire o_data_enter_no;
input wire i_check_reset;
input wire i_data_enter_sw;
input wire [7:0] i_data_enter_0_7;
input wire i_sync_recycle_jumper;	// 1=disable sync check readiness check
input wire i_home_gate_jumper;		// 1=enable home gate cheat
input wire i_pss_trig_jumper;		// 1=enable pss trig cheat
input wire i_sense_amp_1;
input wire i_sense_amp_2;
input wire [11:0] i_slow_brushes;
input wire [11:0] i_stop_brushes;
input wire i_mag_emitter;
input wire i_60_volt_sense;
input wire i_gate_interlock;
input wire i_carriage_interlock;
input wire i_forms_check_or_carr_stop;
input wire i_end_of_forms;
input wire i_restore_key;
input wire i_prt_stop_key;
input wire i_single_cycle_key;
input wire i_prt_start_key;
input wire i_space_key;
output wire o_print;
output wire [132:1] o_hammer_fire;
output wire o_low_speed_start;
output wire o_low_speed_stop;
output wire o_high_speed_start;
output wire o_high_speed_stop;
output wire o_paper_damper_mag_drive;
output wire o_print_ready_ind_ce;
output wire o_forms_check_ind;
output wire o_print_check_ind;
output wire o_sync_check_ind;
output wire o_end_of_forms_ind;
	input wire i_burst_sw_on;	// XXX should this be a parameter?
	input wire i_one_byte_sw_on;	// XXX should this be a parameter?

	input wire i_load_and_single_cycle_sw;
	input wire i_ce_2540_off_line_sw;
	input wire i_ce_mach_reset;

parameter CB = 1'b1;

parameter DELAY = 1;
parameter DELAY_1200ns = 12;	// 1.2 us (arbitrary for now)
parameter DELAY_525ns = 5;	// 0.525 us (arbitrary for now)
parameter DELAY_1500ns = 15;	// 1.5 us (arbitrary for now)
parameter DELAY_150us = 40;	// 150 us (arbitrary for now)
parameter DELAY_15us = 25;	// 15 us (arbitrary for now)
parameter DELAY_3ms = 300;	// 3 ms (arbitrary for now)
parameter DELAY_9ms = 900;	// 9 ms (arbitrary for now)
parameter TIMEOUT_1300ns = 13;	// 1.3 us (arbitrary for now)
parameter TIMEOUT_2800ns = 28;	// 2.8 us (arbitrary for now)
parameter TIMEOUT_10us = 40;	// 10 us (arbitrary for now)
parameter TIMEOUT_13800us = 1380;	// 13.8 ms (arbitrary for now)
parameter TIMEOUT_9800us = 980;	// 9.8 ms (arbitrary for now)
parameter TIMEOUT_5500us = 550;	// 5.5 ms (arbitrary for now)
parameter TIMEOUT_2000ns = 20;	// 2 us (arbitrary for now)
parameter TIMEOUT_300us = 80;	// 300 us (arbitrary for now)
//parameter TIMEOUT_150us = 40;	// 150 us (arbitrary for now)
parameter TIMEOUT_150us = 700;	// 150 us (needs to match sim1403)
parameter TIMEOUT_PSS = TIMEOUT_150us; // 150 us / 1100 lpm
parameter PAPER_TS = 130;	// paper estimate timescale
// parameter TIMEOUT_PSS = TIMEOUT_300us; // 300 us / 600 lpm

parameter PCHADDRESS = 8'h0c;
parameter RDRADDRESS = 8'h0d;
parameter PRTADDRESS = 8'h0e;

//////// assumptions and guesses
wire [7:0] bus_out;
wire bus_out_p;
wire prt_ctl;
wire reset_chan_reg;
wire rdr_address_gate_in;
wire [8:0] rdr_bus_in_address;
wire pch_address_gate_in;
wire [8:0] pch_bus_in_address;
wire prt_address_gate_in;
wire [8:0] prt_bus_in_address;
wire [8:0] x_bus_in_address;
wire x_reset_pch_busy;
wire x_status_in_delay;
wire rdr_2_bit_mod;
wire x_pch_4_bit_mod_normal;
wire pch_3_bit_modifier;
wire pch_2_bit_mod;
wire mach_reset_ce;
wire pfr_reset_pch_cmmd_lat;
wire c_1400_unit_exception_gate;
wire c_unit_exception;
wire x_1400_comp_prov_feed;
wire x_1400_comp_rdr_feed_commd;
wire po_prt_no_op;	// actually a wired-or, and not present...
//wire trigger_d_clock_3_7;
wire stop_sw;		// ?? input from ce panel cerpa088 ce stop key
wire col_bin_blk_parity_check;
wire pfr_not_12_pch_ser_cycle;
wire pfr_set_chan_reg_full;
wire x_60_volt_sense;
wire print_error_chk_inh;
wire equal_check_inh;
wire pss_trig_jumper_enabled;
wire stor_scan_load_mode_c_e;
wire addr_units_a;
wire addr_units_c;
wire end_of_forms;
wire restore_key;
wire prt_stop_key;
wire single_cycle_key;
wire prt_start_key;
wire space_key;
wire pfr_reset_chan_reg_full;
wire stl_turn_on_prt_complete;
wire unprintable_character_gate_ucb;
wire read_strobe_pr;
wire pfr_bus_in_7;

wire x_punch_scan_delayed;

assign o_punch_feed = c_punch_feed;
assign o_2821_pch_ready_turn_off = c_2821_pch_ready_turn_off;
assign o_2821_rdr_ready_turn_off = c_2821_rdr_ready_turn_off;
assign punch_scan = i_punch_scan_cb;
assign check_reset_ce = i_check_reset;
// real 2540 punch drive is "just" bar_tens, bar_units & punch_hammer
assign o_rpaddr = {car};
assign o_rpaddr_binary = {car_binary[6:0]};
assign o_punch_decode = pch_decode;
assign o_2540_reader_check = rdr_equipment_check;
assign o_read_val_chk = rdr_data_check;

assign pfr_xfer_cyc = pfr_xfer_cycle;
assign pfr_xfer_cy = pfr_xfer_cycle;
assign pch_ser_cycle = pch_ser_cy;
assign punch_xlate_logic_out = x_punch_xlate_out;
assign any_op_in_delay = any_op_in_delayed;
assign data_enter_ce = pull_on_chan_reg;
assign pch_buffer_full = x_pch_buffer_full_out;
assign diag_write = diagnostic_write;
assign select_punch = select_pch;
assign read_backward = read_backwards;
assign rd_xfer_cy = rdr_trans_cycle;
assign rd_trans_cycle = rdr_trans_cycle;
assign data_register = data_reg;
assign allow_cy = allow_cycle;
assign bus_out_bits = bus_out;
assign chan_reg = channel_register;
assign pch_trans_cy_req = pch_trans_cycle_req;
assign pch_equipment_check = pch_equipment_chk;
// 32.13.02.1
assign pch_command_stored = punch_command_stored;
assign mach_reset_rdr = mach_reset_rdr_pch;
assign rdr_brush_impulse = c_rdr_brush_impulse;
assign read_chk = read_check_hole_count_chk;
assign pch_translate_chk = punch_translate_check;
assign addr_chk = address_check_ce;
assign print_buffer_bits = print_buffer_data_reg;
assign pr_compare = print_compare;
assign low_speed_start = low_speed_go;
assign clock_ctrl_tr = clk_ctrl_tr;
assign single_space_ss = space_1ss;
assign data_reg_parcheck_gated = data_reg_par_check_gated;
assign restore_latch = restore_lat;
assign rd_0_1_bit_mod = rdr_0_1_bit_mod;
assign x_9_rd_ser_cycle = x_9_read_ser_cycle;
assign stop_sw = check_stop_sw;
assign parity_check = parity_chk;
//assign rd_column_binary = read_col_binary;

assign after_space_ctrl_nucb = after_space_ctrl;
assign block_print_compare_ucb = block_print_compare;
assign last_address_clock_3_7 = addr_132_clock_3_7;
assign last_address_clock_3_7_cf = addr_132_clock_3_7;

assign common_adapter_request_reset = common_request_reset;

assign o_select_in = sel_out_prop_sel_in;
assign bus_out = i_bus_out[7:0];
assign bus_out_p = i_bus_out[8];
assign addr_units_a = units_drive_bar[4];
assign addr_units_b = units_drive_bar[3];
assign addr_units_c = units_drive_bar[2];
assign addr_units_d = units_drive_bar[1];
assign addr_units_e = units_drive_bar[0];
assign x_bar_advance_100 = x_bar_advance_tens & bar_tens == 5'b00101;
assign prt_ctl = prt_control;
assign p0_stor_scan_ld_md_ucb = scan_load_pullover_cfc;
assign load_format_ucb = 1'b0;
assign gnd_tie_off_ucb = 1'b0;
assign addr_240_ucb = 1'b0;
assign ucb_parity_check_lt_ucb = 1'b0;
// 43.32.52.1
assign cf_allow_intv_req_reset_cf = 1'b1;
assign print_read_scan_cf = 1'b1;
assign load_and_single_cycle_sw = i_load_and_single_cycle_sw;
assign ce_2540_off_line_sw = i_ce_2540_off_line_sw;
assign sync_recycle_jumper = i_sync_recycle_jumper;
assign pss_trig_jumper_enabled = i_pss_trig_jumper;
assign prt_adapter_reset_1 = prt_adapter_reset;

assign reset_select_out_latch = 0;
assign x_2821_addressed_tcs = 1'b1;
assign prt_adapter_reset_tcs = 1'b1;
assign o_data_in = 1'b0;
assign o_disc_in = 1'b0;
assign prt_op_in_prt2 = 1'b0;
assign prt_op_in_prt3 = 1'b0;
assign prt_adapter_request_prt_2 = 1'b0;
assign prt_adapter_request_prt_3 = 1'b0;
assign prt_channel_request_prt_2 = 1'b0;
assign prt_channel_request_prt_3 = 1'b0;
assign prt_service_in_prt2 = 1'b0;
assign prt_service_in_prt3 = 1'b0;
assign prt_status_in_prt2 = 1'b0;
assign prt_status_in_prt3 = 1'b0;
assign prt_sense_delay_gate_prt_2 = 1'b0;
assign prt_sense_delay_gate_prt_3 = 1'b0;
assign unprintable_character_gate_ucb = 1'b1;
assign block_print_compare = 1'b0;
assign stor_scan_load_mode_c_e = 1'b0;
assign off_line_run = 1'b0;
assign off_line_ce = 1'b0;
assign addr_set_sw = 1'b0;
assign c_e_error_reset_ce = 1'b0;
assign hammer_check_latch_ce = 1'b0;
assign not_ce_start_key_sw = 1'b0;
assign single_cycle_mode_ce = 1'b0;
assign carriage_set_sw_ce = 1'b0;
assign print_carr_mode_ce = 1'b0;
assign carr_set_immed_ce = 1'b0;
assign ce_start_key_sw = 1'b0;
assign ce_error_stop_sw_ce = 1'b0;
assign carr_set_sw = 1'b0;
assign storage_scan_sw = 1'b0;
assign ce_data_enter_sw = 1'b0;
assign off_line_run_sw = 1'b0;
assign pfr_mode = 1'b0;
assign pfr_mode_sw = 1'b0;
assign mach_reset_ce = 1'b0;
assign address_set_sw_c_e = 1'b0;
assign metering_in = 1'b1;
assign cfc_bus_in = 8'b0;
assign x_1400_comp_prov_feed = 1'b0;
assign x_1400_comp_rdr_feed_commd = x_1400_comp_read_feed;

function [8:0] parity_addr;
	input [7:0] addr;
	input gate;
	parity_addr = { ~^{addr}, addr} & {9{gate}};
endfunction


assign pch_address_gate_in = pch_op_in & address_in;
assign pch_bus_in_address = parity_addr(PCHADDRESS, pch_address_gate_in);
assign rdr_address_gate_in = rdr_op_in & address_in;
assign rdr_bus_in_address = parity_addr(RDRADDRESS, rdr_address_gate_in);
assign x_bus_in_address = rdr_bus_in_address | pch_bus_in_address |
	prt_bus_in_address;

latch1 u_pch_read(i_clk,
	pch_command_gate & pch_rdy_and_cmmd_valid &
	bus_out[1] & ~bus_out[0],		// matches: xxxxxx10
	reset_pch_commd_mod_latch,
	pch_read);

// modifies write - enable PFR
// 42.12.02.1
latch1 u_pch_4_bit_mod(i_clk,
	x_4_bit_mod_pull_on |
	pch_command_gate & bus_out[3],		// +4/-4
	reset_pch_commd_mod_latch,
	x_pch_4_bit_mod_normal);

// modifies write - "compat" bit for 1401 compatibility
//	read, feed and no stacker select
// 42.14.01.1
latch1 u_pch_3_bit_mod(i_clk,
	pch_command_gate & bus_out[4],		// +3/-3
	reset_pch_commd_mod_latch,
	pch_3_bit_modifier);

wire col_bin_x, col_bin_y, col_bin_z;
wire [5:0] x_col_bin_set_channel_reg;
wire [11:0] col_bin_write;
wire x_col_bin_xfer_cy;
generate if (CB == 1'b1) begin
latch1 u_rdr_2_bit_mod(i_clk,
	rdr_command_gate & rdr_rdy_and_commd_valid & bus_out[5],
	reset_rdr_commd_mod_latch,
	rdr_2_bit_mod);
// modifies write - column binary mode
// 42.11.01.1
latch1 u_pch_2_bit_mod(i_clk,
	pch_command_gate & bus_out[5] &		// +2/-2
		pch_rdy_and_cmmd_valid,
	reset_pch_commd_mod_latch,
	pch_2_bit_mod);
assign x_col_bin_xfer_cy = (pch_2_bit_mod | rdr_2_bit_mod) & xfer_cy_req & allow_cycle;
// 42.11.01.1
assign read_col_binary = x_col_bin_xfer_cy & ~pch_write;
// 42.11.01.1
assign block_read_xlate = x_col_bin_xfer_cy;
assign block_pch_translate_chk = x_col_bin_xfer_cy;
latch1 u_col_bin_adv(i_clk,
	x_col_bin_xfer_cy & trigger_a,
	~allow_cycle,
	col_bin_z);
latch1 u_col_bin_x(i_clk,
	x_525_600 & ~col_bin_y & col_bin_z,
	reset_pch_commd_mod_latch |
		x_525_600 & col_bin_y & col_bin_z,
	col_bin_x);
latch1 u_col_bin_y(i_clk,
	x_150_225 & col_bin_x,
	reset_pch_commd_mod_latch |
		x_150_225 & ~col_bin_x,
	col_bin_y);
// col_binary_1 true for xfer of TE0123
// 42.31.02.1
assign col_binary_1 = ~col_bin_x & x_col_bin_xfer_cy;
// column_binary_2 true for xfer of 456789
// 42.31.02.1
assign column_binary_2 = col_bin_x & x_col_bin_xfer_cy;
// 42.31.02.1
assign blk_par_ctrl_col_bin = column_binary_2;
// 42.31.02.1
assign blk_rar_ctrl_col_bin = column_binary_2;
assign x_col_bin_set_channel_reg =
data_reg_regen[11:6] & {6{col_binary_1 & x_150_375}} |
data_reg_regen[5:0] & {6{column_binary_2 & x_150_375}};
// 42.23.03.1 42.23.04.1
assign col_bin_write = {
//data_reg_regen[11:6] & {6{column_binary_2 & pch_2_bit_mod & x_150_375}} |
channel_register[5:0] & {6{col_binary_1 & pch_2_bit_mod & x_150_375}},
channel_register[5:0] & {6{column_binary_2 & pch_2_bit_mod & x_150_375}}
};
end else begin
assign rdr_2_bit_mod = 1'b0;
assign pch_2_bit_mod = 1'b0;
assign read_col_binary = 0;
assign block_read_xlate = 1'b0;
assign block_pch_translate_chk = 0;
assign col_binary_1 = 0;
assign column_binary_2 = 0;
assign blk_par_ctrl_col_bin = 0;
assign blk_rar_ctrl_col_bin = 0;
assign x_col_bin_set_channel_reg = 6'h0;
assign col_bin_write = 12'h0;
end
endgenerate

// 42.31.02.1
wire column_binary_2;

//assign pch_status_inhibit = 0;
assign pch_xfer_cycle = pch_trans_cycle;
assign pch_trans_cy = pch_trans_cycle;
assign pch_insert_blank = pch_insert_blanks;
assign pch_read_sense = pch_read | pch_sense;
assign pch_chan_end = pch_channel_end;
assign not_pch_dvc_end_samp = not_pch_device_end_smp;
assign data_reg_p = ~^{data_reg};
assign data_reg_parity_check = 0;
assign rd_2_row_bit = i_rd_2_row_bit;
assign c_rd_2_row_bit = i_rd_2_row_bit;
assign c_pch_chk_row_bit = i_pch_chk_row_bit;
assign c_pfr_rd_row_bit = i_pfr_row_bit;
assign c_1400_unit_exception_gate = i_1400_unit_exception_gate;
assign c_unit_exception = i_unit_exception;
assign c_rdr_brush_impulse = i_read_impulse_cb;
assign after_9_emitter = i_after_9_emitter;

assign sense_amp_1 = i_sense_amp_1;
assign sense_amp_2 = i_sense_amp_2;
assign slow_brushes = i_slow_brushes;
assign stop_brushes = i_stop_brushes;
assign mag_emitter = i_mag_emitter;
assign x_60_volt_sense = i_60_volt_sense;
assign x_1403_chain_inlk = ~i_gate_interlock;
assign forms_check_or_carr_stop = i_forms_check_or_carr_stop;
assign end_of_forms = i_end_of_forms;
assign restore_key = i_restore_key;
assign prt_stop_key = i_prt_stop_key;
assign single_cycle_key = i_single_cycle_key;
assign prt_start_key = i_prt_start_key;
assign space_key = i_space_key;

assign o_low_speed_start = low_speed_start;
assign o_low_speed_stop = low_speed_stop;
assign o_high_speed_start = high_speed_start;
assign o_high_speed_stop = high_speed_stop;
assign o_paper_damper_mag_drive = paper_damper_mag_drive;
assign o_print_ready_ind_ce = print_ready_ind_ce;

assign sync_check = x_sync_check_out;
assign pss_trig_jumper = x_pss_trig_jumper;
assign home_gate_jumper = ~i_home_gate_jumper | home_gate;

// XXX ss_3 does not transit at the same time as pss_trig, but
//  "just after".  The resulting race causes set_bar_to_000 to glitch.
wire gated_pss_1, x_gated_pss_delayed;
delay2 #(2) u_pss_delayed(i_clk, i_reset,
gated_pss,
x_gated_pss_delayed);
assign gated_pss_1 = x_gated_pss_delayed & gated_pss;

reg [0:0] xctr;
wire osc;
assign osc = &{xctr};
always @(posedge i_clk) begin
	if (i_reset) begin
		xctr <= 0;
	end else begin
		xctr <= xctr + 1;
	end
end
assign x_150_225 = trigger_c & ~trigger_d;
assign x_75_150 = x_075_150;

wire mach_reset_out;
latch1 u_mach_reset(i_clk,
	i_reset | ~i_operational_out,
	mach_reset_out & ~trigger_d & trigger_e,
	mach_reset_out);

assign rdr_pch_bus_in_status[7] = 1'b0;	// not used
assign rdr_pch_bus_in_status[6] = 1'b0;	// 2 channel only
assign rdr_pch_bus_in_status[5] = 1'b0;	// 2 channel only
assign prt_sense_delay_gate = prt_sense & ~not_service_in_sample;
assign prt_bus_in_status[5] = 1'b0;	// control unit end
assign prt_bus_in_status[6] = 1'b0;	// status modifier
assign prt_bus_in_status[7] = 1'b0;	// attention
assign gated_diagnostic_pch_chk_cycle = x_450_525 & diagnostic_pch_chk_cycle;

assign block_chan_reg_set = pch_check_read | read_check_read;

wire x_cmd_out_adv, x_cmd_gate_adv;
assign x_cmd_out_adv = i_command_out & ~x_command_out_delayed;
assign x_cmd_gate_adv = pch_channel_request & bus_out_odd_parity &
	address_in & x_cmd_out_adv & ~pch_busy_queued;
assign rdr_rdy_and_commd_valid = rdr_rdy_and_cmmd_valid;
assign rdr_xlate_logic_out = read_xlate;

decchk1 u_car_units(car[4:0], units_bar_ok);
decchk1 u_car_tens(car[9:5], tens_bar_ok);

// 33.13.54.1
// pg 8181 (30) tc-18 gate and load format commands
// line 32 "not prt device end sample"
//	goes true when prt_device_end falls
//	goes false after 1.3 usec
//	[ device_end goes false when:
//		prt_status_in is true
//		service_out goes false. ]
//		(( x_service_out_delay approximates the delay here. ))
ss2 #(TIMEOUT_1300ns) u_prt_dvc_end_smp(i_clk, i_reset,
	~prt_device_end,
	not_prt_device_end_smp);

wire x0_000;
pdetect1 u_000_pulse(i_clk, x_000_075, x0_000);
// r0_075 is a 1 clock wide pulse otherwise like r0_000_150
wire r0_075;
pdetect1 u_075_pulse(i_clk, x_075_150 & allow_cycle, r0_075);

wire x0_150;
pdetect1 u_150_pulse(i_clk, x_150_225, x0_150);
wire r0_150 = x0_150 & allow_cycle;

wire x0_375;
ss2 #(1) u_375_pulse(i_clk, i_reset, x_375_450, x0_375);
wire w0_375 = x0_375 & allow_cycle;

// in the real hardware, the bus exchange must be less than 5 microseconds?
// if the bus exchange is 2 memory cycles, 2 columns are stored per byte.
wire x_block_par_advance_0, x_block_par_advance;
latch3 u_x_blk_par_adv(i_clk,
	chan_reg_full & allow_cycle & x0_375,
	~i_service_out | pch_end,
	x_block_par_advance_0);
assign x_block_par_advance = x_block_par_advance_0 & 1'b0;

// 42.33.01.1
assign pch_emit_12 = ~pch_ctr_b & pch_ctr_a;

localparam [4:0] sense_hack = 5'h15;

// sense final status has no obvious means to be returned
// in interleaved mode.  not_command_out_sample is not true
// for reselection, so x_pch_interleave_mode_ending_or_stacked_status
// does not work.
// sense_hack[0] - enable hack to return sense final status
//	as separate reselected bus cycle.
// sense_hack[1] - enable hack to force burst mode for pch sense.
// sense_hack[2] - enable hack require proceed for rdr sense.
// sense_hack[3] - enable hack to force burst mode for rdr sense.
// sense_hack[4] -  enable hack require proceed for pch sense.

localparam [3:0] prt_hack = 4'hf;
// prt_hack[0] -  enable hack to delay service_in+ to clear memwrite
// prt_hack[1] -  enable hack to shorten memwrite to clear service_in+
// prt_hack[2] -  enable hack to avoid double-setting prt_write_data_avail
// prt_hack[3] -  enable hack to delay clearing svcin when being set too.

localparam [1:0] pch_hack = 2'h3;
// pch_hack[0] -  enable hack to not double-clear chan_reg_full
// pch_hack[1] -  enable hack to narrow window for setting allow_cycle

wire x_not_command_out_sample;
wire x_not_command_out_sample_interleave;
latch1 u_not_cmmd_out_smp_2(i_clk,
	x_command_out_delayed & ~i_command_out & proceed,
	~any_op_in | status_service_in_dly,
	x_not_command_out_sample_interleave);

assign x_not_command_out_sample =
	sense_hack[0] ? x_not_command_out_sample_interleave
		: not_command_out_sample;

wire x_sense_force_burst = sense_hack[1] & pch_sense
	| sense_hack[3] & rdr_sense;

assign rdr_read_req = rdr_read & rdr_command_gate & bus_out[7] & bus_out[6] & bus_out[2];
assign pch_read_req = pch_read & pch_command_gate & bus_out[7] & bus_out[6] & bus_out[2];
assign pch_write_req = pch_write & pch_command_gate & bus_out[2] & bus_out[5];

// 42.12.03.1
assign pfr_trans_cy_req = pch_read & ~chan_reg_full & pch_op_in &
	~x_any_service_in &
	~end_pfr_data_xfer & (pch_adapter_request |
		(sel_out_burst_sw_on & ~pch_channel_request & ~address_in));

wire end_pfr_data_xfer;
latch1 u_end_pfr_data_xfer(i_clk,
	pch_read & pch_channel_end,
	reset_pch_commd_mod_latch,
	end_pfr_data_xfer);

// 42.12.01.1
assign pfr_xlate_gate = pfr_xfer_cy & ~read_col_binary & x_225_375;

// 42.12.01.1
assign pfr_set_chan_reg_full = pfr_trans_cy_req & x_375_450 & allow_cycle;

// 42.12.01.1
assign pfr_pch_service_req = ~pch_interrupt_req & ~pch_complete
			& ~pch_end & pch_read & chan_reg_full;

// 42.12.01.1
assign pfr_reset_chan_reg = pfr_xfer_cycle & x_225_300;
// 42.12.01.1
assign pfr_reset_chan_reg_full = end_pfr_data_xfer
		& rdr_pch_service_in & pch_op_in |
	pch_read & i_service_out & rdr_pch_service_in & pch_op_in;

// 42.13.27.1
assign pfr_bus_in_7 = pch_status_gate & pfr_unit_exception & ~pch_sense;

// print storage timing pulses - timing diagram on ald 33.23.15.0
// 33.33.42.1
wire clock_5_0;
wire clock_5_6;
wire clock_6_7;
wire clock_7_0;
wire trigger_d_clock_3_7_ucb;

reg [1:0] pctr;
wire osc_pulse;			// 21a4c16a dfq
assign osc_pulse = &{pctr};
always @(posedge i_clk) begin
	if (i_reset) begin
		pctr <= 0;
	end else if (osc_pulse)
		pctr <= 1;
	else
		pctr <= pctr + 1;
end
reg trigger_a_clock_0_4;	// 21a4c15q dhf
reg trigger_b_clock_1_5;	// 21a4c15p dhf
reg trigger_c_clock_2_6;	// 21a4c14q dhf
reg trigger_d_clock_3_7;	// 21a4c14p dhf
reg trigger_e_clock_4_0;	// 21a4c13q dhf
always @(posedge i_clk) begin
	if (i_reset)
		{trigger_a_clock_0_4, trigger_b_clock_1_5,
			trigger_c_clock_2_6, trigger_d_clock_3_7,
			trigger_e_clock_4_0} <= 0;
	else if (osc_pulse)
		{trigger_a_clock_0_4, trigger_b_clock_1_5,
			trigger_c_clock_2_6, trigger_d_clock_3_7,
			trigger_e_clock_4_0}
		<=
		{~trigger_d_clock_3_7 & clock_run_tr, trigger_a_clock_0_4,
			trigger_b_clock_1_5, trigger_c_clock_2_6,
			trigger_d_clock_3_7};
end

assign clock_0_2 = trigger_a_clock_0_4 & ~trigger_c_clock_2_6;
//assign clock_1_5 = trigger_b_clock_1_5;
wire x_clock_2_3 = trigger_c_clock_2_6 & ~trigger_d_clock_3_7;
assign clock_2_4 = trigger_c_clock_2_6 & trigger_a_clock_0_4;
//assign clock_4_0 = trigger_e_clock_4_0;
assign clock_4_5 = trigger_e_clock_4_0 & trigger_b_clock_1_5;
assign clock_4_6 = trigger_e_clock_4_0 & trigger_c_clock_2_6;
assign clock_5_0 = ~trigger_b_clock_1_5 & trigger_e_clock_4_0;
assign clock_5_6 = ~trigger_b_clock_1_5 & trigger_c_clock_2_6;
assign clock_5_7 = ~trigger_b_clock_1_5 & trigger_d_clock_3_7;
assign clock_6_0 = ~trigger_c_clock_2_6 & trigger_e_clock_4_0;
assign clock_6_7 = ~trigger_c_clock_2_6 & trigger_d_clock_3_7;
assign clock_7_0 = ~trigger_d_clock_3_7 & trigger_e_clock_4_0;
assign clock_6_0_2_4 = clock_6_0 | clock_2_4;

assign trigger_d_clock_3_7_ucb = trigger_d_clock_3_7;
assign clock_5_7_nucb = clock_5_7;
// 33.33.44.1
assign read_strobe_pr = ~write_gate &
	trigger_c_clock_2_6 & ~trigger_d_clock_3_7;

// XXX this only generates 5 microsecond strobes.
// on the real thing, there is an array of 132 single-shots
// past this which also act as coil protection devices
// (hardwired to fire for 1.2 ms no more than once every 44 microseconds)
d132x5 u_hammer_fire(i_clk, i_reset,
	units_drive_bar,
	bar_tens,
	bar_100,
	comp_equal_sample,
	o_hammer_fire);

wire reset_pcg_1 = home_gate & gated_pss & ~gated_pss_1;
assign reset_pcg = ~train_ready;
assign diag_write_tie_down = 1;	// should be switchable?
assign check_reset_prt = 0;	// should be driven by some input.  key??

reg [5:0] x_print_scan_ctr;
reg last_print_scan;
always @(posedge i_clk) begin
	last_print_scan <= print_scan;
	if (print_gate | mach_reset_printer)
		x_print_scan_ctr <= 0;
	else if (print_scan & ~last_print_scan & ss_1)
		x_print_scan_ctr <= x_print_scan_ctr + 1;
end

wire print_scan_48;

assign print_scan_48 = x_print_scan_ctr == 'd48;
assign print_scan_49 = x_print_scan_ctr == 'd49;

assign after_space_ctrl = print_scan_48;

wire x_not_command_out_sample_x;
wire xxx_turn_cos_out;
latch1 u_xxx_turn_cos_out(i_clk,
	status_service_in_dly & x_not_command_out_sample_x,
	~x_not_command_out_sample_x | ~any_op_in,
	xxx_turn_cos_out);
latch1 u_not_cmmd_out_smp_3(i_clk,
	x_command_out_delayed & ~i_command_out & proceed,
	~any_op_in | xxx_turn_cos_out & ~(status_service_in_dly),
	x_not_command_out_sample_x);

// wrong, but for now...
assign check_stop_sw = 1'b0;
assign io_check_reset_pr = mach_reset_printer;
assign print_error_chk_inh = 0;
assign equal_check_inh = 0;
assign stl_go_ss = 1'b0;
assign end_load_format = 1'b1;
assign end_load_format_ucb = 1'b1;
assign reset_train_ready_ucb = 0;
assign ucb_home_gate_ucb = 1'b0;
assign set_storage_parity_ck_ucb = 0;
assign cf_invalid_command = 0;
assign cf_set_unit_check = 0;
assign cfc_block_read_strobe_cf = 0;
assign read_scan_cfc = 1'b0;
assign prt_adapter_request_prt_1 = 0;
assign load_format_mode_ucb = 0;
assign gate_carr_ctrl_reg_ucb = 0;
assign on_line_and_uncomp_char_ucb = 0;
assign scan_load_pullover_cfc = 0;
assign line_full_ucb = 1'b1;
assign stl_mode = 0;
assign x_1400_delayed_feed = 0;
assign x_1400_comp_rdr_busy = 0;
assign pch_sense_bit_6 = 0;	// unusual command sequence
assign not_commd_sr_out_smp_pwr_pr3 = 1'b1;
assign pfr_reset_pch_cmmd_lat = 1'b0;
assign prt_bus_in_sense[3] = 1'b0;	// data check (1404,ucs)
assign prt_bus_in_sense[2] = 1'b0;	// buffer parity check (ucs)
assign prt_bus_in_sense[1] = 1'b0;	// unusual command sequence (1404)
assign pfr_command_reject = 0;
assign pfr_reset_pch_sense_latch = 0;
// assign pfr_trans_cy_req = 0;
assign pfr_not_12_pch_ser_cycle = 0;
assign start_sw = mach_reset_out | x_delayed_mach_start;
assign punch_sw = 0;
assign storage_sw = 0;
assign storage_scan = 0;
assign col_bin_blk_parity_check = 0;
assign pch_chan_reg = 0;
assign data_enter = 0;
assign diagnostic_pch_chk_cycle = 0;
assign x_1400_comp_read_feed = 0;
assign po_prt_no_op = 0;
assign read = 1'b0;
assign read_sw = 1'b0;
assign turn_on_prt_sense_lat_tcs = 0;
assign gate_carr_ctrl_reg = 1;
assign reset_ham_ck_and_pty_ck = prt_write_ctrl & prt_command_gate;
assign gate_write_tr_off_ucb = 1'b0;

wire x_delayed_mach_start;
delay1 #(10) u_delayed_mach_start(i_clk, i_reset, mach_reset_out, x_delayed_mach_start);

//////// page 48
//////// udc-4 reader-punch data flow (sheet 1)
//////// 2020

wire [9:0] car;	// card read punch bar
wire [11:0] car_x;	// card read punch bar
wire [7:0] car_binary;	// card read punch bar

// on the 2821, the actual core storage used by the reader & punch
// is decimally addressed (by what is named 'car" here).  address
// range is 1-80 (so location 0 is not used).
// the reader and punch portions are parallel but separately
// enabled by "gated select pch" and "select rdr".
// core memory readout is destructive; all cycles are read-write.
//
// here, we generate and use a binary address, and always
// overwrite the location right afterwards.
// reader: 1-80 punch: 129-208 unused: 0,81-128,209-255.
reg [17:0] cbuf [0:255];
wire [7:0] cbuf_addr;
reg [17:0] cbuf_data;
wire [17:0] cbuf_data_in;

assign car_x = {2'b0, car};

dec2bin1 u_car2bin(car_x, car_binary);

assign cbuf_addr = {pch_select, car_binary[6:0]};

// sense amp output is available during 150-225 only.
assign {
	x_sense_amps_out
} = cbuf_data[11:0] & {12{read_strobe & ~block_sa_output_ctl}};
assign {
	sa_xu, sa_xl,
	sa_yu, sa_yl,
	sa_pfr_zu, sa_pfr_zl
} = cbuf_data[17:12] & {6{x_150_225 & allow_cycle}};

// inhibit (write) data should be valid from 375-450
assign cbuf_data_in = {
	~inh_current_xu, ~inh_current_xl,
	~inh_current_yu, ~inh_current_yl,
	~inh_current_zu, ~inh_current_zl,
	x_storage_in
};

always @(posedge i_clk) begin
	cbuf_data <= cbuf[cbuf_addr];
	if (allow_cycle & x0_375)
		cbuf[cbuf_addr] <= cbuf_data_in;
end

//////// page 49
//////// udc-5 reader-punch data flow (sheet 2)
//////// 2021

wire pch_read_req;
wire pch_read;
wire pch_check_read;
wire diagnostic_read_cycle;
wire pfr_xfer_cycle;
wire rdr_trans_cycle;
wire read_check_read;
wire rdr_read_req;
wire rdr_read;
wire pch_trans_cy;
wire diagnostic_write;
wire pch_channel_end;
wire pch_write;
wire read_channel_end;
wire not_modifiers_0_1;
wire gated_diagnostic_pch_chk_cycle;
wire punch_translate_check;
wire pch_write_req;

wire [11:0] data_reg;
wire [11:0] punch_xlate_logic_out;

wire [7:0] read_xlate;
wire x_read_xlate_bad;

wire pfr_trans_cy_req;
wire channel_end;
wire rdr_trans_cycle_req;
wire pfr_xfer_cy;
wire rd_xfer_cy;
wire [5:0] col_bin_set_channel_reg;

wire data_reg_parity_check;
wire rdr_translate_chk;
wire pch_chk_cycle;
wire diagnostic_pch_chk_cycle;
wire pch_translate_chk;
wire addr_chk;
wire pch_trans_cycle;
wire rdr_xlate_gate;

// 42.11.01.1
latch1 u_punch_check_read(i_clk,
	pch_read_req,
	~pch_read,
        pch_check_read);

// XXX isn't this punch_translate_check aka pch_translate_chk ?
// XXX ald shows output as being "+y pch xlate check *ce"
// 32.20.67.1
latch1 u_punch_xlate_chk_light(i_clk,
	pch_trans_cy & ~pch_check_read &
		~diagnostic_write & punch_translate_check,
	check_reset | mach_reset_rdr_pch |	// XXX from ald
	gated_diagnostic_pch_chk_cycle,
	o_punch_xlate_check_light);

// 42.31.01.1
assign diagnostic_read_cycle = (pch_check_read & pfr_xfer_cycle)
	| (rdr_trans_cycle & read_check_read);

// 42.11.01.1
latch1 u_read_check_read(i_clk,
	rdr_read_req,
	~rdr_read,
	read_check_read);

// 42.11.01.1
latch1 u_diag_write(i_clk,
	pch_write_req,
	~pch_write,
	diagnostic_write);

// 32.20.63.1 - 32.20.66.1
ccc13 u_read_xlate(i_clk, i_reset,
	data_reg,
	read_xlate, x_read_xlate_bad);
// 32.31.10.1
assign invalid_card_code = x_read_xlate_bad;

/// XXX u_pfr_xfer_cycle also on page 88
// latch1 u_pfr_xfer_cycle(i_clk,
//	pfr_trans_cy_req,
//	channel_end,
//	pfr_xfer_cy);

/// XXX how does this compare to page 63 4020c6
/// XXX how does this compare to page 64 4040c5
/// XXX how does this compare to page 85 5041c3
// 32.32.13.1
//latch1 u_read_xfer_cycle(i_clk,
//	rdr_trans_cycle_req,
//	channel_end,
//	rd_xfer_cy);

// XXX x_col_bin_set_channel_reg not shown on ild, ald missing.
// 42.31.01.1
assign col_bin_set_channel_reg = {
	data_reg_xu & diagnostic_read_cycle,
	data_reg_xl & diagnostic_read_cycle,
	data_reg_parity_check & diagnostic_read_cycle,
	rdr_translate_chk & diagnostic_read_cycle,
	(rdr_translate_chk & diagnostic_read_cycle |
	diagnostic_pch_chk_cycle & pch_translate_chk),
	addr_chk & diagnostic_read_cycle} |
	x_col_bin_set_channel_reg;

/// XXX also see x_channel_register_in, channel_register page 66
wire [7:0] channel_register;

wire [7:0] x_channel_register_in;

//assign rdr_xlate_gate = (pfr_xfer_cy | rd_xfer_cy) &
//	~rd_column_binary & x_225_375;
// XXX more input from page 64,82 (82 matches ald)
assign rdr_xlate_gate =
	(~read_col_binary & rdr_trans_cycle & x_225_375
		| pfr_xlate_gate)
	& ~block_chan_reg_set;

// also see page 64,82
// 32.11.12.1-32.11.15.1
assign x_channel_register_in = read_xlate & {8{rdr_xlate_gate}}
	| col_bin_set_channel_reg
	| bus_out & {8{
		pch_op_in & x_75_150 &	// XXX this line from page 82
		pch_trans_cycle}}
	| data_enter_ce;		// XXX this line from page 82

//////// page 50
//////// udc-6 printer data flow
//////// 2080

wire x_bar_advance_100;

// XXX omitting ce set tens logic here.
// 33.23.02.1
latch1 u_bar_100(i_clk,
	b_0_2 & x_bar_advance_100,
	tens_set_reset_control,
	bar_100);


wire [11:0] bar_x;	// printer bar
wire [7:0] bar_binary;	// printer bar

// on the 2821, the actual core storage used by the printer
// is decimally addressed (by what is named 'bar" here).  address
// range is 1-132 (so location 0 is not used).
// core memory readout is destructive; all cycles are read-write.
//
// here, we generate and use a binary address, and always
// overwrite the location right afterwards.
// printer: 1-132 unused: 0,133-255.
// 33.23.05.1-33.23.08.1
// 1,2,4,8,a,b,c  plc,pc,ec,hf,ecdel,
reg [13:0] pbuf [0:255];
wire [7:0] pbuf_addr;
reg [13:0] pbuf_data_out;
reg [13:0] pbuf_data;
wire [17:0] pbuf_data_in;

assign bar_x = {1'b0, bar_100, bar_tens, units_drive_bar};

dec2bin1 u_bar2bin(bar_x, bar_binary);

assign pbuf_addr = bar_binary;

wire [1:0] sa_dummy;
wire [6:0] x_sense_out;

// sense amp output is available during 2-3 only.
// XXX the ild does not even mention sense_gate_gen
assign {
	sa_pc,
	sa_ec, sa_hf,
	sa_ecd, sa_plc,
	sa_dummy,
	x_sense_out
} = pbuf_data & {12{sense_gate_gen}};

// inhibit (write) data should be valid from 5-0
// XXX must shorten to 5-6 to fix race with next data byte from channel
assign pbuf_data_in = {
	~inh_current_pc,
	~inh_current_ec, ~inh_current_hf,
	~inh_current_ecd, ~inh_current_plc,
	2'b0,
	x_print_in
};

// XXX hack to shorten memwrite to clear service_in+
wire x_memwrite_pulse = prt_hack[1] ? clock_5_6 : clock_5_0;

always @(posedge i_clk) begin
	if (x_memwrite_pulse & ~tr_1 & ~tr_2)
		pbuf[pbuf_addr] <= pbuf_data_in;
	else if (x_clock_2_3)
		pbuf_data_out <= pbuf[pbuf_addr];
end

reg xxx_x_clock_2_3;
always @(posedge i_clk) begin
xxx_x_clock_2_3 <= x_clock_2_3;
if (x_clock_2_3 & xxx_x_clock_2_3)
	pbuf_data <= pbuf_data_out;
else if (clock_0_2)
	pbuf_data <= 0;
end
//////// page 53
//////// sld-1 Reader-Punch Error Check
//////// 3020

// - reader punch error circuits -
//  [1]	a no-op with extra bits to rdr.
//  [2]	a write command to the rdr
//  [3]	a control command that indicates a feed command without feeding
//  [4]	two consecutive feeds without an intervening read
//  [5]	a no-op to the punch with extra bits
//  [6]	a command to stacker select pockets 2 and 3
//  [7]	bus out check for the command bit on initial selection pch
//  [8]	bus out check on buffer load
//  [9]	bus out check for the command bit on initial selection rdr

// logic for modifiers_only read_backward etc. replicated here.

wire rdr_sense_bit_0;
wire rdr_sense_bit_2;
wire rdr_sense_bit_3;
wire rdr_sense_bit_4;
wire rdr_sense_bit_6;
wire pch_sense_bit_0;
wire pch_sense_bit_2;
wire pch_sense_bit_3;
wire pch_sense_bit_4;
wire pch_sense_bit_6;
wire pch_status_reset;
wire x_pch_noop_extra_bits;
wire x_pch_stacker_2_3;
wire x_pch_reader_busy;
wire x_rdr_unit_check_out;
wire rdr_unit_check;
wire bus_out_check;
wire reset_rdr_sense_latches;
wire x_1400_delayed_feed;
wire rdr_bus_out_check;
wire rdr_control;
wire rdr_command_reject;
wire [7:0] rdr_pch_bus_in_sense;
wire [7:0] rdr_pch_bus_in_status;
wire rdr_unusual_command;
wire rdr_sense_gate;
wire pch_sense_gate;
wire pch_status_gate;
wire pch_interven_reqd;
wire pch_command_gate;
wire pch_adapter_reset;
wire rdr_status_gate;
wire pch_unit_check;
wire pch_command_reject;
wire pch_bus_out_check;
wire pch_busy_queued;
wire x_pch_unit_check_out;
wire pfr_reset_pch_sense_latch;
wire x_075_150;
wire x_invalid_command;

// reader sense byte 0 bit 0: command reject
assign rdr_sense_bit_0 = ~rdr_valid_cmmd & rdr_command_gate;

/// XXX any_bit_bus_out_0_thru_5 called any_bits_bus_out_0_through_5 on page 87
// 32.13.31.1
assign any_bit_bus_out_0_thru_5 = |{bus_out[7:2]};	// +0 +1 +2 +3 +4 +5
// 32.12.32.1
assign x_pch_noop_extra_bits = any_bit_bus_out_0_thru_5 & // -6 -7	[5]
	bus_out[1] & bus_out[0];			// match: MMMMMM11
// 32.12.32.1
assign x_pch_stacker_2_3 = bus_out[7] & bus_out[6]	// -0 -1 +6 -7	[6]
	& ~bus_out[1] & bus_out[0];			// match: 11xxxx01
// 32.12.32.1
assign x_pch_reader_busy = bus_out[2] &		// -5 -7
	bus_out[0] & rdr_busy;			// match: xxxxx1x1

// punch sense byte 0 bit 0: command reject
// 32.13.31.1
assign pch_sense_bit_0 = pch_command_gate & x_pch_invalid_cmd;
/// x_pch_invalid_cmd also here on page 87
// 32.13.31.1
assign x_pch_invalid_cmd =
	x_pch_noop_extra_bits | x_pch_stacker_2_3 |
	x_pch_reader_busy | modifiers_only | read_backwards;
// punch sense byte 0 bit 2: bus out check
// 32.13.31.1
assign pch_sense_bit_2 = (pch_channel_request & command_out_delay &
		address_in & ~pch_busy_queued & bus_out_check) |	// [7]
	(bus_out_check & pch_trans_cycle & x_075_150);			// [8]

// reader sense byte 0 bit 2: bus out check
// 32.12.31.1
assign rdr_sense_bit_2 = rdr_channel_request & command_out_delay &
	address_in & bus_out_check & ~rdr_busy_queued;

// 32.12.22.1
latch1 u_rdr_unit_check(i_clk,
	rdr_sense_bit_0 | rdr_sense_bit_3 |
		rdr_sense_bit_4 | rdr_sense_bit_6 |
		rdr_sense_bit_2,
	rdr_status_reset,
	x_rdr_unit_check_out);
// 32.12.22.1
assign rdr_unit_check = x_rdr_unit_check_out | rdr_interven_reqd;

// 32.12.31.1
latch1 u_rdr_bus_out_check(i_clk,
	rdr_sense_bit_2,
	reset_rdr_sense_latches,
	rdr_bus_out_check);

// 32.12.31.1
assign reset_rdr_sense_latches = x_1400_delayed_feed |
	rdr_adapter_reset | rdr_read & rdr_command_gate |
	rdr_read & rdr_command_gate;

// 32.12.32.1
latch1 u_rdr_commd_reject(i_clk,
	rdr_sense_bit_0,
	reset_rdr_sense_latches,
	rdr_command_reject);

// XXX invalid command: pch_status_reset pulses in unison with pch_sense_bit_0.
// 32.13.22.1
wire x_pch_unit_check_in = pch_sense_bit_0 | pch_sense_bit_2 |
	pch_sense_bit_3 | pch_sense_bit_4 | pch_sense_bit_6;
latch1 u_pch_unit_check(i_clk,
	x_pch_unit_check_in,
	pch_status_reset & ~x_pch_unit_check_in,
	x_pch_unit_check_out);
assign pch_unit_check = x_pch_unit_check_out | pch_interven_reqd;

// XXX not named in the ild, but is used, and is named in the ald.
// 32.13.31.1
assign reset_pch_sense_latches = pch_command_gate & pch_write |
	pch_adapter_reset |
	pfr_reset_pch_sense_latch;

// 32.13.31.1
latch1 u_pch_commd_reject(i_clk,
	pch_sense_bit_0,
	reset_pch_sense_latches,
	pch_command_reject);

// 32.13.31.1
latch1 u_pch_bus_out_check(i_clk,
	pch_sense_bit_2,
	reset_pch_sense_latches,
	pch_bus_out_check);

// 32.11.26.1
assign rdr_pch_bus_in_sense[1] = rdr_unusual_command & rdr_sense_gate;
// XXX rdr_interven_reqd inverted here.
// 32.11.21.1
assign rdr_pch_bus_in_sense[6] = (rdr_interven_reqd & rdr_sense_gate) |
	(pch_interven_reqd & pch_sense_gate);
// 32.11.26.1
assign rdr_pch_bus_in_status[1] =
	(rdr_unit_check & rdr_status_gate & ~rdr_sense) |
	(pch_status_gate & ~pch_sense & pch_unit_check);
// 32.11.21.1
assign rdr_pch_bus_in_sense[7] =
	(rdr_command_reject & rdr_sense_gate) |
	(pch_sense_gate & pch_command_reject);
// 32.11.23.1
assign rdr_pch_bus_in_sense[5] =
	(rdr_bus_out_check & rdr_sense_gate) |
	(pch_sense_gate & pch_bus_out_check);

//////// page 54
//////// sld-2 reader sense bit 3 and 4
//////// 3040

//	reader error checks:
//	[1] no hole sense by rd 2
//	[2] incorrect count at rd 1 or rd 2
//	[3] the data register is checked for parity
//	    and the buffer address register is checked
//	    for valid address during both read transfer
//	    and read service cycles

wire rd_2_row_bit;
wire i2_read_ser_cycle;
wire check_reset;
wire rdr_cl_lat_not_npro;
wire read_check_hole_count_chk;
wire units_bar_ok;
wire tens_bar_ok;
wire rd_xfer_cy_or_ser_cy;
wire rdr_data_reg_bar_check;
wire address_check_cep;
wire allow_cy;
wire address_check_ce;
wire invalid_card_code;
wire read_val_chk_set;
wire read_val_chk;
wire rdr_data_check;
wire x_datareg_eq_pun_xlate_nonblocked;
wire block_read_xlate;
wire x_rdr_data_check_gate_out;
wire rdr_pch_bus_in_4_pfr;
wire pch_xlte_and_data_reg_comp;
wire x_375_450;
wire rdr_equipment_check;
wire rdr_translate_check;
wire pch_equipment_check;

// 32.20.53.1
wire x_set_read_check =
	// no hole sense by rd 2
	(data_reg_xu & ~rd_2_row_bit & i2_read_ser_cycle & x_300_450) |
	// incorrect count at rd 1 or rd 2
	(x_300_450 & i2_read_ser_cycle & ~rd_2_row_bit & data_reg_xl) |
	(x_300_450 & i2_read_ser_cycle & rd_2_row_bit & ~data_reg_xl);
// 32.20.53.1
latch1 u_read_chk(i_clk,
	x_set_read_check,
	check_reset | rdr_cl_lat_not_npro,
	read_check_hole_count_chk);

// 32.20.53.1
latch1 u_rdr_data_reg_bar_chk(i_clk,
	(~units_bar_ok | ~tens_bar_ok) & rd_xfer_cy_or_ser_cy
		& x_300_450,
	mach_reset_rdr_pch | (rdr_trans_cycle & x_450_525),
	rdr_data_reg_bar_check);

// 32.20.53.1
latch1 u_addres_check(i_clk,
	(~units_bar_ok | ~tens_bar_ok) & x_300_450 & allow_cy,
	check_reset,
	address_check_ce);

// 32.20.78.1 32.20.79.1
assign x_datareg_eq_pun_xlate_nonblocked = data_reg == punch_xlate_logic_out;

// XXX this is only named in the ald
// 32.20.79.1
assign pch_xlte_and_data_reg_comp = block_read_xlate | x_datareg_eq_pun_xlate_nonblocked;

// XXX ild says ~pch_xlte_and_data_reg_comp is
//	&'d with x_375_450; ald shows x_450_525
// reader sense byte 0 bit 3: equipment check
// 32.12.34.1
assign rdr_sense_bit_3 = (read_check_hole_count_chk & rdr_trans_cycle) |
	(rdr_trans_cycle & rdr_data_reg_bar_check & x_375_450) |
	(rdr_trans_cycle & x_450_525 & ~pch_xlte_and_data_reg_comp);

// 32.12.34.1
wire x_rdr_equipment_check_out;
latch1 u_rdr_equip_chk(i_clk,
	rdr_sense_bit_3,
	reset_rdr_sense_latches,
	x_rdr_equipment_check_out);
assign rdr_equipment_check = rdr_sense_bit_3 | x_rdr_equipment_check_out;

// XXX beware: there are several rdr_translate_check in the ald.
// 32.20.79.1
assign rdr_translate_check = ~pch_xlte_and_data_reg_comp & x_450_525 &
	(pfr_xfer_cycle | rdr_trans_cycle);

// 32.20.79.1
latch1 u_rd_xlate_chk(i_clk,
	rdr_translate_check,
	check_reset | mach_reset_rdr_pch |
	(x_450_525 & diagnostic_read_cycle) |
		check_reset | mach_reset_rdr_pch,	// XXX from ald
	rdr_translate_chk);

// 32.11.24.1
assign rdr_pch_bus_in_sense[4] = (rdr_equipment_check & rdr_sense_gate) |
	(pch_equipment_check & pch_sense_gate);

// 32.12.34.1
assign read_val_chk_set = rdr_trans_cycle & x_300_450 &
	invalid_card_code & ~read_col_binary;

// 32.12.34.1
latch1 u_rdr_data_check_gate(i_clk,
	read_val_chk_set,
	~rdr_op_in,
	x_rdr_data_check_gate_out);

// reader sense byte 0 bit 4: data check (non ebcdic / mode 1 read)
assign rdr_sense_bit_4 = rdr_pch_service_in & i_service_out &
	x_rdr_data_check_gate_out;

// 32.12.34.1
latch1 u_rdr_data_chk(i_clk,
	x_rdr_data_check_gate_out,
	reset_rdr_sense_latches,
	rdr_data_check);

// XXX ild has "2540 on line"; ald has "2540 off line"
// 32.12.34.1
latch1 u_read_val_chk(i_clk,
	rdr_data_check | (x_rdr_data_check_gate_out & x_2540_off_line),
	check_reset,
	read_val_chk);

// 32.12.25.1
assign rdr_pch_bus_in_sense[3] = rdr_pch_bus_in_4_pfr |
	(rdr_sense_gate & rdr_data_check);

//////// page 55
//////// sld-3 punch sense bit 3 and 4
//////// 3060

//	- punch error check circuits -
//  [1]	the output of the data register is translated back to ebcdic
//	code and compared with the channel register
//  [2]	the data register is checked for even parity during buffer write
//  [3] no hole sensed by punch check brushes or incorrect count at
//	data register xl or punch check brushes
//  [4] the 12 bit compare read translate and the data register parity
//	are checked during the pfr transfer cycle
//  [5] the pre-punched pfr card is checked for more than one punch
//	in columns 1 through 7.  any combinations of errors in steps
//	1 through 5 will set the punch equipment check latch

wire [7:0] rdr_xlate_logic_out;
wire x_chanreg_ne_rdr_xlate;
wire block_pch_translate_chk;
wire pch_bar_check;
wire x_turn_on_pch_stack_inh_1;
wire data_reg_par_check_gated;
wire pch_select;
wire pch_insert_blank_cycle;
wire die_cl_dly;
wire reset_par_2;
wire x_pch_stack_inh_1_out;
wire pch_rdy_and_cmmd_valid;
wire pch_busy;
wire after_9_emitter;
wire emit_8_pch;
wire emit_7_pch;
wire pch_stk_inh_2_lat;
wire after_9_pch_ser_cycle;
wire pch_stk_inh_3_lat;
wire check_reset_ce;
wire punch_hole_count_check;
wire pch_data_check_gate;
wire x_pch_data_check_out;
wire pch_pfr_write;
wire pch_br_cl_delay;
wire pch_row_bit_ser_cycle;
wire pch_ser_cycle;
wire pfr_val_chk_set;
wire reset_pch_sense_latches;
wire pfr_xfer_cyc;
wire data_reg_parcheck_gated;
wire pch_equipment_chk;

// 32.20.67.1
assign x_chanreg_ne_rdr_xlate = chan_reg != rdr_xlate_logic_out;

// 32.20.53.1
assign pch_bar_check = ~(~(~units_bar_ok | ~tens_bar_ok) | x_2540_off_line) &
	x_225_300 & pch_select;

// XXX ald names pch_translate_check which is not latched, not to be
// confused with pch_translate_chk which is latched.
// 32.20.67.1
wire pch_translate_check = (x_chanreg_ne_rdr_xlate & ~block_pch_translate_chk)
	& x_375_450 & pch_trans_cycle;

// 32.33.21.1
assign x_turn_on_pch_stack_inh_1 = pch_translate_check | pch_bar_check |
	(data_reg_par_check_gated & die_cl_dly & pch_ser_cy &
		pch_insert_blank_cycle & x_375_450);

// 32.33.21.1
assign reset_par_2 = pch_channel_request & pch_rdy_and_cmmd_valid &
	~pch_busy;

// does [3]
// 32.33.22.1
assign punch_hole_count_check = (data_reg_xu & pch_br_cl_delay &
		~pch_row_bit_ser_cycle & pch_ser_cycle) |
	(~pch_row_bit_ser_cycle & pch_br_cl_delay & data_reg_xl &
		pch_ser_cycle) |
	(pch_br_cl_delay & pch_row_bit_ser_cycle & ~data_reg_xl &
		pch_ser_cycle);

// 32.33.21.1
latch1 u_pch_stack_inh_1(i_clk,
	x_turn_on_pch_stack_inh_1,
	mach_reset_rdr_pch | reset_par_2,
	x_pch_stack_inh_1_out);

// 32.33.21.1
latch1 u_pch_stack_inh_2(i_clk,
	x_pch_stack_inh_1_out & after_9_emitter,
	mach_reset_rdr_pch | emit_8_pch,
	pch_stk_inh_2_lat);

// 32.33.22.1
latch1 u_pch_stack_inh_3(i_clk,
	(pch_stk_inh_2_lat & emit_7_pch) |
		(x_375_450 & after_9_pch_ser_cycle & punch_hole_count_check),
	mach_reset_rdr_pch | reset_par_2 | check_reset_ce,
	pch_stk_inh_3_lat);

// does [5]
// 42.12.03.1
assign pfr_val_chk_set = pfr_xfer_cycle & x_300_525 & invalid_card_code;

// 42.12.03.1
latch1 u_pch_data_check_gate(i_clk,
	pfr_val_chk_set,
	~pch_op_in,
	pch_data_check_gate);

// XXX inverted x_2540_off_line here
// 42.12.03.1
latch1 u_pfr_val_light(i_clk,
	(~x_2540_off_line & pch_data_check_gate) | x_pch_data_check_out,
	check_reset,
	o_pfr_val_light);

// punch sense byte 0 bit 4: data check (non ebcdic / mode 1 read)
// 42.12.03.1
assign pch_sense_bit_4 = pch_data_check_gate & i_service_out &
	rdr_pch_service_in;

// 42.12.03.1
latch1 u_pch_data_check(i_clk,
	pch_sense_bit_4,
	reset_pch_sense_latches,
	x_pch_data_check_out);

assign pch_pfr_write = x_pch_data_check_out;

// XXX ild shows rdr_pch_bus_in_sense[3] ; do they mean this?
// 42.12.03.1
assign rdr_pch_bus_in_4_pfr = x_pch_data_check_out & pch_sense_gate;

// punch sense byte 0 bit 3: eqipment check
// does [4] "pfr_equipment_chk"
// 42.12.03.1 32.13.33.1
assign pch_sense_bit_3 = (rdr_translate_check & pfr_xfer_cy) |
	(pfr_xfer_cyc & data_reg_parcheck_gated) |
	(pch_complete & ~rdr_pch_status_in & pch_stk_inh_3_lat);
// 32.13.33.1
latch1 u_pch_equip_chk(i_clk,
	pch_sense_bit_3,
	reset_pch_sense_latches,
	pch_equipment_chk);

//////// page 56
//////// sld-4 printer error check
//////// 3080

//	- printer error checks -
//  [1]	the sync check is set if the pcg does not contain a 1 or the ss ring
//	is not a 3 at home position
//  [2]	the data is checked for parity during buffer loading and printing
//  [3]	a print compare occurs for a position already printed
//  [4]	a print position does not contain an unprintable character or has not
//	had a print compare by scan 49
//  [5]	a hammer fires without a print compare
//  [6]	a print compare occurs but the hammer does not fire
//  [7]	print check plane regeneration
//  [8]	check for a space of more than three lines or a skip to
//	an invalid command
//  [9]	check for an undefined command to printer
// [10]	check for an invalid command to printer
// [11]	bus out parity check on initial command
// [12]	bus out parity check during buffer load

wire home_gate;
wire [5:0] pcg;
wire ss_1;
wire ss_2;
wire ss_3;
wire train_ready;
wire gated_pss;
wire x_sync_check_out;
wire sync_recycle_jumper;
wire x_prt_req_busy_opin;
wire prt_sense_gate_in;
wire gated_sync_check;
wire print_ready;
wire prt_interven_reqd;
wire cf_set_unit_check;
wire gated_prt_end;
wire prt_parity_hammer_check;
wire x_bad_command;
wire x_bad_parity;
wire x_prt_unit_check_out;
wire prt_sense_extended;
wire prt_status_gate_in;
wire prt_unit_check;
wire prt_command_gate;
wire prt_busy_queued;
wire prt_write_ctrl;
wire prt_sense_reset;
wire print_read;
wire cf_invalid_command;
wire prt_command_reject;
wire prt_bus_out_check;
wire [6:0] print_buffer_bits;
wire gnd_tie_off_ucb;
wire clock_2_4;
wire clock_5_7_nucb;
wire clock_5_7;
wire set_storage_parity_ck_ucb;
wire reset_ham_ck_and_parity_ck;
wire prt_parity_check_latch;
wire pr_compare;
wire print_line_complete_tr;
wire line_full_ucb;
wire print_scan_49;
wire on_line_and_uncomp_char_ucb;
wire hammer_fire_tr;
wire print_scan;
wire print_scan_print_read;
wire print_check_tr;
wire hammer_check_latch;
wire line_full;	// not named in ald/ild

// XXX line_full_ucb & print_scan_49 are wire-anded;
// this is shown in three places page 56,71,72 but the result
// is never named.
// 33.23.11.1
// 33.33.02.1
// 33.33.47.1
assign line_full = line_full_ucb & print_scan_49;

// 33.33.21.1
latch1 u_sync_check(i_clk,
	mach_reset_printer |	// XXX hack
	gated_pss_1 & home_gate & (|{pcg[5:1]} | ~pcg[0] | ss_1 | ss_2 | ~ss_3),
	train_ready,
	x_sync_check_out);

// 33.33.21.1
assign gated_sync_check = x_sync_check_out & ~sync_recycle_jumper;

// 33.33.01.1
latch1 u_print_ready(i_clk,
	start_latch & ~gated_sync_check,
	gated_sync_check,
	print_ready);

// XXX x_prt_req_busy_opin_2 sorta duplicates this on page 90
// 33.13.56.l
assign x_prt_req_busy_opin = ~(prt_channel_request | prt_busy | prt_op_in)
	& ~prt_device_end;	// XXX ald shows prt_device_in...

// XXX see prt_interv_required see page 90 (5080E2)
// 33.13.56.1
//latch1 u_print_interven_required(i_clk,
//	x_prt_req_busy_opin & ~not_status_in_sample & ~print_ready,
//	x_prt_req_busy_opin & ~not_status_in_sample & print_ready,
//	prt_interven_reqd);

// 33.13.56.1
latch1 u_prt_unit_check(i_clk,
	cf_set_unit_check | (gated_prt_end & prt_parity_hammer_check) |
	x_bad_command | x_bad_parity,
	prt_status_selective_reset,
	x_prt_unit_check_out);
// 33.13.56.1
assign prt_unit_check = prt_interven_reqd | x_prt_unit_check_out;

// XXX ild has a weird way of show cascaded ands for [10]
// 33.13.62.1
assign x_bad_command = bus_out[0] & ~prt_write_command_gate &	// [8]
		prt_command_gate |
	prt_command_gate & ~bus_out[0] &			// [9]
		any_bit_bus_out_0_thru_4 |
	prt_command_gate & bus_out[2] & (bus_out[1]		// [10]
		& bus_out[0]);
// 33.13.62.1
assign x_bad_parity = prt_channel_request & address_in &	// [11]
		command_out_delay & ~prt_busy_queued &
		bus_out_check |
	bus_out_check & prt_service_in & clock_2_4 &		// [12]
		prt_write_ctrl;

// 33.13.62.1
assign prt_sense_reset = prt_write_ctrl & prt_command_gate |
	prt_command_gate & print_read | prt_adapter_reset;

// 33.13.62.1
latch1 u_prt_commd_reject(i_clk,
	cf_invalid_command | x_bad_command,
	prt_sense_reset,
	prt_command_reject);

// 33.13.62.1
latch1 u_prt_bus_out_chk(i_clk,
	x_bad_parity,
	prt_sense_reset,
	prt_bus_out_check);

// 33.23.10.1
wire x_odd_print_parity = ~^{print_buffer_bits};
wire x_set_parity_check =
	x_odd_print_parity & ~(gnd_tie_off_ucb | ~clock_5_7_nucb)
		| set_storage_parity_ck_ucb;
// 33.23.10.1
wire x_clear_parity_check =
	print_check_read & trigger_a_clock_0_4 |
	reset_ham_ck_and_parity_ck;
// XXX looks like continuous x_clear_parity_check during x_set_parity_check
// is expected and should inhibit output.
// 33.23.10.1
latch1 u_prt_parity_check(i_clk,
	x_set_parity_check & ~x_clear_parity_check,
	x_clear_parity_check & ~x_set_parity_check,
	prt_parity_check_latch);	// XXX named in ald

// also see page 72
// 33.33.47.1
latch1 u_hammer_check(i_clk,
	(~gnd_tie_off_ucb & pr_compare & print_line_complete_tr |	// [3]
		line_full &			// [4]
			~print_line_complete_tr &
			~on_line_and_uncomp_char_ucb |
		~hammer_fire_tr & ~equal_check_tr_1 & print_scan |	// [5]
		hammer_fire_tr & equal_check_tr_2 & print_scan |	// [6]
		print_scan_print_read & print_check_tr)			// [7]
		& clock_5_7 & ~reset_ham_ck_and_parity_ck |
		print_check_tr & stor_scan_load_mode_c_e_1,
	reset_ham_ck_and_parity_ck,
	hammer_check_latch);	// XXX probable name in ald

// XXX isn't this the same thing as "parity_hammer_check" on page 72 ?
// 33.33.47.1
assign prt_parity_hammer_check =
1'b0 &	// XXX don't see how to avoid
	prt_parity_check_latch | hammer_check_latch;

assign prt_bus_in_sense[6] = prt_interven_reqd & prt_sense_gate_in;
// 33.13.85.1
assign prt_bus_in_status[1] = prt_unit_check & ~prt_sense_extended &
	prt_status_gate_in;
// 33.13.82.1
assign prt_bus_in_sense[7] = prt_command_reject & prt_sense_gate_in;
assign prt_bus_in_sense[5] = prt_sense_gate_in & prt_bus_out_check;
// 33.13.83.1
assign prt_bus_in_sense[4] = prt_sense_gate_in &
	prt_parity_hammer_check;

//////// page 62
//////// sld-10 sense, reader-punch and printer
//////// 4000

//	- reader sense command -
//  [1]	during initial selection of the reader, a
//	sense command activates the reader command gate
//	to set the reader sense latch
//  [2]	the reader sense register is gated on to the
//	bus in lines by reader-punch service in with
//	the sense command stored
//  [3]	reader-punch service in, with operational in,
//	sets reader channel end and reader device end
//
//	- punch sense commmand -
//  [1]	during initial selection of the punch, a
//	sense command activates the punch command gate
//	to set the punch sense latch
//  [2]	the punch sense register is gated on to the
//	bus in lines by reader-punch service in with
//	the sense command stored
//  [3]	reader-punch service in, with operational in,
//	sets punch channel end and punch device end
//
//	- printer sense commmand -
//  [1]	during initial selection of the printer, a
//	sense command activates the printer command gate
//	to set the printer sense latch
//  [2]	the printer sense register is gated on to the
//	bus in lines by printer service in with the
//	sense command stored
//  [3]	service out acknowledges receipt of the
//	sense byte and, gated with service in, sets
//	printer channel end and printer device end
//
// note: all sense commands may be performed in either
//	burst or data interleave mode

wire x_set_rdr_chan_end;
wire x_pch_sense_service_in;
wire turn_on_prt_sense_lat_tcs;
wire reset_rdr_commd_mod_latch;
wire reset_pch_commd_mod_latch;
wire reset_prt_command_latches;
wire pch_device_end;
wire rdr_feed_command;
wire prt_sense;
wire [7:0] prt_bus_in_sense;
wire [7:0] prt_bus_in_status;
wire prt_status_selective_reset;
wire prt_channel_end;
wire prt_device_end;

// 32.12.02.1
latch1 u_rdr_sense(i_clk,
	rdr_command_gate &
	~bus_out[3] & bus_out[2] & ~bus_out[1] & ~bus_out[0],
		// matches: xxxx0100
	reset_rdr_commd_mod_latch,
	rdr_sense);

// 32.12.21.1
assign x_set_rdr_chan_end = rdr_sense & rdr_op_in & rdr_pch_service_in |
		// XXX these conditions are from page 64
	(col_80 & x_450_525 & rdr_trans_cycle & ~col_binary_1) |
	(i_command_out & rdr_pch_service_in & rdr_op_in) |
	rdr_control & rdr_command_gate |
		// XXX these conditions from ald
	rdr_op_in & disconnect & ~rdr_feeding & rdr_command_stored |
	rdr_no_op;

// 32.12.21.1
latch1 u_rdr_channel_end(i_clk,
	x_set_rdr_chan_end,
	rdr_status_reset,
	rdr_channel_end);

// XXX rdr dev reset is run through two low speed inverters.
//	this probably shapes the width of not_rdr_device_end_smp
wire x_delayed_rdr_dev_reset;
delay1 #(1) u_hack_rdr_dev_rst(i_clk, mach_reset_out, rdr_status_reset, x_delayed_rdr_dev_reset);
/// XXX how does this compare to page 64
// 32.12.22.1
latch1 u_rdr_device_end(i_clk,
	rdr_channel_end & ~rdr_feed_command |
	rd_complete & rdr_busy & ~status_in_extended & rdr_feed_command |
	rdr_no_op,
	x_delayed_rdr_dev_reset,
	rdr_device_end);

assign rdr_pch_bus_in_sense[2] = 0;	// 5,7 not used
assign rdr_pch_bus_in_sense[0] = 0;

// 32.11.21.1-32.11.27.1
assign rdr_pch_bus_in = rdr_pch_bus_in_sense | rdr_pch_bus_in_status;

// XXX must not turn off pch_sense before status_in_delay
wire hack_des_1, hack_des_2, hack_des_3;
delay1 #(1) u_hack_des_2(i_clk, mach_reset_out, pch_device_end, hack_des_2);
ss2 #(8) u_hack_des_3(i_clk, mach_reset_out, ~pch_device_end, hack_des_3);
assign hack_des_1 = ~pch_device_end & hack_des_2 | hack_des_3;

// 32.13.02.1
latch1 u_pch_sense(i_clk,
	pch_command_gate &
	~bus_out[3] & bus_out[2] & ~bus_out[1] & ~bus_out[0],
		// matches: xxxx0100
~hack_des_1 &
	reset_pch_commd_mod_latch,
	pch_sense);

// 32.13.21.1
assign x_pch_sense_service_in = pch_sense & pch_op_in & rdr_pch_service_in;

/// XXX also pch chan end, page 66
// 32.13.21.1
//latch1 u_pch_channel_end(i_clk,
//	x_pch_sense_service_in,
//	pch_status_reset,
//	pch_channel_end);

/// XXX pch_device_end is also on page 67
// 32.13.22.1
latch1 u_pch_device_end(i_clk,
	x_pch_write_complete |	// XXX "set" case from page 67
	x_pch_ready_transition |	// only in ald
//	pch_no_op |	// XXX in ald, but not necesary because of next,
	pch_channel_end & ~pch_write,
	pch_status_reset,
	pch_device_end);

// 33.13.11.1
latch1 u_prt_sense(i_clk,
	turn_on_prt_sense_lat_tcs |
	(bus_out[2] & ~bus_out[1] & ~bus_out[0]	// match: 00000100
	& no_bits_bus_out_0_thru_4 & prt_command_gate),
	reset_prt_command_latches,
	prt_sense);

/// XXX how does this compare to page 68
// XXX ald is distinctly different
// 33.13.54.1
//latch1 u_prt_chan_end(i_clk,
//	i_service_out & prt_service_in & prt_sense,
//	prt_status_selective_reset,
//	prt_channel_end);
// latch: 33.13.54.1

// XXX how does this compare to page 70
// XXX actual definition in ald quite different.
// 33.13.54.1
//latch1 u_prt_device_end(i_clk,
//	prt_sense & i_service_out & prt_service_in,
//	prt_status_selective_reset,
//	prt_device_end);

// XXX bus_in_data & bus_in_check not in ILD, not named as such in ALD.
// 33.13.82.1-33.13.85.1
assign prt_bus_in = prt_bus_in_sense | prt_bus_in_status
	| prt_bus_in_data | prt_bus_in_check;

//////// page 63
//////// sld-11 i/o tester operation - reader - punch
//////// 4020

// - notes-
//  [1]	set ce start latch and initial ce start time
//  [2]	activate read or punch feed
//  [3]	for read or pfr, gate xfer cycle req off line, reset bar
//	activate rdr trans cy req and read trans cycle
//  [4]	take read or punch service cycles
//  [5]	error stop switch will block rd or pch feed and
//	allow a storage scan without going off line
//  [6]	check planes are read out and regenerated
//	during a storage scan

wire ce_start_lat;
wire start_sw;
wire x_300_150;
wire x_525_600;
wire x_300_375;
wire x_ce_start_data_enter;
wire data_enter;
wire buffer_entry_p_bit_1;
wire buffer_entry;
wire data_reg_p_pullover;
//wire data_reg_12_9_pullover;
//wire pch_xlate_12_9;
wire gate_xfer_cy_req_off_line;
wire off_line_run_sw;	// XXX should these be i_ ?
wire read_sw;
wire pfr_mode_sw;
wire x_read_feed_out;
wire check_stop;
wire read_chk;
wire gate_rd_complete_2540;
wire rd_complete;
wire x_punch_feed_out;
wire x_punch_feed;
wire load_and_single_cycle_sw;
wire pch_chk;
wire parity_chk;
wire pch_feed;
wire c_2821_pch_ready_turn_off;
wire c_2821_rdr_ready_turn_off;
wire rd_0_1_bit_mod;
wire pch_check_error_stop_on_line;
wire mach_reset_rdr;
wire check_stop_sw;
wire pch_4_bit_mod;
wire punch_sw;
wire stop_storage_scan;
wire pch_chk_err_stop_off_line;
wire parity_check;
wire x_xfer_complete_read;
wire x_rdr_transfer_cy_req_out;
wire x_reset_rar_out;
wire reset_rar;
wire ser_cycle_not_rd_1;
wire ser_cycle_not_rd_2;
//wire ser_cycle_not_pch_chk;
wire storage_scan_sw;
wire data_enter_sw;
wire data_enter_0_7;
wire [7:0] pull_on_chan_reg;
wire block_rar_and_par_advance_ce;
wire r0_000_150;
//wire x_rd_serv_cyc_1_out;
wire x_various_rdr_transfer_reasons;
wire select_pch;
wire storage_sw;
wire pch_trans_cy_req;
wire pch_ser_cy_req;
//wire rdr_trans_cycle_stor_scan;

// 32.31.06.1
latch1 u_ce_start_time(i_clk,
	~ce_start_lat & & x_300_450 & ~start_sw,
	~x_300_150,
	ce_start_time);

// 32.31.06.1
latch1 u_ce_start_lat(i_clk,
	ce_start_time & x_450_525,
	x_525_600 & start_sw,
	ce_start_lat);

assign x_ce_start_data_enter = ce_start_lat & data_enter;
// 32.20.80.1
assign buffer_entry_p_bit_1 = x_ce_start_data_enter & x_300_375;
// 32.20.80.1
//assign buffer_entry = x_ce_start_data_enter & x_225_375;
// 32.20.33.1
assign data_reg_p_pullover = buffer_entry_p_bit_1
	& data_reg_parity_check;
// 32.20.31.1 - 32.20.34.1
//assign data_reg_12_9_pullover = buffer_entry & pch_xlate_12_9;
assign gate_xfer_cy_req_off_line = (off_line_run_sw & read_sw) |
	(read_sw & pfr_mode_sw);

// 32.12.40.1
latch1 u_read_feed(i_clk,
	gate_xfer_cy_req_off_line & ce_start_lat,
	mach_reset_rdr_pch |	// XXX ald has this
	check_stop & (read_chk | read_val_chk),
	x_read_feed_out);
// XXX also on page 65, slightly different
// 32.31.07.1
latch1 u_read_complete(i_clk,
	x_225_375 & i2_read_ser_cycle & ~block_rdr_feed
		& gate_rd_complete_2540 & col_80,
	mach_reset_rdr_pch |		// XXX from ald
	not_rdr_device_end_smp |	// XXX from page 65 and ald
	x_2540_off_line & x_075_150,
	rd_complete);
// XXX note: the alds have 2 signals called "read feed".
// 32.12.40.1
assign read_feed_1 = x_read_feed_out & ~rd_complete;

/// XXX punch_complete is also on page 67
// 32.31.07.1
latch1 u_punch_complete(i_clk,
	col_80 & x_450_525 & after_9_pch_ser_cycle,
mach_reset_rdr_pch |	// XXX hack guess
pch_cl_lat_not_npro | not_pch_device_end_smp |	// from page 67
	x_075_150 & x_2540_off_line & after_9_emitter,
	pch_complete);

// 32.13.32.1
latch1 u_punch_feed(i_clk,
	ce_start_lat & ~(~off_line_run_sw & read_sw) &
		x_2540_off_line & ~storage_scan & ~load_and_single_cycle_sw,
	mach_reset_rdr_pch | pch_ctr_f & stop_sw |	// XXX ald has these
		pch_chk_err_stop_off_line,
	x_punch_feed_out);
// 32.13.33.1
assign x_punch_feed = ~pch_complete & x_punch_feed_out;

// XXX ild inverts pch_check_error_stop_on_line here, ald does not.
// 32.20.53.1
latch1 u_block_pch_fd(i_clk,
	pch_check_error_stop_on_line,
	mach_reset_rdr | ~check_stop_sw,
	block_pch_feed);
// 32.20.53.1
assign c_2821_pch_ready_turn_off = block_pch_feed;
// 32.20.53.1
latch1 u_block_rd_fd(i_clk,
	rd_chk_err_stop_on_line,	// XXX no set in ild
	~check_stop_sw | mach_reset_rdr,
	block_rdr_feed);
assign c_2821_rdr_ready_turn_off = rd_0_1_bit_mod & block_rdr_feed;
assign check_stop = check_stop_sw;
// 42.12.02.1
assign pch_4_bit_mod =
	pfr_mode_sw & punch_sw |
	x_pch_4_bit_mod_normal;	// XXX missing inputs here
// 32.20.53.1
assign stop_storage_scan = ~(~pch_chk_err_stop_off_line
	| (read_chk & check_stop)) |
	(check_stop & parity_check);

assign x_xfer_complete_read = gate_rd_complete_2540 &
	i2_read_ser_cycle & x_225_375 & col_80 &
	gate_xfer_cy_req_off_line;
// 32.31.07.1
latch1 u_rdr_transfer_cy_req(i_clk,
	x_xfer_complete_read,
	mach_reset_rdr_pch |			// XXX ald has this
	rdr_channel_end | x_2540_off_line,
	x_rdr_transfer_cy_req_out);
latch1 u_reset_rar(i_clk,
	x_xfer_complete_read,
	mach_reset_rdr_pch |			// XXX ald has this
	~x_2540_off_line | x_075_150,
	x_reset_rar_out);
/// XXX how does this compare to page 64
// 32.31.07.1
assign rdr_trans_cycle_req = x_rdr_transfer_cy_req_out & ~x_reset_rar_out |
	| x_rdr_trans_cycle_req; // XXX or's in page 64 calc
// 32.31.07.1
assign reset_rar = (x_reset_rar_out & x_000_075) |
	reset_rar_2;			// ald shows this as a wired or

// XXX this is called rdr_trans_cy_stor_scan on page 83.
// 32.31.01.1
//assign rdr_trans_cycle_stor_scan = storage_scan | rdr_trans_cycle;
// XXX ser_cy_not_rd2_not_pch_chk and ser_cycle_not_rd_1 expanded out
//	more correctly and clearly on page 83
// 32.31.01.1
//assign ser_cycle_not_rd_1 = ~rdr_trans_cycle_stor_scan;
// 32.31.01.1
//assign ser_cy_rd_2_not_pch_chk = ~rdr_trans_cycle_stor_scan | ser_cycle_not_rd_2;

assign o_data_enter_no = storage_scan_sw | load_and_single_cycle_sw;
assign data_enter_sw = i_data_enter_sw;
assign data_enter_0_7 = i_data_enter_0_7;
assign block_rar_and_par_advance_ce = data_enter_sw & load_and_single_cycle;
assign pull_on_chan_reg = data_enter_0_7;
// 32.05.01.0 32.33.17.1
assign load_and_single_cycle = load_and_single_cycle_sw;

assign x_various_rdr_transfer_reasons =
( ( load_and_single_cycle & ce_start_time & read_sw ) |
		( read_sw & ce_start_lat & storage_scan ) |
		( ~rd_ser_cy_req  & ~xfer_cy_req) |
		( xfer_cy_req & rdr_trans_cycle_req) |
		(select_pch & diagnostic_write ))
	& ~diagnostic_write;

/// XXX how does this compare to page 85
// 32.32.13.1 32.31.01.1
latch1 u_rd_xfer_cy_1(i_clk,
	x_various_rdr_transfer_reasons
		& rdr_trans_cycle_req & r0_000_150,
	x_000_075,
	rdr_trans_cycle);

/// XXX how does this compare to page 85
// 32.32.13.1
//latch1 u_rd_serv_cy_1(i_clk,
//	x_various_rdr_transfer_reasons &
//		r0_000_150 & ~xfer_cy_req,
//	x_000_075,
//	x_rd_serv_cyc_1_out);

// also see page 66
// also see page 88
// 32.33.17.1
// select_pch isn't labelled here, but it's the wired'd or that
// goes into "pch trans cy"'s set input.
assign select_pch =
		( ce_start_time & load_and_single_cycle_sw & punch_sw)
		| (ce_start_lat & punch_sw & storage_sw) |
		(pfr_trans_cy_req & xfer_cy_req) |
		(xfer_cy_req & pch_trans_cy_req) |
		( ~rd_ser_cy_req & pch_ser_cy_req & ~xfer_cy_req );


/// XXX u_pch_trans_cy and u_pch_serv_cy also on page 88
/// XXX u_pch_trans_cy also on page 66
// XXX latch1 u_pch_trans_cy(,,,pch_trans_cycle) duplicated on pages 64,88
// 32.33.17.1
wire x_set_pch_trans_cy_in = select_pch & ~pch_read &
		xfer_cy_req & r0_000_150;
latch1 u_pch_trans_cy(i_clk,
	x_set_pch_trans_cy_in,
	(x_000_075 & ~x_set_pch_trans_cy_in),
	pch_trans_cycle);

// XXX also duplicated on page 67
// 32.33.17.1
latch1 u_pch_serv_cy(i_clk,
	select_pch & r0_000_150 & ~xfer_cy_req,
	x_000_075,
	pch_ser_cy);

//////// page 64
//////// sld-12 reader commands (sheet 1)
//////// 4040

// - read command (burst or data interleave mode)
//  [1]	set reader read during initial selection
//  [2]	in data interleave mode activate reader adapter request and
//	await for select out to set reader operational in
//  [3] activate reader transfer cycle request
//  [4]	set transfer cycle request
//  [5]	read first character out of read buffer to data register,
//	through read translator, and into channel register
//  [6]	set channel register full to inactivate reader transfer
//	cycle request and initiate a reader-punch service in
//  [7]	character is accepted by service out resetting channel
//	register full and reader-punch service in
//  [8]	in data interleave mode the normal polling sequence transfers
//	1 or 2 byte burst until the 80th character or command out
//	response to reader-punch service in
//  [9]	in burst mode, transfers continue unti lthe 80th character or
//	a command out response to reader-punch service in
// [10]	set reader channel end
// [11]	if this is a read and feed command skip to control command
//	step 2
// [12] if this is a read and no feed command set reader device end
//	and end read data transfer
// [13]	set interrupt request and reader adapter request to present
//	the status ot the channel

wire col_binary_1;
wire rdr_status_inhibit;
wire end_read_data_xfer;
wire rdr_rdy_and_cmmd_valid;
wire pch_trans_cycle_req;
wire x_525_075;
//wire sel_rdr_not_diagn_write;
wire gated_select_pch;
wire rdr_select;
//wire rd_column_binary;
// wire x_data_strobe;
wire [11:0] data_reg_regen;
wire x_150_225;
wire [11:0] x_rdr_storage_output;
wire x_rdr_trans_cycle_req;

// XXX multiple rdr channel end on this page... and page 62.
// 32.11.21.1
//latch1 u_rdr_channel_end_2(i_clk,
//	(col_80 & x_450_525 & rdr_trans_cycle & ~col_binary_1)
//		| (i_command_out & rdr_pch_service_in & rdr_op_in),
//	(rdr_op_in & rdr_pch_status_in & i_service_out & ~rdr_status_inhibit),
//	rdr_channel_end);
// 32.12.41.1
latch1 u_end_read_data_xfer(i_clk,
	rdr_channel_end,
	~rdr_read,
	end_read_data_xfer);
// 32.12.02.1
latch1 u_rdr_read(i_clk,
	rdr_command_gate & rdr_rdy_and_cmmd_valid &
	bus_out[1] & ~bus_out[0],		// matches: xxxxxx10
	reset_rdr_commd_mod_latch,
	rdr_read);
/// XXX this is just rdr_trans_cycle_req here, but must be or'd into page 63
// 32.12.41.1
assign x_rdr_trans_cycle_req = rdr_read & ~chan_reg_full & rdr_op_in &
	~end_read_data_xfer & (rdr_adapter_request |
		(sel_out_burst_sw_on & ~rdr_channel_request & ~address_in));
/// XXX punch uses the same name xfer_cy_req on page 66
//latch1 u_xfer_cy_req(i_clk,
//	(rdr_trans_cycle_req | pch_trans_cycle_req | pfr_trans_cy_req)
//		& x_525_075,
//	~(rdr_trans_cycle_req | pch_trans_cycle_req | pfr_trans_cy_req)
//		& x_525_075,
//	xfer_cy_req);

// duplicated with ce additions on page 85
// 32.32.13.1
//assign select_rdr = (~rd_ser_cy_req & ~xfer_cy_req) |
//	(xfer_cy_req & rdr_trans_cycle_req);
//assign sel_rdr_not_diagn_write = ~(~select_rdr & diagnostic_write);
// 32.32.13.1 32.31.01.1
//latch1 u_rdr_xfer_cycle(i_clk,
//	sel_rdr_not_diagn_write & r0_000_150 & rdr_trans_cycle_req,
//	x_000_075,
//	rdr_trans_cycle);

// XXX in the real device, buffer core storage is slow enough
//	that the service-in will always drop before chan_reg gets
//	full again.  in this implementation, buffer storage is
//	much faster - so we must block a lagging service-in from
//	clearing it so discarding half the data.  Also we must
//	split chan_reg_full meaning when this is true: must look
//	"empty" for consumers yet "full" for producers.
reg x_cfsi_seen;
initial x_cfsi_seen = 0;
always @(posedge i_clk)
	if (~x_service_out_delayed & ~rdr_pch_service_in)
		x_cfsi_seen <= 0;
	else if (chan_reg_full & rdr_pch_service_in & i_service_out)
		x_cfsi_seen <= 1;
wire block_premature_crf_clear = x_cfsi_seen & pch_hack[0];
wire chan_reg_full_1;

/// XXX u_chan_reg also on page 66
//32.11.16.1
//latch1 u_chan_reg_full(i_clk,
//	rdr_trans_cycle & x_375_450,
//	( (end_read_data_xfer & rdr_pch_service_in & rdr_op_in)
//		| (rdr_op_in & rdr_pch_service_in & i_service_out) ),
//	chan_reg_full);
//32.11.16.1
latch1 u_chan_reg_full_3(i_clk,
	pfr_set_chan_reg_full |			// XXX from ald
	rdr_trans_cycle & x_375_450 |
x_150_225 &
		pch_write & pch_op_in & i_service_out & rdr_pch_service_in,
	pfr_reset_chan_reg_full |	// XXX ald has this pfr line
	( (end_read_data_xfer & rdr_pch_service_in & rdr_op_in) |
		(rdr_op_in & rdr_pch_service_in & i_service_out
			& ~block_premature_crf_clear) ) |	// XXX hack
		~rdr_pch_op_in | (pch_trans_cycle & x_225_300),
	chan_reg_full);
assign chan_reg_full_1 = chan_reg_full & ~block_premature_crf_clear;
// XXX this is a trigger in the ald, but an ff in the ild.
//	trigger is "dhf" - on and off share one ac set.
//	this may need to be edge triggered.
// 32.20.17.1
latch1 u_rdr_and_pch_select(i_clk,
	gated_select_pch & r0_000_150,
	i_reset |	// ald says this is reset by "clock reset"
	select_rdr,
	pch_select);
// XXX rdr_select not shown as used in ILD
// 32.12.02.1
assign rdr_select = ~pch_select;
// 32.12.02.1
latch1 u_rdr_control(i_clk,
	rdr_command_gate & rdr_rdy_and_cmmd_valid &
	bus_out[5] & bus_out[1] & bus_out[0],	// xx1xxx11
	reset_rdr_commd_mod_latch,
	rdr_control);
// XXX multiple rdr channel end on this page... and page 62.
// 32.12.21.1
//latch1 u_rdr_channel_end_3(i_clk,
//	rdr_control & rdr_command_gate,
//	rdr_status_reset,
//	rdr_channel_end);
// 32.20.63.1-32.20.66.1

assign data_reg_regen = data_reg;

// XXX data_reg_12_9_pullover: in ald, data reg bits
// are overdriven with gated pch xlate 12-9 bits.
// kinda duplicated as "data register" page 66
latch1 #(.W(12)) u_data_reg(i_clk,
//	x_rdr_storage_output & {12{x_data_strobe & x_150_225}},
	x_sense_amps_out |
	data_reg_12_9_pullover,
//	x_75_150,
	reset_data_reg,
	data_reg);

//////// page 65
//////// sld-13 reader commands (sheet 2)
//////// 4041

// - control command (feed portion of a read command)
//  [1]	a feed command sets reader controls and
//	reader channel end during initial selection
//  [2] reader feed commmand sets reader end and activates
//	read feed to start a feed (and stacker select) cycle
//  [3]	enter the 9 holes in to row bits, reset reader address
//	register and set read service cycle request
//  [4]	read service cycles transfer row bits to buffer
//  [5]	repeat steps 3 and 4 for each c. b. pulse
//  [6]	set read complete, reader device end, reader
//	interrupt request and reader adapter request to
//	present the status to the channel

wire not_rdr_device_end_smp;
wire rdr_0_1_bit_mod;
wire read_feed;	// wire'd or: there are multiple drivers in the ald
wire x_1400_comp_read_feed;
wire reset_rdr_commd_busy_lat;
wire stacker_r2;
wire stacker_r3;
wire rdr_1_bit_mod;
wire rdr_0_bit_mod;
wire gated_read_feed;
wire rdr_rdy_and_commd_valid;
wire x_9_rd_ser_cycle;
wire rdr_ready_latch;
wire inhibit_375_000;
wire rdr_brush_impulse;
wire x_step_rar;
wire x_reset_rar;
wire x_rdr_brush_impulse_delayed;
wire allow_cycle;

// 32.12.22.1
assign rdr_feed_command = (~rdr_0_1_bit_mod & rdr_read) | rdr_control
	| x_1400_comp_rdr_feed_commd;	// XXX this condition is from ald

// 32.12.42.1
latch1 u_rdr_interrupt_req(i_clk,
	((rdr_device_end | rdr_channel_end) & ~chan_reg_full) | rdr_queued,
	not_status_in_sample | rdr_adapter_reset,
	rdr_interrupt_req);

// 32.12.42.1
latch1 u_rdr_end(i_clk,
	rdr_feed_command & rdr_interrupt_req & rdr_channel_end &
	~rdr_status_reset & ~rd_complete,
	reset_rdr_commd_busy_lat | rd_complete,
	rdr_end);

// XXX read feed is a wire'd or with 3 drivers.
// 32.12.41.1
assign read_feed = read_feed_1 |
	x_1400_comp_read_feed |
	(rdr_feed_command & rdr_end);

// XXX also on page 63, slightly different
// 32.31.07.1
//latch1 u_rd_comp(i_clk,
//	i2_read_ser_cycle & col_80 & x_225_375 & ~block_rdr_feed &
//		gate_rd_complete_2540,
//	not_rdr_device_end_smp,
//	rd_complete);
/// XXX how does this compare to page 62
// 32.12.22.1
//latch1 u_rdr_device_end_2(i_clk,
//	rd_complete & rdr_busy & ~status_in_extended & rdr_feed_command,
//	rdr_status_reset,
//	rdr_device_end);

// 32.31.04.1
assign o_read_feed = read_feed & ~block_rdr_feed;

// 32.12.41.1
assign gated_read_feed = read_feed_1 & rdr_cl_lat_not_npro;

// 32.32.14.1
assign stacker_r2 = ~((~rdr_0_bit_mod & gated_read_feed & rdr_1_bit_mod)
	| stacker_r3);
// 32.32.14.1
assign stacker_r3 = (gated_read_feed & rdr_0_bit_mod & ~rdr_1_bit_mod);

// 32.12.03.1
latch1 u_rdr_1_bit_mod(i_clk,
	bus_out[6] & rdr_rdy_and_commd_valid & rdr_command_gate,
	reset_rdr_commd_mod_latch,
	rdr_1_bit_mod);
// 32.12.03.1
latch1 u_rdr_0_bit_mod(i_clk,
	rdr_command_gate & rdr_rdy_and_commd_valid & bus_out[7],
	reset_rdr_commd_mod_latch,
	rdr_0_bit_mod);
// 32.12.41.1
assign rdr_0_1_bit_mod = rdr_1_bit_mod & rdr_0_bit_mod;

// 32.12.42.1
latch1 u_reader_ready(i_clk,
	rdr_op_in & rdr_pch_status_in & i_service_out & ~rdr_interven_reqd,
	rdr_interven_reqd,
	rdr_ready_latch);

// read row counter.  6-bit double-shift register
// see page 8:
//	A	9	ABCDE	5	DEF	1
//	AB	8	ABCDEF	4	EF	10
//	ABC	7	BCDEF	3	F	11
//	ABCD	6	CDEF	2	-	12
reg [5:0] read_time_counter;
wire [11:0] read_encode;
wire [11:0] x_storage_in;
wire [11:0] x_storage_in_prt;
wire x_1400_comp_rdr_busy;

// 32.32.11.1
wire x_reader_scan_posedge;
ss2 #(1) u_rdr_scan_edge(i_clk, i_reset, rdr_brush_impulse,
	x_reader_scan_posedge);
docount1 u_read_time(i_clk,
	rdr_cl_lat_not_npro | mach_reset_rdr_pch,
	x_reader_scan_posedge,	// XXX fixme
	read_time_counter);

// XXX does read_encode need to latch?
// 32.20.41.1 - 32.20.44.1
assign read_encode = {12{rd_2_row_bit}} & {
	~rd_ctr_a & ~rd_ctr_f,	// T
	~rd_ctr_e & rd_ctr_f,	// E
	~rd_ctr_d & rd_ctr_e,	// 0
	~rd_ctr_c & rd_ctr_d,	// 1
	~rd_ctr_b & rd_ctr_c,	// 2
	~rd_ctr_a & rd_ctr_b,	// 3
	rd_ctr_a & rd_ctr_f,	// 4
	rd_ctr_e & ~rd_ctr_f,	// 5
	rd_ctr_d & ~rd_ctr_e,	// 6
	rd_ctr_c & ~rd_ctr_d,	// 7
	rd_ctr_b & ~rd_ctr_c,	// 8
	rd_ctr_a & ~rd_ctr_b };	// 9

/// XXX write has something different here on page 66
assign x_storage_in = read_encode |
	(data_reg_regen & {12{
		inhibit_375_000 & ~x_9_rd_ser_cycle
	}});
// XXX this next bit does not make sense.  buffer_blank_insert
//	is a print specific signal.  Also this is
//	not shown at all on ald.
assign x_storage_in_prt = {12{
x_300_450 & buffer_blank_insert |	// this line from page 66
1'b0
	}};

// XXX r0_075 was r0_000_150 but decade step pulse must be one cycle wide.
assign x_step_rar = ~block_rar_advance & select_rdr & r0_075;
assign x_reset_rar = reset_rar | mach_reset_rdr_pch;

// XXX logic for rdr_brush_delayed, reset_rar_1, delta_rd_ser_cy_req,
//	rd_ser_cy_req duplicated on page 65 (5041)

// XXX ild has "rdr_rdy_and_cmmd_valid" where ald has "rdr_command_stored".
// 32.12.21.1
latch1 u_busy_latch(i_clk,
	x_1400_comp_rdr_busy |
		rdr_channel_end & rdr_queued |
		rdr_command_stored & ~rdr_channel_request &
			~not_rdr_device_end_smp,
power_on_reset |	// XXX hack
	not_rdr_device_end_smp | reset_rdr_commd_busy_lat,
	rdr_busy);

wire xxx_hack_allow_cycle = (~pch_hack[1] | ~trigger_b);
/// XXX this is duplicated on page 66
/// XXX ald: shows ~trigger_d req'd for both cases.
// 32.31.11.1
wire x_set_allow_cycle = (select_rdr | select_pch) &
xxx_hack_allow_cycle &	// hack
~trigger_d;
latch1 u_allow_cycle(i_clk,
	x_set_allow_cycle,
	x_000_075 & ~x_set_allow_cycle,
	allow_cycle);

//////// page 66
//////// sld-14 punch commands (sheet 1)
//////// 4060

// - punch write commands -
//  [1]	set punch write during initial selection
//  [2]	set channel register full with service out
//	response to reader-punch service in (no
//	character yet in command register)
//  [3]	activate punch transfer cycle request
//	and set transfer cycle request trigger to
//	synchronize channel operation with the
//	reader-punch clock
//  [4]	set punch transfer cycle
//  [5]	the character is sent to the channel register,
//	translated, and gated into the buffer register
//  [6]	reset channel register full to inactivate
//	punch transfer cycle request and
//	initiate a reader-punch service in
//  [7]	serivce out respone to reader-punch
//	service in again sets channel register
//	full for the second character
//  [8]	in data interleave mode the normal polling
//	sequence transfers 1 or 2 byte bursts until
//	80th character or a command out repsonse
//	to reader-punch service in
//  [9]	in burst mode, transfers continue until
//	the 80th character or a command out
//	response to reader-punch service in
// [10]	set punch channel end and punch interrupt
//	request
// [11]	set punch end to initiate a punch feed cycle
// [12]	if less than characters have been
//	transferred, set punch insert blanks
// [13]	set punch buffer full when column 80 is reached
// [14]	punch scan cb is made before 12 time
// [15]	81 punch service cycles are taken out of the
//	buffer and into the data register where they are
//	compared, to set the punch magnet drivers
// [16]	set last address with position 80 to inactdivate punch
// [17]	at punch magnet impulse 12 time the punches are fired
// [18]	take punch scan with each digit time of the card
// [19]	take after nine (thirteenth) punch scan to complete
//	punch checking
// [20]	set punch complete and punch device end
// [21]	set punch interrupt request and punch adapter request

wire punch_command_stored;
wire [11:0] x_punch_xlate_out;
wire [11:0] data_reg_12_9_pullover;
wire [11:0] x_sense_amps_out;
wire [11:0] data_register;
wire not_pch_dvc_end_samp;
wire pch_chan_reg;
wire block_sa_output_ctl;
wire pch_xfer_cycle;
wire reset_data_reg;
wire x_150_300;
wire x_other_pch_busy;
wire pch_insert_blank;
wire buffer_blank_insert;
wire select_punch;

// 32.13.02.1
latch1 u_pch_write(i_clk,
	pch_command_gate & ~bus_out[1] & bus_out[0] &
		pch_rdy_and_cmmd_valid,		// match: xxxxxx01
	reset_pch_commd_mod_latch,
	pch_write);
assign punch_command_stored = pch_sense | pch_read | pch_write;

// XXX "pch chan reg" in ALD should be pch_channel_request;
//  omitting this causes pch_busy to be set too soon and returned at
//  initial selection.  this is bad.
// 32.13.21.1
latch1 u_pch_busy(i_clk,
	(punch_command_stored & ~pch_channel_request & ~not_pch_dvc_end_samp
	) |
	x_other_pch_busy,	// XXX unlabeled stub in ild
	x_reset_pch_busy,	// XXX what should this value be?
	pch_busy);

// also see pages 49,82
/// XXX also see x_channel_register_in, channel_register page 49
// XXX "original has "+chan reg full" feeding into a negated input;
//	but that makes no sense, why clear an empty register?
// 32.11.12.1-32.11.15.1
latch1 #(.W(8)) u_channel_reg(i_clk,
	x_channel_register_in,
	reset_chan_reg,
	channel_register);

// 32.20.74.1 - 32.20.78-1
ccc10 u_punch_xlate(i_clk, i_reset,
	channel_register,
	x_punch_xlate_out);
// col_bin_write is not show in ild, only in ald.
// 32.20.74.1 - 32.20.78-1
assign data_reg_12_9_pullover = x_punch_xlate_out &
	{12{buffer_entry}} |
	col_bin_write;		// XXX only in ald
// 32.20.80.1
// XXX buffer_entry logic not obvious in ild
//YYY assign x_pch_xfer_entry = ~(x_225_375 | pch_xfer_cycle)
//YYY	& buffer_entry;	/// XXX see similar logic page 63
//assign buffer_entry = x_225_375 & pch_xfer_cycle |
//	x_225_375 & x_ce_start_data_enter;
// but from ild, turns out there are two buffer_entry signals.
// the one with ce start latch or'd in is only sent to 32.20.02.1
// to make "data_strobe".
//assign buffer_entry = ~pch_2_bit_mod & x_225_375 & pch_trans_cycle;
assign buffer_entry = ~pch_2_bit_mod & x_150_375 & pch_trans_cycle;
wire buffer_entry_2;
assign buffer_entry_2 = buffer_entry |
	x_225_375 & x_ce_start_data_enter;

/// XXX u_allow_cycle is duplicated on page 65

// 32.20.02.1
assign reset_data_reg = x_075_150 /* YYY& allow_cycle*/;
// YYY "&allow_cycle" not in ald or ild

// kinda duplicated as "data reg" on page 64
// 32.20.31.1 32.20.35.1
//latch1 #(.W(12)) u_data_register(i_clk,
//	x_sense_amps_out,
//	reset_data_reg,
//	data_register);

// how does block_sa_output_ctl affect data_register ?
// ald has something slighlty different.
//assign block_sa_output_ctl = x_150_300 & (pch_insert_blank | pch_xfer_cycle);

/// XXX reader has something different here on page 65
// assign x_storage_in = data_register & ~{12{x_300_450 & buffer_blank_insert}};
/// XXX u_chan_reg also on pages 64
//32.11.16.1
//latch1 u_chan_reg_full_2(i_clk,
//	pch_write & pch_op_in & i_service_out & rdr_pch_service_in,
//	~rdr_pch_op_in | (pch_trans_cycle & x_225_300),
//	chan_reg_full);

// 32.13.33.1
assign pch_trans_cycle_req = pch_write & chan_reg_full & pch_op_in & ~pch_end;
wire rdr_ser_cy_req;
wire pch_status_inhibit;
wire pch_chan_end;
wire c_punch_feed;	// XXX o_ ?
wire diag_write;
wire reset_pch_commd_busy_lat;

/// rdr uses the same name xfer_cy_req on page 64,88
//latch1 u_xfer_cy_req_2(i_clk,
//	pch_trans_cycle_req & x_525_075,
//	~pch_trans_cycle_req & x_525_075,
//	xfer_cy_req);

// also see select_pch page 63
// also see page 88
// 32.33.17.1
// assign select_punch = (xfer_cy_req & pch_trans_cycle_req) |
//	(~xfer_cy_req & ~rdr_ser_cy_req & pch_ser_cy_req);

/// XXX also pch channel end, page 62
// 32.13.21.1
latch1 u_pch_chan_end(i_clk,
	pch_no_op |	// XXX not in ild
	x_pch_sense_service_in |
	(col_80 & x_225_300 & ~col_binary_1 & pch_trans_cycle) |
	(rdr_pch_service_in & i_command_out & pch_op_in),
pch_status_reset |	// XXX ald has this.
mach_reset_rdr_pch |
	pch_op_in & rdr_pch_status_in & i_service_out & ~pch_status_inhibit,
	pch_channel_end);

wire x_pch_interrupt_req_set =
	(pch_chan_end | pch_device_end) & ~chan_reg_full | pch_queued;

/// XXX pch_interrupt also on page 87
//	except pch_queued only shown there.
// XXX must be latch3.  latch2 has a 2 clock delay, which causes
//	interrupt_req to not be reset fast enough at trailing
//	edge of status_in, resulting in status_in being re-asserted.
// 32.13.42.1
latch3 u_pch_interrupt(i_clk,
	x_pch_interrupt_req_set
		& ~not_status_in_sample	// XXX hack
		,
	not_status_in_sample | pch_adapter_reset,
	pch_interrupt_req);

// 32.13.42.1
latch1 u_pch_end(i_clk,
	~pch_status_reset & pch_write & pch_chan_end &
		pch_interrupt_req &
		~pch_device_end,
	pch_device_end | reset_pch_commd_busy_lat,
	pch_end);

// XXX latch1 u_pch_trans_cy(,,,pch_trans_cycle) duplicated on pages 63,64,88

// 32.13.33.1
assign c_punch_feed = (pch_feed | (
		pch_end & pch_write & ~pch_bus_out_check &
		~pch_complete & ~diagnostic_write))
	& ~block_pch_feed;

/// XXX u_pch_trans_cy also on page 63,88
/// XXX gated_select_pch also on page 88
// assign gated_select_pch = select_punch & ~diag_write;

//////// page 67
//////// sld-15 punch commands (sheet 2)
//////// 4061

wire pch_cl_lat_not_npro;

// punch row counter.  6-bit double-shift register
// see page 10:
//	A	12	ABCDE	2	DEF	6
//	AB	11	ABCDEF	3	EF	7
//	ABC	10	BCDEF	4	F	8
//	ABCD	1	CDEF	5	-	9
wire [5:0] pch_time_counter;
wire pch_decode;
wire not_pch_device_end_smp;

// 32.33.11.1 32.33.12.1
wire x_punch_scan_posedge;
ss2 #(1) u_pch_scan_edge(i_clk, i_reset, punch_scan, x_punch_scan_posedge);
docount1 u_pch_time(i_clk,
	pch_cl_lat_not_npro | mach_reset_rdr_pch,
	x_punch_scan_posedge,	// "punch scan" leading edge
	pch_time_counter);

// 32.33.15.1 32.33.16.1
assign pch_decode =
	data_reg[11] & ~pch_ctr_b & pch_ctr_a |	// T
	data_reg[10] & ~pch_ctr_c & pch_ctr_b |	// E
	data_reg[9] & ~pch_ctr_d & pch_ctr_c |	// 0
	data_reg[8] & ~pch_ctr_e & pch_ctr_d |	// 1
	data_reg[7] & ~pch_ctr_f & pch_ctr_e |	// 2
	data_reg[6] & pch_ctr_f & pch_ctr_a |	// 3
	data_reg[5] & pch_ctr_b & ~pch_ctr_a |	// 4
	data_reg[4] & pch_ctr_c & ~pch_ctr_b |	// 5
	data_reg[3] & pch_ctr_d & ~pch_ctr_c |	// 6
	data_reg[2] & pch_ctr_e & ~pch_ctr_d |	// 7
	data_reg[1] & pch_ctr_f & ~pch_ctr_e |	// 8
	data_reg[0] & ~pch_ctr_f & ~pch_ctr_a;	// 9

// XXX duplicated on page 63
// 32.33.17.1
//latch1 u_pch_ser_cy(i_clk,
//	select_punch & ~xfer_cy_req & r0_000_150,
//	x_000_075,
//	pch_ser_cy);

// 32.31.05.1
assign after_9_pch_ser_cycle = pch_ser_cy & after_9_emitter;

/// XXX punch_complete is also on page 63
// 32.31.07.1
//latch1 u_punch_complete_2(i_clk,
//	after_9_pch_ser_cycle & x_450_525 & col_80,
//	pch_cl_lat_not_npro | not_pch_device_end_smp,
//	pch_complete);

/// XXX pch_device_end is also on page 62
// 32.13.22.1
wire x_pch_write_complete;
assign x_pch_write_complete = pch_complete & pch_write &
	~status_in_extended & pch_busy & ~after_9_emitter;
//latch1 u_punch_device_end(i_clk,
//	pch_complete & pch_write & ~status_in_extended & pch_busy &
//		~after_9_emitter,
//	pch_status_reset,
//	pch_device_end);
/// XXX pch_ser_cy_req also on page 88
/// XXX u_pch_buffer_full also on page 88
/// XXX u_pch_insert_blank also on page 88

//////// page 68
//////// sld-16 printer commands (sheet 1)
//////// 4080

//	- print write -
//  [1]	set print write gate during initial selection
//  [2]	set write gate trigger
//  [3]	character is put on bus and made available with service out response
//	to printer service in
//  [4]	activate printer adapter clock start ot set the lock run trigger
//  [5]	data on bus is sent through the print translator and set into the
//	print buffer data register
//  [6]	data is sent to buffer and buffer address register (bar) is advanced
//	to the next position
//  [7]	reset the clock run trigger
//  [8]	the fall of service out sets printer service in for the next character
//  [9]	in burst mode, transfers countinue until address 132 or a command out
//	response to printer service in
// [10]	in data interleave mode the normal polling sequene transfers 1 or 4
//	byte burst until address 132 or a command out response to printer
//	service in
// [11]	set printer channel end and printer interrupt request and reset print
//	write
// [12]	if less than 132 characters, insert blanks and reset buffer clock at
//	address 132
// [13]	activate last address to initiate a print operation
// [14]	set print gate latch and then reset write gate trigger
// [15]	pss gated with ss3 sets print trigger, resets print gate and sets
//	print scan
// [16]	start buffer clock, reset the buffer data register and advance the
//	buffer addrss register (bar)
// [17]	position 1 is read into printer buffer data register.  compared to
//	the pcg (or ucb) character and, on a "compare equal sample" fires
//	hammer 1.  (if no compare, hammer is not fired)
// [18]	character is transfered back to buffer
// [19]	buffer address register (bar) is advanced 3 positions and pcg (or ucb
//	address register) is advanced 2 positions
// [20]	sub scan continues for 44 cycles until address 130 (tens 13) sets clock
//	control to set up pcg (or ucb address register) for next sub scan
// [21]	two more sub scans (ss3 and ss3) occur similar to the above
// [22]	in the basic printer 47 more scans option all hammers to all
//	characters.  in the ucb, line full is set when all positions are
//	either printed or unprintable
// [23]	print scan 49 (or a ucb line full scan) complets any checks made
//	during printing
// [24]	reset print trigger
// [25]	reset bufer address register to zero
// [26]	carriage operaiton is performed is required.  (see carriage operations
//	on page 4082)
// [27]	carriage ending sets device end to initiate printer adapter request
//	and printer interrupt request

wire prt_control;
wire prt_write;
wire prt_command_gate_1;
wire prt_control_command_gate;
wire prt_write_command_gate;
wire allow_prt_command_gate_prst;
wire prt_adapter_reset;
wire prt_write_data_avail;
wire last_address_sampled_cf;
wire addr_132_smp;
wire stl_mode;
wire prt_status_inhibit;
wire clock_4_5;
//wire clock_4_0;
//wire clock_1_5;
wire last_address_clock_3_7;
//wire trigger_e_clock_4_0;
//wire trigger_b_clock_1_5;
wire x_1403_on_line;
wire end_load_format_ucb;
wire prt_adapter_clock_start;
wire write_gate;
wire single_cycle_mode_ce;
wire stor_scan_load_mode_c_e_1;
wire start_latch;
wire addr_carr_set_on_line;
wire prt_busy;
wire reset_write_gate;
wire print_gate;
wire x_not_clock_4_0_and_not_clock_1_5;
wire buffer_entry_on_line;
wire cfc_block_read_strobe_cf;
// wire x_clock_run_out;
//wire trigger_c_clock_2_6;
wire x_reset_prt_chan_end;
wire prt_ctrl_extended;
wire not_prt_device_end_smp;

// 33.13.11.1
latch1 u_print_control(i_clk,
	~bus_out[2] & bus_out[1] & bus_out[0] &	// +5 -6 -7
		any_bit_bus_out_0_thru_4 &		// match: MMMMM011
		prt_command_gate_1 &
		~(~prt_control_command_gate | ~allow_prt_command_gate_prst),
	reset_prt_command_latches,
	prt_control);

// XXX ald shows print_read_sense here too
// 33.13.11.1
assign prt_command_stored = prt_write | prt_ctl | print_read_sense;

// XXX ild shows 2 inputs here as 'sets',
//	but in ald those look like a clear.
// 33.13.51.1
latch1 u_prt_busy(i_clk,
	prt_queued & prt_channel_end |
		prt_ctrl_extended & ~prt_channel_request |
		~prt_channel_request & prt_command_stored & ~prt_adapter_reset,
	prt_adapter_reset & prt_command_stored |	// no, not sets.
	mach_reset_printer | not_prt_device_end_smp,
	prt_busy);

// XXX ild claims there's an inverter here; ald gates show it
//	being necesary to correct nor output (-y) to be +y
// 33.13.11.1
assign reset_prt_command_latches = prt_adapter_reset | prt_channel_end;

// 33.13.12.1
latch1 u_print_write(i_clk,
	~(~allow_prt_command_gate_prst
			| ~prt_write_command_gate) &	// +6 -7
		prt_command_gate_1 & ~bus_out[1]	// match: XXXXXX01
		& bus_out[0],
	reset_prt_command_latches,
	prt_write);

/// XXX how does this compare to page 62
// XXX ald is distinctly different
// 33.13.54.1
//latch1 u_prt_chan_end_2(i_clk,
//	(prt_write & ~(~last_address_sampled_cf | ~addr_132_smp)) |
//		(~stl_mode & prt_control) |
//		(i_command_out & prt_service_in),
//mach_reset_printer |	// XXX added
//	x_reset_prt_chan_end,
//	prt_channel_end);

// 33.13.51.1
assign x_reset_prt_chan_end = prt_status_in & ~prt_status_inhibit &
	i_service_out;

// XXX if prt_service_in and i_service_out are held
//	too long, then clock_4_5 can happen.  prt_write_data_avail
//	should only be set true on the leading edge of its set condition.
//	in fact, it should be delayed until x_service_out_delayed
//	goes true so that x_not_serv_out_smp is valid.
reg [1:0] x_prt_wavail_delayed;
always @(posedge i_clk) begin
if (i_reset)
	x_prt_wavail_delayed <= 0;
else case (x_prt_wavail_delayed)
0:
	x_prt_wavail_delayed[0] <= x_prt_set_write_avail;
1:
	x_prt_wavail_delayed[1] <= x_service_out_delayed;
default:
if (~i_service_out)	// paranoid value here would be ~x_service_out_delayed
	x_prt_wavail_delayed <= 0;
endcase
end
wire block_set_prt_wavail = prt_hack[2] & x_prt_wavail_delayed[0];

// 33.13.71.1
wire x_prt_set_write_avail =
	prt_write_ctrl &			// prt_write_ctrl named on 91
		i_service_out & prt_service_in;

// XXX u_prt_write_data_avail also on page 91 5081c3
// 33.13.71.1
latch1 u_prt_write_data_avail(i_clk,
	x_prt_set_write_avail & ~block_set_prt_wavail,
	clock_4_5 | ~prt_op_in,
	prt_write_data_avail);

// 33.13.71.1
assign prt_adapter_clock_start = prt_write_data_avail |
//	(~prt_write & ~last_address_clock_3_7 & x_1403_on_line &
//		~end_load_format_ucb & write_gate);
	prt_op_in & ~print_read_reg_full & print_read & ~prt_channel_end &
	(prt_adapter_request | sel_out_burst_sw_on & ~prt_channel_request);

/// clock_run here seems to be clk_run_tr on page 71 4083e2
// 33.33.41.1
trigger3 u_clock_run(.i_clk(i_clk),
	.i_set_gate2(~clock_run_tr),
	.i_ac_set2(x_home_single_start_set_online),	// page 71
	.i_set_gate(prt_adapter_clock_start
| (buffer_blank_insert & ~last_address_pr)	// YYY
	| x_set_clock_run			// XXX hack
),
	.i_ac_set(osc_pulse),
	.i_dc_set(1'b1),
	.i_dc_reset(~mach_reset_printer),	// XXX guess
	.i_ac_reset2(1'b0),
	.i_reset_gate2(1'b0),
	.i_ac_reset(~trigger_c_clock_2_6),
	.i_reset_gate(clock_run_tr),
	.o_out(clock_run_tr));

// XXX write_gate also on page 71 as "wr gate"
// 33.33.03.1
wire x_write_gate_dcset = x_addr_start_ss_cont_errstop | x_prt_busy_write;
// XXX dc_set and reset are both low at start of write
//	because prt_write is asserted before prt_busy
// 33.33.03.1
trigger2 u_write_gate(.i_clk(i_clk),
	.i_set_gate(~write_gate),
	.i_ac_set(single_cycle_mode_ce &
		stor_scan_load_mode_c_e_1 &
		start_latch & ~addr_carr_set_on_line),
	.i_dc_set( ~x_write_gate_dcset
//		| reset_write_gate		// XXX hack avoid osc state.
		),
	.i_dc_reset(~reset_write_gate
		| x_write_gate_dcset		// XXX hack avoid osc state.
		),
	.i_ac_reset(~trigger_e_clock_4_0),
	.i_reset_gate(gate_write_tr_off),	// XXX not detailed in ild
	.o_out(write_gate));

assign x_not_clock_4_0_and_not_clock_1_5 = ~(~trigger_e_clock_4_0 &
	trigger_b_clock_1_5);
// 33.33.44.1
assign buffer_entry_on_line = write_gate & prt_write &
	x_not_clock_4_0_and_not_clock_1_5;
// 33.33.44.1
assign buffer_blank_insert = cfc_block_read_strobe_cf |
	(write_gate & ~prt_write & x_1403_on_line &
		x_not_clock_4_0_and_not_clock_1_5);

//////// page 69
//////// sld-17 printer commands (sheet 2)
//////// 4081

wire [5:0] x_print_translate_out;
wire x_print_translate_space;
wire x_print_translate_unassigned;
wire x_set_clock_run;
wire clock_6_0;
wire reset_print_gate;
wire read_scan_cfc;
wire single_cycle_print;
wire [6:0] print_buffer_data_reg;
wire block_print_compare_ucb;
wire clock_4_6;
wire print_compare;
wire comp_equal_sample;
wire unprintable_character;
wire home_gate_jumper;
wire scan_load_pullover_cfc;
wire print_scan_45;
wire diagnostic_print_write;
wire forms_side_cf;
wire not_print_scan_or_not_read_scan_cf;
wire clk_ctrl_tr_ce;
wire tens_address_13;

// 33.33.26.1 - 33.33.27.1
e2bcd3 u_print_translate(i_clk, i_reset,
	bus_out,
	x_print_translate_out,
	x_print_translate_space,
	x_print_translate_unassigned);

wire [6:0] x_print_buffer_data_reg_out;
// 33.23.05.1 - 33.23.08.1
latch1 #(.W(7)) u_print_buffer_data_reg(i_clk,
	x_sense_out,
	clock_0_2,
	x_print_buffer_data_reg_out);
assign print_buffer_data_reg = x_print_xlate | x_print_buffer_data_reg_out;

// 33.33.41.1
assign x_set_clock_run = (print_scan | clk_ctrl_tr | read_scan_cfc) &
	~single_cycle_print;

// XXX also see page 69
//latch1 u_clock_run(i_clk,
//	x_set_clock_run,
//	~trigger_c_clock_2_6 & x_clock_run_out,
//	x_clock_run_out);

// 33.33.45.1
// ??? 33.33.46.1
assign print_compare = (pcg == print_buffer_data_reg[5:0]) & print_tr;

// 33.33.46.1
assign comp_equal_sample = (~print_line_complete_tr &
	( (print_scan & clock_4_6 & ~print_scan_49) & ~block_print_compare_ucb)
	& print_compare) & ~unprintable_character;

// 33.33.22.1
trigger2 u_tr_1(.i_clk(i_clk),
	.i_set_gate(1'b1),
	.i_ac_set(~print_scan | ~print_read_scan_cf),
	.i_dc_set(1'b1),
	.i_dc_reset(~mach_reset_out),	// XXX hack
	.i_ac_reset(~trigger_e_clock_4_0),
	.i_reset_gate(tr_1),
	.o_out(tr_1));

// 33.33.22.1
trigger2 u_tr_2(.i_clk(i_clk),
	.i_set_gate(~tr_2),
	.i_ac_set(~tr_1),
	.i_dc_set(1'b1),
	.i_dc_reset(~mach_reset_out),	// XXX hack
	.i_ac_reset(~trigger_e_clock_4_0),
	.i_reset_gate(~tr_1),
	.o_out(tr_2));

// more detail on 4083
// 33.33.02.1
//latch1 u_print_gate(i_clk,
//	last_address_pr & write_gate & clock_6_0,
//	gated_pss & print_tr | reset_print_gate,
//	print_gate);

// more detail on 4083
// 33.33.02.1
//latch1 u_print_tr(i_clk,
//	print_gate & home_gate_jumper & ~( stor_scan_load_mode_c_e_1 |
//			scan_load_pullover_cfc ) & ~write_gate & ss_3 &
//			~(carriage_settling & ~diagnostic_print_write) &
//		& gated_pss,
//	~train_ready |
//		trigger_e_clock_4_0 & (print_scan_45 & ss_3 & tr_2 |
//		tr_2 & ss_3 & diagnostic_print_write & forms_side_cf),
//	print_tr);

assign not_print_scan_or_not_read_scan_cf = ~print_read_scan_cf | ~print_scan;

// XXX ild shows not_print_scan_or_not_read_scan_cf as set-gatenable;
//  this is not shown (at least not on 33.33.03.1).  Neither shows an ac_set,
//  so not clear this matters...
// 33.33.03.1
trigger2 u_print_scan(.i_clk(i_clk),
	.i_set_gate(~print_scan),
	.i_ac_set(1'b0),
	.i_dc_set(~print_sub_scan_start),
	.i_dc_reset(print_tr),
	.i_ac_reset(~trigger_e_clock_4_0),
	.i_reset_gate(clk_ctrl_tr),
	.o_out(print_scan));

// 33.33.22.1
trigger2 u_clock_ctr(.i_clk(i_clk),
	.i_set_gate(~clk_ctrl_tr),
	.i_ac_set(tens_address_13 &
		~not_print_scan_or_not_read_scan_cf & clock_4_5),
	.i_dc_set(1'b1),
	.i_dc_reset(1'b1),
	.i_ac_reset(clock_4_5),
	.i_reset_gate(tr_2),
	.o_out(clk_ctrl_tr));


assign clk_ctrl_tr_ce = clk_ctrl_tr;

//////// page 70
//////// sld-18 carriage operations
//////// 4082

//	- printer control command -
//  [1]	during initial selection the print control latch is set
//  [2]	set designated carriage register(s)
//  [3]	set immediate go and carriage go ss
//  [4]	if this is a write command, print scan 46 (or 48) will set
//	carriage go ss
//  [5]	if this is a skip command, set carriage drive trigger to
//	activate high speed start and low speed start
//  [6]	slow brush compare with carriage control register activate
//	high speed stop and slow speed
//  [7]	if this is a space command, space 1, space 2, or space 3
//	single shot activates low speed start
//  [8]	compare skip equal activates carriage ending and resets
//	carriage drive trigger
//  [9]	low speed stop is activated to initiate carriage settling
// [10]	with print complete set, printer device end is set
// [11]	set printer interrupt request and printer adapter request

wire carr_set_immed_ce;
wire mach_reset_printer;
wire carriage_ending;
wire carr_set_sample;
wire immed_go_lat;
wire x_print_stl_go_low_speed_go;
wire low_speed_go_delayed;
wire carr_ctrl_reg_sample;
wire print_tr;
wire stl_go_ss;
wire comp_skip_eq_forms_check;
wire gate_carr_ctrl_reg_ucb;
wire gate_carr_ctrl_reg;
wire skip_ctrl;
wire x_mach_reset_printer_or_carriage_ending;
wire [2:0] x_carriage_reg;
wire x_carriage_reg_1;
wire [3:0] carr_ctrl_reg;
wire carriage_go_ss;
wire restore_lat;
wire space_ctrl;
wire compare_skip_equal;
wire carriage_settling;
wire after_space_ctrl;
wire space_latch;
wire forms_check_latch;
wire prt_command_stored;
wire print_complete;
wire prt_status_sel_reset;
wire space_3ss;
wire space_2ss;
wire space_1ss;
wire x_space_nss_delayed;
wire low_speed_start;
wire low_speed_stop;
wire low_speed_go;
wire carriage_dr;
wire off_line_space;
wire [11:0] stop_brushes;	// input?
wire mag_emitter;		// input?
wire [3:0] stop_brush_encode;
wire x_stop_brush_encode_match;
wire single_space_ss;
wire carr_brush_reg_set;
wire lo_speed_go;
wire [3:0] carr_brush_reg;
wire x_comp_skip_eq_set;
wire [11:0] slow_brushes;	// input?
wire [3:0] slow_brush_encode;
wire slow_speed;
wire slow_speed_latch;
wire restore_latch;
wire high_speed_start_ce;
wire high_speed_start;
wire high_speed_stop_ce;
wire high_speed_stop;
wire forms_check_or_carr_stop;
wire x_not_forms_check_or_carr_stop_delayed;
wire carr_brush_reg_reset;
wire carr_brush_reg_reset_ss;
wire x_carriage_ending;
wire paper_damper_mag_drive;
wire x_paper_estimate;

// XXX also on page 72
// 33.32.13.1
latch1 u_immediate(i_clk,
	prt_control & prt_command_gate_1 & ~stl_mode |
	~stl_mode & carr_set_immed_ce & carr_set_sample,
	mach_reset_printer | carriage_ending,
	immed_go_lat);

// 33.32.06.1
wire prt_busy_offline = prt_busy_off_line;	// XXX name from ald
// 33.32.06.1
wire x_skip_done_or_not_ready = ~x_1403_on_line & ~print_ready |
		compare_skip_equal & x_1403_on_line;
// XXX set_carr_go_ss is shown on page 72 slightly differently
// XXX "or line_full" --- ald wire-or's this and line_full_ucb
// 33.32.06.1
assign set_carr_go_ss =					// XXX name from ald
	(( (( ~x_skip_done_or_not_ready & immed_go_lat & ~carriage_settling)
				| x_after_space_ctrl_or_line_full) &
			prt_busy_offline) |
		restore_lat | space_latch);
// 33.32.06.1
ss2 #(TIMEOUT_2800ns) u_carriage_go(i_clk, i_reset,
	set_carr_go_ss & ~forms_check_latch & ~stl_mode,
	carriage_go_ss);

// duplicated on page 72
// 33.32.12.1
wire x_print_stl_go_low_speed_go_n;
ss2 #(TIMEOUT_1300ns) u_carr1(i_clk, i_reset,
	~(print_tr | stl_go_ss | low_speed_go_delayed),
	x_print_stl_go_low_speed_go_n);
assign x_print_stl_go_low_speed_go = ~x_print_stl_go_low_speed_go_n;

// duplicated with additions on on page 72
// 33.32.12.1
assign x_carriage_ending =
	(immed_go_lat & prt_busy & comp_skip_eq_forms_check &
			~low_speed_go_delayed |
		~x_print_stl_go_low_speed_go)
	& x_1403_on_line;

// XXX ild does not separate or name this term
// 33.32.06.1
wire carr_ctrl_reg_stl_sample = clock_2_4 & bus_out_odd_parity & prt_control;

// 33.32.06.1
assign carr_ctrl_reg_sample =
	(~(stl_mode & ~gate_carr_ctrl_reg_ucb) & prt_command_gate_1 |
		carr_ctrl_reg_stl_sample)
	& gate_carr_ctrl_reg;	// XXX ald doesn't show this last term.

// XXX 2821 ild shows this as a nor?
// 33.32.10.1
assign x_mach_reset_printer_or_carriage_ending =
	mach_reset_printer | carriage_ending;

// carriage control register

// 33.32.10.1
latch1 u_skip_space(i_clk,
	bus_out[7] & carr_ctrl_reg_sample |
		carriage_go_ss & restore_lat,
	mach_reset_printer | carriage_ending,
	skip_ctrl);
assign space_ctrl = ~skip_ctrl;

// 33.32.10.1
latch1 #(.W(3)) u_carriage_reg(i_clk,
	bus_out[6:4] & {3{carr_ctrl_reg_sample}} |
		data_enter_ce[6:4] & {3{carr_set_sample}},
	x_mach_reset_printer_or_carriage_ending,
	x_carriage_reg);

// 33.32.10.1
latch1 u_carriage_reg_1(i_clk,
	data_enter_ce[3] & carr_set_sample |
		carriage_go_ss & restore_lat |
		bus_out[3] & carr_ctrl_reg_sample,
	x_mach_reset_printer_or_carriage_ending,
	x_carriage_reg_1);

// 33.32.02.1
assign carr_ctrl_reg = {x_carriage_reg, x_carriage_reg_1};

// 33.32.04.1
dodecode3 u_stop_decode(stop_brushes, stop_brush_encode,
	x_stop_brush_encode_match);

wire x_mag_emitter_delayed;
assign lo_speed_go = low_speed_go_delayed;	// XXX from ald
delay1 #(1) u_mag_emitter_delay(i_clk, mach_reset_out, mag_emitter,
	x_mag_emitter_delayed);		// ald: double inverter
assign carr_brush_reg_set = x_mag_emitter_delayed & lo_speed_go |
	single_space_ss;

// XXX carr_brush_reg_reset looks almost like it could be a wire'd or
// connection - but with what?
// 33.32.12.1
ss2 #(TIMEOUT_2000ns) u_carr_brush_reg_set_reset(i_clk, i_reset,
	~carr_brush_reg_set,
	carr_brush_reg_reset);

// 33.32.05.1
latch1 #(.W(4)) u_carr_brush_reg(i_clk,
	stop_brush_encode & {4{carr_brush_reg_set}},
	carr_brush_reg_reset | prt_write,
	carr_brush_reg);

// XXX incomplete - much more complete version in ald
// 33.33.03.1
// latch1 u_print_complete(i_clk,
//	carriage_ending,
//	1'b0,
//	print_complete);

// XXX how does this compare to page 62
// XXX actual definition in ald quite different.
// 33.13.54.1
//latch1 u_prt_device_end_2(i_clk,
//	~status_in_extended & ~prt_command_stored & prt_busy & print_complete,
//	prt_status_sel_reset,
//	prt_device_end);

// 33.32.17.1
assign paper_damper_mag_drive = print_tr & ~stl_mode & ~low_speed_go;

// 33.32.14.1
ss2 #(TIMEOUT_13800us) u_ss3(i_clk, i_reset,
	carr_ctrl_reg[1] & carr_ctrl_reg[0] &	// -1 -2
		carriage_go_ss & space_ctrl,
	space_3ss);

// 33.32.14.1
ss2 #(TIMEOUT_9800us) u_ss2(i_clk, i_reset,
	carr_ctrl_reg[1] & ~carr_ctrl_reg[0] &	// +1 -2
		carriage_go_ss & space_ctrl,
	space_2ss);

wire xxx_ss1_term =
	~(carr_ctrl_reg[3] | carr_ctrl_reg[2] |	// +1 +2 +4 +8
		carr_ctrl_reg[1] | carr_ctrl_reg[0] |
		space_latch | off_line_space);

// XXX ald and ild both show +1 -- but that matches op=00000 001.
// Component description and other sources say skip space 1
// should be op=00001 001.
// XXX ild doesn't make the negation of the "or" term obvious.
// 33.32.14.1
ss2 #(TIMEOUT_5500us) u_ss1(i_clk, i_reset,
	~(carr_ctrl_reg[3] | carr_ctrl_reg[2] |	// +1 +2 +4 +8
		carr_ctrl_reg[1] |
1'b1^	// YYY
carr_ctrl_reg[0] |
		space_latch | off_line_space) &
		carriage_go_ss & ~mach_reset_printer,
	space_1ss);

// 33.32.17.1
delay2 #(DELAY_3ms) u_space_nss_delayed(i_clk, i_reset,
	space_3ss | space_2ss,
	x_space_nss_delayed);

// 33.32.17.1
assign low_speed_stop = ~(space_3ss | space_2ss | space_1ss | carriage_dr);
assign low_speed_go = ~low_speed_stop;
assign low_speed_go_delayed = low_speed_go | x_space_nss_delayed;
// 33.32.17.1
ss2 #(TIMEOUT_5500us) u_carr_settle(i_clk, i_reset,
	~low_speed_go, carriage_settling);

// 33.32.15.1 33.32.16.1
assign slow_speed = |{slow_brush_latches & (12'b1<<(12-carr_ctrl_reg))};

// 33.32.16.1
rlim4 #(.TS(PAPER_TS)) u_paper_estimator(.i_clk(i_clk),
	.i_reset(mach_reset_out),
	.i_ls1(high_speed_start), .i_ls2(low_speed_stop),
	.i_hs(high_speed_stop), .i_stopped(low_speed_start),
	.o_out(x_paper_estimate));

// 33.32.16.1
latch1 u_slow_speed_latch(i_clk,
	x_paper_estimate | slow_speed,
	~carriage_dr,
	slow_speed_latch);

// 33.32.17.1
assign high_speed_start_ce = ~slow_speed_latch & ~forms_check_latch &
	~restore_latch & carriage_dr;
// 33.32.17.1
assign high_speed_start = high_speed_start_ce;
// 33.32.17.1
assign high_speed_stop_ce = ~high_speed_start;
// 33.32.17.1
assign high_speed_stop = high_speed_stop_ce;

// 33.32.11.1
delay2 #(DELAY_9ms) u_forms_check(i_clk, i_reset,
	forms_check_or_carr_stop,
	x_not_forms_check_or_carr_stop_delayed);

// 33.32.11.1
trigger2 u_carr_drive(.i_clk(i_clk),
	.i_set_gate(~space_ctrl),
	.i_ac_set(~carriage_go_ss),
	.i_dc_set(1'b1),
	.i_dc_reset(mach_reset_printer |
		x_not_forms_check_or_carr_stop_delayed | compare_skip_equal),
	.i_ac_reset(1'b0),
	.i_reset_gate(1'b0),
	.o_out(carriage_dr));

// XXX I think these are the same thing?
// 33.32.12.1
assign carr_brush_reg_reset_ss = carr_brush_reg_reset;

// 33.32.11.1
latch1 u_comp_skip_eq(i_clk,
	~(prt_control & ~((carr_brush_reg == carr_ctrl_reg) & ~space_ctrl & ~carr_brush_reg_reset_ss)),
	carriage_settling | prt_control | prt_write |
		mach_reset_printer | carriage_go_ss,
	compare_skip_equal);

// 33.32.11.1
assign comp_skip_eq_forms_check = compare_skip_equal | forms_check_latch;

// XXX carriage_settling: + and - cases may not be exactly inverted,
//	+ case may have 43.32.01.1 carriage settling or'd in.
// printer inputs?
//	stop_brushes
//	slow_brushes
//	mag_emitter
// printer outputs (DM):
//	paper_damper_mag_drive
//	low_speed_start
//	low_speed_stop
//	high_speed_stop
//	high_speed_start

//////// page 71
//////// sld-19 i/o tester operations - printer
//////// 4083

wire ce_start_key_sw;
wire not_ce_start_key_sw;
wire pss_ctrl_latch;
wire ce_home_ctrl;
wire x_home_single_start_set_online;
wire x_cont_set_online_start_load_errstop;
wire ce_data_enter_sw;
wire continuous_mode;
wire clock_run_tr;
wire end_load_format;
wire x_single_scan_cct;
wire x_ldformat_wg_pw_la37_online;
wire x_start_clock;
wire ce_drum_pulse;
wire x_set_wrgate;
wire x_bsy_w_scan_pg_gw;
wire x_bsy_w_startl_online_cont_erstop;
wire gate_write_tr_off_ucb;
wire x_drum_pulse;
wire sense_amp_1, sense_amp_2;
wire x_drum_sense_delayed;
wire x_clear_pss_trig;
wire ucb_home_gate_ucb;
wire io_check_reset_pr;
wire sync_check;
wire pss_trig_jumper;
wire p0_stor_scan_ld_md_ucb;
wire x_stor_scan_load_mode;
wire osc_ctrl_gate_on;
wire data_entry_drive_ce;
wire carr_set_sw;
wire x_drumpulse_scan46;
wire x_start_trrdy_singlec;
wire mechanical_inlk;
wire x_1403_chain_inlk;
wire reset_train_ready_ucb;
wire diagnostic_write_reset;
wire x_pss_trig_jumper;

// 33.33.02.1
latch1 u_ce_start_latch(i_clk,
	ce_start_key_sw,
	mach_reset_printer | not_ce_start_key_sw,
	ce_start_latch);

// 33.33.02.1
latch1 u_pss_ctrl_latch(i_clk,
	mach_reset_printer | tr_2 & clock_6_0 & single_cycle_print |
		~single_cycle_print,
	single_cycle_print & tr_2,
	pss_ctrl_latch);

// 33.33.00.1
latch1 u_ce_home_ctrl_latch(i_clk,
	mach_reset_printer & single_cycle_print | ~single_cycle_print,
	train_ready & ~start_latch,
	ce_home_ctrl);

// 33.33.41.1
assign x_home_single_start_set_online = ~ce_home_ctrl & single_cycle_mode &
	start_latch & ~addr_carr_set_on_line;

// 33.33.41.1
assign single_cycle_data_enter = ce_data_enter_sw & ~continuous_mode;

// 33.33.41.1
assign x_cont_set_online_start_load_errstop = continuous_mode &
	~addr_carr_set_on_line & start_latch & stor_scan_load_mode_c_e_1 &
	~error_stop;

// 33.33.41.1
assign x_ldformat_wg_pw_la37_online = ~end_load_format & write_gate &
	~prt_write & ~last_address_clock_3_7 & x_1403_on_line;

// 33.33.41.1
assign x_single_scan_cct = ~single_cycle_print & (print_scan | clk_ctrl_tr);

assign x_start_clock = x_cont_set_online_start_load_errstop |
	x_ldformat_wg_pw_la37_online | x_single_scan_cct |
	| prt_adapter_clock_start;

// XXX clk_run_tr here seems to be clock_run on page 69

// 33.33.01.1
assign start_latch = ~(~(ce_start_latch | print_start_latch)
	& ~low_speed_stop);
// ??? from ald?: assign start_latch = ~(low_speed_stop & (ce_start_latch | ~print_start_latch));

// 33.33.02.1
assign ce_drum_pulse = start_latch & ~ce_home_ctrl & pss_ctrl_latch;

// 33.33.03.1
assign single_cycle_print = print_carr_mode_ce & single_cycle_mode;

// 33.33.03.1
assign continuous_mode = ~single_cycle_mode;

// XXX ild calls input "(1403) chan inlk"; ald has "chain inlk"
// 33.33.00.1
assign mechanical_inlk = (single_cycle_print | x_1403_chain_inlk);

// 33.33.03.1
assign x_set_wrgate = single_cycle_mode & stor_scan_load_mode_c_e_1 &
	~addr_carr_set_on_line & start_latch;

// 33.33.03.1
assign x_bsy_w_startl_online_cont_erstop = prt_busy & prt_write |
	start_latch & ~addr_carr_set_on_line & stor_scan_load_mode_c_e_1 &
		continuous_mode & ~error_stop;

// 33.33.03.1
assign x_bsy_w_scan_pg_gw = ~x_bsy_w_startl_online_cont_erstop &
		stor_scan_load_mode_c_e_1 |
	print_gate | gate_write_tr_off_ucb;

// XXX wr_gate also on page 68 as 'write gate"
// 33.33.03.1
//latch1 u_wr_gate(i_clk,
//	~write_gate & x_set_wrgate | x_bsy_w_startl_online_cont_erstop,
//	reset_write_gate | ~trigger_e_clock_4_0 & x_bsy_w_scan_pg_gw,
//	write_gate);

// XXX ild shows this as using "-ss 3" (into -a gate input),
// but on page 21 TC-9 seems this needs the negative sense.
// XXX And --- I think this should only cleared on ss_1, not ss_2...
// 33.33.21.1
assign set_bar_to_000 = ~write_gate & gated_pss_1 & ss_1 &
	~stor_scan_load_mode_c_e_1 & (print_tr | print_gate) |
	prt_command_gate_1;

// 33.33.21.1
assign block_bar_adv = set_bar_to_000 | print_gate | tr_2;

// drum pulse logic / pss trigger train, in much less detail, on page 93.
// 2a 4a
// 33.33.00.1
delay2 #(DELAY_15us) u_drum_sense(i_clk, i_reset,
	(sense_amp_1 & ~sense_amp_2),
	x_drum_sense_delayed);

// 33.33.00.1
assign x_drum_pulse = (x_drum_sense_delayed & ~(print_scan & ~pss_trig_ss)) &
	~single_cycle_print;

// 33.33.00.1
assign drum_pulse = x_drum_pulse | ce_drum_pulse;

// 33.33.00.1
assign x_clear_pss_trig = ~mechanical_inlk | mach_reset_printer |
	diagnostic_write_reset | reset_train_ready_ucb;

// 33.33.00.1
assign x_drumpulse_scan46 = ~drum_pulse & ~single_cycle_print |
	clock_4_6 & print_scan;

// 33.33.00.1
trigger2 u_pss_trig(.i_clk(i_clk),
	.i_set_gate(pss_trig_ss),
	.i_ac_set(drum_pulse),
	.i_dc_set(1'b1),
	.i_dc_reset(~x_clear_pss_trig),
	.i_ac_reset(x_drumpulse_scan46),
	.i_reset_gate(pss_trig),
	.o_out(pss_trig));

// 5b
// 33.33.00.1
ss2 #(.N(TIMEOUT_PSS), .NE(1)) u_pss_ss(i_clk, i_reset,
	pss_trig,
	pss_trig_ss);

// 33.33.00.1
assign x_start_trrdy_singlec = ~(start_latch & ~train_ready &
	single_cycle_print);

// 33.33.00.1
trigger2 u_home_gate(.i_clk(i_clk),
	.i_set_gate(~pss_trig_ss),
	.i_ac_set(drum_pulse),
	.i_dc_set(x_start_trrdy_singlec),
	.i_dc_reset(~mach_reset_printer),
	.i_ac_reset(~pss_trig),
	.i_reset_gate(home_gate),
	.o_out(home_gate));

// 33.33.00.1
wire x_train_ready_gate = single_cycle_print | home_gate & ~pss_trig_ss;
// 33.33.00.1
trigger3 u_train_ready(.i_clk(i_clk),
	.i_set_gate(x_train_ready_gate),
	.i_ac_set(home_gate),
	.i_dc_set(1'b1),
	.i_dc_reset(~x_clear_pss_trig),
	.i_ac_reset(io_check_reset_pr),
	.i_reset_gate(sync_check),
	.i_ac_set2(1'b0),
	.i_set_gate2(1'b0),
	.i_ac_reset2(pss_trig_jumper),
	.i_reset_gate2(sync_check),
	.o_out(train_ready));

// Note 2 on ald makes it clear that pss_trig_jumper can be
// jumpered to pin "n" on the same module, which is pss_trig.
// 33.33.00.1
assign x_pss_trig_jumper = pss_trig_jumper_enabled & pss_trig;

// 33.33.00.1
assign gated_pss = pss_trig & train_ready & ~clk_ctrl_tr & ~tr_2;

// 33.33.02.1
assign osc_ctrl_gate_on = print_gate & ~x_stor_scan_load_mode;

// XXX ild shows gated_pss & print_tr - ald shows that being shared
//	as print_sub_scan_start
// 33.33.02.1
latch1 u_print_gate(i_clk,
	~stl_go_ss & ~immed_go_lat & ~low_speed_go &
			print_carr_mode_ce & print_ready & ~print_tr |
		last_address_pr & write_gate & clock_6_0,
	print_sub_scan_start | reset_print_gate |
		clock_4_6 & stor_scan_load_mode_c_e_1,
	print_gate);

assign x_stor_scan_load_mode = ( stor_scan_load_mode_c_e |
		p0_stor_scan_ld_md_ucb );

// 33.05.01.0 33.33.02.1
assign stor_scan_load_mode_c_e_1 = x_stor_scan_load_mode;

// 33.33.02.1
assign data_entry_drive_ce = stor_scan_load_mode_c_e_1 | carr_set_sw;

// 33.33.02.1
wire x_print_tr_gate = print_gate & home_gate_jumper &
			~stor_scan_load_mode_c_e_1 &
			~write_gate & ss_3 &
			~(carriage_settling & ~diagnostic_print_write) &
		1'b1;
// 33.33.02.1
trigger2 u_print_trig(.i_clk(i_clk),
	.i_set_gate(x_print_tr_gate),
	.i_ac_set(gated_pss),
	.i_dc_set(1'b1),
	.i_dc_reset(train_ready),
	.i_ac_reset(~trigger_e_clock_4_0),
	.i_reset_gate(tr_2 & ss_3 & line_full |
		tr_2 & ss_3 & diagnostic_print_write),
	.o_out(print_tr));

//////// page 72
//////// sld-20 i/o tester operations - printer
//////// 4084

wire print_line_complete_inh;
wire address_set_drive_ce;
wire x_ce_addr_set_ctrl_out;
wire prt_busy_off_line;
//wire x_skip_1;
wire x_after_space_ctrl_or_line_full;
//wire x_skip_3;
//wire x_skip_4;
wire after_space_ctrl_nucb;
wire x_go_space_or_restore;
wire ce_carr_reset;
wire x_print_ready_not_busy;
wire set_carr_go_ss;
wire restore_key_latch;
wire space_key_latch;
wire print_ready_ind_ce;
wire x_ce_carr_set_ctrl_out;
wire carriage_set_sw_ce;
wire err_stop_sw_c_e;
wire ce_error_stop_sw_ce;
wire parity_hammer_check;
wire ucb_parity_check_lt_ucb;
wire hammer_check_latch_ce;
wire c_e_error_reset_ce;
wire check_reset_prt;
wire reset_ham_ck_and_pty_ck;

// 33.23.11.1
assign print_scan_print_read = print_scan | print_read;
// 33.23.11.1
assign print_line_complete_inh = x_more_plc_terms &	// XXX ald has more...
	print_scan_print_read &
	print_line_complete_tr &
	~(~x_1403_on_line & line_full);

// immed_go_lat duplicated on page 70

// 33.23.03.1
assign address_set_drive_ce = ~(start_latch & ~x_1403_on_line &
	address_set_sw_c_e & x_ce_addr_set_ctrl_out);

// 33.23.03.1
latch1 u_ce_addr_set_ctrl(i_clk,
	address_set_sw_c_e & start_latch,
	mach_reset_printer | start_latch & ~address_set_sw_c_e,
	x_ce_addr_set_ctrl_out);

// 33.23.03.1
assign c_e_address_reset = ~x_1403_on_line & address_set_sw_c_e &
	~x_ce_addr_set_ctrl_out;

// 33.23.03.1
assign addr_carr_set_on_line = address_set_sw_c_e | carr_set_sw |
	x_1403_on_line;

// x_1403_on_line duplicated on page 90

// "prt adapt reset latch" duplicated as "prt adapter reset" on page 90

// 33.32.06.1
assign prt_busy_off_line = prt_busy | ~x_1403_on_line;

// 33.32.06.1
//assign x_skip_1 = x_1403_on_line & compare_skip_equal |
//	~print_ready & ~x_1403_on_line;

assign x_after_space_ctrl_or_line_full = after_space_ctrl_nucb /* | line_full_ucb */;

// 33.32.06.1
assign off_line_space = ~x_after_space_ctrl_or_line_full & ~x_1403_on_line;

// 33.32.06.1
//assign x_skip_3 = ~x_skip_1 & immed_go_lat & ~carriage_settling | x_after_space_ctrl_or_line_full;

// 33.32.06.1
//assign x_skip_4 = prt_busy_off_line & x_skip_3;

// 33.32.12.1
assign x_print_ready_not_busy = ~prt_busy_off_line & ~prt_ctrl_extended &
	print_ready & ~stl_mode;

// 33.32.12.1
assign x_go_space_or_restore = ~low_speed_go & ~x_1403_on_line &
	(restore_lat | space_latch);

// duplicated without additions on page 70
// 33.32.12.1
assign carriage_ending = x_carriage_ending |
	x_print_ready_not_busy |
	ce_carr_reset |
	x_go_space_or_restore;

// XXX shown on page 70
// 33.32.06.1
//assign set_carr_go_ss = x_skip_4 | restore_lat | space_latch;

// 33.32.13.1
assign restore_lat = restore_key_latch & ~forms_check_latch &
	~stl_mode & ~print_ready_ind_ce;

// 33.32.13.1
assign space_latch = ~stl_mode & ~print_ready_ind_ce &
	space_key_latch;

// 33.32.04.1
latch1 u_ce_carr_set_ctrl(i_clk,
	space_latch & ~carriage_set_sw_ce,
	space_latch & carriage_set_sw_ce | mach_reset_printer,
	x_ce_carr_set_ctrl_out);

// 33.32.04.1
assign ce_carr_reset = ~x_ce_carr_set_ctrl_out & carriage_set_sw_ce &
	~x_1403_on_line;

// 33.32.04.1
assign carr_set_sample = space_latch & x_ce_carr_set_ctrl_out &
	carriage_set_sw_ce & ~x_1403_on_line;

// 33.33.47.1
assign err_stop_sw_c_e = ce_error_stop_sw_ce;

// 33.33.47.1
assign error_stop = err_stop_sw_c_e & parity_hammer_check;

// XXX isn't this the same thing as "prt_parity_hammer_check" on page 56 ?
// 33.33.47.1
assign parity_hammer_check = ucb_parity_check_lt_ucb |
1'b0 &	// XXX don't see how to avoid
	prt_parity_check_latch | hammer_check_latch_ce;

// "hammer check latch" here looks like "hammer check" latch on page 56
// the copy here does not include all the set logic, but does
// expand out the clear logic.

// 33.33.47.1
assign io_check_reset_pr = check_reset_prt | c_e_error_reset_ce;

// 33.33.47.1
assign reset_ham_ck_and_parity_ck = mach_reset_printer |
	reset_ham_ck_and_pty_ck |
	io_check_reset_pr;

//////// page 80
//////// sld-28 common interface number 1
//////// 5000

wire select_out;
wire reset_select_out_latch;
wire x_command_out_delayed;
wire command_out_delay;
wire immediate_proceed;
wire command_out_sample;
wire any_op_in;
wire status_service_in_dly;
wire x_service_out_delayed;
wire service_out_delay;
wire not_command_out_sample;
wire x_not_cmd_out_and_immed_proceed;
wire x_not_serv_out_smp;
wire not_command_service_out_smp;
wire address_out_delay;
wire sel_out_prop_sel_in;
wire any_op_in_delayed;
wire sel_out_burst_sw_on;
wire common_request_reset;
wire status_in_dly_abbreviated;
wire bus_out_clear;
wire any_channel_request;
wire not_status_in_sample;
wire test_io;
wire disconnect;
wire x_not_select_out;

// 31.11.34.1
assign select_out = i_select_out & i_hold_out;

// 31.11.34.1
latch1 u_select_out(i_clk,
	select_out,
	~i_hold_out | reset_select_out_latch,
	x_not_select_out);

// 31.11.11.1
delay1 #(DELAY_1200ns) u_command_out(i_clk, i_reset,
	i_command_out, x_command_out_delayed);

// 31.11.11.1
assign command_out_delay = i_command_out & x_command_out_delayed;

// 31.11.11.1
assign x_not_cmd_out_and_immed_proceed = ~i_command_out & immediate_proceed;

// page 121 (8000 tc-1 basic-interface timings (burst mode))
//	item 17 "not command out smp"
//	set by trailing edge of command_out
//	cleared by status_in_delay
// XXX service_in_delay can larger than x_command_out_delayed &~i_command_out,
//	so must block old pulse...
wire x_block_cmmd_out_smp_clear;
wire x_set_cmmd_out_smp = x_command_out_delayed & x_not_cmd_out_and_immed_proceed;
wire x_clear_cmmd_out_smp = status_service_in_dly;
latch3 u_hack_cmd_out_smp(i_clk,
	~x_set_cmmd_out_smp & x_clear_cmmd_out_smp,
	~any_op_in | ~x_clear_cmmd_out_smp,
	x_block_cmmd_out_smp_clear);
// 31.11.11.1
latch1 u_not_cmmd_out_smp(i_clk,
	x_set_cmmd_out_smp,
	~any_op_in | x_clear_cmmd_out_smp & ~x_block_cmmd_out_smp_clear,
	not_command_out_sample);

// this delay MUST be smaller than the delay for status_in
// 31.11.11.1
delay1 #(DELAY_1200ns-4) u_service_out(i_clk, i_reset,
	i_service_out, x_service_out_delayed);

// 31.11.11.1
assign service_out_delay = i_service_out & x_service_out_delayed;

wire x_set_not_serv_out_smp = x_service_out_delayed & ~i_service_out & x_not_cmd_out_and_immed_proceed;
wire x_clear_not_serv_out_smp = status_service_in_dly;

wire hack_block_not_serv_out_smp_clear;
latch3 u_hack_serv_out(i_clk,
	x_set_not_serv_out_smp & x_clear_not_serv_out_smp,
	~any_op_in | ~x_clear_not_serv_out_smp,
	hack_block_not_serv_out_smp_clear);
	
// 31.11.11.1
latch3 u_not_serv_out_smp(i_clk,
	x_set_not_serv_out_smp,
	~any_op_in | x_clear_not_serv_out_smp & ~hack_block_not_serv_out_smp_clear,
	x_not_serv_out_smp);

// 31.11.11.1
assign not_command_service_out_smp = (not_command_out_sample | x_not_serv_out_smp);

// 31.11.11.1
assign address_out_delay = ~sel_out_prop_sel_in & i_address_out & ~(~i_address_out & any_op_in_delayed);

// 31.11.21.1
assign sel_out_burst_sw_on = select_out | i_burst_sw_on |
	x_sense_force_burst;	// XXX hack

// 31.11.21.1
assign common_request_reset = i_address_out | ((o_service_in & i_command_out) | sel_out_prop_sel_in | status_in_dly_abbreviated);

// 31.11.35.1
assign disconnect = i_address_out & ~select_out;

// 31.11.07.1 31.11.08.1
assign bus_out_check = ~^{i_bus_out};
// 31.11.08.1
assign bus_out_odd_parity = ~bus_out_check;

// 31.11.21.1
assign bus_out_clear = ~|bus_out;

// 31.11.21.1
latch1 u_test_io(i_clk,
	bus_out_clear & ~address_in & any_channel_request & command_out_delay,
	~any_op_in | not_status_in_sample,
	test_io);

//////// page 81
//////// sld-29 common interface number 2
//////// 5001

wire select_out_delay;
wire rdr_channel_request;
wire pch_channel_request;
wire prt_channel_request;
wire prt_channel_request_prt_2;
wire prt_channel_request_prt_3;
wire prt_op_in;
wire rdr_pch_op_in;
wire prt_op_in_prt2;
wire prt_op_in_prt3;
wire prt_adapter_request;
wire prt_adapter_request_prt_2;
wire prt_adapter_request_prt_3;
wire rdr_adapter_request;
wire pch_adapter_request;
wire any_adapter_request;
wire not_rdr_pch_adapter_request;
wire x_interleave_proceed;
wire proceed;
wire x_immediate_proceed_delayed;
wire address_in;
wire x_address_in_delayed;
wire x_byte_cnt_1;
wire x_byte_cnt_2;
wire byte_cnt_1;
wire byte_cnt_2;
wire byte_cnt_2_a;
wire [7:0] rdr_pch_bus_in;
wire [7:0] prt_bus_in;
wire [7:0] cfc_bus_in;
wire [7:0] rdr_bus_in;
wire suppress_data;
wire x_any_status_in;
wire status_in_delay;
wire rdr_pch_status_in;
wire prt_status_in;
wire prt_status_in_prt2;
wire prt_status_in_prt3;
wire status_in_extended;
wire rdr_pch_service_in;
wire prt_service_in;
wire prt_service_in_prt2;
wire prt_service_in_prt3;
wire x_any_service_in;
wire service_in_delay;
wire not_service_in_sample;
wire service_in;
wire service_in_tag;
wire x_any_sense_delay_gate;
wire rdr_pch_sense_dly_gate;
wire prt_sense_delay_gate;
wire prt_sense_delay_gate_prt_2;
wire prt_sense_delay_gate_prt_3;
wire [7:0] bus_in;
wire bus_in_p;

// 31.11.13.1
delay1 #(DELAY_525ns) u_select_out_delayed(i_clk, i_reset,
	i_select_out, select_out_delay);
// 31.11.13.1
assign any_channel_request = rdr_channel_request |
	pch_channel_request |
	prt_channel_request |
	prt_channel_request_prt_2 |
	prt_channel_request_prt_3;
// 31.11.13.1
assign sel_out_prop_sel_in = select_out_delay & i_select_out &
	~any_channel_request & ~any_adapter_request & ~any_op_in;
// 31.11.13.1
assign any_op_in = prt_op_in | rdr_pch_op_in | prt_op_in_prt2 | prt_op_in_prt3;
// 31.11.13.1
assign any_op_in_delayed = any_op_in;
// 31.11.04.1
assign o_operational_in = any_op_in;
// 31.11.04.1
assign o_request_in = any_adapter_request;
assign any_adapter_request = prt_adapter_request |
	prt_adapter_request_prt_2 |
	prt_adapter_request_prt_3 |
	rdr_adapter_request |
	pch_adapter_request;
// 31.11.13.1
assign not_rdr_pch_adapter_request = ~rdr_adapter_request & ~pch_adapter_request;

// XXX cmd-out in response to service-in should stop an active channel
//	request.  Without the check for "~immediate_proceed" that also
//	sets this latch, which seems wrong.
// 31.11.21.1
latch1 u_interleave_proceed(i_clk,
// YYY ~immediate_proceed &	// XXX hack to avoid cmd-out "stop"
	i_command_out & ~any_channel_request & any_op_in,
mach_reset_out |	// XXX hack
	~any_op_in,
	x_interleave_proceed);

// 31.11.21.1
latch1 u_burst_proceed(i_clk,
//	~(x_interleave_proceed | ~command_out_delay),
	x_interleave_proceed | command_out_delay,
	~any_op_in,
	immediate_proceed);

// XXX there's a problem if ~hold_out duration < 1200 ns...
wire x_immediate_proceed_delayed_out;
// 31.11.21.1
delay1 #(DELAY_1200ns) u_immediate_proceed_delay(i_clk, i_reset,
	immediate_proceed, x_immediate_proceed_delayed_out);
assign x_immediate_proceed_delayed = x_immediate_proceed_delayed_out & immediate_proceed;

// 31.11.21.1
// XXX confusing negates here - but seems to need a plain 'or'
//assign proceed = ~(x_interleave_proceed | ~x_immediate_proceed_delayed);
assign proceed = (x_interleave_proceed | x_immediate_proceed_delayed);

// 32.11.21.1
assign address_in = ~proceed & any_op_in & ~i_address_out;

// 31.11.04.1
delay1 #(DELAY_525ns) u_address_in(i_clk, i_reset,
	address_in
		& ~mach_reset_out,	// XXX hack to avoid delayed X
	x_address_in_delayed);

// XXX had to mess with nots here to make this work.
// 31.11.04.1
assign o_address_in = x_address_in_delayed & (address_in | ~any_channel_request);

// XXX original byte count triggers had "ac" inputs.
wire x_service_in_leading_edge;
pdetect1 u_service_in_leading_edge (i_clk,
	service_in,
	x_service_in_leading_edge);

// 31.11.08.1
latch1 u_byte_cnt_1(i_clk,
	~x_byte_cnt_1 & x_service_in_leading_edge,
	~any_op_in | x_service_in_leading_edge & x_byte_cnt_1,
	x_byte_cnt_1);

// 31.11.08.1
latch1 u_byte_cnt_2(i_clk,
	~x_byte_cnt_2 & x_service_in_leading_edge & x_byte_cnt_1,
	~any_op_in | x_service_in_leading_edge & x_byte_cnt_2 & x_byte_cnt_1,
	x_byte_cnt_2);

// 31.11.08.1
assign byte_cnt_1 = i_one_byte_sw_on & x_byte_cnt_1;
// XXX in the ald, "-y byte cnt 2" is and'd with one_byte_switch_on, but
//	"+y byte cnt 2" is not.
// 31.11.08.1
assign byte_cnt_2 = x_byte_cnt_2;
assign byte_cnt_2_a = i_one_byte_sw_on & x_byte_cnt_2;

// XXX chan_reg to bus-in shown on page 4040;
//	w/o any details on "rdr-pch bus in mix"
//	or how addr on bus-in gets mixed in.

// 32.11.23.1 - 32.11.27-1
// 32.11.03.1 32.11.05.1 32.11.06.1
assign bus_in = chan_reg | rdr_pch_bus_in | prt_bus_in | cfc_bus_in;
// 32.11.05.1 32.11.06.1
assign bus_in_p = ~^{ bus_in } & any_op_in & proceed;
// 32.11.03.1
assign o_bus_in = { bus_in_p, bus_in } | x_bus_in_address;

latch1 u_suppress_data(i_clk,
	sel_out_burst_sw_on & i_service_out & i_suppress_out,
	~i_suppress_out | ~any_op_in,
	suppress_data);

// this is "status in" on the alds
assign x_any_status_in = rdr_pch_status_in |
	prt_status_in |
	prt_status_in_prt2 |
	prt_status_in_prt3;

// XXX there is a race between command-out (end of burst xfer setting
//  channel end) and status-out (returning channel-end.)
//  The status-in delay must be larger to avoid
//  prematurely clearing channel-end.
// XXX also, if the channel does not drop select_out promptly after
//	status (say, with testio), the printer will hang with prt_op_in true.
// 31.11.12.1
delay1 #(DELAY_1200ns-4) u_any_status_in(i_clk, i_reset,
	x_any_status_in, x_status_in_delay);

assign status_in_delay = x_status_in_delay;

// not clear in the ild, but in the ald, this is clearly a 2 gate delay:
// 31.11.12.1
delay1 #(1) u_status_in_extended(i_clk, mach_reset_out, x_any_status_in,
	status_in_extended);
// XXX not_status_in_sample - at least for use by pch_interrupt_req;
//	I think this was meant to be asserted briefly just
//	status_in_extended drops, not continously when not
//	status_in_extended.
// 32.11.12.1
// assign not_status_in_sample = ~status_in_extended & ~status_in_delay;
assign not_status_in_sample = ~status_in_extended & status_in_delay;
// 32.11.04.1
assign status_in_dly_abbreviated = x_any_status_in & status_in_delay;
// 32.11.04.1
assign o_status_in = status_in_dly_abbreviated;

// 32.11.12.1
assign status_service_in_dly = service_in_delay | status_in_delay;

// 31.11.12.1
assign x_any_service_in = rdr_pch_service_in |
	prt_service_in |
	prt_service_in_prt2 |
	prt_service_in_prt3;

// XXX must be longer than status_in_delay so that
//	x_not_serv_out_smp gets cleared properly.
// 31.11.12.1
delay1 #(DELAY_1200ns+4) u_any_service_in(i_clk, i_reset,
	x_any_service_in, service_in_delay);

// 31.11.12.1
assign service_in = x_any_service_in;
// 31.l1.12.1
assign not_service_in_sample = ~service_in & service_in_delay;
// 31.11.04.1
assign o_service_in = service_in_tag;

// 31.11.12.1
assign x_any_sense_delay_gate = rdr_pch_sense_dly_gate |
	prt_sense_delay_gate|
	prt_sense_delay_gate_prt_2|
	prt_sense_delay_gate_prt_3;

// 31.11.12.1
assign service_in_tag = ((service_in_delay & x_any_service_in &
				x_any_sense_delay_gate) |
			(x_any_service_in & ~x_any_sense_delay_gate));

//////// page 82
//////// sld-30 reader-punch common interface
//////// 5020

wire rdr_sense_req;
wire pch_sense_req;
wire x_reader_sense;
wire x_punch_sense;
wire x_reader_read_burst;
wire x_punch_read_and_write_burst;
wire rdr_interrupt_req;
wire rdr_sense;
wire pch_interrupt_req;
wire pch_sense;
wire pch_op_in;
wire rdr_op_in;
wire chan_reg_full;
wire x_nsuppd_ncmdsvcout_smp;
wire punch_ser_cy_req;
wire pch_complete;
wire pch_end;
wire pfr_pch_service_req;
wire x_225_300;
wire x_reader_read_interleave;
wire x_pch_read_and_write_interleave;
wire reset_service_in;
wire pch_read_sense;
wire x_service_out_or_rdr_pch_service_in;
wire x_sel_service_burst;
wire x_rdr_interleave_mode_ending_or_stacked_status;
wire x_rdr_burst_mode_ending_or_stacked_status;
wire x_pch_interleave_mode_ending_or_stacked_status;
wire x_pch_burst_mode_ending_or_stacked_status;
wire x_sel_burst_command_svc;
wire x_srv_out_svc_in;
wire x_rdr_pch_initial_selection;
wire x_rdr_sup_sel;
wire x_pch_sup_sel;
wire rdr_queued;
wire pch_queued;
wire [7:0] bus_out_bits;
wire [5:0] col_bin_set_chan_reg;
wire [7:0] data_enter_ce;
wire block_chan_reg_set;
wire pfr_xlate_gate;
wire read_col_binary;
wire x_75_150;
wire x_225_375;
wire x_300_525;
wire x_450_525;
wire pfr_reset_chan_reg;
wire [7:0] chan_reg;
wire x_rdr_pch_set_status_in;
wire x_rdr_pch_clear_status_in;

wire x_nss_hack_1;
assign x_nss_hack_1 = proceed | ~sense_hack[4];
wire x_nss_hack_2;
assign x_nss_hack_2 = proceed | ~sense_hack[2];

wire x_nns_hack_1;
ss1 #(8) u_nss_hack_1(i_clk, i_reset, x_nsuppd_ncmdsvcout_smp, x_nns_hack_1);

// 32.11.04.1
assign rdr_sense_req = rdr_adapter_request | (~rdr_channel_request &
	~not_status_in_sample & sel_out_burst_sw_on);
// 32.11.04.1
assign pch_sense_req = pch_adapter_request | (~pch_channel_request &
	~not_status_in_sample & sel_out_burst_sw_on);

// 32.11.01.1
assign x_reader_sense = rdr_sense_req & ~rdr_interrupt_req
	& rdr_sense & x_nsuppd_ncmdsvcout_smp
& x_nss_hack_2	// XXX hack
	& rdr_op_in;
// 32.11.01.1
assign x_punch_sense = pch_sense_req &
	x_nsuppd_ncmdsvcout_smp &
x_nss_hack_1 &	// XXX hack
	pch_sense & ~pch_interrupt_req & pch_op_in;
// 32.11.01.1
assign x_reader_read_burst =
	x_nsuppd_ncmdsvcout_smp &
	rdr_op_in & chan_reg_full_1 & sel_out_burst_sw_on &
	~any_channel_request;
// 32.11.01.1
assign x_punch_read_and_write_burst =
	~any_channel_request &
	sel_out_burst_sw_on &
	x_nsuppd_ncmdsvcout_smp  &
	pch_op_in & punch_ser_cy_req;
//1;//

wire xxx_command_out_extended, xxx_temp;
wire xxx_sta_svc_in_extended, xxx_temp2;
delay2 #(2) u_cmd_out_extended(i_clk, i_reset,
~i_command_out,
xxx_temp);
assign xxx_command_out_extended = ~xxx_temp;
delay2 #(20) u_sta_svc_in_extended(i_clk, i_reset,
~x_any_status_in & ~x_any_service_in,
xxx_temp2);
assign xxx_sta_svc_in_extended = ~xxx_temp2;

// XXX ald shows ~rdr_pch_status_in being or'd in...
// 32.11.01.1
assign x_nsuppd_ncmdsvcout_smp = ~suppress_data &
xxx_temp &	// XXX avoid glitch w/ racing leading edge of rdr_pch_status_in
	not_command_service_out_smp & ~rdr_pch_status_in;

// ald calls this "pch service req"
// 32.11.04.1
assign punch_ser_cy_req = ~(~(~pch_interrupt_req & ~pch_complete
			& ~pch_end & pch_write & ~chan_reg_full)
	& ~pfr_pch_service_req)
	& (~x_225_300 | ~pch_trans_cycle)
	;
// 32.11.01.1
assign x_reader_read_interleave = chan_reg_full_1 & rdr_op_in &
	rdr_adapter_request &
	x_nsuppd_ncmdsvcout_smp;
// 32.11.01.1
assign x_pch_read_and_write_interleave = punch_ser_cy_req &
	pch_op_in &
	x_nsuppd_ncmdsvcout_smp &
	pch_adapter_request;

// XXX should NOT drop service in before service_in_delayed rises.
wire hack_rst_svc_in = service_in_delay;
// 32.11.04.1
assign reset_service_in = (hack_rst_svc_in & rdr_op_in & service_out_delay) |
	(hack_rst_svc_in & service_out_delay & pch_read_sense & pch_op_in) |
	(hack_rst_svc_in & service_out_delay & pch_trans_cycle & x_225_300);

// 32.11.01.1
latch1 u_rdr_pch_service_in(i_clk,
	x_reader_sense | x_punch_sense | x_reader_read_burst |
	x_punch_read_and_write_burst | x_reader_read_interleave |
	x_pch_read_and_write_interleave,
	command_out_delay | ~rdr_pch_op_in | reset_service_in,
	rdr_pch_service_in);
// 32.11.03.1
assign x_service_out_or_rdr_pch_service_in = ~(~i_service_out & ~rdr_pch_service_in);
// 32.11.03.1

assign x_rdr_sup_sel = ~rdr_queued | ~i_suppress_out | select_out;
assign x_pch_sup_sel = ~pch_queued | ~i_suppress_out | select_out;


// 32.11.03.1
assign x_sel_burst_command_svc = sel_out_burst_sw_on &
	(not_command_service_out_smp & ~x_srv_out_svc_in);
// 32.11.03.1
assign x_srv_out_svc_in = i_service_out | rdr_pch_service_in;
// 32.11.03.1
assign x_rdr_interleave_mode_ending_or_stacked_status =
	x_not_command_out_sample & rdr_adapter_request &
	~x_srv_out_svc_in &
	rdr_op_in & rdr_interrupt_req;
// 32.11.03.1
assign x_rdr_burst_mode_ending_or_stacked_status =
	rdr_interrupt_req & rdr_op_in & ~rdr_adapter_request &
	x_sel_burst_command_svc & x_rdr_sup_sel;
// 32.11.03.1
assign x_pch_interleave_mode_ending_or_stacked_status =
	~x_srv_out_svc_in &
	not_command_out_sample & pch_adapter_request &
	pch_interrupt_req & pch_op_in;
// 32.11.03.1
assign x_pch_burst_mode_ending_or_stacked_status =
	pch_op_in & pch_interrupt_req & x_sel_burst_command_svc &
	x_pch_sup_sel & ~pch_adapter_request;
// 32.11.03.1
assign x_rdr_pch_initial_selection = not_command_out_sample &
	any_channel_request & rdr_pch_op_in;
// 32.11.03.1
assign rdr_pch_op_in = rdr_op_in | pch_op_in;

assign x_rdr_pch_set_status_in =
	x_rdr_interleave_mode_ending_or_stacked_status |
	x_rdr_burst_mode_ending_or_stacked_status |
	x_pch_interleave_mode_ending_or_stacked_status |
	x_pch_burst_mode_ending_or_stacked_status |
	x_rdr_pch_initial_selection;

assign x_rdr_pch_clear_status_in =
	~x_csso_hack_1 &	// XXX avoid bogus clear
	command_out_delay |
	service_out_delay;

// XXX race condition: svc-in & cmd-out must not glitch following sta-in
wire x_csso_hack_0, x_csso_hack_1, x_csso_hack_2, x_csso_hack_3;
assign x_csso_hack_3 = i_command_out & o_service_in;
ss2 #(2) u_hack_0(i_clk, i_reset, ~x_csso_hack_3, x_csso_hack_0);
delay1 #(2) u_hack_2(i_clk, i_reset, x_csso_hack_0, x_csso_hack_2);
latch3 u_hack_1(i_clk, x_csso_hack_3, i_reset | x_csso_hack_2, x_csso_hack_1);

// XXX avoid premature clear from delayed status_in bit.
wire x_block_rdr_pch_sta_in_clear;
latch3 u_block_rdr_pch_sta_in_clear(i_clk,
	x_rdr_pch_set_status_in & x_rdr_pch_clear_status_in,
	~rdr_pch_op_in | ~x_rdr_pch_clear_status_in,
	x_block_rdr_pch_sta_in_clear);

// XXX set test for sim clear here: on cmd-out & svc-in for CU byte termination;
//	avoid setting pch_queued because of asserting status-in internally
//	before cmd-out dropped externally.
// 32.11.03.1
latch1 u_rdr_pch_status_in(i_clk,
proceed &
	x_rdr_pch_set_status_in & ~x_rdr_pch_clear_status_in,
	~rdr_pch_op_in |
//YYY ~x_block_rdr_pch_sta_in_clear &
	x_rdr_pch_clear_status_in & ~x_rdr_pch_set_status_in,
	rdr_pch_status_in);

// 32.11.13.1
assign reset_chan_reg =
	mach_reset_rdr_pch |	// XXX hack
	(pch_trans_cycle & x_450_525) |
		(x_225_300 & rdr_trans_cycle) |
		~pch_trans_cycle & ~rdr_pch_service_in &
			~chan_reg_full & ~x_300_525 |
		pfr_reset_chan_reg;

/// also see pages 49,64
// 32.11.1.1 32.11.12.1-32.11.15.1
//latch1 #(.W(8)) u_chan_reg(i_clk,
//	(read_xlate &
//			{8{~block_chan_reg_set &
//				~(pfr_xlate_gate | (~read_col_binary &
//					rdr_trans_cycle & x_225_375))}}) |
//		(bus_out_bits &
//			{8{pch_op_in & x_75_150 & pch_trans_cycle}}) |
//		col_bin_set_chan_reg |
//		data_enter_ce,
//	reset_chan_reg,
//	chan_reg);

//////// page 83
//////// sld-31 row bit check control
//////// 5021

//    1	there is one position in each check plane for every
//	card column. the same planes are used for both read
//	and punch but they have different positions.
//    2 all check planes are cleared of previous data at
//	plus (+) hole count transfer time
//  [1]	regen xu until hole count transfer
//  [2]	transfer yu to xu. block transfer if a row bit is sensed at this time
//  [3]	transfer yl to xl.  block transfer if a row bit is sensed at this time
//  [4]	preform binary count of holes sensed at second read or punch check brushes
//  [5]	transfer yl to xl.  allow transfer if row bit is sensed at this time
//  [6]	any hole sensed at first read brushes sets yu
//  [7]	regen yu until hole count transfer
//  [8]	any bit in data register (punch) sets yu
//  [9]	regen yl until hole count transfer
// [10]	preform binary count of holes sensed at first rd brushes
// [11]	set yl with rd 1 row bit at 9 time
// [12]	set yl if data reg count is odd.  block for pfr if pfr count was odd
// [13]	regen zu until hole count transfer
// [14]	any bit sensed by pfr brushes.  set zu
// [15]	preform binray count of holes sensed by pfr brushes

wire rdr_trans_cy_stor_scan;
wire c_rd_2_row_bit;
wire c_pch_chk_row_bit;
wire ser_cy_not_rd2_not_pch_chk;
wire rd_2_pch_chk_rd_ser_cycle;
wire x_c_pch_chk_row_bit;
wire sa_xu;
wire sa_xl;
wire sa_yu;
wire sa_yl;
wire sa_pfr_zu;
wire sa_pfr_zl;
wire pfr_write_yu;
wire pfr_write_yl;
wire data_reg_xu;
wire data_reg_xl;
wire data_reg_yu;
wire data_reg_yl;
wire data_reg_zu;
wire data_reg_zl;
wire hole_count_xfer;
wire inh_current_xu;
wire inh_current_xl;
wire inh_current_yu;
wire inh_current_yl;
wire inh_current_zu;
wire inh_current_zl;
wire any_bit;
wire rd_1_ser_cy;
wire i2_pch_ser_cycle;
wire addr_reg_000;
wire pch_select_or_pch_trans;
wire rd_ctr_a;
wire rd_ctr_b;
wire rd_ctr_f;
wire data_reg_p;
wire write_xu;
wire write_xl;
wire write_yu;
wire write_yl;
wire write_zu;
wire write_zl;
wire pfr_read_row_bit;
wire pch_emit_12;
wire c_pfr_rd_row_bit;

// 32.31.01.1
assign pfr_read_row_bit = c_pfr_rd_row_bit;

// 32.20.44.1
assign write_xu = (data_reg_xu & ~hole_count_xfer		// [1]
		& ser_cy_not_rd2_not_pch_chk) |
	( ser_cy_not_rd2_not_pch_chk & data_reg_yu &		// [2]
		hole_count_xfer);
assign inh_current_xu = inhibit_375_000 & ~write_xu;

// 32.20.44.1
assign write_xl = (ser_cy_not_rd2_not_pch_chk &			// [3]
		hole_count_xfer & data_reg_yl) |
	(ser_cy_not_rd2_not_pch_chk & ~hole_count_xfer &	// [4]
		data_reg_xl) |
	(~hole_count_xfer & ~data_reg_xl &			// [4]
		rd_2_pch_chk_rd_ser_cycle) |
	(rd_2_pch_chk_rd_ser_cycle & hole_count_xfer &		// [5]
		~data_reg_yl);
assign inh_current_xl = inhibit_375_000 & ~write_xl;

// 42.23.02.1
assign pfr_write_yu = data_reg_zu & i2_pch_ser_cycle;

// 42.23.02.1
assign pfr_write_yl = i2_pch_ser_cycle & data_reg_zl & data_reg_p;

// XXX added "& trigger_c" to any_bit term to keep it from picking
//	up trailing edge of previous value of any_bit. (any_bit
//	goes false at about +112 ns, goes valid at +187 (relative to
//	the start of trigger_a.)  i2_pch_ser_cycle goes + at
//	+112 ns.
// 32.20.45.1
assign write_yu = pfr_write_yu |
		rd_1_ser_cy |					// [6]
		(~hole_count_xfer & data_reg_yu) |		// [7]
		any_bit & i2_pch_ser_cycle & ~addr_reg_000 &	// [8]
			trigger_c;				// XXX added
assign inh_current_yu = inhibit_375_000 & ~write_yu;

// 32.20.45.1
assign write_yl = pfr_write_yl |
	(~hole_count_xfer & pch_select_or_pch_trans &		// [9]
		data_reg_yl) |
	(~hole_count_xfer & data_reg_yl &			// [10]
		ser_cycle_not_rd_1) |
	(rd_1_ser_cy & ~data_reg_yl) |				// [10]
	(rd_1_ser_cy & rd_ctr_a & ~rd_ctr_b) |			// [11]
	(~data_reg_p & ~data_reg_zl & ~(~i2_pch_ser_cycle	// [12]
			| addr_reg_000));
assign inh_current_yl = inhibit_375_000 & ~write_yl;

// 42.13.27.1
assign write_zu = ~hole_count_xfer & data_reg_zu & pch_select |	// [13]
	pch_ser_cy & pfr_read_row_bit & pch_4_bit_mod;		// [14]

// 42.13.27.1
assign write_zl = pch_select & data_reg_zl &			// [15]
		~pfr_read_row_bit & ~pch_emit_12 |
	pch_4_bit_mod & ~pch_emit_12 & pfr_read_row_bit &	// [15]
		~data_reg_zl;

assign inh_current_zu = inhibit_375_000 & ~write_zu;
assign inh_current_zl = inhibit_375_000 & ~write_zl;

// 32.20.53.1
assign rdr_trans_cy_stor_scan = storage_scan | rdr_trans_cycle;

// XXX ser_cy_not_rd2_not_pch_chk and ser_cycle_not_rd_1
//	also show less clearly and correctly on page 63.
// 32.31.01.1
assign ser_cy_not_rd2_not_pch_chk = rdr_trans_cy_stor_scan |
	(pch_ser_cy & ~x_c_pch_chk_row_bit) |
	(rd_ser_cycle & ~x_rd_ser_rd_2_row_bit);
// 32.31.01.1
assign ser_cycle_not_rd_1 = rdr_trans_cy_stor_scan |
	rd_ser_cycle & ~rd_1_ser_cy;

wire x_rd_ser_rd_2_row_bit;

// XXX DT with 2 terminals - is this an AND?
// 32.31.01.1
assign x_rd_ser_rd_2_row_bit = rd_ser_cycle & c_rd_2_row_bit;
// 32.31.01.1
assign x_c_pch_chk_row_bit = c_pch_chk_row_bit;

// 32.31.01.1
assign rd_2_pch_chk_rd_ser_cycle = (x_c_pch_chk_row_bit |
	x_rd_ser_rd_2_row_bit);

// 32.20.35.1
latch1 u_xu_tr(i_clk, sa_xu, reset_data_reg, data_reg_xu);
// 32.20.35.1
latch1 u_xl_tr(i_clk, sa_xl, reset_data_reg, data_reg_xl);
// 32.20.35.1
latch1 u_yu_tr(i_clk, sa_yu, reset_data_reg, data_reg_yu);
// 32.20.35.1
latch1 u_yl_tr(i_clk, sa_yl, reset_data_reg, data_reg_yl);
// 42.20.36.1
latch1 u_zu_tr(i_clk, sa_pfr_zu, reset_data_reg, data_reg_zu);
// 42.20.36.1
latch1 u_zl_tr(i_clk, sa_pfr_zl, reset_data_reg, data_reg_zl);

// XXX 32.20.22.1 32.20.35.1 "M" - takes inh_current_[xyz][ul],
// outputs to "SA" which makes sa_pfr_[xyz][ul]

//////// page 84
//////// sld-32 reader interface controls
//////// 5040

wire x_9_read_ser_cycle;
wire rdr_adapter_reset;
wire x_9_read_ser_out;
wire any_bit_bus_out_0_thru_5;
wire x_bad_block_67;
wire x_bad_2n67;
wire x_none_01345;
wire x_bad_6n7;		// write
wire x_bad_0167;
wire modifiers_only;
wire read_backwards;
wire rdr_valid_cmmd;
wire x_rdr_address_match;
wire x_2540_on_line;
wire x_2540_off_line;
wire block_rdr_feed;
wire block_pch_feed;
wire ce_2540_off_line_sw;
wire metering_in;
wire pfr_mode;
wire load_and_single_cycle;
wire storage_scan;	// storage scan / storage scan*ce
wire off_line_run;
wire off_line_ce;
wire rdr_adapter_reset_1;
wire rdr_command_gate;
wire bus_out_odd_parity;
wire rdr_busy_queued;
wire rdr_status_reset;
wire rdr_busy;
wire reader_ready;
wire rdr_command_stored;
wire rdr_interven_reqd;
wire x_rdr_data_interleave_mode;
wire x_rdr_stacked_status;
wire x_rdr_non_stacked_status;
wire rdr_device_end;
wire rdr_feeding;
wire rdr_end;
wire x_rdr_data_or_status_request;
wire rdr_adapter_request_reset;
wire mach_reset_rdr_pch;
wire reset_rdr_commd_nbusy_lat;
wire read_feed_1;
wire x_rdr_initial_selection;
wire x_interleave_mode;
wire any_op_in_delay;
wire x_status_or_disconnect;
wire x_status;
wire x_data_interleave_mode_data_transfer;
wire x_status_if_status_was_stacked;
wire x_interface_disconnect;
wire x_ending_status;
wire rdr_channel_end;
wire addr_set_ce;
wire addr_set_sw;

// 32.12.32.1
latch1 u_9_read_ser_cy(i_clk,
	x_9_read_ser_cycle,
	rdr_adapter_reset | rdr_trans_cycle,
	x_9_read_ser_out);

// 32.12.32.1
assign x_bad_block_67 = x_9_read_ser_out &
	any_bit_bus_out_0_thru_5 &			// -6 -7
	bus_out[1] & bus_out[0];			// match: MMMMMM11
// 32.12.32.1
assign x_none_01345 = ~(bus_out[7] & bus_out[6] &	// +0 +1 +3 +4 +5
	bus_out[4] & bus_out[3] & bus_out[2]);	// match: 00x000xx
// 32.12.32.1
assign x_bad_2n67 = ~x_none_01345 & ~bus_out[5] &	// +2 -6 -7
	bus_out[1] & bus_out[7];			// match: MM0MMM11
// 32.12.32.1
assign x_bad_6n7 = ~bus_out[1] & bus_out[0];	// +6 -7
							// match: xxxxxx01
// 32.12.32.1
assign x_bad_0167 = bus_out[7] & bus_out[6] &	// -0 -1 -6 -7
	bus_out[1] & bus_out[0];			// match: 11xxxx11
// 32.12.32.1
assign modifiers_only = ~bus_out[2] & ~bus_out[1] &	// +5 +6 +7
	~bus_out[0] & ~bus_out_clear;			// match: NNNNN000
// 32.12.32.1
assign read_backwards = bus_out[3] & bus_out[2] &	// -4 -5 +6 +7
	~bus_out[1] & ~bus_out[0];			// match: xxxx1100

// 32.12.32.1
assign rdr_valid_cmmd = ~(x_bad_block_67 | x_bad_2n67 |
	x_bad_6n7 | x_bad_0167 | modifiers_only | read_backwards);

// 32.12.12.1
assign x_rdr_address_match = bus_out == RDRADDRESS;
// 32.11.16.1
assign x_2540_off_line = (~block_rdr_feed &
	~block_pch_feed &
		(ce_2540_off_line_sw | ~metering_in |
		pfr_mode | load_and_single_cycle |
		storage_scan |
		(off_line_run |
			off_line_ce)));
// 32.11.16.1
assign x_2540_on_line = ~x_2540_off_line;
// 32.11.16.1 32.05.01.0
assign addr_set_ce = ~x_2540_on_line & addr_set_sw;

// needs latch2 - clear held high by ~rdr_op_in
// 32.12.12.1
latch2 u_rdr_chan_request(i_clk, i_reset,
	x_rdr_address_match & address_out_delay & x_2540_on_line,
	rdr_adapter_reset_1 | not_status_in_sample | ~rdr_op_in,
	rdr_channel_request);

// 32.12.03.1
assign rdr_command_gate = rdr_channel_request & address_in &
	bus_out_odd_parity & command_out_delay & ~rdr_busy_queued;

// 32.12.42.1
latch1 u_reader_queued(i_clk,
	i_command_out & rdr_pch_status_in & rdr_op_in,
	rdr_status_reset | (rdr_op_in & address_in & rdr_adapter_request),
	rdr_queued);

// 32.12.34.1
latch1 u_reader_interven_required(i_clk,
	~rdr_busy & ~reader_ready & ~rdr_op_in,
	~rdr_op_in & (reader_ready & ~rdr_command_stored),
	rdr_interven_reqd);

// 32.12.32.1
assign rdr_rdy_and_cmmd_valid = ~rdr_interven_reqd & rdr_valid_cmmd;

// 32.12.11.1
assign x_rdr_data_interleave_mode = ~rdr_device_end & ~rdr_feeding &
	rdr_command_stored & ~rdr_end & ~rdr_op_in & ~select_out;
// 32.12.11.1
assign x_rdr_stacked_status = ~select_out & ~rdr_op_in &
	~i_suppress_out & rdr_queued;
// 32.12.11.1
assign x_rdr_non_stacked_status = ~select_out & ~rdr_op_in &
	~rdr_queued & rdr_interrupt_req;

// 32.12.11.1
assign x_rdr_data_or_status_request =
		x_rdr_data_interleave_mode | x_rdr_stacked_status |
		x_rdr_non_stacked_status;

// if both "clear" and "set", "set" wins.
wire x_set_rdr_adapter_request =
	x_2540_on_line & ~sel_out_prop_sel_in & x_rdr_data_or_status_request;
wire x_clear_rdr_adapter_request =
	(~x_rdr_data_or_status_request & ~select_out & ~rdr_op_in) |
		common_adapter_request_reset |
		rdr_adapter_request_reset |
		rdr_adapter_reset;
// why common adapter request reset and not common request reset ?
// 32.12.11.1
latch1 u_rdr_adapt_request(i_clk,
	x_set_rdr_adapter_request,
	x_clear_rdr_adapter_request & ~x_set_rdr_adapter_request,
	rdr_adapter_request);
// 32.11.04.1
assign rdr_adapter_request_reset = (((byte_cnt_2_a & ~read_col_binary)
		| byte_cnt_2)
		& rdr_pch_service_in & rdr_op_in) |
	(rdr_pch_service_in & rdr_sense & rdr_op_in);

// 32.12.11.1
wire x_rdr_adapter_reset_out;
latch1 u_rdr_adapt_reset(i_clk,
	i_operational_out,
power_on_reset |	// XXX hack
	(rdr_op_in & i_suppress_out & ~i_operational_out) |
		mach_reset_rdr_pch |
		x_2540_off_line,
	x_rdr_adapter_reset_out);
assign rdr_adapter_reset = ~x_rdr_adapter_reset_out;
// 32.12.11.1
assign rdr_adapter_reset_1 = rdr_adapter_reset;	// XXX should this be a delay?
// 32.12.11.1
assign reset_rdr_commd_nbusy_lat = (~read_feed & rdr_adapter_reset &
	~rdr_feeding) | mach_reset_rdr_pch;

// 32.12.14.1
assign x_rdr_initial_selection = rdr_channel_request & x_2540_on_line &
	select_out & ~sel_out_prop_sel_in;
// 32.12.14.1
assign x_interleave_mode = ~sel_out_prop_sel_in & select_out &
	select_out_delay & rdr_adapter_request &
	~i_address_out & ~any_op_in_delay;

// 32.12.14.1
assign x_status = not_status_in_sample & ~sel_out_burst_sw_on;
// 32.12.14.1
assign x_data_interleave_mode_data_transfer =  ~sel_out_burst_sw_on &
	~rdr_adapter_request & not_service_in_sample;
// 32.12.14.1
assign x_status_if_status_was_stacked = not_status_in_sample &
	rdr_interrupt_req & ~select_out;
// 32.12.14.1
assign x_interface_disconnect = ~(rdr_channel_end | ~rdr_busy | rdr_feeding) & i_address_out & ~select_out;
// 32.12.14.1
assign x_ending_status = ~select_out & ~rdr_channel_request & ~rdr_interrupt_req &
	(rdr_end | ~rdr_command_stored);

// 32.12.14.1
assign x_status_or_disconnect = x_status |
	x_data_interleave_mode_data_transfer | x_status_if_status_was_stacked |
	x_interface_disconnect | x_ending_status;
// 32.12.14.1
latch1 u_rdr_op_in(i_clk,
	x_rdr_initial_selection | x_interleave_mode,
	sel_out_prop_sel_in | rdr_adapter_reset_1 | x_status_or_disconnect,
	rdr_op_in);

//////// page 85
//////// sld-33 read select service and transfer
//////// 5041

wire select_rdr;
wire ce_start_time;
wire read;
wire ce_start_latch;
wire rd_ser_cy_req;
wire xfer_cy_req;
wire x_select_or_diagnostic;
wire x_000_075;
wire rd_trans_cycle;
wire rd_xfer_cy_ser_cy;
wire rd_ser_cycle;
wire c_rd_cycle;	// XXX this may be an o_ output
wire c_rdr_brush_impulse;	// XXX this may be an i_ input
wire rdr_brush_delayed;
wire reset_rar_1;
wire pch_ser_cy;
wire col_80;
wire x_300_450;
wire x_rd_ser_col80_300;
wire x_bl_rar_advance_out;
wire block_rar_advance;
wire blk_rar_ctrl_col_bin;
wire block_rar_and_par_advance;
wire x_delta_rd_ser_cy_req;

// duplicated without ce additions on page 64
// 32.32.13.1
assign select_rdr = (load_and_single_cycle & ce_start_time & read) |
	(read & storage_scan & ce_start_latch) |
	(rd_ser_cy_req & ~xfer_cy_req) |
	(xfer_cy_req & rdr_trans_cycle_req) |
	(select_pch & diagnostic_write);

assign x_select_or_diagnostic = select_rdr & ~diagnostic_write;

/// XXX how does this compare to page 49 2021c1
/// XXX how does this compare to page 63 4020c6
/// XXX how does this compare to page 64 4040c5
// 32.32.13.1
//latch1 u_rd_xfer_cy_2(i_clk,
//	~(x_select_or_diagnostic ) & r0_000_150 & rdr_trans_cycle_req,
//	x_000_075,
//	rd_trans_cycle);

/// XXX how does this compare to page 63
// 32.32.13.1
latch1 u_rd_serv_cy_2(i_clk,
	x_select_or_diagnostic & r0_000_150 & ~xfer_cy_req,
	x_000_075,
	rd_ser_cycle);

// 32.31.04.1
assign c_rd_cycle = rd_ser_cycle;
// 32.32.13.1
assign rd_xfer_cy_ser_cy = rd_trans_cycle | rd_ser_cycle;

// XXX rdr_brush_delayed, reset_rar_1, delta_rd_ser_cy_req,
//	rd_ser_cy_req also on page 65
// 32.32.13.1
delay1 #(DELAY_150us) u_rdr_brush_impulse(i_clk, i_reset,
	c_rdr_brush_impulse, rdr_brush_delayed);

// 32.32.13.1
assign reset_rar_1 = rdr_brush_delayed & ~c_rdr_brush_impulse;

assign x_rd_ser_col80_300 = col_80 & x_300_450 & rd_ser_cycle;

// 32.32.13.1
latch1 u_delta_rd_ser_cy_req(i_clk,
	reset_rar_1,
	mach_reset_rdr_pch | x_rd_ser_col80_300,
	x_delta_rd_ser_cy_req);

// 32.32.13.1
latch1 u_rd_ser_cy_req(i_clk,
	~rdr_brush_delayed & x_300_450 & x_delta_rd_ser_cy_req,
	pch_ser_cy | ~x_delta_rd_ser_cy_req,
	rd_ser_cy_req);

// 32.32.13.1
latch1 u_bl_rar_advance(i_clk,
	reset_rar_1,
	mach_reset_rdr_pch | (x_300_450 & rd_ser_cycle),
	x_bl_rar_advance_out);

// 32.32.13.1
assign block_rar_advance = x_bl_rar_advance_out |
	blk_rar_ctrl_col_bin | block_rar_and_par_advance;

//////// page 86
//////// sld-34 reader address register (rar)
//////// 5042

wire [4:0] rar_units;
wire [4:0] rar_tens;
wire rar_reset;
wire x_rar_advance_units;
wire x_rar_advance_tens;

// 32.20.11.1
decade6 u_rar_units(i_clk,
	rar_reset,
	x_rar_advance_units,
	rar_units);

// XXX r0_075 was r0_000_150 but decade step pulse must be one cycle wide.
// XXX also, select_rdr comes true just after 000
assign x_rar_advance_units = ~block_rar_advance & select_rdr &
	r0_075 & ~blk_rar_ctrl_col_bin;

// 32.20.11.1
assign rar_reset = reset_rar_1 | mach_reset_rdr_pch | reset_rar;

// XXX omitting ce_set_tens logic here.
// 32.20.12.1
decade6 u_rar_tens(i_clk,
	rar_reset,
	x_rar_advance_tens,
	rar_tens);

// XXX r0_075 was r0_000_150 but decade step pulse must be one cycle wide.
// XXX also, select_rdr comes true just after 000
// 32.20.12.1
assign x_rar_advance_tens = select_rdr & r0_075 &
	rar_units[2] & rar_units[0] &
	~block_rar_and_par_advance & ~blk_rar_ctrl_col_bin;

//////// page 87
//////// sld-35 punch select - service and transfer
//////// 5060

wire x_pun_address_match;
wire pch_adapter_reset_1;
wire any_bits_bus_out_0_through_5;
wire no_bits_bus_out_0_through_5;	// XXX is this used?
wire x_pch_invalid_cmd;			// XXX "valid_cmmd"
wire pfr_command_reject;
wire read_backward;
wire punch_ready;
wire interface_pch_ready_latch;
wire x_pch_data_interleave_mode;
wire x_pch_status_non_stacked;
wire x_pch_stacked_status;
wire pch_feeding;
wire x_pch_data_or_status_request;
wire common_adapter_request_reset;
wire pch_adapter_request_reset;
wire pch_1_bit_mod;
wire pch_feed_p_u;

/// XXX pch_interrupt also on page 66

// 32.13.12.1
assign x_pun_address_match = bus_out == PCHADDRESS;

// needs latch2 - clear held high by ~pch_op_in
// 32.13.12.1
latch2 u_pch_chan_request(i_clk, i_reset,
	x_pun_address_match & x_2540_on_line & address_out_delay,
	not_status_in_sample | pch_adapter_reset_1 | ~pch_op_in,
	pch_channel_request);

// 32.13.02.1
assign pch_command_gate = pch_channel_request & bus_out_odd_parity &
	address_in & command_out_delay & ~pch_busy_queued;

// 32.13.42.1
latch1 u_punch_queued(i_clk,
	pch_op_in & i_command_out & rdr_pch_status_in,
	pch_status_reset | (pch_op_in & address_in & pch_adapter_request),
	pch_queued);

// 32.13.42.1
latch1 u_punch_not_ready(i_clk,
	(pch_op_in & rdr_pch_status_in & i_service_out & ~pch_interven_reqd) |
		pch_adapter_reset,
	pch_interven_reqd,
	interface_pch_ready_latch);

/// XXX any_bits_bus_out_0_through_5 called any_bit_bus_out_0_thru_5 on page 53
// 32.13.31.1
assign any_bits_bus_out_0_through_5 = any_bit_bus_out_0_thru_5;
// 32.13.31.1
assign no_bits_bus_out_0_through_5 = ~any_bit_bus_out_0_thru_5;

/// x_pch_invalid_cmd also here on page 53
// 32.13.31.1
//assign x_pch_invalid_cmd = ~((any_bits_bus_out_0_through_5	// -6 -7
//		& bus_out[1] & bus_out[0]) |	// match: MMMMMM11
//	(bus_out[7] & bus_out[6] & ~bus_out[1] &	// -0 -1 +6 -7
//		bus_out[0]) |				// match: 11XXXX01
//	(bus_out[2] & bus_out[0] & rdr_busy) |	// -5 -7
//							// match: xxxxx1x1
//	pfr_command_reject | read_backward | modifiers_only);

// 32.13.31.1
assign pch_rdy_and_cmmd_valid = ~x_pch_invalid_cmd & ~pch_interven_reqd;

// 32.13.33.1
latch1 u_punch_interven_requirer(i_clk,
	~pch_busy & ~punch_ready & ~pch_op_in,
	~pch_op_in & (punch_ready & ~pch_command_stored),
	pch_interven_reqd);

// 32.13.11.1
assign x_pch_data_interleave_mode = pch_command_stored & ~pch_feeding &
	~pch_end & ~pch_device_end & ~select_out & ~pch_op_in;
// 32.13.11.1
assign x_pch_status_non_stacked = ~pch_op_in & ~select_out &
	pch_interrupt_req & ~pch_queued;
// 32.13.11.1
assign x_pch_stacked_status = ~pch_op_in & ~select_out & pch_queued &
	~i_suppress_out;

// 32.13.11.1
assign x_pch_data_or_status_request = x_pch_data_interleave_mode |
	x_pch_status_non_stacked |
	x_pch_stacked_status;

// 32.13.11.1
latch1 u_pch_adapter_request(i_clk,
	~sel_out_prop_sel_in & x_2540_on_line & x_pch_data_or_status_request,
	(~x_pch_data_or_status_request & ~pch_op_in & ~select_out) |
		common_adapter_request_reset |
		pch_adapter_request_reset |
		pch_adapter_reset,
	pch_adapter_request);

// 32.13.04.1
assign pch_adapter_request_reset =
	(((byte_cnt_2_a & ~pch_1_bit_mod) | byte_cnt_2)
		& rdr_pch_service_in & pch_op_in) |
	(pch_op_in & rdr_pch_service_in & pch_sense);

// 32.13.11.1
wire x_n_pch_adapter_reset;
latch1 u_pch_adapter_reset(i_clk,
	i_operational_out,
	(pch_op_in & i_suppress_out & ~i_operational_out) |
		x_2540_off_line |
		mach_reset_rdr_pch,
	x_n_pch_adapter_reset);
assign pch_adapter_reset = ~x_n_pch_adapter_reset;
// 32.13.11.1
assign reset_pch_commd_busy_lat = mach_reset_rdr_pch | (~pch_feeding &
		~pch_feed_p_u & pch_adapter_reset);
// 32.13.11.1
assign pch_adapter_reset_1 = pch_adapter_reset;

// 32.13.14.1
		// interleave mode:
wire x_s_pop_interleave = (pch_adapter_request & select_out_delay & ~i_address_out &
			~any_op_in_delayed & ~rdr_adapter_request &
			~sel_out_prop_sel_in & select_out);
		// initial selection:
wire x_s_pop_initsel = select_out & ~sel_out_prop_sel_in &
	x_2540_on_line & pch_channel_request;
		// status
wire x_c_pop_status = not_status_in_sample & ~sel_out_burst_sw_on;
		// data interleave mode data transfer
wire x_c_pop_interleave_data = ~sel_out_burst_sw_on & ~pch_adapter_request &
	not_service_in_sample;
		// status if status has been stacked
wire x_c_pop_stacked =
	not_status_in_sample & pch_interrupt_req & ~select_out;
		// interface disconnect
wire x_c_pop_idisc = ~select_out & ~( pch_busy |
		pch_channel_end | pch_feeding) & i_address_out;
		// ending status
wire x_c_pop_ending_status = ~select_out & ~pch_channel_request &
	~pch_interrupt_req & (pch_end | ~pch_command_stored);
wire x_pch_op_in_set = x_s_pop_interleave | x_s_pop_initsel;
wire x_pch_op_in_clear =
	sel_out_prop_sel_in | pch_adapter_reset_1 |
	x_c_pop_status |
	x_c_pop_interleave_data |
	x_c_pop_stacked |
	x_c_pop_idisc |
	x_c_pop_ending_status;
latch1 u_pch_op_in(i_clk,
	x_pch_op_in_set,
	x_pch_op_in_clear,
	pch_op_in);

//////// page 88
//////// sld-36 punch select - service and transfer
//////// 5061

wire x_any_trans_cycle_req;
wire pch_scan_emit;
wire pch_select_pch;
wire block_par_advance;
wire last_address;
wire punch_scan;
// wire punch;		same as punch_sw elsewhere
wire blk_par_ctrl_col_bin;
wire allow_par_adv;
wire pch_buffer_full;
wire pch_insert_blanks;
wire pch_brush_impulse;
wire reset_par;
wire x_pch_buffer_full_out;
wire pch_command_stored;

// also see page 63
// also see page 66
// 32.33.17.1
//assign pch_select_pch = (load_and_single_cycle & ce_start_time & punch) |
//	(punch & ce_start_latch & storage_scan) |
//	(pfr_trans_cy_req & xfer_cy_req) |
//	(xfer_cy_req & pch_trans_cy_req) |
//	(pch_ser_cy_req & ~rd_ser_cy_req & xfer_cy_req);

assign gated_select_pch = select_pch & ~diagnostic_write;
/// XXX u_pch_trans_cy also on pages 63,66
//latch1 u_pch_trans_cy(i_clk,
//	select_pch & xfer_cy_req & ~pch_read & r0_000_150,
//	x_000_075,
//	pch_trans_cycle);
// duplicate of pch_trans_cycle_req
// 32.13.33.1
// assign pch_trans_cy_req = chan_reg_full & pch_op_in & ~pch_end & pch_write;

// found here:
// 32.31.11.1 4040B3
// 32.31.11.1 4060B4
// 32.31.11.1 5061C2
assign x_any_trans_cycle_req = rdr_trans_cycle_req | pch_trans_cycle_req |
	pfr_trans_cy_req;
// 32.31.11.1
latch1 u_xfer_cy_req(i_clk,
	x_any_trans_cycle_req & x_525_075,
	mach_reset_rdr_pch | ( ~x_any_trans_cycle_req & x_525_075),
	xfer_cy_req);

/// XXX u_pch_trans_cy and u_pch_serv_cy duplicated here and on page 63
/// XXX u_pch_serv_cy also duplicated on page 67

assign o_punch_cycle = pch_ser_cy;	// "-c punch cycle"

/// XXX allow-par-adv also on page 67
// 32.33.18.1
latch1 u_allow_par_adv(i_clk,
	x_225_300 & pch_ser_cy,
	mach_reset_rdr_pch | last_address,
	allow_par_adv);

// 32.33.18.1
assign block_rar_and_par_advance = data_enter & load_and_single_cycle;
// 32.33.18.1
assign block_par_advance = block_rar_and_par_advance |
	blk_par_ctrl_col_bin |
	~allow_par_adv & ~last_address & pch_scan_emit |
	x_block_par_advance;	// XXX hack
/// XXX last-address also on page 67
// XXX at end of transfer|insert blanks, even though pch_scan_emit
// is false, must briefly assert last_address, otherwise first pch_scan_emit
// cycle is extremely truncated starting at col80 not 1.
// 32.33.18.l
wire x_set_last_address = pch_ser_cy & col_80 & x_300_450;
latch1 u_last_address(i_clk,
	x_set_last_address,
	~pch_scan_emit & ~x_set_last_address,
	last_address);
// page 88 (5061): punch service cycle timing chart
// turns on with pch_scan_emit -- any punch brush impulse.
// turns off when "last_address" inserted
/// XXX pch_ser_cy_req also on page 67
// 32.33.18.1
assign pch_ser_cy_req = (~last_address & pch_scan_emit & ~pch_complete) |
	(~pch_buffer_full & pch_insert_blanks);

// page 88 (5061): punch service cycle timing chart; notes
//  [1]	turns on with any punch brush impulse.
//  [2] turns off with punch brush impulse ending
//	remains on for duration of transfer (all 80 cols)
// 32.33.18.1
latch1 u_pch_scan_emit(i_clk,
	(after_9_emitter & ~pch_complete & x_300_450) |
		(x_300_450 & punch_scan),
	mach_reset_rdr_pch | pch_brush_impulse | pch_complete,
	pch_scan_emit);

// 32.33.18.1
assign reset_par = pch_scan_emit & ~pch_complete &
	~pch_ser_cy & ~allow_par_adv;

/// XXX pfr_xfer_cy also on page 49
// 42.13.27.1
latch1 u_pfr_xfer_cy(i_clk,
	pfr_trans_cy_req & xfer_cy_req & r0_000_150,
	x_000_075,
	pfr_xfer_cycle);

// XXX pch_command_stored true when col_80 should set latch -> latch2
/// XXX u_pch_buffer_full also on page 67
// 32.33.25.1
latch2 u_pch_buffer_full(i_clk, i_reset,
	(pch_trans_cycle & col_80 & x_300_450) |
		(col_80 & x_300_450 & pch_ser_cy),
mach_reset_rdr_pch |	// XXX hack guess
	~pch_command_stored,
	x_pch_buffer_full_out);
/// XXX u_pch_insert_blank also on page 67
// XXX pch_command_stored usually true; must be latch2.
// 32.33.25.1
wire x_set_pch_insert_blanks =
	~x_pch_buffer_full_out & pch_write & pch_end & x_300_450;
wire x_reset_pch_insert_blanks =
mach_reset_rdr_pch |	// XXX hack guess
	~pch_command_stored | (x_pch_buffer_full_out & x_000_075);
latch1 u_pch_insert_blank(i_clk,
	x_set_pch_insert_blanks & ~x_reset_pch_insert_blanks,
	x_reset_pch_insert_blanks,
	pch_insert_blanks);
// 32.33.25.1
assign pch_insert_blank_cycle = pch_ser_cy & pch_insert_blanks;

//////// page 89
//////// sld-37 punch address register (par)
//////// 5062

wire [4:0] par_units;
wire [4:0] par_tens;
wire par_reset;
wire x_par_advance_units;
wire x_par_advance_tens;

// 32.20.13.1
decade6 u_par_units(i_clk,
	par_reset,
	x_par_advance_units,
	par_units);

// XXX would be straight assignment but pulse must be one clock wide.
// and it must be aligned with x_par_advance_tens -- r0_075
// 32.20.13.1
//pdetect1 u_par_advance_units (i_clk,
//	~block_par_advance & gated_select_pch & r0_000_150,
//	x_par_advance_units);
assign x_par_advance_units = ~block_par_advance & r0_075 & gated_select_pch;

// 32.20.13.1
assign par_reset = reset_par | reset_par_2 | mach_reset_rdr_pch;

// XXX omitting ce set tens logic here.
decade6 u_par_tens(i_clk,
	par_reset,
	x_par_advance_tens,
	par_tens);

// XXX block_rar_and_par_advance mispelled as block_par_and_par_advance in ild
// XXX r0_075 was r0_000_150 but decade step pulse must be one cycle wide.
// 32.20.14.1
assign x_par_advance_tens = gated_select_pch & r0_075 &
	par_units[2] & par_units[0] &	// +C +E
	~block_rar_and_par_advance & ~blk_par_ctrl_col_bin &
	~x_block_par_advance;	// XXX hack

//////// page 90
//////// sld-38 printer interface number 1
//////// 5080

wire no_bits_bus_out_0_thru_4;
wire any_bit_bus_out_0_thru_4;
wire x_prt_address_match;
wire x_2821_addressed_tcs;
wire prt_adapter_reset_tcs;
wire print_carr_mode_ce;
wire load_format_mode_ucb;
wire prt_adapter_reset_1;
wire prt_queued;
wire x_prt_set_adapter_request;
wire prt_interrupt_req;
wire prt_adapter_request_reset;
wire prt_sense_control;
wire print_read_reg_full;
wire x_prt_req_busy_opin_2;
wire cf_allow_intv_req_reset_cf;

// 33.13.53.1
assign no_bits_bus_out_0_thru_4 = &{~bus_out[7:3]};	// -0 -1 -2 -3 -4
// 33.13.53.1
assign any_bit_bus_out_0_thru_4 = |{bus_out[7:3]};	// +0 +1 +2 +3 +4

// 33.13.53.1
assign prt_control_command_gate = any_bit_bus_out_0_thru_4 &
	prt_write_command_gate;
// 33.13.53.1
assign allow_prt_command_gate_prst = prt_write_command_gate;
// 33.13.53.1
assign prt_write_command_gate =
	((~bus_out[4] & ~bus_out[3])		// +3 +4 +1 +2
		| ~bus_out[6] | ~bus_out[5]) &	// x0000xxx
	((~bus_out[6] & ~bus_out[5])		// +1 +2 -0
		| bus_out[7]) &			// 100xxxxx
	(~bus_out[7] | bus_out[6] |		// +0 -1 -2 -3 -4
		bus_out[5] | bus_out[4] | bus_out[3]);
// 33.13.61.1
assign x_prt_address_match = bus_out == PRTADDRESS &
	x_2821_addressed_tcs & prt_adapter_reset_tcs &
	address_out_delay & x_1403_on_line;

// duplicated on page 72
// 33.13.51.1
assign x_1403_on_line = metering_in & ~stor_scan_load_mode_c_e_1 &
	~print_carr_mode_ce & ~load_format_mode_ucb &
	~off_line_ce;

// XXX page 90 logic includes mpr/ucb cases for calculating this,
//	which look to be less efficient ways to get the identical result.
// 33.13.56.l
assign x_prt_req_busy_opin_2 = x_prt_req_busy_opin;

// XXX prt_interv_required is sorta duplicated on page 56
// 33.13.56.1
latch1 u_prt_interv_required(i_clk,
	x_prt_req_busy_opin_2 & ~print_ready & ~not_status_in_sample,
mach_reset_out |	// XXX hack
	x_prt_req_busy_opin_2 & ~not_status_in_sample & print_ready &
		cf_allow_intv_req_reset_cf,
	prt_interven_reqd);

// 33.13.61.1
latch2 u_printer_channel_request(i_clk, i_reset,
	x_prt_address_match,
	not_status_in_sample | prt_adapter_reset_1 | ~prt_op_in,
	prt_channel_request);

// 33.13.41.1
assign prt_command_gate = prt_channel_request & address_in &
	~prt_busy_queued & x_command_out_delayed &
	bus_out_odd_parity;

// 33.13.41.1
assign prt_command_gate_1 = prt_command_gate & ~prt_interven_reqd;

// 33.13.51.1
assign prt_status_selective_reset = prt_adapter_reset |
	prt_status_in & ~prt_status_inhibit & i_service_out;

// 33.13.51.1
latch1 u_prt_queued(i_clk,
	i_command_out & prt_status_in,
	prt_op_in & prt_adapter_request & address_in |
mach_reset_out |	// XXX hack
		prt_status_selective_reset,
	prt_queued);

// 33.13.41.1
assign prt_adapter_request_reset = print_read & byte_cnt_2_a &
		prt_service_in |
	prt_op_in & ~byte_cnt_2 & service_in_delay & ~byte_cnt_1 &
		service_out_delay |
	i_service_out & prt_service_in & prt_sense_control;

// 33.13.32.1
assign x_prt_set_adapter_request = prt_command_stored &	// data interleave mode
		~select_out & ~prt_op_in |
	~select_out & ~prt_op_in & prt_interrupt_req &	// non-stacked status
		~prt_queued |
	prt_queued & ~i_suppress_out & ~select_out &	// stacked status
		~prt_op_in;

// duplicated as "prt adapt reset latch" on page 72
// 33.13.32.1
wire x_n_prt_adapter_reset;
latch1 u_prt_adapter_reset(i_clk,
	i_operational_out,
	~x_1403_on_line | mach_reset_printer |
		prt_op_in & i_suppress_out & ~i_operational_out,
	x_n_prt_adapter_reset);
assign prt_adapter_reset = ~x_n_prt_adapter_reset;

// 33.13.32.1
latch1 u_prt_adapter_request(i_clk,
	x_prt_set_adapter_request & ~sel_out_prop_sel_in & x_1403_on_line,
	~x_prt_set_adapter_request & ~prt_op_in & ~select_out |
		common_request_reset | prt_adapter_request_reset |
		prt_adapter_reset,
	prt_adapter_request);

// 33.13.32.1
latch1 u_prt_interrupt_req(i_clk,
	(prt_channel_end | prt_device_end) &
		~print_read_reg_full | prt_queued,
	prt_adapter_reset | not_status_in_sample,
	prt_interrupt_req);

//////// page 91
//////// sld-39 printer interface number 2
//////// 5081

wire prt_service_request;
wire last_address_clock_3_7_cf;
wire load_format_ucb;
wire addr_240_ucb;
//wire trigger_d_clock_3_7_ucb;
wire addr_132_clock_3_7;
wire x_set_prt_op_in;
wire x_reset_prt_op_in;
wire prt_adapter_request_prt_1;
wire x_set_prt_svc_in;
wire x_set_prt_status_in;
wire x_not_command_service_out_or_sr_out_smp;
wire not_commd_sr_out_smp_pwr_pr3;

// 33.13.71.1
assign prt_service_request = prt_control | prt_sense |
	~(last_address_clock_3_7_cf | (load_format_ucb &
			addr_240_ucb & trigger_d_clock_3_7_ucb) |
		addr_132_clock_3_7) & prt_write & ~prt_write_data_avail;

// XXX prt write data avail here also on page 68

// XXX assume correct polarity on this...?
// 33.13.01.1
assign x_set_prt_op_in = prt_channel_request &	// initial selection
	x_1403_on_line & select_out |
	select_out & select_out_delay &	// interleave mode
	~i_address_out & not_rdr_pch_adapter_request &
	~any_op_in_delayed & prt_adapter_request &
	~prt_adapter_request_prt_1 & ~prt_adapter_request_prt_2;
// 33.13.01.1
latch1 u_prt_op_in(i_clk,
	x_set_prt_op_in & ~sel_out_prop_sel_in,
	sel_out_prop_sel_in | prt_adapter_reset_1 | x_reset_prt_op_in,
	prt_op_in);
// 33.13.01.1
assign x_reset_prt_op_in = x_sop_ending_status |
	x_sop_status_stacked | x_sop_intf_disc | x_sop_status |
	x_sop_interleave_data;

// 33.13.01.1
wire x_sop_ending_status = ~prt_channel_request &	// ending status
		~prt_command_stored & ~prt_interrupt_req & ~select_out;
// 33.13.01.1
wire x_sop_status_stacked =
	~select_out & prt_interrupt_req &		// status if status
		not_status_in_sample;			//  stacked
// 33.13.01.1
wire x_sop_intf_disc =
	~select_out & ~prt_command_stored &		// interface
		i_address_out;				//  disconnect
// 33.13.01.1
wire x_sop_status =
	~select_out & not_status_in_sample &		// status
		~sel_out_burst_sw_on;
// 33.13.01.1
wire x_sop_interleave_data =
	~sel_out_burst_sw_on & ~prt_adapter_request &	// data interleave
		not_service_in_sample;			//  mode data transfer

assign x_not_command_service_out_or_sr_out_smp = ~(~not_command_service_out_smp |
				~not_commd_sr_out_smp_pwr_pr3);

// 33.13.21.1
assign x_set_prt_svc_in = (print_read | ~clock_4_5) &
	x_spi_read |
	x_spi_data_interleave_mode |
	x_spi_burst_mode;

wire x_spi_read = not_command_service_out_smp &		// printer read
		print_read_reg_full & ~suppress_data &
			~prt_interrupt_req;
wire x_spi_data_interleave_mode = ~suppress_data &	// printer data
		~prt_interrupt_req &			//  interleave mode
			prt_adapter_request &
			x_not_command_service_out_or_sr_out_smp &
			prt_service_request & ~prt_channel_request;
wire x_spi_burst_mode = ~prt_channel_request &		// printer burst mode
			~suppress_data & prt_service_request &
			x_not_command_service_out_or_sr_out_smp &
			sel_out_burst_sw_on;

// XXX hack; delay svcin to clear memwrite.
wire prt_svcin_clock_clear = prt_hack[0] ? clock_5_6
	: clock_4_5;
wire x_clear_prt_svc_in = prt_svcin_clock_clear
		| ~prt_write_ctrl & service_out_delay
		| command_out_delay;

// 33.13.21.1
latch1 u_prt_service_in(i_clk,
	x_set_prt_svc_in & prt_op_in,
	~prt_op_in | x_clear_prt_svc_in & ~x_set_prt_svc_in,
	prt_service_in);
// 33.13.21.1
wire x_prt_initial_selection = prt_channel_request & not_command_out_sample;
// 33.13.21.1
wire x_prt_interleave_mode_ending_or_stacked_status = not_command_out_sample &
	prt_adapter_request & prt_interrupt_req;
// 33.13.21.1
wire x_prt_burst_mode_ending_or_stacked_status =
	prt_interrupt_req & sel_out_burst_sw_on &
(x_not_command_out_sample_x |
			x_not_command_service_out_or_sr_out_smp) &
			~prt_adapter_request &
			(select_out | prt_queued | i_suppress_out);
// 33.13.21.1
assign x_set_prt_status_in = x_prt_initial_selection |
	x_prt_interleave_mode_ending_or_stacked_status |
	x_prt_burst_mode_ending_or_stacked_status;

// 33.13.21.1
latch1 u_prt_status_in(i_clk,
	x_set_prt_status_in &
	~prt_service_in & prt_op_in & ~i_service_out &
~service_in_delay & ~x_any_service_in & ~i_command_out & // XXX hack
		~status_in_delay,
	~prt_op_in | command_out_delay | service_out_delay,
	prt_status_in);

//////// page 92
//////// sld-40 storage address register (bar)
//////// 5082

wire [4:0] bar_units;
wire [4:0] units_drive_bar;
wire [4:0] bar_tens;
wire x_bar_advance_units;
wire block_bar_adv;
wire single_cycle_data_enter;
wire clock_0_2;
wire tens_set_reset_control;
wire buffer_scan_reset;
wire c_e_address_reset;
wire set_bar_to_000;
wire tr_1;
wire tr_2;
wire address_set_sw_c_e;
//wire trigger_a_clock_0_4;
wire error_stop;
wire addr_units_e;
wire addr_units_d;
wire addr_units_b;
wire x_bar_advance_tens;
wire single_cycle_mode;
wire write_gate_print_read;
wire bar_100;

// XXX hack: all digits of bar must advance in the same i_clk cycle.
wire b_0_2;
pdetect1 u_0_2(i_clk, clock_0_2, b_0_2);

// 33.23.00.1
assign x_bar_advance_units = ~block_bar_adv & ~single_cycle_data_enter &
	b_0_2;

// 33.23.00.1
assign tens_set_reset_control = c_e_address_reset | set_bar_to_000 |
	mach_reset_printer | tr_1 | buffer_scan_reset;
// 33.23.00.1
assign buffer_scan_reset = load_format_ucb & ~address_set_sw_c_e |
	trigger_a_clock_0_4 & print_gate & stor_scan_load_mode_c_e_1 &
	~error_stop;

wire xxx_set6 = tr_2 & ss_1;
wire xxx_set3 = tr_2 & ~ss_3;

wire xxx_hack_bar_123;
latch1 u_hack_bar_123(i_clk,
	print_tr & gated_pss,
	trigger_e_clock_4_0,
	xxx_hack_bar_123);
wire xxx_hack_block_incr = xxx_hack_bar_123 & ss_1;
wire xxx_hack_block_carry = xxx_hack_bar_123 & ss_2;

// 33.23.00.1
decade14 u_bar_units(i_clk,
	tens_set_reset_control,
	tr_2 & ~ss_3,	// "set0 or 9"
	tr_2 & ss_1,	// "set9"
//YYY ~xxx_hack_block_incr &
	x_bar_advance_units,
	bar_units);

// 33.23.01.1
assign units_drive_bar = {
	print_tr & bar_units_d | ~print_tr & bar_units_a,	// -D -A
	print_tr & bar_units_a | ~print_tr & bar_units_b,	// -A -B
	bar_units_c,						// C
	print_tr & bar_units_e | ~print_tr & bar_units_d,	// -E -D
	print_tr & bar_units_b | ~print_tr & bar_units_e};	// -B -E
wire bar_tens_a;
wire bar_tens_b;
wire bar_tens_c;
wire bar_tens_d;
wire bar_tens_e;
assign {bar_tens_a, bar_tens_b, bar_tens_c, bar_tens_d, bar_tens_e} = bar_tens;
wire bar_units_a;
wire bar_units_b;
wire bar_units_c;
wire bar_units_d;
wire bar_units_e;
assign {bar_units_a, bar_units_b, bar_units_c, bar_units_d, bar_units_e} = bar_units;

// 33.23.02.1
assign x_bar_advance_tens = single_cycle_mode &
	stor_scan_load_mode_c_e_1 & bar_units_c & addr_units_e |
	addr_units_e & bar_units_c & write_gate_print_read |
	addr_units_e & bar_units_c & ~gated_pss & print_scan |
	bar_units_c & print_scan & ~gated_pss & addr_units_d |
	addr_units_d & print_scan & ~gated_pss & addr_units_b;

// XXX omitting ce set tens logic here.
// 33.23.02.1
decade12 u_bar_tens(i_clk,
	tens_set_reset_control,
//YYY ~xxx_hack_block_carry &
b_0_2 &
	x_bar_advance_tens,
	bar_tens);

//////// page 93
//////// sld-41 print character generator
//////// 5083

wire drum_pulse;
wire reset_pcg;
wire advance_by_1;
wire advance_by_2;
wire x_print_read_scan_or_cf;
wire clock_6_0_2_4;
wire print_read_scan_cf;
wire clk_ctrl_tr;		// XXX looks like this
wire clock_ctrl_tr;		//  next one...?
//wire drum_pulse_delayed;
wire pss_trig;
wire pss_trig_ss;

// pss_trig, home_gate & train_ready duplicated with
// more detail on 4083
//delay1 #(DELAY_1500ns) u_drum_pulse(i_clk, i_reset,
//	drum_pulse, drum_pulse_delayed);
//
//// 33.33.00.1
//latch1 u_pss_trig(i_clk,
//	drum_pulse & ~pss_trig_ss,
//	x_clear_pss_trig & pss_trig,
//	pss_trig);
//
//// 33.33.00.1
//ss2 #(TIMEOUT_PSS) u_pss_ss(i_clk, i_reset,
//	pss_trig,
//	pss_trig_ss);
//
//// XXX set inputs here surely shouldn't match pss_trig ?
//// 33.33.00.1
//latch1 u_home_gate(i_clk,
//	drum_pulse & pss_trig_ss,
//	mach_reset_printer | home_gate & ~pss_trig,
//	home_gate);
//
//// 33.33.00.1
//latch1 u_train_ready(i_clk,
//	~pss_trig_ss & home_gate,
//	x_clear_pss | io_check_reset_pr & sync_check | pss_trig_jumper & sync_check,
//	train_ready);
//
// assign gated_pss = pss_trig & train_ready;

// 33.33.20.1
trigger2 u_ss_1(.i_clk(i_clk),
	.i_set_gate(home_gate | ss_3),
	.i_ac_set(gated_pss),
	.i_dc_set(1'b1),
	.i_dc_reset(x_1403_on_line & ~mach_reset_printer),
	.i_ac_reset(gated_pss),
	.i_reset_gate(ss_1),
	.o_out(ss_1));

// 33.33.20.1
trigger2 u_ss_2(.i_clk(i_clk),
	.i_set_gate(ss_1),
	.i_ac_set(gated_pss),
	.i_dc_set(1'b1),
	.i_dc_reset(x_1403_on_line & ~mach_reset_printer),
	.i_ac_reset(gated_pss),
	.i_reset_gate(ss_2 | home_gate),
	.o_out(ss_2));

// 33.33.20.1
trigger2 u_ss_3(.i_clk(i_clk),
	.i_set_gate(ss_2),
	.i_ac_set(gated_pss),
	.i_dc_set(1'b1),
	.i_dc_reset(x_1403_on_line & ~mach_reset_printer),
	.i_ac_reset(gated_pss),
	.i_reset_gate(ss_3 | home_gate),
	.o_out(ss_3));

assign x_print_read_scan_or_cf = ~print_read_scan_cf | ~print_scan;

// XXX duplicated on 69
// 33.33.22.1
assign advance_by_1 = ~x_print_read_scan_or_cf & gated_pss |
	gated_pss_1 & ss_3;

// 33.33.23.1
assign advance_by_2 = ~x_print_read_scan_or_cf &
		~gated_pss & clock_0_2 & ~clk_ctrl_tr |
	tr_2 & ~ss_3 & clock_6_0_2_4 |
	clock_6_0_2_4 & clock_ctrl_tr;

// 33.33.24.1
pcg4 u_pcg1(i_clk,
	reset_pcg,
	advance_by_1,
	advance_by_2,
	pcg);

//////// alds

// 31.11.11.1	out tag line delays

// 31.12.42.1
assign rdr_pch_sense_dly_gate = rdr_sense & rdr_op_in | pch_sense & pch_op_in;

// 32.11.21.1	rdr pch bus in gates+bus in 0,1
assign rdr_status_gate = ~rdr_status_inhibit & rdr_pch_status_in & rdr_op_in;
assign pch_status_gate = ~pch_status_inhibit & rdr_pch_status_in & pch_op_in;
assign rdr_sense_gate = rdr_sense & rdr_op_in & rdr_pch_service_in;
assign pch_sense_gate = rdr_pch_service_in & pch_op_in & pch_sense;

// 32.11.23.1	rdr pch bus in mix 2 and 5
assign rdr_pch_bus_in_status[2] =
	(rdr_device_end & rdr_status_gate) |
	(pch_status_gate & pch_device_end);

// 32.11.24.1	rdr pch bus in mix 3
assign pch_busy_queued = pch_busy | ~pch_channel_end & pch_interrupt_req;
assign rdr_busy_queued = rdr_busy | ~rdr_channel_end & rdr_interrupt_req;

//	previous command in progress or interrupt condition pending
//		command in progress: from initial selection
//		to device end accepted
assign rdr_pch_bus_in_status[4] =
	~(test_io & rdr_interrupt_req & rdr_op_in)
		& rdr_busy_queued
		& rdr_channel_request & rdr_pch_status_in |
	rdr_pch_status_in & pch_channel_request &
		& pch_busy_queued
		& ~(test_io & pch_interrupt_req & pch_op_in);

// 32.11.25.1	rdr pch bus in mix 2 and 5
assign rdr_pch_bus_in_status[3] =
	(rdr_channel_end & rdr_status_gate) |
	(pch_status_gate & pch_channel_end);

// 32.11.27.1	rdr pch bus in mix 7+p
	// reader: endfile & last card has been read and stacked
	// punch: endfile & last card read but not stacked
assign rdr_pch_bus_in_status[0] = unit_exception_rdr & rdr_status_gate |
	pfr_bus_in_7;
// 32.12.02.1	rdr read,control,+sense

assign rdr_command_stored = rdr_read | rdr_control | rdr_sense;

// 32.12.03.1	rdr mod 0+1,rdr queued on init sel
//assign reset_rdr_commd_mod_latch =
//rdr_rdy_and_cmmd_valid & x_cmd_gate_adv | mach_reset_rdr_pch;
assign reset_rdr_commd_mod_latch =
reset_rdr_commd_busy_lat | not_rdr_device_end_smp |
unit_exception_rdr & rdr_pch_status_in;

// 32.12.11.1	rdr adapter request + adapter reset
wire x_2540_reset_from_cpu;

assign x_2540_reset_from_cpu = ~i_suppress_out & x_2540_on_line &
	~i_operational_out;

assign reset_rdr_commd_busy_lat = mach_reset_rdr_pch |
	rdr_adapter_reset & ~i_operational_out & ~read_feed_1;

// 32.12.21.1	rdr busy rdr channel end
wire reset_rar_2;
assign rdr_status_reset = rdr_adapter_reset |
mach_reset_out |	// XXX hack
	rdr_op_in & rdr_pch_status_in & i_service_out & ~rdr_status_inhibit;

// this is actually a wire'd or with reset_rar.
assign reset_rar_2 = pch_command_gate & diagnostic_write |
	rdr_command_gate & rdr_rdy_and_cmmd_valid;

// 32.12.22.1	rdr device end rdr unit check
wire rdr_no_op;

latch1 u_rdr_device_end_smp(i_clk,
	rdr_device_end & rdr_status_reset,
	~rdr_op_in,
	not_rdr_device_end_smp);

assign rdr_no_op = rdr_command_gate & rdr_rdy_and_cmmd_valid &
	no_bits_bus_out_0_through_5 &
	bus_out[1] & bus_out[0];	// -6 -7 00000011

// 32.12.33.1	rdr unusual command sense latch
wire x_two_reads;

assign rdr_sense_bit_6 = rdr_trans_cycle_req & x_525_600 & x_two_reads;

latch1 u_two_reads(i_clk,
	rdr_op_in & i_command_out & rdr_pch_service_in & rdr_read |
		~col_binary_1 & rdr_trans_cycle & col_80 & x_450_525,
	rdr_adapter_reset | ~read_check_read,
	x_two_reads);

latch1 u_unusual_command(i_clk,
	rdr_sense_bit_6,
	reset_rdr_sense_latches,
	rdr_unusual_command);

// 32.12.40.1	read feed ce control
wire x_rdr_check_error;
wire rd_chk_err_stop_on_line;

assign x_rdr_check_error = rdr_sense_bit_3 | read_val_chk;
assign rd_chk_err_stop_on_line = x_rdr_check_error & rdr_busy & stop_sw;

// 32.12.42.1	rdr interrupt req, queued, ready end
//assign rdr_status_inhibit = ~service_out_delay;
assign rdr_status_inhibit = rdr_busy & ~rdr_interrupt_req;

// 32.13.02.1	pch write,sense,

// must assert reset_pch_commd_mod_latch *before* pch_command_gate.
//	otherwise pch_write pch_sense etc. aren't set right.
assign reset_pch_commd_mod_latch =
reset_pch_commd_busy_lat | not_pch_dvc_end_samp | pfr_reset_pch_cmmd_lat;

// 32.13.03.1	pch 0 bit modifier pch 1 bit mod
wire pch_0_bit_mod;

// modifies write - select stacker RP3
latch1 u_pch_0_bit_mod(i_clk,
	pch_command_gate & bus_out[7] &			// +0/-0
		pch_rdy_and_cmmd_valid,
	reset_pch_commd_mod_latch,
	pch_0_bit_mod);

// modifies write - select stacker P2
latch1 u_pch_1_bit_mod(i_clk,
	pch_command_gate & bus_out[6] &			// +1/-1
		pch_rdy_and_cmmd_valid,
	reset_pch_commd_mod_latch,
	pch_1_bit_mod);

// 32.13.21.1	pch busy pch channel end
assign pch_status_reset = pch_adapter_reset |
power_on_reset |	// XXX hack
	pch_op_in & i_service_out & rdr_pch_status_in & ~pch_status_inhibit;

assign x_other_pch_busy = pch_queued & pch_channel_end;
assign xxx2_x_reset_pch_busy = pch_device_end | mach_reset_rdr_pch;
assign xxx_x_reset_pch_busy = reset_pch_commd_busy_lat | not_pch_device_end_smp;
wire xxx_x_reset_pch_busy, xxx2_x_reset_pch_busy;
assign x_reset_pch_busy = reset_pch_commd_busy_lat | not_pch_device_end_smp;

// 32.13.22.1	pch device end pch unit check
wire pch_no_op;
wire x_pch_ready_transition;

latch1 u_pch_dvc_end_smp(i_clk,
	pch_device_end & pch_status_reset,
	~pch_op_in,
	not_pch_device_end_smp);

assign pch_no_op = pch_command_gate & pch_rdy_and_cmmd_valid &
	bus_out[0] & bus_out[1];	// +5 -6 -7 00000011

assign x_pch_ready_transition =
	~interface_pch_ready_latch & x_2540_on_line & ~pch_interven_reqd;

// 32.13.31.1	pch command reject +bus out check

// 32.13.32.1	punch feed ce control
wire x_pch_check_error;

assign pch_check_error_stop_on_line = x_pch_check_error & check_stop & pch_busy;
assign pch_chk_err_stop_off_line = check_stop & x_pch_check_error;

assign x_pch_check_error = (pch_chk | pch_sense_bit_3 | pch_sense_bit_4 |
		(pch_ser_cy & parity_chk));

// 32.13.33.1	pch data chk,eqmt chk,interv reqd
wire pch_ready;

// XXX pch_feed is not isolated; need to feed both ways.
assign pch_feed_p_u = x_punch_feed |
	~pch_bus_out_check & pch_end & ~pch_complete & ~diagnostic_write;
assign pch_feed = pch_feed_p_u;

assign pch_ready = punch_ready;

// 32.13.42.1	pch interrupt req,queued,ready,end
assign pch_status_inhibit = pch_busy & ~pch_interrupt_req;

// 32.20.01.1	reader-punch buffer clock
//		triggers
//	time	abcde		time	abcde
//	000	10000		300	01111
//	075	11000		375	00111
//	150	11100		450	00011
//	225	11110		525	00001
reg trigger_a, trigger_b, trigger_c, trigger_d, trigger_e;
always @(posedge i_clk) begin
	if (i_reset)
		{trigger_a, trigger_b, trigger_c, trigger_d, trigger_e} <= 0;
	else if (osc)
		{trigger_a, trigger_b, trigger_c, trigger_d, trigger_e} <=
			{~trigger_d, trigger_a, trigger_b, trigger_c,
				trigger_d};
end

assign mach_reset_rdr_pch = power_on_reset | x_2540_reset_from_cpu |
	mach_reset_ce;

// 32.20.02.1	reader punch buffer timings
wire read_strobe;

assign inhibit_375_000 = ~trigger_b & trigger_e & allow_cycle;
assign r0_000_150 = trigger_a & ~trigger_c & allow_cycle;
assign read_strobe = ~buffer_entry_2 & ~trigger_d & trigger_c & allow_cycle;
assign block_sa_output_ctl = (~column_binary_2 & pch_trans_cycle |
		pch_insert_blank_cycle)
        & x_150_300;

// 32.20.03.1	clock times #1
wire x_150_375;
assign x_075_150 = trigger_b & ~trigger_c;
assign x_150_375 = trigger_b & trigger_c;
assign x_150_300 = trigger_c & ~trigger_e;
assign x_300_150 = ~x_150_300;
assign x_300_375 = trigger_b & trigger_e;
//assign x_150_450 = trigger_c;
assign x_300_525 = trigger_d & trigger_e;
assign x_300_450 = trigger_c & trigger_e;

// 32.20.04.1	clock times #2
assign x_000_075 = trigger_a & ~trigger_b;
assign x_375_450 = ~trigger_b & trigger_c;
assign x_225_375 = trigger_b & trigger_d;
assign x_225_300 = trigger_a & trigger_d;
assign x_450_525 = ~trigger_c & trigger_d;
assign x_525_600 = ~trigger_a & ~trigger_d;
assign x_525_075 = ~trigger_b & ~trigger_d;

// 32.20.16.1	read+punch buffer bias drive sheet
// 32.20.17.1	read+punch buffer bias drive sheet 3
assign car = {rar_tens, rar_units} & {10{rdr_select}} |
	{10{pch_select}} & {par_tens, par_units};

assign pch_select_or_pch_trans = pch_trans_cycle | pch_select;

// 32.20.45.1	inhibit current yu and yl

assign addr_reg_000 = car[0] & car[1] & car[6] & car[5];	// DE DE

// 32.20.52.1	data reg parity check

assign check_reset = power_on_reset | check_reset_ce;

assign data_reg_par_check_gated = ~addr_reg_000 & x_375_450 &
	~pch_trans_cycle & data_reg_parity_check &
	~(col_bin_blk_parity_check | pfr_not_12_pch_ser_cycle |
		~allow_cycle | x_9_read_ser_cycle);

latch1 u_parity_check(i_clk,
	data_reg_parity_check,
	check_reset,
	parity_chk);

//assign data_reg_parity_check = ~^{data_reg_p, data_reg};

// 32.20.622.1	reader xlate gating no. 2
assign any_bit = |{data_reg};

// 32.20.67.1	read translate and chan reg compare

// XXX isn't this o_punch_xlate_check_light ?
latch1 u_punch_translate_check(i_clk,
	pch_translate_check,
	check_reset | mach_reset_rdr_pch |
		x_450_525 & diagnostic_pch_chk_cycle,
	punch_translate_check);

// 32.31.01.1	row bit line receivers
wire x_4_bit_mod_pull_on;
wire pfr_unit_exception;

assign pch_row_bit_ser_cycle = c_pch_chk_row_bit;
assign gate_rd_complete_2540 = i_gate_rd_complete_2540;
assign rd_1_ser_cy = i_rd_1_row_bit & rd_ser_cycle;

assign pch_brush_impulse = i_pch_brush_impulse;

assign rdr_cl_lat_not_npro = i_rdr_cl_lat_not_npro;
assign pch_cl_lat_not_npro = i_pch_cl_lat_not_npro;
assign x_4_bit_mod_pull_on = i_4_bit_mod_pull_on;

latch1 u_pfr_unit_excep_lat(i_clk,
	pch_read & pch_command_gate & i_pfr_unit_exception_gate,
	pch_status_reset,
	pfr_unit_exception);

// 32.31.02.1	sig lines termination rdr-pch to icu
assign punch_ready = i_punch_ready;
assign reader_ready = i_reader_ready;
assign die_cl_dly = i_die_cl_delay;

wire unit_exception_rdr;
wire pch_clutch_set;

assign pch_br_cl_delay = i_pch_brush_cl_delay_int;

// captures "endfile" from card reader
// (reader) "endfile" pressed and last card has been read and stacked
// (pfr) "endfile" pressed last card has been read but not stacked
// if endfile not pressed, then before this happens, the "empty-hopper"
// condition sets intervention req'd and all operations stop
// with the last few cards still in the read or punch path.
//
latch1 u_unit_except_rdr(i_clk,
	rdr_read & rdr_command_gate & c_unit_exception |
	x_2540_on_line & x_1400_comp_prov_feed &
		rdr_trans_cycle & c_1400_unit_exception_gate,
	rdr_status_reset,
	unit_exception_rdr);

assign pch_clutch_set = i_pch_clutch_set;

// 32.31.04.1	signal lines icu to rdr pch no. 1

assign o_punch_restart_gate = pch_stk_inh | pch_4_bit_mod;
assign o_read_cycle = rd_ser_cycle;
assign o_unit_exception_rdr = unit_exception_rdr;
assign o_time_150_450 = trigger_c;
assign o_time_150_375 = x_150_375;
assign o_time_075_150 = x_075_150;
assign o_pch_write = ~pch_complete & (pch_channel_request | pch_command_stored);
assign o_rdr_feed_command = rdr_feed_command;
assign o_time_225_525 = trigger_d;
assign o_xfer_cy_req = xfer_cy_req;
assign o_mach_reset_rdr_pch = mach_reset_rdr_pch;
assign o_power_on_reset = power_on_reset;

// 32.31.05.1	last address and check plane ctrl
assign i2_read_ser_cycle = ~rd_ctr_a & ~rd_ctr_f & rd_ser_cycle;
assign x_9_read_ser_cycle =  rd_ctr_a & ~rd_ctr_b & rd_ser_cycle;
assign hole_count_xfer = x_9_read_ser_cycle | i2_pch_ser_cycle;
assign i2_pch_ser_cycle = pch_ser_cy & ~pch_ctr_b & pch_ctr_a;	// 12 not i2 ??

// don't need to decode '0' in 80.
assign col_80 = car[7] & car[6];	// c & d

// 32.31.07.1	rd-pch complete

latch1 u_pch_feeding(i_clk,
	pch_feed,
	mach_reset_rdr_pch | not_pch_device_end_smp,
	pch_feeding);

latch1 u_rdr_feeding(i_clk,
	read_feed,
	not_rdr_device_end_smp | mach_reset_rdr_pch,
	rdr_feeding);

// 32.32.11.1	reader time counter
wire rd_ctr_c;
wire rd_ctr_d;
wire rd_ctr_e;

assign {rd_ctr_a,rd_ctr_b,rd_ctr_c,rd_ctr_d,rd_ctr_e,rd_ctr_f} =
	read_time_counter;

// 32.32.13.1
assign rd_xfer_cy_or_ser_cy = rd_ser_cycle | rdr_trans_cycle;

// 32.33.11.1 32.33.12.1	punch time counter
wire pch_ctr_a;
wire pch_ctr_b;
wire pch_ctr_c;
wire pch_ctr_d;
wire pch_ctr_e;
wire pch_ctr_f;
assign {pch_ctr_a,pch_ctr_b,pch_ctr_c,pch_ctr_d,pch_ctr_e,pch_ctr_f} =
	pch_time_counter;

// 32.33.15.1	punch compare 12,11,0,1,2,3,5 and6
assign emit_7_pch = ~pch_ctr_d & pch_ctr_e;

// 32.33.16.1	punch compare 4, 7, 8 and 9 + ce
assign emit_8_pch = ~pch_ctr_e & pch_ctr_f;

latch1 u_punch_check(i_clk,
	pch_select & x_375_450 & after_9_pch_ser_cycle &
			punch_hole_count_check |
		punch_hole_count_check & x_375_450 & pch_select & storage_scan,
	check_reset,
	pch_chk);

// 32.33.22.1	punch stacker inhibit 3 latch
wire pch_stk_inh;
// XXX ald shows 2 pch_stk_inh lines.  One of is wire-or'd with just
// x_seq_2_p2_out; it is not otherwise used.
assign pch_stk_inh = pch_stk_inh_3_lat;

// 32.33.23.1	punch stack select p2
wire x_seq_1_p2_set;
wire x_seq_2_p2_set;
wire x_seq_3_p2_set;
wire x_seq_4_p2_set;
wire seq_1_reset;
wire x_seq_2_p2_reset;
wire x_seq_3_p2_reset;
wire x_seq_4_p2_reset;
wire x_seq_1_p2_out;
wire x_seq_2_p2_out;
wire x_seq_3_p2_out;
wire x_seq_4_p2_out;
wire stacker_p2;
wire clutch_set_emitter;

assign seq_1_reset = pch_ready & after_9_pch_ser_cycle;

assign x_seq_1_p2_set = pch_1_bit_mod & ~pch_3_bit_modifier & ~pch_stk_inh &
		~pch_0_bit_mod & after_9_emitter;

latch1 u_seq_1_p2(i_clk,
	x_seq_1_p2_set,
	seq_1_reset | mach_reset_rdr_pch,
	x_seq_1_p2_out);

assign x_seq_2_p2_set = pch_1_bit_mod & ~pch_0_bit_mod &
			pch_3_bit_modifier & pch_ctr_f & ~pch_ctr_e |
		x_seq_1_p2_out & pch_ctr_f & ~pch_ctr_e;

latch1 u_seq_2_p2(i_clk,
	x_seq_2_p2_set,
	x_seq_2_p2_reset | pch_stk_inh | mach_reset_rdr_pch,
	x_seq_2_p2_out);

assign x_seq_2_p2_reset = ~clutch_set_emitter & x_seq_3_p2_out;

assign x_seq_3_p2_set = pch_clutch_set & ~pch_stk_inh & x_seq_2_p2_out;
latch1 u_seq_3_p2(i_clk,
	x_seq_3_p2_set,
	x_seq_3_p2_reset | mach_reset_rdr_pch,
	x_seq_3_p2_out);
assign x_seq_3_p2_reset = x_seq_4_p2_out & ~clutch_set_emitter;
assign x_seq_4_p2_set = pch_clutch_set & ~x_seq_2_p2_out & x_seq_3_p2_out;
latch1 u_seq_4_p2(i_clk,
	x_seq_4_p2_set,
	x_seq_4_p2_reset | mach_reset_rdr_pch,
	x_seq_4_p2_out);
assign x_seq_4_p2_reset = pch_clutch_set & ~x_seq_3_p2_out;

assign stacker_p2 = stacker_p3 | x_seq_4_p2_out;

// 32.33.24.1	punch stacker select p3
wire x_seq_1_p3_set;
wire x_seq_2_p3_set;
wire x_seq_3_p3_set;
wire x_seq_4_p3_set;
wire x_seq_2_p3_reset;
wire x_seq_3_p3_reset;
wire x_seq_4_p3_reset;
wire x_seq_1_p3_out;
wire x_seq_2_p3_out;
wire x_seq_3_p3_out;
wire x_seq_4_p3_out;
wire stacker_p3;

assign x_seq_1_p3_set = ~pch_1_bit_mod & ~pch_3_bit_modifier & ~pch_stk_inh &
		pch_0_bit_mod & after_9_emitter;

latch1 u_seq_1_p3(i_clk,
	x_seq_1_p3_set,
	seq_1_reset | mach_reset_rdr_pch,
	x_seq_1_p3_out);

assign x_seq_2_p3_set = ~pch_1_bit_mod & pch_0_bit_mod &
			pch_3_bit_modifier & pch_ctr_f & ~pch_ctr_e |
		x_seq_1_p3_out & pch_ctr_f & ~pch_ctr_e;

latch1 u_seq_2_p3(i_clk,
	x_seq_2_p3_set,
	pch_stk_inh | x_seq_2_p3_reset | mach_reset_rdr_pch,
	x_seq_2_p3_out);

assign x_seq_2_p3_reset = ~clutch_set_emitter & x_seq_3_p3_out;

assign x_seq_3_p3_set = pch_clutch_set & x_seq_2_p3_out;
latch1 u_seq_3_p3(i_clk,
	x_seq_3_p3_set,
	x_seq_3_p3_reset | mach_reset_rdr_pch,
	x_seq_3_p3_out);
assign x_seq_3_p3_reset = x_seq_4_p3_out & ~clutch_set_emitter;
assign x_seq_4_p3_set = pch_clutch_set & ~x_seq_2_p3_out & x_seq_3_p3_out;
latch1 u_seq_4_p3(.i_clk(i_clk),
	.i_set(x_seq_4_p3_set),
	.i_clear(x_seq_4_p3_reset | mach_reset_rdr_pch),
//	.o_out(x_seq_4_p3_out));
	.o_out(xxx_s4p3out));
// XXX need to delay x_seq_4_p3_out to avoid race...
//assign x_seq_4_p3_out = xxx_s4p3out;
wire xxx_s4p3out;
reg xxx_s4p3temp;
always @(posedge i_clk) begin
	xxx_s4p3temp <= xxx_s4p3out;
end
assign x_seq_4_p3_out = xxx_s4p3temp;
assign x_seq_4_p3_reset = pch_clutch_set & ~x_seq_3_p3_out;

assign stacker_p3 = x_seq_4_p3_out;

assign clutch_set_emitter = pch_clutch_set;

// 33.13.11.1	prt command latches

assign prt_sense_control = prt_sense | prt_control;
assign prt_write_ctrl = prt_write | prt_control;

// 33.13.12.1	prt read and write latches
wire print_data_read;

latch1 u_printer_data_read_latch(i_clk,
	~bus_out[0] & bus_out[1] & prt_command_gate_1 &	// -5 +6 -7
		no_bits_bus_out_0_thru_4 & ~bus_out[2],	// match: 00000010
	reset_prt_read,
	print_data_read);

// 33.13.13.1	diagnostic write, check read latches
wire diag_write_tie_down;
wire print_check_read;

latch1 u_diagnostic_prt_write(i_clk,
	prt_command_gate_1 & prt_write & bus_out[2],
	carriage_ending | mach_reset_printer,
	diagnostic_print_write);

assign diagnostic_write_reset = diagnostic_print_write &
	diag_write_tie_down & write_gate;

assign print_read = print_check_read | print_data_read;

latch1 u_prt_check_read_latch(i_clk,
	~bus_out[0] & bus_out[1] & bus_out[2] &		// +5 +6 -7
		no_bits_bus_out_0_thru_4 & prt_command_gate_1,
	reset_prt_read,					// match: 00000110
	print_check_read);

// 33.13.32.1	prt adapt req,reset,interrupt req
wire reset_prt_read;

assign reset_prt_read = prt_op_in & disconnect & prt_channel_end |
	prt_adapter_reset |
	(i_command_out | i_service_out) & prt_channel_end & prt_service_in;

// 33.13.41.1	4 byte control and prt command gate
wire prt_mach_reset_1;

assign prt_mach_reset_1 = power_on_reset |
	x_1403_on_line & ~i_suppress_out & ~i_operational_out |
	c_e_mach_reset;

// 33.13.51.1	prt queued,busy-1403 online ctrl

assign reset_write_gate = ~prt_busy & x_1403_on_line | mach_reset_printer;
assign reset_print_gate = reset_write_gate;

latch1 u_prt_ctrl_extended(i_clk,
	prt_control,
	prt_adapter_reset | not_prt_device_end_smp,
	prt_ctrl_extended);

// 33.13.53.1	printer status latches
wire prt_unit_exception;
latch1 u_prt_unit_excep(i_clk,
	brush_12 & gated_prt_end,
	prt_status_selective_reset,
	prt_unit_exception);

// 33.13.54.1	printer ch end and device end status
wire x_prt_sel_reset_delayed;
wire x_set_chan_and_dev_end;
wire prt_no_op_extended;

// XXX ild gives 2 examples page 62 and 68, neither much like the ald.
latch1 u_prt_chan_end(i_clk,
	x_set_chan_and_dev_end |
//		addr_240 & load_format_ucb & prt_write & clock_5_7_ucb |
		i_command_out & prt_service_in |
		trigger_d_clock_3_7 & prt_control |
		prt_write & addr_132_smp |
		prt_control & stl_mode |
		disconnect & prt_command_stored & prt_op_in |
		x_prt_no_op,
	prt_status_selective_reset,
	prt_channel_end);

delay1 #(1) u_prt_sel_reset_delayed(i_clk, mach_reset_out,
	prt_status_selective_reset,
	x_prt_sel_reset_delayed);

assign x_set_chan_and_dev_end = i_service_out & prt_sense & prt_service_in |
	addr_132_smp & print_read;

/// XXX not really the same as ild page 62 or page 70
latch1 u_prt_device_end(i_clk,
	x_set_chan_and_dev_end |
		x_prt_no_op |
		initial_prt_ready |
		i_command_out & prt_service_in & print_read |
		~status_in_extended & ~prt_command_stored &
			prt_busy & print_complete,
	x_prt_sel_reset_delayed,
	prt_device_end);

latch1 u_prt_no_op_extended(i_clk,
	x_prt_no_op,
	prt_adapter_reset | not_prt_device_end_smp,
	prt_no_op_extended);

// 33.13.53.1	printer status latches
wire print_read_sense;

assign print_read_sense = print_data_read | print_check_read | prt_sense;

// 33.13.56.1	prt unit ck,interv reqd,initial rdy
wire initial_prt_ready;
wire x_init_prt_rdy_out;
wire x_prt_no_op;

latch1 u_initial_prt_ready(i_clk,
	i_service_out & prt_status_in & ~prt_interven_reqd,
	prt_adapter_reset | prt_interven_reqd,
	x_init_prt_rdy_out);

assign initial_prt_ready = x_1403_on_line & ~prt_interven_reqd &
	~x_init_prt_rdy_out;

assign x_prt_no_op = po_prt_no_op |
	no_bits_bus_out_0_thru_4 & bus_out[1] &		// +5 -6 -7
		bus_out[0] & ~bus_out[2] &		// match: 00000011
		prt_command_gate_1;

// 33.13.61.1	printer sense latches + chan req

wire brush_9;
wire brush_12;

latch1 u_prt_brush_9(i_clk,
	carr_brush_9_set,
	prt_sense_reset,
	brush_9);

latch1 u_prt_brush_12(i_clk,
	carr_brush_12_set,
	prt_sense_reset,
	brush_12);

// 33.13.62.1	prt invalid cmmd prt. bus out chk

assign gated_prt_end = ~prt_no_op_extended & ~prt_command_stored &
	prt_busy & ~prt_status_in & ~prt_sense_extended;

assign stl_turn_on_prt_complete = clock_2_4 & prt_control;

// 33.13.71.1	print control gates
wire print_check_read_gate_in;
wire print_data_read_gate_in;

assign prt_status_inhibit = prt_busy & ~prt_interrupt_req;
assign prt_status_gate_in = prt_status_in & ~prt_status_inhibit;
// see page 22 - TC-10 - item 18
assign prt_address_gate_in = prt_op_in & address_in;
assign print_check_read_gate_in = proceed & print_check_read & prt_service_in;
assign print_data_read_gate_in = proceed & print_data_read & prt_service_in;

latch1 u_prt_read_reg_full(i_clk,
	clock_4_5 & print_read,
	~print_read & prt_service_in |		// XXX might not be right
		prt_service_in & i_service_out |
		~prt_op_in,
	print_read_reg_full);
assign prt_sense_gate_in = prt_sense & prt_service_in;

// 33.13.83.1	prt bus in mix 2-3

assign prt_bus_in_status[4] =
	~(test_io & prt_interrupt_req & prt_op_in)
		& prt_busy_queued
		& prt_channel_request & prt_status_in;

assign prt_busy_queued = ~prt_channel_end & prt_interrupt_req | prt_busy;

// 33.13.84.1	prt bus in mix 4 and 5

assign prt_bus_in_status[3] = prt_channel_end & prt_status_gate_in;
assign prt_bus_in_status[2] = prt_device_end & prt_status_gate_in;

// 33.13.85.1	prt bus in mix 6.7 and p

// ILD doesn't indicate a brush 12 possibility here.
assign prt_bus_in_status[0] = prt_status_gate_in & prt_device_end &
	prt_unit_exception;

assign prt_bus_in_sense[0] = prt_sense_gate_in & brush_9;

latch1 u_prt_sense_extd(i_clk,
	prt_sense,
	not_prt_device_end_smp | prt_adapter_reset,
	prt_sense_extended);

// 33.13.85.1 33.13.82.1 33.13.84.1 33.13.83.1	prt bus in mix
wire [8:0] prt_bus_in_check;
wire [8:0] prt_bus_in_data;

assign prt_bus_in_address = parity_addr(PRTADDRESS,prt_address_gate_in);
assign prt_bus_in_check = {print_line_complete_tr,print_check_tr,
		prt_parity_check_latch} &
	{8{print_check_read_gate_in}};
assign prt_bus_in_data = print_buffer_bits & {8{print_data_read_gate_in}};

// 33.23.03.1	storage tens bias drive
wire last_address_pr;	// XXX not the same as rp "last address"

assign tens_address_13 = bar_tens_b & bar_tens_e & bar_100;	// H B E
assign last_address_pr = addr_units_a & addr_units_e & tens_address_13;
assign addr_132_smp = last_address_pr & clock_5_7;
assign addr_132_clock_3_7 = last_address_pr & trigger_d_clock_3_7;

// 33.23.05.1	buffer data reg 1,2,4 and inhibits
wire [6:0] x_print_xlate;
wire [6:0] x_print_in;
wire print_buffer_c_bit;
wire print_buffer_b_bit;
wire print_buffer_a_bit;
wire print_buffer_8_bit;
wire print_buffer_4_bit;
wire print_buffer_2_bit;
wire print_buffer_1_bit;

assign { print_buffer_c_bit,print_buffer_b_bit,
	print_buffer_a_bit,print_buffer_8_bit,print_buffer_4_bit,
	print_buffer_2_bit,print_buffer_1_bit } =
		print_buffer_data_reg;

assign x_print_xlate = {~^{x_print_translate_out},
	x_print_translate_out} & {7{buffer_entry_on_line}};
assign x_print_in = ({buffer_blank_insert, 6'b0} | print_buffer_data_reg)
	& {7{clock_5_0}};

// 33.23.07.1	buffer register c, plc and inhibits
wire sa_pc;
wire sa_ec;
wire sa_hf;
wire sa_ecd;
wire sa_plc;
wire inh_current_pc;
wire inh_current_ec;
wire inh_current_hf;
wire inh_current_ecd;
wire inh_current_plc;
wire x_ecd_out;
wire equal_check_tr_1;
wire equal_check_tr_2;

latch1 u_plc_tr(i_clk, sa_plc, clock_0_2, print_line_complete_tr);

assign inh_current_plc = ~(print_line_complete_inh & clock_5_0);

// 33.23.08.1	buffer reg check planes and inhibits
wire x_equal_chk_out;
wire x_print_check_tr_out;

latch1 u_pr_chk(i_clk, sa_pc, clock_0_2, x_print_check_tr_out);

assign print_check_tr = io_check_reset_pr | x_print_check_tr_out;

assign inh_current_pc = ~(print_error_chk_inh & clock_5_0);

assign inh_current_ecd = ~(x_equal_chk_out & clock_5_0);

latch1 u_equal_chk(i_clk, sa_ec, clock_0_2, x_equal_chk_out);

assign inh_current_ec = ~(equal_check_inh & clock_5_0);

latch1 u_ham_fire(i_clk, sa_hf, clock_0_2, hammer_fire_tr);

assign inh_current_hf = ~(x_60_volt_sense & clock_5_0);

latch1 u_eq_chk_del(i_clk, sa_ecd, clock_0_2, x_ecd_out);

assign equal_check_tr_1 = x_equal_chk_out;		// -y
assign equal_check_tr_2 = x_equal_chk_out | x_ecd_out;	// +y

// 33.23.09.1 sw core matrix-vr control-load cds
wire sense_gate_gen;

assign sense_gate_gen = read_strobe_pr;

// 33.23.11.1	print line complete check
wire single_line_print;
wire reset_print_ready_1;
wire x_single_cycle_out;
wire x_line_full_and_end_scan;
wire block_print_compare;	// m7 feature

latch1 u_single_cycle(i_clk,
	single_cycle_key,
	~single_cycle_key & ~print_ready | mach_reset_printer,
	x_single_cycle_out);

ss2 #(TIMEOUT_10us) u_single_line_print(i_clk, i_reset,
	x_single_cycle_out,
	single_line_print);

assign reset_print_ready_1 = x_single_cycle_out & print_scan;	// wire or'd.

assign x_line_full_and_end_scan = ~print_scan | line_full;
assign unprintable_character = unprintable_character_gate_ucb &
	(~print_buffer_4_bit & ~print_buffer_1_bit & ~print_buffer_2_bit &
		~print_buffer_8_bit & x_line_full_and_end_scan |
	(print_buffer_2_bit | print_buffer_1_bit) & ~gnd_tie_off_ucb &
		print_buffer_8_bit &
		print_buffer_4_bit & x_line_full_and_end_scan);

// XXX supply missing terms for page 72 (print_line_complete_inh)
wire x_more_plc_terms = ~unprintable_character & ~pr_compare & ~block_print_compare;

// 33.32.01.1	slow brush latches 1-8
// 33.32.02.1	slow brush latches 9-12

reg [11:0] slow_brush_latches;

always @(posedge i_clk) begin
	if (mach_reset_printer)
		slow_brush_latches <= 0;
	else
		slow_brush_latches = (slow_brush_latches & ~
			i_stop_brushes) | i_slow_brushes;
end

// 33.32.03.1	integrated stop brushes 1-12
// input stop_brushes should go through an "integrator'
// (low pass filter), then a driver.  debounce/deglitchness.

wire int_stop_br_1, int_stop_br_2, int_stop_br_4;
wire int_stop_br_9, int_stop_br_12;
assign int_stop_br_1 = stop_brushes[11];
assign int_stop_br_2 = stop_brushes[10];
assign int_stop_br_4 = stop_brushes[8];
assign int_stop_br_9 = stop_brushes[3];
assign int_stop_br_12 = stop_brushes[0];

// 33.32.04.1	stop brush encoder and 9 and 12

wire carr_brush_12_set;
wire carr_brush_9_set;

assign carr_brush_12_set = skip_ctrl & int_stop_br_12 & carr_brush_reg_set;
assign carr_brush_9_set = skip_ctrl & int_stop_br_9 & carr_brush_reg_set;

// 33.32.13.1	sp restore

latch1 u_restore_key_latch(i_clk,
	restore_key,
	~low_speed_go & ~restore_key,
	restore_key_latch);

latch1 u_space_key_latch(i_clk,
	space_key,
	~space_key,
	space_key_latch);

// 33.32.14.1	space 1,2,3-carr go forms ck lat

assign o_forms_check_ind = forms_check_latch;
assign o_end_of_forms_ind = end_of_forms;

// 33.32.16.1	slow brush decode and meter run

assign o_print = x_1403_on_line & print_tr;

// 33.33.01.1	start-run latches machine reset
wire power_on_reset;
wire c_e_mach_reset;
wire print_start_latch;

// XXX ald has reset*nmpr | reset*mpr - neither is shown.
assign power_on_reset = mach_reset_out;

assign c_e_mach_reset = i_ce_mach_reset;

assign mach_reset_printer = prt_mach_reset_1;

latch1 u_forms_ck_latch(i_clk,
	forms_check_or_carr_stop & ~single_cycle_print |
		int_stop_br_1 & int_stop_br_2 & int_stop_br_4 |
		end_of_forms & ~stl_mode & int_stop_br_1,
	mach_reset_printer | check_reset_prt,
	forms_check_latch);

latch1 u_print_start_lat(i_clk,
	single_line_print | prt_start_key,
	~prt_start_key | mach_reset_printer,
	print_start_latch);

assign print_ready_ind_ce = print_ready;

// 33.33.02.1	print sub scan start
wire print_sub_scan_start;

assign print_sub_scan_start = print_tr & gated_pss_1;

// 33.33.03.1	printer busy, print scan write gate
wire x_addr_start_ss_cont_errstop;
wire gate_write_tr_off;

assign x_addr_start_ss_cont_errstop = ~addr_carr_set_on_line &
		start_latch &
		stor_scan_load_mode_c_e_1;
wire x_prt_busy_write;
assign x_prt_busy_write = prt_busy & prt_write;
wire x_start_adrstoconterrstop;
assign x_start_adrstoconterrstop = ~stor_scan_load_mode_c_e_1 &
	start_latch & stor_scan_load_mode_c_e_1 & continuous_mode & ~error_stop;
assign gate_write_tr_off_ucb = stor_scan_load_mode_c_e_1 &
	x_start_adrstoconterrstop | print_gate;
assign write_gate_print_read = print_data_read | print_check_read | write_gate;
assign single_cycle_mode = single_cycle_mode_ce;

latch1 u_print_complete(i_clk,
	carriage_ending | mach_reset_printer | stl_turn_on_prt_complete,
	x_1403_on_line & write_gate | prt_command_gate & prt_control,
	print_complete);

assign gate_write_tr_off = gate_write_tr_off_ucb |
	stor_scan_load_mode_c_e & x_write_gate_dcset | print_gate;

assign o_sync_check_ind = sync_check;
assign o_print_check_ind = parity_hammer_check;
endmodule
