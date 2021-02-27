`default_nettype   none
`timescale 10ns / 1ns
module tb;
	reg clk, rst;

	// bus and tag
	wire [8:0] bus_out;
	wire [8:0] bus_in;
	reg address_out;
	reg command_out;
	reg service_out;
	reg data_out;
	wire address_in;
	wire status_in;
	wire service_in;
/* verilator lint_off UNUSED */
	wire data_in;
	wire disc_in;
/* verilator lint_on UNUSED */
	reg operational_out;
	reg select_out;
	reg hold_out;
	reg suppress_out;
	wire operational_in;
	wire select_in;
/* verilator lint_off UNUSED */
	wire request_in;
/* verilator lint_on UNUSED */

localparam [7:0] test_dev = 12;

	reg load_and_single_cycle_sw;
	reg ce_2540_off_line_sw;
	reg ce_mach_reset;
	// 2821
	reg burst_sw_on;
	reg one_byte_sw_on;
	wire data_enter_no;
	reg data_enter_sw;
	reg [7:0] data_enter_0_7;
	// 2540
	// icu -> rdr pch
	wire [9:0] rpaddr;
	wire [6:0] rpaddr_binary;
	wire read_feed;
	wire punch_feed;
	wire power_on_reset;
	wire mach_reset_rdr_pch;
	wire time_075_150;
	wire time_150_375;
	wire xfer_cy_req;
	wire unit_exception_rdr;
	wire pch_write;
	wire rdr_feed_command;
	wire punch_cycle;
	wire read_cycle;
	wire time_150_450;
	wire time_225_525;
	wire x_2821_rdr_ready_turn_off;
	wire x_2821_pch_ready_turn_off;
	wire punch_restart_gate;
	wire punch_decode;
	wire x_2540_reader_check;
	wire read_val_chk;
	// row bit
	wire rd_1_row_bit;
	wire rd_2_row_bit;
	wire pch_chk_row_bit;
	wire pfr_row_bit;
	wire rdr_cl_lat_not_npro;
	wire pch_cl_lat_not_npro;
	wire gate_rd_complete_2540;
	wire x_4_bit_mod_pull_on;
	wire pfr_unit_exception_gate;
	// rdr pch -> icu
	wire punch_scan_cb;
	wire after_9_emitter;
	wire pch_clutch_set;
	wire unit_exception;
	wire punch_impulse_cb;
	wire pch_brush_cl_delay_int;
	wire die_cl_delay;
	wire punch_ready;
	wire reader_ready;
	wire read_impulse_cb;
	wire x_1400_unit_exception_gate;
	// ce
	wire punch_xlate_check_light;
	wire pfr_val_light;
	//
	reg check_reset;

	// rp switches
	reg rdr_start_key;
	reg rdr_stop_key;
	reg rdr_end_of_file_key;
	reg pch_start_key;
	reg pch_stop_key;
	reg pch_end_of_file_key;
	// rp lights
	wire rdr_validity_check_light;
	wire stacker_light;
	wire rdr_ready_light;
	wire rdr_read_check_light;
	wire rdr_end_of_file_light;
	wire rdr_feed_stop_light;
	wire transport_light;
	wire chip_box_light;
	wire punch_check_light;
	wire pch_ready_light;
	wire pch_end_of_file_light;
	wire pch_feed_stop_light;

	// experimental
	reg rp_strobe;
	reg [7:0] rp_cmd;
	wire rp_ack;

	// bus workspace
	reg [7:0] bs_out;
	wire bs_out_p;
	wire [7:0] bs_in;
	wire bs_in_p;
	wire bad_parity_in;

	assign bs_out_p = (~^{bs_out} | parity_control[1]) ^ parity_control[0];

	assign bus_out = {bs_out_p, bs_out};
	assign {bs_in_p, bs_in} = bus_in;
	assign bad_parity_in = ~^{bus_in};

	reg [1:0] parity_control;

	reg [7:0] last_dev = 12;
	reg last_adrin;
	always @(posedge clk)
		last_adrin <= address_in;
	always @(posedge clk)
		if (~rst & address_in & ~last_adrin)
			last_dev <= bs_in;

	// reset momentary action keys
	always @(posedge clk) begin
		if (rdr_start_key)
			rdr_start_key <= 0;
		if (rdr_stop_key)
			rdr_stop_key <= 0;
		if (rdr_end_of_file_key)
			rdr_end_of_file_key <= 0;
		if (pch_start_key)
			pch_start_key <= 0;
		if (pch_stop_key)
			pch_stop_key <= 0;
		if (pch_end_of_file_key)
			pch_end_of_file_key <= 0;
	end

reg [143:0] some_data;
reg [23:0] abc;

integer dataoff;
reg [15:0] seqno;

reg [7:0] sbuf[0:65535];

reg [15:0] baby;
reg [15:0] data_start, data_index, data_lim;
initial begin
baby <= 0;
sbuf[0] <= 'hc2;	// B
sbuf[1] <= 'h81;	// a
sbuf[2] <= 'h82;	// b
sbuf[3] <= 'ha8;	// y
sbuf[4] <= 'h40;	// sp
sbuf[5] <= 'hc9;	// I
sbuf[6] <= 'h40;	// sp
sbuf[7] <= 'h88;	// h
sbuf[8] <= 'h85;	// e
sbuf[9] <= 'h99;	// r
sbuf[10] <= 'h85;	// e
sbuf[11] <= 'h5a;	// !
//assign sbuf[12] = 'h15;
sbuf[580] <= 'hff;
sbuf[581] <= 'hff;
sbuf[582] <= 'hff;
sbuf[583] <= 'hff;
sbuf[584] <= 'hff;
sbuf[585] <= 'hff;
sbuf[586] <= 'hff;
sbuf[587] <= 'hff;
sbuf[588] <= 'hff;
sbuf[589] <= 'hff;
sbuf[590] <= 'hff;
sbuf[591] <= 'hff;
sbuf[592] <= 'hff;
sbuf[593] <= 'hff;
sbuf[594] <= 'hff;
sbuf[595] <= 'hff;
sbuf[596] <= 'hff;
sbuf[597] <= 'hff;
end

initial begin
//	abc <= "ABC";
//	some_data <= "Pretty girl hello ";
	abc = 24'hc1c2c3;
	some_data <= 144'hd79985a3a3a8408789999340888593939640;
	seqno <= 1;
	dataoff <= 0;
end

reg [5:0] keydata[0:512];
reg [8:0] kbd_index, kbd_size;
assign keydata[0] = 'o76;	// lc
assign keydata[1] = 'o61;	// a
assign keydata[2] = 'o12;	// 0
assign keydata[3] = 'o01;	// 1
assign keydata[4] = 'o02;	// 2
assign keydata[5] = 'o03;	// 3
assign keydata[6] = 'o11;	// 9
assign keydata[7] = 'o00;	// space
assign keydata[8] = 'o16;	// uc
assign keydata[9] = 'o27;	// X
assign keydata[10] = 'o33;	// !
assign keydata[11] = 'o36;	// eob
assign keydata[12] = 'o44;	// m
assign keydata[13] = 'o71;	// i
assign keydata[14] = 'o22;	// s
assign keydata[15] = 'o40;	// -
assign keydata[16] = 'o44;	// m
assign keydata[17] = 'o71;	// i
assign keydata[18] = 'o22;	// s
assign keydata[19] = 'o40;	// cancel	special
assign keydata[20] = 'o62;	// b
assign keydata[21] = 'o61;	// a
assign keydata[22] = 'o64;	// d
assign keydata[23] = 'o47;	// p		special
assign keydata[24] = 'o61;	// a
assign keydata[25] = 'o51;	// r
assign keydata[26] = 'o71;	// i
assign keydata[27] = 'o36;	// eob
assign keydata[28] = 'o76;	// lc
assign keydata[29] = 'o73;	// .
assign keydata[30] = 'o73;	// .
assign keydata[31] = 'o73;	// .
assign keydata[32] = 'o16;	// uc
assign keydata[33] = 'o67;	// G
assign keydata[34] = 'o76;	// lc
assign keydata[35] = 'o24;	// u
assign keydata[36] = 'o64;	// d
assign keydata[37] = 'o65;	// e
assign keydata[38] = 'o40;	// -
assign keydata[39] = 'o64;	// d
assign keydata[40] = 'o61;	// a
assign keydata[41] = 'o23;	// t
assign keydata[42] = 'o61;	// a
assign keydata[43] = 'o36;	// eob

	reg maybe_status = 0;
	reg do_stack_status = 0;
	reg maybe_recv_data = 0;
	reg maybe_send_data = 0;
	reg send_more_data = 0;
	reg maybe_card_data = 0;
	reg [7:0] cycle_count;
	reg [7:0] max_cycles;
	reg [12:0] grace_cycles;
	wire [15:0] data_count;
	wire [15:0] max_read_data;
