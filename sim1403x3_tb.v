`default_nettype none
`timescale 1ns / 1ns
module tb;

	reg clk;
	reg rst;

	wire sa1, sa2;

	reg [8:0] v;
	reg reset;
	reg advance;
	reg compare;
	reg [132:1] result;
	wire valid;
	wire [7:0] bar;
	reg low_speed_go;
	reg high_speed_go;
	wire mag_emitter;
	wire [11:0] slow_brushes;
	wire [11:0] stop_brushes;
	reg print;
	reg [132:1] hammer_fire;
	reg [8:0] ham;

initial begin
$dumpfile("sim1403x3.vcd");
$dumpvars(0, tb);
end

	sim1403x3 u0( .i_clk(clk), .i_reset(rst),
		.i_low_speed_start(low_speed_go),
		.i_low_speed_stop(~low_speed_go),
		.i_high_speed_start(high_speed_go),
		.i_high_speed_stop(~high_speed_go),
		.i_print(print), .i_hammer_fire(hammer_fire),
		.o_sense_amp_1(sa1),
		.o_sense_amp_2(sa2),
		.o_mag_emitter(mag_emitter),
		.o_slow_brushes(slow_brushes),
		.o_stop_brushes(stop_brushes));

	always #1 clk = ~clk;

	initial begin
		{clk, rst} <= 1;
		#3 rst <= 0;
	end

	reg [7:0] bcount;
	reg saved_mag;
	always @(posedge clk) begin
		saved_mag <= mag_emitter;
		if (mag_emitter & ~saved_mag)
			bcount <= bcount + 1;
	end

	initial begin
		low_speed_go <= 0;
		high_speed_go <= 0;
		print <= 0;
		hammer_fire <= 0;
		#3;
		# 1500;
$display("T=%0t 1ss", $time);
		low_speed_go <= 1;
		# (550*2) low_speed_go <= 0;
		# 1500 ;
$display("T=%0t 2ss", $time);
		low_speed_go <= 1;
		# (980*2) low_speed_go <= 0;
		# 1500 ;
$display("T=%0t 3ss", $time);
		low_speed_go <= 1;
		# (1830*2) low_speed_go <= 0;
		# 1500 ;
		bcount <= 0;
		#2 ;
$display("T=%0t carr high+low", $time);
		low_speed_go <= 1;
		high_speed_go <= 1;
		while (bcount < 7) begin
			#2;
		end
$display("T=%0t carr just low", $time);
		high_speed_go <= 0;
		while (bcount < 14) begin
			#2;
		end
$display("T=%0t carr stop", $time);
		low_speed_go <= 0;
		# 1500 ;
$display("T=%0t carr stopped", $time);
		low_speed_go <= 1;
		while (bcount < 130) begin
			#2;
		end
		low_speed_go <= 0;
		# 1500 ;
$display("T=%0t finish", $time);
		print <= 1;
		# 5000 ;
		hammer_fire <= 1<<131;
		# 10;
		hammer_fire <= 0;
		# 2;
		hammer_fire <= 1;
		# 10;
		hammer_fire <= 0;
		# 2;
		ham <= 0;
		# 2;
		while (ham < 133) begin
			# 8 ;
			hammer_fire <= (1<<ham);
			# 2;
			ham <= ham + 1;
			hammer_fire <= 0;
			# 2;
		end
		# 5000;
		print <= 0;
	end

	initial begin
	$monitor("T=%0t sa1=%d sa2=%x", $time, sa1, sa2);

	#610000;
		$finish;

	end
endmodule