assign data_count = data_index - data_start;
assign max_read_data = data_lim - data_start;
reg found_bad_parity;
wire sample_parity;
assign sample_parity = status_in | address_in | service_in;
	always @(posedge clk)
		if (~sample_parity)
			found_bad_parity <= 0;
		else if (~found_bad_parity & bad_parity_in) begin
			found_bad_parity <= 1;
$display("T=%d: bad parity: bus=%0x", $time, bus_in);
		end

	always @(posedge clk)
		if (rp_ack)
			rp_strobe <= 0;

reg [7:0] last_status;
reg saw_devend;
	always @(posedge clk)
		if (address_in)
			last_status <= 0;
		else if (!status_in)
			;
		else if (last_dev != test_dev)
			;
		else begin
			last_status <= last_status | bs_in;
			if (bs_in[2])
				saw_devend <= 1;
		end

	always @(posedge clk) begin
		if (status_in && ~command_out) begin
		if (last_dev == test_dev) begin
$display("T=%d have status: status=%0x", $time, bs_in);
			last_status <= last_status | bs_in;
			if (bs_in[2])
				saw_devend <= 1;
			#4 service_out <= 1;
			while (status_in)
				#2;
			#2 service_out <= 0;
		end else begin
$display("T=%d discard status: dev=%x status=%0x", $time, last_dev, bs_in);
			#4 service_out <= 1;
				while (status_in)
					#2;
			service_out <= 0;
		end
		end
	end

	always @(posedge clk)
	if (maybe_status & address_in) begin
$display("T=%d about to receive status? dev=%0x", $time, bs_in);
		#4 command_out <= 1;
		while (address_in)
			#2 ;
		if (maybe_status)
			#2 command_out <= 0;
		while (operational_in & ~status_in)
			#2 ;
		#2;
		while (status_in | service_out)
			#2 ;
		if (maybe_status)
			#4 hold_out <= 0;
$display("T=%d #1 done getting status", $time);
	end

	always @(posedge clk)
	if ((maybe_send_data | send_more_data) & service_in) begin
maybe_send_data <= 0;
send_more_data <= 1;
		if (command_out) begin
		end else if (data_index < data_lim) begin
$display("T=%d sending data? %d,data=%0x", $time, data_index,sbuf[data_index]);
			bs_out <= sbuf[data_index];
			data_index <= data_index + 1;
				#4 service_out <= 1;
			while (operational_in & service_in)
				#2;
			#2 service_out <= 0;
		end else begin
$display("T=%d sending data? %d,no more data", $time, data_index);
			command_out <= 1;
send_more_data <= 0;
			while (operational_in & service_in)
				#2;
			#2 command_out <= 0;
		end
	end
	else if ((maybe_send_data | send_more_data) & status_in) begin
		maybe_send_data <= 0;
		send_more_data <= 0;
	end

	always @(posedge clk)
	if (!service_in)
		;
	else if (command_out)
		;
	else if (maybe_recv_data) begin
grace_cycles <= grace_cycles + 1;
if (data_count >= max_read_data) begin
$display("T=%d recv: discard data=%0x", $time, bs_in);
	#4 command_out <= 1;
end else begin
sbuf[data_index] = bs_in;
data_index <= data_index + 1;
$display("T=%d receiving data? data=%0x (%d)", $time, bs_in, data_count);
		#4 service_out <= 1;
end
		while (operational_in & service_in & maybe_recv_data)
			#2;
		#2 service_out <= 0;
		command_out <= 0;
	end

reg start_poll;
reg [8:0] hold_out_delay;
	always @(posedge clk) if (start_poll) begin
		if (~service_out & request_in & ~operational_in & ~hold_out) begin
			if (hold_out_delay < 16) ++hold_out_delay;
			else
			hold_out <= 1;
		end
		if (hold_out & (select_in | address_in)) begin
			hold_out <= 0;
			hold_out_delay <= 0;
		end
	end
	always @(posedge clk) if (start_poll) begin
		if (hold_out & address_in) begin
if (cycle_count >= max_cycles + grace_cycles) begin
$display("T=%d poll: excess cycles dev=%0x--channel reset *******************", $time, bs_in);
hold_out <= 0;
#4 operational_out <= 0;
#16 operational_out <= 1;
saw_devend <= 1;	// fakeout
end else begin
cycle_count <= cycle_count + 1;
$display("T=%d poll: got dev=%0x", $time, bs_in);
			#4 command_out <= 1;
			while (address_in & start_poll)
				#2 ;
			#8 command_out <= 0;
end
		end
	end else begin
		cycle_count <= 0;
		grace_cycles <= 0;
		hold_out_delay <= 0;
	end

reg saved_2540_reader_check;
reg saved_read_val_chk;
reg saved_pfr_val_light;
always @(posedge clk) begin
	saved_2540_reader_check <= x_2540_reader_check;
	saved_read_val_chk <= read_val_chk;
	saved_pfr_val_light <= pfr_val_light;
	case ({saved_2540_reader_check, x_2540_reader_check})
	1:
$display("T=%d  !! light reader read-check went true", $time);
	2:
$display("T=%d  !! light reader read-check went false", $time);
	endcase
	case ({saved_read_val_chk, read_val_chk})
	1:
$display("T=%d  !! light reader validity-check went true", $time);
	2:
$display("T=%d  !! light reader validity-check went false", $time);
	endcase
	case ({saved_pfr_val_light, pfr_val_light})
	1:
$display("T=%d  !! light punch validity-check went true", $time);
	2:
$display("T=%d  !! light punch validity-check went false", $time);
	endcase
end

initial begin
$dumpfile("x2821.vcd");
$dumpvars(0, tb);
end

	x2821 u0( .i_clk(clk), .i_reset(rst),
		// channel bus
		.i_bus_out(bus_out), .o_bus_in(bus_in),
		.i_address_out(address_out), .i_command_out(command_out),
		.i_service_out(service_out), .i_data_out(data_out),
		.o_address_in(address_in), .o_status_in(status_in),
		.o_service_in(service_in), .o_data_in(data_in),
		.o_disc_in(disc_in),
		.i_operational_out(operational_out),
		.i_select_out(select_out), .i_hold_out(hold_out),
		.i_suppress_out(suppress_out),
		.o_operational_in(operational_in),
		.o_select_in(select_in), .o_request_in(request_in),
		// 2540
		.i_rd_1_row_bit(rd_1_row_bit),
		.i_rd_2_row_bit(rd_2_row_bit),
		.i_pch_chk_row_bit(pch_chk_row_bit),
		.i_pfr_row_bit(pfr_row_bit),
		.i_rdr_cl_lat_not_npro(rdr_cl_lat_not_npro),
		.i_pch_cl_lat_not_npro(pch_cl_lat_not_npro),
		.i_gate_rd_complete_2540(gate_rd_complete_2540),
		.i_4_bit_mod_pull_on(x_4_bit_mod_pull_on),
		.i_pfr_unit_exception_gate(pfr_unit_exception_gate),
		.i_punch_scan_cb(punch_scan_cb),
		.i_after_9_emitter(after_9_emitter),
		.i_pch_clutch_set(pch_clutch_set),
		.i_unit_exception(unit_exception),
		.i_pch_brush_impulse(punch_impulse_cb),
		.i_pch_brush_cl_delay_int(pch_brush_cl_delay_int),
		.i_die_cl_delay(die_cl_delay),
		.i_punch_ready(punch_ready),
		.i_reader_ready(reader_ready),
		.i_read_impulse_cb(read_impulse_cb),
		.i_1400_unit_exception_gate(x_1400_unit_exception_gate),
		.o_rpaddr(rpaddr),
		.o_rpaddr_binary(rpaddr_binary),
		.o_read_feed(read_feed),
		.o_punch_feed(punch_feed),
		.o_power_on_reset(power_on_reset),
		.o_mach_reset_rdr_pch(mach_reset_rdr_pch),
		.o_time_075_150(time_075_150),
		.o_time_150_375(time_150_375),
		.o_xfer_cy_req(xfer_cy_req),
		.o_unit_exception_rdr(unit_exception_rdr),
		.o_pch_write(pch_write),
		.o_rdr_feed_command(rdr_feed_command),
		.o_punch_cycle(punch_cycle),
		.o_read_cycle(read_cycle),
		.o_time_150_450(time_150_450),
		.o_time_225_525(time_225_525),
		.o_2821_rdr_ready_turn_off(x_2821_rdr_ready_turn_off),
		.o_2821_pch_ready_turn_off(x_2821_pch_ready_turn_off),
		.o_punch_restart_gate(punch_restart_gate),
		.o_punch_decode(punch_decode),
		.o_2540_reader_check(x_2540_reader_check),
		.o_read_val_chk(read_val_chk),
		// 1403
		.i_sense_amp_1(sense_amp_1),
		.i_sense_amp_2(sense_amp_2),
		.i_slow_brushes(slow_brushes),
		.i_stop_brushes(stop_brushes),
		.i_mag_emitter(mag_emitter),
		.i_gate_interlock(gate_interlock),
		.i_carriage_interlock(carriage_interlock),
		.i_forms_check_or_carr_stop(forms_check_or_carr_stop),
		.i_end_of_forms(end_of_forms),
		.i_restore_key(restore_key),
		.i_prt_stop_key(prt_stop_key),
		.i_single_cycle_key(single_cycle_key),
		.i_prt_start_key(prt_start_key),
		.i_space_key(space_key),
		.i_60_volt_sense(x_60_volt_sense),
		.o_print(print),
		.o_hammer_fire(hammer_fire),
		.o_low_speed_start(low_speed_start),
		.o_low_speed_stop(low_speed_stop),
		.o_high_speed_start(high_speed_start),
		.o_high_speed_stop(high_speed_stop),
		.o_paper_damper_mag_drive(paper_damper_mag_drive),
		.o_print_ready_ind_ce(print_ready_ind_ce),
		.o_forms_check_ind(forms_check_ind),
		.o_print_check_ind(print_check_ind),
		.o_sync_check_ind(sync_check_ind),
		.o_end_of_forms_ind(end_of_forms_ind),
		// ce
		.o_data_enter_no(data_enter_no),
		.o_punch_xlate_check_light(punch_xlate_check_light),
		.o_pfr_val_light(pfr_val_light),
		.i_data_enter_sw(data_enter_sw),
		.i_data_enter_0_7(data_enter_0_7),
		.i_burst_sw_on(burst_sw_on),
		.i_one_byte_sw_on(one_byte_sw_on),
		.i_load_and_single_cycle_sw(load_and_single_cycle_sw),
		.i_ce_2540_off_line_sw(ce_2540_off_line_sw),
		.i_ce_mach_reset(ce_mach_reset),
		.i_sync_recycle_jumper(sync_recycle_jumper),
		.i_home_gate_jumper(home_gate_jumper),
		.i_pss_trig_jumper(pss_trig_jumper),
		.i_check_reset(check_reset));

	// 1403
	wire sense_amp_1;
	wire sense_amp_2;
	wire [11:0] slow_brushes;
	wire [11:0] stop_brushes;
	wire mag_emitter;
	wire print_ready_ind_ce;
	wire forms_check_ind;
	wire print_check_ind;
	wire sync_check_ind;
	wire end_of_forms_ind;
	reg gate_interlock;
	reg carriage_interlock;
	reg forms_check_or_carr_stop;
	reg end_of_forms;
	reg restore_key;
	reg prt_stop_key;
	reg single_cycle_key;
	reg prt_start_key;
	reg space_key;
	reg sync_recycle_jumper;
	reg home_gate_jumper;
	reg pss_trig_jumper;
	reg x_60_volt_sense;
	wire print;
	wire [132:1] hammer_fire;
	wire low_speed_start;
	wire low_speed_stop;
	wire high_speed_start;
	wire high_speed_stop;
	wire paper_damper_mag_drive;

	sim1403x3 u1(.i_clk(clk), .i_reset(rst),
		.i_low_speed_start(low_speed_start),
		.i_low_speed_stop(low_speed_stop),
		.i_high_speed_start(high_speed_start),
		.i_high_speed_stop(high_speed_stop),
		.i_print(print),
		.i_hammer_fire(hammer_fire),
		.o_sense_amp_1(sense_amp_1), .o_sense_amp_2(sense_amp_2),
		.o_mag_emitter(mag_emitter),
		.o_slow_brushes(slow_brushes),
		.o_stop_brushes(stop_brushes));

	sim2540x1 u2(.i_clk(clk), .i_reset(rst),
		// icu to rdr pch
		// rp bar
		.i_rpaddr(rpaddr),
		.i_rpaddr_binary(rpaddr_binary),
		.i_punch_feed(punch_feed),
		.i_read_feed(read_feed),
		.i_punch_decode(punch_decode),
		.i_punch_cycle(punch_cycle),
		.i_read_cycle(read_cycle),
		.i_punch_restart_gate(punch_restart_gate),
		.i_2821_pch_ready_turn_off(x_2821_pch_ready_turn_off),
		.i_2821_rdr_ready_turn_off(x_2821_rdr_ready_turn_off),
		.i_unit_exception_rdr(unit_exception_rdr),
		.i_time_075_150(time_075_150),
		.i_time_150_375(time_150_375),
		.i_pch_write(pch_write),
		.i_rdr_feed_command(rdr_feed_command),
		.i_time_150_450(time_150_450),
		.i_time_225_525(time_225_525),
		.i_xfer_cy_req(xfer_cy_req),
		.i_mach_reset_rdr_pch(mach_reset_rdr_pch),
		.i_power_on_reset(power_on_reset),
		// rdr-pch to icu
		.o_punch_ready(punch_ready),
		.o_reader_ready(reader_ready),
		.o_read_impulse_cb(read_impulse_cb),
		.o_punch_scan_cb(punch_scan_cb),
		.o_1400_unit_exception(x_1400_unit_exception_gate),
		.o_after_9_emitter(after_9_emitter),
		.o_unit_exception(unit_exception),
		.o_die_cl_delay(die_cl_delay),
		.o_4_bit_mod(x_4_bit_mod_pull_on),
		.o_pfr_unit_exception(pfr_unit_exception_gate),
		.o_pch_clutch_set(pch_clutch_set),
		.o_punch_impulse_cb(punch_impulse_cb),
		.o_pch_brush_cl_delay_int(pch_brush_cl_delay_int),
		// row bit
		.o_rd_1_row_bit(rd_1_row_bit),
		.o_rd_2_row_bit(rd_2_row_bit),
		.o_pch_chk_row_bit(pch_chk_row_bit),
		.o_pch_cl_lat_not_npro(pch_cl_lat_not_npro),
		.o_pfr_row_bit(pfr_row_bit),
		.o_gate_rd_complete_2540(gate_rd_complete_2540),
		.o_rdr_cl_lat_not_npro(rdr_cl_lat_not_npro),
		// unit controls
		.i_rdr_start_key(rdr_start_key),
		.i_rdr_stop_key(rdr_stop_key),
		.i_rdr_end_of_file_key(rdr_end_of_file_key),
		.i_pch_start_key(pch_start_key),
		.i_pch_stop_key(pch_stop_key),
		.i_pch_end_of_file_key(pch_end_of_file_key),
		// unit lights
		.o_rdr_validity_check_light(rdr_validity_check_light),
		.o_stacker_light(stacker_light),
		.o_rdr_ready_light(rdr_ready_light),
		.o_rdr_read_check_light(rdr_read_check_light),
		.o_rdr_end_of_file_light(rdr_end_of_file_light),
		.o_rdr_feed_stop_light(rdr_feed_stop_light),
		.o_transport_light(transport_light),
		.o_chip_box_light(chip_box_light),
		.o_punch_check_light(punch_check_light),
		.o_pch_ready_light(pch_ready_light),
		.o_pch_end_of_file_light(pch_end_of_file_light),
		.o_pch_feed_stop_light(pch_feed_stop_light),
		// experimental
		.i_strobe(rp_strobe),
		.i_cmd(rp_cmd),
		.o_ack(rp_ack));

	initial begin
		gate_interlock <= 0;
		carriage_interlock <= 0;
		forms_check_or_carr_stop <= 0;
		end_of_forms <= 0;
		restore_key <= 0;
		prt_stop_key <= 0;
		single_cycle_key <= 0;
		prt_start_key <= 0;
		sync_recycle_jumper = $test$plusargs("SYNC") !== 0; // +SYNC
		home_gate_jumper = $test$plusargs("SYNC") !== 0; // +SYNC
		pss_trig_jumper = $test$plusargs("PSS") !== 0; // +PSS
		space_key <= 0;
		x_60_volt_sense <= 0;
	end

	always #1 clk = ~clk;

	always @(posedge clk)
		select_out <= hold_out;

	initial begin
		{clk,rst} <= 1;
		#3 rst <= 0;
	end

task set_card_sequence;
input [15:0] base;
input [23:0] lbl;
inout [15:0] sno;
reg [63:0] field;
begin
	$sformat(field, "%s%05d", lbl, sno);
	sno = sno + 1;
	sbuf[base+0] = field[63:56];
	sbuf[base+1] = field[55:48];
	sbuf[base+2] = field[47:40];
	sbuf[base+3] = field[39:32] | 8'hf0;
	sbuf[base+4] = field[31:24] | 8'hf0;
	sbuf[base+5] = field[23:16] | 8'hf0;
	sbuf[base+6] = field[15:8] | 8'hf0;
	sbuf[base+7] = field[7:0] | 8'hf0;
end
endtask

function [11:0] etoh;
input [7:0] e;
case (e)
'h00: etoh = 'hb03;	// (?e)
'h01: etoh = 'h901;	// (?e)
'h02: etoh = 'h881;	// (?e)
'h03: etoh = 'h841;	// (?e)
'h04: etoh = 'h821;	// (pf)
'h05: etoh = 'h811;	// (ht)
'h06: etoh = 'h809;	// (lc)
'h07: etoh = 'h805;	// (del)
'h08: etoh = 'h803;	// (?e)
'h09: etoh = 'h903;	// (?e)
'h0a: etoh = 'h883;	// (?e)
'h0b: etoh = 'h843;	// (?e)
'h0c: etoh = 'h823;	// (?e)
'h0d: etoh = 'h813;	// (?e)
'h0e: etoh = 'h80b;	// (?e)
'h0f: etoh = 'h807;	// (?e)
'h10: etoh = 'hd03;	// (?e)
'h11: etoh = 'h501;	// (?e)
'h12: etoh = 'h481;	// (?e)
'h13: etoh = 'h441;	// (?e)
'h14: etoh = 'h421;	// (res)
'h15: etoh = 'h411;	// (nl)
'h16: etoh = 'h409;	// (bs)
'h17: etoh = 'h405;	// (il)
'h18: etoh = 'h403;	// (?e)
'h19: etoh = 'h503;	// (?e)
'h1a: etoh = 'h483;	// (?e)
'h1b: etoh = 'h443;	// (?e)
'h1c: etoh = 'h423;	// (?e)
'h1d: etoh = 'h413;	// (?e)
'h1e: etoh = 'h40b;	// (?e)
'h1f: etoh = 'h407;	// (?e)
'h20: etoh = 'h703;	// (?e)
'h21: etoh = 'h301;	// (?e)
'h22: etoh = 'h281;	// (?e)
'h23: etoh = 'h241;	// (?e)
'h24: etoh = 'h221;	// (byp)
'h25: etoh = 'h211;	// (lf)
'h26: etoh = 'h209;	// (eob)
'h27: etoh = 'h205;	// (pre)
'h28: etoh = 'h203;	// (?e)
'h29: etoh = 'h303;	// (?e)
'h2a: etoh = 'h283;	// (?e)
'h2b: etoh = 'h243;	// (?e)
'h2c: etoh = 'h223;	// (?e)
'h2d: etoh = 'h213;	// (?e)
'h2e: etoh = 'h20b;	// (?e)
'h2f: etoh = 'h207;	// (?e)
'h30: etoh = 'hf03;	// (?e)
'h31: etoh = 'h101;	// (?e)
'h32: etoh = 'h081;	// (?e)
'h33: etoh = 'h041;	// (?e)
'h34: etoh = 'h021;	// (pn)
'h35: etoh = 'h011;	// (rs)
'h36: etoh = 'h009;	// (uc)
'h37: etoh = 'h005;	// (eot)
'h38: etoh = 'h003;	// (?e)
'h39: etoh = 'h103;	// (?e)
'h3a: etoh = 'h083;	// (?e)
'h3b: etoh = 'h043;	// (?e)
'h3c: etoh = 'h023;	// (?e)
'h3d: etoh = 'h013;	// (?e)
'h3e: etoh = 'h00b;	// (?e)
'h3f: etoh = 'h007;	// (?e)
'h40: etoh = 'h000;	// (sp)
'h41: etoh = 'hb01;	// (?e)
'h42: etoh = 'ha81;	// (?e)
'h43: etoh = 'ha41;	// (?e)
'h44: etoh = 'ha21;	// (?e)
'h45: etoh = 'ha11;	// (?e)
'h46: etoh = 'ha09;	// (?e)
'h47: etoh = 'ha05;	// (?e)
'h48: etoh = 'ha03;	// (?e)
'h49: etoh = 'h902;	// (?e)
'h4a: etoh = 'h882;	// ([)
'h4b: etoh = 'h842;	// (.)
'h4c: etoh = 'h822;	// (<)
'h4d: etoh = 'h812;	// (()
'h4e: etoh = 'h80a;	// (+)
'h4f: etoh = 'h806;	// (!)
'h50: etoh = 'h800;	// (&)
'h51: etoh = 'hd01;	// (?e)
'h52: etoh = 'hc81;	// (?e)
'h53: etoh = 'hc41;	// (?e)
'h54: etoh = 'hc21;	// (?e)
'h55: etoh = 'hc11;	// (?e)
'h56: etoh = 'hc09;	// (?e)
'h57: etoh = 'hc05;	// (?e)
'h58: etoh = 'hc03;	// (?e)
'h59: etoh = 'h502;	// (?e)
'h5a: etoh = 'h482;	// (])
'h5b: etoh = 'h442;	// ($)
'h5c: etoh = 'h422;	// (*)
'h5d: etoh = 'h412;	// ())
'h5e: etoh = 'h40a;	// (;)
'h5f: etoh = 'h406;	// (^)
'h60: etoh = 'h400;	// (-)
'h61: etoh = 'h300;	// (/)
'h62: etoh = 'h681;	// (?e)
'h63: etoh = 'h641;	// (?e)
'h64: etoh = 'h621;	// (?e)
'h65: etoh = 'h611;	// (?e)
'h66: etoh = 'h609;	// (?e)
'h67: etoh = 'h605;	// (?e)
'h68: etoh = 'h603;	// (?e)
'h69: etoh = 'h302;	// (?e)
'h6a: etoh = 'hc00;	// (|)
'h6b: etoh = 'h242;	// (,)
'h6c: etoh = 'h222;	// (%)
'h6d: etoh = 'h212;	// (_)
'h6e: etoh = 'h20a;	// (>)
'h6f: etoh = 'h206;	// (?)
'h70: etoh = 'he00;	// (?e)
'h71: etoh = 'hf01;	// (?e)
'h72: etoh = 'he81;	// (?e)
'h73: etoh = 'he41;	// (?e)
'h74: etoh = 'he21;	// (?e)
'h75: etoh = 'he11;	// (?e)
'h76: etoh = 'he09;	// (?e)
'h77: etoh = 'he05;	// (?e)
'h78: etoh = 'he03;	// (?e)
'h79: etoh = 'h102;	// (`)
'h7a: etoh = 'h082;	// (:)
'h7b: etoh = 'h042;	// (#)
'h7c: etoh = 'h022;	// (@)
'h7d: etoh = 'h012;	// (')
'h7e: etoh = 'h00a;	// ( =)
'h7f: etoh = 'h006;	// (")
'h80: etoh = 'hb02;	// (?e)
'h81: etoh = 'hb00;	// (a)
'h82: etoh = 'ha80;	// (b)
'h83: etoh = 'ha40;	// (c)
'h84: etoh = 'ha20;	// (d)
'h85: etoh = 'ha10;	// (e)
'h86: etoh = 'ha08;	// (f)
'h87: etoh = 'ha04;	// (g)
'h88: etoh = 'ha02;	// (h)
'h89: etoh = 'ha01;	// (i)
'h8a: etoh = 'ha82;	// (?e)
'h8b: etoh = 'ha42;	// (?e)
'h8c: etoh = 'ha22;	// (?e)
'h8d: etoh = 'ha12;	// (?e)
'h8e: etoh = 'ha0a;	// (?e)
'h8f: etoh = 'ha06;	// (?e)
'h90: etoh = 'hd02;	// (?e)
'h91: etoh = 'hd00;	// (j)
'h92: etoh = 'hc80;	// (k)
'h93: etoh = 'hc40;	// (l)
'h94: etoh = 'hc20;	// (m)
'h95: etoh = 'hc10;	// (n)
'h96: etoh = 'hc08;	// (o)
'h97: etoh = 'hc04;	// (p)
'h98: etoh = 'hc02;	// (q)
'h99: etoh = 'hc01;	// (r)
'h9a: etoh = 'hc82;	// (?e)
'h9b: etoh = 'hc42;	// (?e)
'h9c: etoh = 'hc22;	// (?e)
'h9d: etoh = 'hc12;	// (?e)
'h9e: etoh = 'hc0a;	// (?e)
'h9f: etoh = 'hc06;	// (?e)
'ha0: etoh = 'h702;	// (?e)
'ha1: etoh = 'h700;	// (~)
'ha2: etoh = 'h680;	// (s)
'ha3: etoh = 'h640;	// (t)
'ha4: etoh = 'h620;	// (u)
'ha5: etoh = 'h610;	// (v)
'ha6: etoh = 'h608;	// (w)
'ha7: etoh = 'h604;	// (x)
'ha8: etoh = 'h602;	// (y)
'ha9: etoh = 'h601;	// (z)
'haa: etoh = 'h682;	// (?e)
'hab: etoh = 'h642;	// (?e)
'hac: etoh = 'h622;	// (?e)
'had: etoh = 'h612;	// (?e)
'hae: etoh = 'h60a;	// (?e)
'haf: etoh = 'h606;	// (?e)
'hb0: etoh = 'hf02;	// (?e)
'hb1: etoh = 'hf00;	// (?e)
'hb2: etoh = 'he80;	// (?e)
'hb3: etoh = 'he40;	// (?e)
'hb4: etoh = 'he20;	// (?e)
'hb5: etoh = 'he10;	// (?e)
'hb6: etoh = 'he08;	// (?e)
'hb7: etoh = 'he04;	// (?e)
'hb8: etoh = 'he02;	// (?e)
'hb9: etoh = 'he01;	// (?e)
'hba: etoh = 'he82;	// (?e)
'hbb: etoh = 'he42;	// (?e)
'hbc: etoh = 'he22;	// (?e)
'hbd: etoh = 'he12;	// (?e)
'hbe: etoh = 'he0a;	// (?e)
'hbf: etoh = 'he06;	// (?e)
'hc0: etoh = 'ha00;	// ({)
'hc1: etoh = 'h900;	// (A)
'hc2: etoh = 'h880;	// (B)
'hc3: etoh = 'h840;	// (C)
'hc4: etoh = 'h820;	// (D)
'hc5: etoh = 'h810;	// (E)
'hc6: etoh = 'h808;	// (F)
'hc7: etoh = 'h804;	// (G)
'hc8: etoh = 'h802;	// (H)
'hc9: etoh = 'h801;	// (I)
'hca: etoh = 'ha83;	// (?e)
'hcb: etoh = 'ha43;	// (?e)
'hcc: etoh = 'ha23;	// (?e)
'hcd: etoh = 'ha13;	// (?e)
'hce: etoh = 'ha0b;	// (?e)
'hcf: etoh = 'ha07;	// (?e)
'hd0: etoh = 'h600;	// (})
'hd1: etoh = 'h500;	// (J)
'hd2: etoh = 'h480;	// (K)
'hd3: etoh = 'h440;	// (L)
'hd4: etoh = 'h420;	// (M)
'hd5: etoh = 'h410;	// (N)
'hd6: etoh = 'h408;	// (O)
'hd7: etoh = 'h404;	// (P)
'hd8: etoh = 'h402;	// (Q)
'hd9: etoh = 'h401;	// (R)
'hda: etoh = 'hc83;	// (?e)
'hdb: etoh = 'hc43;	// (?e)
'hdc: etoh = 'hc23;	// (?e)
'hdd: etoh = 'hc13;	// (?e)
'hde: etoh = 'hc0b;	// (?e)
'hdf: etoh = 'hc07;	// (?e)
'he0: etoh = 'h282;	// (?e)
'he1: etoh = 'h701;	// (?e)
'he2: etoh = 'h280;	// (S)
'he3: etoh = 'h240;	// (T)
'he4: etoh = 'h220;	// (U)
'he5: etoh = 'h210;	// (V)
'he6: etoh = 'h208;	// (W)
'he7: etoh = 'h204;	// (X)
'he8: etoh = 'h202;	// (Y)
'he9: etoh = 'h201;	// (Z)
'hea: etoh = 'h683;	// (?e)
'heb: etoh = 'h643;	// (?e)
'hec: etoh = 'h623;	// (?e)
'hed: etoh = 'h613;	// (?e)
'hee: etoh = 'h60b;	// (?e)
'hef: etoh = 'h607;	// (?e)
'hf0: etoh = 'h200;	// (0)
'hf1: etoh = 'h100;	// (1)
'hf2: etoh = 'h080;	// (2)
'hf3: etoh = 'h040;	// (3)
'hf4: etoh = 'h020;	// (4)
'hf5: etoh = 'h010;	// (5)
'hf6: etoh = 'h008;	// (6)
'hf7: etoh = 'h004;	// (7)
'hf8: etoh = 'h002;	// (8)
'hf9: etoh = 'h001;	// (9)
'hfa: etoh = 'he83;	// (?e)
'hfb: etoh = 'he43;	// (?e)
'hfc: etoh = 'he23;	// (?e)
'hfd: etoh = 'he13;	// (?e)
'hfe: etoh = 'he0b;	// (?e)
'hff: etoh = 'he07;	// (?e)
endcase
endfunction

task copy_to_holes;
input [15:0] src;
input [15:0] dst;
integer i;
begin
for (i = 0; i < 80; i = i + 1) begin
	sbuf[dst+(i<<1)] = etoh(sbuf[src+i]) >> 6;
	sbuf[1+dst+(i<<1)] = etoh(sbuf[src+i]) & 63;
end
end
endtask

task set_card_data;
input [15:0] base;
input [18*8-1:0] dat;
inout [31:0] xx;
reg [7:0] oo;
integer xxx;
begin
	oo = 0;
	xxx = xx;
	while (oo < 71) begin
		sbuf[base+oo] = dat>>(8*(17-xxx));
		oo = oo + 1;
		if (xxx >= 17) xxx = 0;
			else xxx = xxx + 1;
	end
	xx = xxx;
	if (xxx >= 1) xxx = xxx-1; else xxx = xxx + 71-1;
		sbuf[base+71] = 8'h40;	// " "
	end
endtask

wire [7:0] xxx_data;

task fill_card_data;
input [15:0] ds, sz;
reg [15:0] i;
begin
	for (i = ds ; i < ds+sz; i = i + 1)
		sbuf[i] = xxx_data;
end
endtask

function [11:0] card_data;
input [9:0] i;
if ((i<<1) < data_count)
card_data = {sbuf[data_start + (i<<1)][5:0],sbuf[1+data_start + (i<<1)][5:0]};
else
card_data = {xxx_data[3:0], xxx_data};
endfunction

task dump_card_image;
reg [15:0] sz;
reg [9:0] i;
begin
sz = max_read_data;
for (i = 0; i < (data_index-data_start)/2 && i < sz/2; i = i + 16)
$display("%d: %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x",
	i,
	card_data(i), card_data(i+1),
	card_data(i+2), card_data(i+3),
	card_data(i+4), card_data(i+5),
	card_data(i+6), card_data(i+7),
	card_data(i+8), card_data(i+9),
	card_data(i+10), card_data(i+11),
	card_data(i+12), card_data(i+13),
	card_data(i+14), card_data(i+15));
end
endtask

task do_init;
begin
// $monitor("T=%d cycle_clutch=%b cycle_counter", $time, cycle_clutch, cycle_counter);
one_byte_sw_on <= 1;
burst_sw_on <= 0;
data_enter_sw <= 0;
data_enter_0_7 <= 0;
load_and_single_cycle_sw <= 0;
ce_2540_off_line_sw <= 0;
ce_mach_reset <= 0;
rdr_start_key <= 0;
rdr_stop_key <= 0;
rdr_end_of_file_key <= 0;
pch_start_key <= 0;
pch_stop_key <= 0;
pch_end_of_file_key <= 0;
check_reset <= 0;
rp_strobe <= 0;
rp_cmd <= 0;
data_start <= 300;
data_lim <= 300;
	hold_out <= 0;
max_cycles <= 4;
	{operational_out, select_out, hold_out, suppress_out} <= 0;
	{address_out, command_out, service_out, data_out} <= 0;

#2 data_index <= data_start;


	// initial reset
$display("T=%d  -- initial reset --", $time);
	parity_control <= 0;
	bs_out <= 0;
	start_poll <= 0;

	#2
operational_out	<= 1;
	#4
	maybe_status <= 1;
	hold_out <= 1;
	#16
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	hold_out <= 0;
	bs_out <= 0;
	maybe_status <= 0;
	end
endtask

task do_push_not_ready;
	begin
$display("T=%d  -- push not ready pb --", $time);
	#8 load_and_single_cycle_sw <= 1;
	#12 ;
	maybe_status <= 1;
	hold_out <= 1;
	#16
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	hold_out <= 0;
	bs_out <= 0;
	maybe_status <= 0;
	end
endtask
task do_push_ready;
	begin
$display("T=%d  -- push ready pb --", $time);
	#8 load_and_single_cycle_sw <= 0;
	#12 ;
	hold_out <= 1;
	#16
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	maybe_status <= 0;
	hold_out <= 0;
	bs_out <= 0;
	#8
	hold_out <= 0;
	bs_out <= 0;
	end
endtask
task do_select_no_such_dev;
	begin
$display("T=%d  -- select no such device (0) --", $time);
	#8
	address_out <= 1;
	#2
	hold_out <= 1;
	#14
	if (!select_in) begin
$display("%d waiting for select-in", $time);
	while (~operational_in & ~select_in)
		#2 ;
	end
	if (select_in)
		;
	else if (operational_in) begin
$display("%d fatal -- how did operational_in rise for device=0?", $time);
$finish;
	end
	address_out <= 0;
	#2
	hold_out <= 0;
	#8
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	end
endtask
task do_testio;
	begin
	bs_out <= test_dev;
$display("T=%d  -- testio device=%d --", $time, test_dev);
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	while (~address_in | ~operational_in) begin
	if (operational_in) begin
		address_out <= 0;
		bs_out <= 0;
	end
	if (select_in) begin
$display("T=%d  ** fatal error - device did not respond", $time);
		hold_out <= 0;
		#2 bs_out <= 0;
	#30 $finish;
	end
	#2;
	end
	#6
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	#8
	hold_out <= 0;
	#8
	while (operational_in || address_in || status_in || service_in)
		#2 ;

	#20 ;
	end
endtask
task do_ready_reader;
begin
$display("T=%d  -- waiting for reader ready --", $time);
	rdr_start_key <= 1;
	while (!rdr_ready_light)
		#2 ;
$display("T=%d reader is ready", $time);
end
endtask
task do_ready_punch;
begin
$display("T=%d  -- waiting for punch ready --", $time);
	pch_start_key <= 1;
	while (!pch_ready_light)
		#2 ;
$display("T=%d punch is ready", $time);
end
endtask
task do_wait_for_ready;
	begin
		if (print_ready_ind_ce)
			;
		else begin
$display("T=%d  -- wait for printer ready --", $time);
		while (!print_ready_ind_ce)
			#2 ;
$display("%d printer now ready", $time);
		end
	end
endtask
task do_write_burst;
input [7:0] modifier;
input [23:0] lbl;
input [15:0] ds;
input [15:0] sz;
	begin

saw_devend <= 0;
$display("T=%d  -- write device=%d ss=%d%s #%d", $time, test_dev, modifier[7:6], modifier & 'h20 ? ",cb" : "", lbl);
	data_start <= ds;
	data_lim <= ds + sz;
	data_index <= ds;
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
//	bs_out <= 'h1;		// write-icr
	bs_out <= {modifier | 6'h9};	// write-acr
$display("\t%d wait for address_in", $time);
	while (~address_in)
		#2 ;
	#6
	command_out <= 1;
$display("\t%d wait for ~address_in", $time);
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
$display("\t%d wait for status_in", $time);
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
$display("\t%d wait for ~status_in", $time);
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
if (last_status != 0) begin
$display("\t%d initial status nz; write not accepted", $time);
end else begin
$display("\t%d maybe_send_data", $time);
	maybe_send_data <= 1;
	#2 ;
$display("\t%d wait for status_in", $time);
	while (~status_in)
		#2 ;
	#8
$display("\t%d wait for devend", $time);
	while (~saw_devend) begin
		if (request_in) begin
			maybe_status <= 1;
			hold_out <= 1;
			#8;
			if (hold_out & ~operational_in)
				hold_out <= 0;
		end else #2 ;
	end
	maybe_send_data <= 0;
	#8 ;
end
	hold_out <= 0;
$display("\t%d wait for ~operational_in", $time);
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	end
endtask
task do_no_op;
	begin

saw_devend <= 0;
$display("T=%d  -- no-op device=%d --", $time, test_dev);
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'h3;		// no-op
	while (~address_in)
		#2 ;
	#6
if (last_dev != test_dev) begin
$display("T=%d *** wrong device? got dev=%x", $time, last_dev);
end
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	#8
	hold_out <= 0;
	#8
	if (~saw_devend)
$display("*** T=%d  no-op waiting for devend", $time);
	#2
	while (~saw_devend)
		if (request_in) begin
			maybe_status <= 1;
			hold_out <= 1;
			#8;
			if (hold_out & ~operational_in)
				hold_out <= 0;
		end else #2 ;
	hold_out <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	end
endtask
task do_read_backward;
	begin

saw_devend <= 0;
$display("T=%d  -- read-backward device=%d --", $time, test_dev);
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'hc;		// read-backwards
	while (~address_in)
		#2 ;
	#6
if (last_dev != test_dev) begin
$display("T=%d *** wrong device? got dev=%x", $time, last_dev);
end
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	if (bs_in) begin
		saw_devend <= 1;
	end
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	if (!saw_devend)
		maybe_send_data <= 1;
	#8
	while (~saw_devend)
		#2 ;
	maybe_send_data <= 0;
	while (address_in || status_in || service_in)
		#2 ;
	#2 hold_out <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	#2 ;
	while (hold_out) begin
$display("T=%d ... unsticking holdout", $time);
		#2 hold_out <= 0;
	end
//	while (operational_in || address_in || status_in || service_in)
//		#2 ;
//	while (alarm)
//		#2 ;
	end
endtask
task do_alarm;
	begin

saw_devend <= 0;
$display("T=%d  -- alarm device=%d --", $time, test_dev);
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'hb;		// alarm
	while (~address_in)
		#2 ;
	#6
if (last_dev != test_dev) begin
$display("T=%d *** wrong device? got dev=%x", $time, last_dev);
end
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	if (bs_in) begin
		saw_devend <= 1;
	end
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	if (!saw_devend)
		maybe_send_data <= 1;
	#8
	while (~saw_devend)
		#2 ;
	maybe_send_data <= 0;
	while (address_in || status_in || service_in)
		#2 ;
	#2 hold_out <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	#2 ;
	while (hold_out) begin
$display("T=%d ... unsticking holdout", $time);
		#2 hold_out <= 0;
	end
//	while (operational_in || address_in || status_in || service_in)
//		#2 ;
//	while (alarm)
//		#2 ;
	end
endtask
task do_ill_cmd;
	begin

$display("T=%d  -- illegal command(73) device=%d --", $time, test_dev);
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'h73;	// illegal control command
	while (~address_in)
		#2 ;
	#6
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	#8
	hold_out <= 0;
	#8
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	end
endtask
task do_sense_burst;
input [7:0] lbl;
input [15:0] ds;
	begin

saw_devend <= 0;
$display("T=%d  -- sense device=%d -- (burst) #%d", $time, test_dev, lbl);
	bs_out <= test_dev;
	data_start <= ds;
	data_lim <= ds + 1;
	data_index <= ds;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'h4;		// sense
	while (~address_in)
		#2 ;
	#6
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
if (last_status != 0) begin
$display("\t%d initial status nz; sense not accepted", $time);
end else begin
	maybe_recv_data <= 1;
	#8
	#2
	while (~saw_devend)
		if (request_in) begin
			maybe_status <= 1;
			#8;
		end else #2 ;
	while ((status_in || service_out) && operational_in)
		#2 ;
end
	hold_out <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;
	maybe_recv_data <= 0;
	#8;
	end
endtask
task do_sense_interleave;
input [7:0] lbl;
input [15:0] ds;
	begin

	saw_devend <= 0;
$display("T=%d  -- sense device=%d -- (interleaved) #%d", $time, test_dev, lbl);
	bs_out <= test_dev;
	data_start <= ds;
	data_lim <= ds + 1;
	data_index <= ds;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'h4;		// sense
	while (~address_in)
		#2 ;
	#6
	hold_out <= 0;
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
if (last_status != 0) begin
$display("\t%d initial status nz; sense not accepted", $time);
end else begin
	maybe_recv_data <= 1;
	#8
	#2
	start_poll <= 1;
	while (~saw_devend)
		#2;
	#4 ;
	start_poll <= 0;
	while (hold_out || operational_in || address_in || status_in || service_in)
		#2 ;
	maybe_recv_data <= 0;
	#8;
end
	end
endtask
task do_unsolicited_poll;
	begin
$display("T=%d  -- unsolicited poll --", $time);
	hold_out <= 1;
	maybe_status <= 1;
	#4;
	while (hold_out & ~select_in)
		#2 ;
	if (select_in)
		hold_out <= 0;
	while (hold_out || operational_in || address_in || status_in || service_in)
		#2 ;
	maybe_status <= 0;
	end
endtask
task do_read_burst;
input [7:0] modifier;
input [7:0] lbl;
input [15:0] ds;
input [15:0] sz;
	begin

	fill_card_data(ds, sz);
saw_devend <= 0;
if (modifier == 'hc0)
$display("T=%d  -- buffer read device=%d / burst #%d", $time, test_dev, lbl);
else
$display("T=%d  -- read device=%d ss=%d / burst #%d", $time, test_dev, modifier[7:6], lbl);
	data_start <= ds;
	data_lim <= ds + sz;
	data_index <= ds;
	kbd_index <= 0;
	kbd_size <= 12;
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= modifier + 'h2;
	while (~address_in)
		#2 ;
	#6
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	maybe_card_data <= 1;
	maybe_recv_data <= 1;
	#2 ;
	#2;
	#8
	while (~saw_devend) begin
		#2 ;
	end
	maybe_recv_data <= 0;
	maybe_card_data <= 0;
	start_poll <= 0;
	while ( status_in || service_in )
		#2 ;
	hold_out <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;

	#30 ;
	end
endtask
task do_read_interleaved;
input [7:0] lbl;
input [15:0] ds;
input [15:0] sz;
	begin

saw_devend <= 0;
$display("T=%d  -- buffer read device=%d / interleaved #%d", $time, test_dev, lbl);
	data_start <= ds;
	data_lim <= ds + sz;
	data_index <= ds;
	kbd_index <= 0;
	kbd_size <= 12;
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'hc2;		// buffer read
	while (~address_in)
		#2 ;
	#6
	hold_out <= 0;
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	maybe_card_data <= 1;
	maybe_recv_data <= 1;
	#2 ;
start_poll <= 1;
	start_poll <= 1;
	#2;
	#8
	while (~saw_devend) begin
		#2 ;
	end
	maybe_recv_data <= 0;
	maybe_card_data <= 0;
	start_poll <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;

	start_poll <= 0;
	#30 ;
	end
endtask
task do_read_count_term;
input [7:0] lbl;
input [15:0] ds;
input [15:0] sz;
	begin

saw_devend <= 0;
$display("T=%d  -- read device=%d / count termination #%d", $time, test_dev, lbl);
	data_start <= ds;
	data_lim <= ds + sz;
	data_index <= ds;
kbd_index <= 12;
kbd_size = 19;
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'ha;		// read
	while (~address_in)
		#2 ;
	#6
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	maybe_card_data <= 1;
	maybe_recv_data <= 1;
	#2 ;
start_poll <= 1;
	hold_out <= 0;
	#2;
	#8
	while (~saw_devend) begin
		#2 ;
	end
	maybe_recv_data <= 0;
	maybe_card_data <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;

	start_poll <= 0;
	#30 ;
	end
endtask
task do_read_cancel;
input [7:0] lbl;
input [15:0] ds;
input [15:0] sz;
	begin

saw_devend <= 0;
$display("T=%d  -- read device=%d / cancel #%d", $time, test_dev, lbl);
	data_start <= ds;
	data_lim <= ds + sz;
	data_index <= ds;
kbd_index <= 16;
kbd_size = 20;
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'ha;		// read
	while (~address_in)
		#2 ;
	#6
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	maybe_card_data <= 1;
	maybe_recv_data <= 1;
	#2 ;
start_poll <= 1;
	hold_out <= 0;
	#2;
	#8
	while (~saw_devend) begin
		#2 ;
	end
	maybe_recv_data <= 0;
	maybe_card_data <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;

	start_poll <= 0;
	#30 ;
	end
endtask
task do_read_bad_parity;
input [7:0] lbl;
input [15:0] ds;
input [15:0] sz;
	begin


saw_devend <= 0;
$display("T=%d  -- read device=%d / bad parity #%d", $time, test_dev, lbl);
	data_start <= ds;
	data_lim <= ds + sz;
	data_index <= ds;
kbd_index <= 20;
kbd_size = 28;
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'ha;		// read
	while (~address_in)
		#2 ;
	#6
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	maybe_card_data <= 1;
	maybe_recv_data <= 1;
	#2 ;
start_poll <= 1;
	hold_out <= 0;
	#2;
	#8
	while (~saw_devend) begin
		#2 ;
	end
	maybe_recv_data <= 0;
	maybe_card_data <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;

	start_poll <= 0;
	#30 ;

	end
endtask
task do_read_good_parity;
input [7:0] lbl;
input [15:0] ds;
input [15:0] sz;
	begin

saw_devend <= 0;
$display("T=%d  -- read device=%d / good parity #%d", $time, test_dev, lbl);
	data_start <= ds;
	data_lim <= ds + sz;
	data_index <= ds;
kbd_index <= 28;
kbd_size = 44;
	bs_out <= test_dev;
	#2
	address_out <= 1;
	#2
	hold_out <= 1;
	#16
	address_out <= 0;
	bs_out <= 'ha;		// read
	while (~address_in)
		#2 ;
	#6
	command_out <= 1;
	while (address_in)
		#2 ;
	#6
	command_out <= 0;
	bs_out <= 0;
	#4
	while (~status_in)
		#2 ;
	#2 ;
	service_out <= 1;
	#2 ;
	while (status_in)
		#2 ;
	#2
	service_out <= 0;
	maybe_card_data <= 1;
	maybe_recv_data <= 1;
	#2 ;
start_poll <= 1;
	hold_out <= 0;
	#2;
	#8
	while (~saw_devend) begin
		#2 ;
	end
	maybe_recv_data <= 0;
	maybe_card_data <= 0;
	while (operational_in || address_in || status_in || service_in)
		#2 ;

	start_poll <= 0;
	#30 ;

	end
endtask
task do_final_poll;
	begin

$display("T=%d  -- final poll --", $time);
	hold_out <= 1;
	maybe_status <= 1;
	#30;
	if (hold_out & ~operational_in)
		hold_out <= 0;

	end
endtask
task do_check_reset;
integer i;
begin
	if (x_2540_reader_check || read_val_chk) begin
$display("T=%d: doing check reset", $time);
		check_reset <= 1;
		#16 ;
		i <= 0;
		while (i < 32 && (x_2540_reader_check || read_val_chk)) begin
			i <= i + 2;
			#2 ;
		end
		check_reset <= 0;
	end
end
endtask

initial begin
	#2;
	do_init();
	do_push_not_ready();
	do_push_ready();
	do_ready_punch();
	do_select_no_such_dev();
	do_testio();
if ($test$plusargs("LONG") !== 0) begin // +LONG
	do_write_burst(8'h80, 1, baby, 12);
end
	set_card_data(500, some_data, dataoff);
		set_card_sequence(500 + 72, abc, seqno);
	do_write_burst(8'h40, 2, 500, 80);
	set_card_data(500, some_data, dataoff);
		set_card_sequence(500 + 72, abc, seqno);
		copy_to_holes(500, 600);
	do_write_burst(8'h21, 3, 600, 160);
if ($test$plusargs("INVBIT") !== 0) begin
$display("T=%d: setting bad bit for next write", $time);
	set_card_data(500, some_data, dataoff);
		set_card_sequence(500 + 72, abc, seqno);
		copy_to_holes(500, 600);
	sbuf[604] = sbuf[604] | 'h2a;	// T02 (aaa)
	sbuf[605] = sbuf[605] | 'h2a;	// 468
	do_write_burst(8'h21, 9, 600, 160);
	do_sense_burst(1, 300);
	do_write_burst(8'h0, 10, baby, 12);
end
if ($test$plusargs("BADBIT") !== 0) begin
$display("T=%d: setting bad bit for next write", $time);
	rp_strobe <= 1;
	rp_cmd <= "p";
	set_card_data(500, some_data, dataoff);
		set_card_sequence(500 + 72, abc, seqno);
	do_write_burst(8'h0, 4, 500, 80);
	do_sense_interleave(13, 300);
end
if ($test$plusargs("DIAG") !== 0) begin // +DIAG
	do_read_burst('hc4,11, 300, 20);
	do_sense_interleave(13, 300);
end
if ($test$plusargs("LONG") !== 0) begin // +LONG
	do_write_burst(8'h0, 5, baby, 12);
	set_card_data(500, some_data, dataoff);
		set_card_sequence(500 + 72, abc, seqno);
	do_write_burst(8'h0, 6, 500, 80);
	set_card_data(500, some_data, dataoff);
		set_card_sequence(500 + 72, abc, seqno);
	do_write_burst(8'h0, 7, 500, 80);
	set_card_data(500, some_data, dataoff);
		set_card_sequence(500 + 72, abc, seqno);
	do_write_burst(8'h0, 8, 500, 80);
end
	do_no_op();
	do_read_backward();
	do_alarm();
	do_ill_cmd();
	do_sense_burst(2, 300);
	do_sense_interleave(2, 301);
	do_unsolicited_poll();
	do_read_burst('hc0,1, 300, 20);
	do_sense_burst(3, 300);
	do_read_interleaved(1,300, 20);
	do_sense_burst(4, 300);
	do_read_count_term(1,300, 5);
	do_sense_interleave(5, 300);
	do_read_cancel(1,300,5);
	do_sense_interleave(6, 300);
	do_read_bad_parity(1,300,9);
	do_sense_interleave(7, 300);
	do_read_good_parity(1,300,15);
	do_sense_interleave(8, 300);
	do_final_poll();
	#30 $finish;
end
endmodule
