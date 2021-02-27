#CFLAGS=-g -I. -O2
CFLAGS=-g -I. -O0
CXXFLAGS=-g -I. -Iobj -I/usr/share/verilator/include -I/usr/share/verilator/include/vltstd -std=c++17
O=verilated.o verilated_vcd_c.o
P=-lpthread
A=$B $Q
B=x2821_tb x2821a_tb x2821b_tb testccc9 testccc12 pebc e2b6
Q=ccc9.pdf ccc12.pdf
all: $A
ccc12.pdf: ccc12.dot
	dot -Tpdf -o ccc12.pdf ccc12.dot
ccc12.dot: ccc12.v ccc12.ys
	yosys -s ccc12.ys
testccc12: Vccc12.h Vccc12__ALL.a testccc12.o $O
	$(CXX) $(CXXFLAGS) -o testccc12 testccc12.o $O Vccc12__ALL.a $P
Vccc12.h Vccc12__ALL.a: ccc12.v
	verilator -Wall --MMD -trace -y . --Mdir . -cc ccc12.v
	$(MAKE) -C . -f Vccc12.mk
ccc10.pdf: ccc10.dot
	dot -Tpdf -o ccc10.pdf ccc10.dot
ccc10.dot: ccc10.v ccc10.ys
	yosys -s ccc10.ys
testccc10: Vccc10.h Vccc10__ALL.a testccc10.o $O
	$(CXX) $(CXXFLAGS) -o testccc10 testccc10.o $O Vccc10__ALL.a $P
Vccc10.h Vccc10__ALL.a: ccc10.v
	verilator -Wall --MMD -trace -y . --Mdir . -cc ccc10.v
	$(MAKE) -C . -f Vccc10.mk
ccc9.pdf: ccc9.dot
	dot -Tpdf -o ccc9.pdf ccc9.dot
ccc9.dot: ccc9.v ccc9.ys
	yosys -s ccc9.ys
testccc9: Vccc9.h Vccc9__ALL.a testccc9.o $O
	$(CXX) $(CXXFLAGS) -o testccc9 testccc9.o $O Vccc9__ALL.a $P
Vccc9.h Vccc9__ALL.a: ccc9.v
	verilator -Wall --MMD -trace -y . --Mdir . -cc ccc9.v
	$(MAKE) -C . -f Vccc9.mk
#
verilated.o: /usr/share/verilator/include/verilated.cpp
	$(CXX) $(CXXFLAGS) -c -o verilated.o /usr/share/verilator/include/verilated.cpp
verilated_vcd_c.o: /usr/share/verilator/include/verilated_vcd_c.cpp
	$(CXX) $(CXXFLAGS) -c -o verilated_vcd_c.o /usr/share/verilator/include/verilated_vcd_c.cpp
delay1.pdf: delay1.dot
	dot -Tps2 delay1.dot | ps2pdf - delay1.pdf
delay1.dot: delay1.v
	yosys -s delay1.ys
delay1_tb: delay1.v delay1_tb.v
	iverilog -y . -g2005-sv -o delay1_tb delay1_tb.v
ss2.pdf: ss2.dot
	dot -Tps2 ss2.dot | ps2pdf - ss2.pdf
ss2.dot: ss2.v
	yosys -s ss2.ys
ss2_tb: ss2.v ss2_tb.v
	iverilog -y . -g2005-sv -o ss2_tb ss2_tb.v
latch1.pdf: latch1.dot
	dot -Tps2 latch1.dot | ps2pdf - latch1.pdf
latch1.dot: latch1.v latch1.ys
	yosys -s latch1.ys
latch1_tb: latch1.v latch1_tb.v
	iverilog -y . -g2005-sv -o latch1_tb latch1_tb.v
latch2.pdf: latch2.dot
	dot -Tps2 latch2.dot | ps2pdf - latch2.pdf
latch2.dot: latch2.v latch2.ys
	yosys -s latch2.ys
latch2_tb: latch2.v latch2_tb.v
	iverilog -y . -g2005-sv -o latch2_tb latch2_tb.v
dodecode1.pdf: dodecode1.dot
	dot -Tps2 dodecode1.dot | ps2pdf - dodecode1.pdf
dodecode1.dot: dodecode1.v
	yosys -s dodecode1.ys
dodecode1_tb: dodecode1.v dodecode1_tb.v
	iverilog -y . -g2005-sv -o dodecode1_tb dodecode1_tb.v
dodecode2.pdf: dodecode2.dot
	dot -Tps2 dodecode2.dot | ps2pdf - dodecode2.pdf
dodecode2.dot: dodecode2.v
	yosys -s dodecode2.ys
dodecode2_tb: dodecode2.v dodecode2_tb.v
	iverilog -y . -g2005-sv -o dodecode2_tb dodecode2_tb.v
testdod2: Vdod2.h Vdod2__ALL.a Vccc10.h Vccc10__ALL.a testdod2.o $O
	$(CXX) $(CXXFLAGS) -o testdod2 testdod2.o $O Vdod2__ALL.a $P
testdod2.o: Vdod2.h
Vdod2.h Vdod2__ALL.a: dod2.v dodecode2.v
	verilator -CFLAGS "-g" -Wall --MMD -trace -y . --Mdir . -cc dod2.v
	$(MAKE) -C . -f Vdod2.mk
decade3.pdf: decade3.dot
	dot -Tps2 decade3.dot | ps2pdf - decade3.pdf
decade3.dot: decade3.v
	yosys -s decade3.ys
decade3_tb: decade3.v decade3_tb.v
	iverilog -y . -g2005-sv -o decade3_tb decade3_tb.v
## *way* too big to be useful...
#x2821.pdf: x2821.dot
#	dot -Tps2 x2821.dot | ps2pdf - x2821.pdf
#x2821.dot: x2821.v ss1.v ss2.v delay1.v latch1.v latch2.v latch3.v e2bcd3.v ccc13.v ccc9.v dodecode3.v decade7.v decade6.v decchk1.v docount1.v pdetect1.v trigger2.v trigger3.v delay2.v d132x5.v rlim4.v decade12.v decade14.v
#	yosys -s x2821.ys
x2821_tb: x2821.v x2821_tb.v sim1403x3.v sim2540x1.v ss1.v ss2.v delay1.v latch1.v latch2.v latch3.v e2bcd3.v ccc13.v ccc9.v dodecode3.v decade7.v decade6.v decchk1.v docount1.v pdetect1.v trigger2.v trigger3.v delay2.v d132x5.v rlim4.v pcg4.v decade12.v decade14.v ccc10.v
	iverilog -y . -g2005-sv -o x2821_tb x2821_tb.v
x2821a_tb: x2821.v x2821a_tb.v sim1403x3.v sim2540x1.v ss1.v ss2.v delay1.v latch1.v latch2.v latch3.v e2bcd3.v ccc13.v ccc9.v dodecode3.v decade7.v decade6.v decchk1.v docount1.v pdetect1.v trigger2.v trigger3.v delay2.v d132x5.v rlim4.v pcg4.v decade12.v decade14.v ccc10.v
	iverilog -y . -g2005-sv -o x2821a_tb x2821a_tb.v
x2821b_tb: x2821.v x2821b_tb.v sim1403x3.v sim2540x1.v ss1.v ss2.v delay1.v latch1.v latch2.v latch3.v e2bcd3.v ccc13.v ccc9.v dodecode3.v decade7.v decade6.v decchk1.v docount1.v pdetect1.v trigger2.v trigger3.v delay2.v d132x5.v rlim4.v pcg4.v decade12.v decade14.v ccc10.v
	iverilog -y . -g2005-sv -o x2821b_tb x2821b_tb.v
decade6.pdf: decade6.dot
	dot -Tps2 decade6.dot | ps2pdf - decade6.pdf
decade6.dot: decade6.v
	yosys -s decade6.ys
decade6_tb: decade6.v decade6_tb.v
	iverilog -y . -g2005-sv -o decade6_tb decade6_tb.v
docount1.pdf: docount1.dot
	dot -Tps2 docount1.dot | ps2pdf - docount1.pdf
docount1.dot: docount1.v
	yosys -s docount1.ys
docount1_tb: docount1.v docount1_tb.v
	iverilog -y . -g2005-sv -o docount1_tb docount1_tb.v
ccc18.pdf: ccc18.dot
	dot -Tpdf -o ccc18.pdf ccc18.dot
ccc18.dot: ccc18.v ccc18.ys
	yosys -s ccc18.ys
testccc18: Vccc18.h Vccc18__ALL.a testccc18.o $O
	$(CXX) $(CXXFLAGS) -o testccc18 testccc18.o $O Vccc18__ALL.a $P
Vccc18.h Vccc18__ALL.a: ccc18.v
	verilator -Wall --MMD -trace -y . --Mdir . -cc ccc18.v
	$(MAKE) -C . -f Vccc18.mk
decchk1.pdf: decchk1.dot
	dot -Tps2 decchk1.dot | ps2pdf - decchk1.pdf
decchk1.dot: decchk1.v
	yosys -s decchk1.ys
decchk1_tb: decchk1.v decchk1_tb.v
	iverilog -y . -g2005-sv -o decchk1_tb decchk1_tb.v
delay2.pdf: delay2.dot
	dot -Tps2 delay2.dot | ps2pdf - delay2.pdf
delay2.dot: delay2.v
	yosys -s delay2.ys
delay2_tb: delay2.v delay2_tb.v
	iverilog -y . -g2005-sv -o delay2_tb delay2_tb.v
rlim4.pdf: rlim4.dot
	dot -Tps2 rlim4.dot | ps2pdf - rlim4.pdf
rlim4.dot: rlim4.v
	yosys -s rlim4.ys
rlim4_tb: rlim4.v rlim4_tb.v
	iverilog -y . -g2005-sv -o rlim4_tb rlim4_tb.v
d132x5.pdf: d132x5.dot
	dot -Tps2 d132x5.dot | ps2pdf - d132x5.pdf
d132x5.dot: d132x5.v
	yosys -s d132x5.ys
d132x5_tb: d132x5.v d132x5_tb.v
	iverilog -y . -g2005-sv -o d132x5_tb d132x5_tb.v
trigger2.pdf: trigger2.dot
	dot -Tps2 trigger2.dot | ps2pdf - trigger2.pdf
trigger2.dot: trigger2.v
	yosys -s trigger2.ys
trigger2_tb: trigger2.v trigger2_tb.v
	iverilog -y . -g2005-sv -o trigger2_tb trigger2_tb.v
pcg4.pdf: pcg4.dot
	dot -Tps2 pcg4.dot | ps2pdf - pcg4.pdf
pcg4.dot: pcg4.v pcg4.ys trigger2.v trigger3.v
	yosys -s pcg4.ys
pcg4_tb: pcg4.v pcg4_tb.v trigger2.v trigger3.v
	iverilog -y . -g2005-sv -o pcg4_tb pcg4_tb.v
e2bcd3.pdf: e2bcd3.dot
	dot -Tps2 e2bcd3.dot | ps2pdf - e2bcd3.pdf
e2bcd3.dot: e2bcd3.v
	yosys -s e2bcd3.ys
e2bcd3_tb: e2bcd3.v e2bcd3_tb.v
	iverilog -y . -g2005-sv -o e2bcd3_tb e2bcd3_tb.v
sim1403x3.pdf: sim1403x3.dot
	dot -Tps2 sim1403x3.dot | ps2pdf - sim1403x3.pdf
sim1403x3.dot: sim1403x3.v
	yosys -s sim1403x3.ys
sim1403x3_tb: sim1403x3.v sim1403x3_tb.v
	iverilog -y . -g2005-sv -o sim1403x3_tb sim1403x3_tb.v
dec2bin1.pdf: dec2bin1.dot
	dot -Tps2 dec2bin1.dot | ps2pdf - dec2bin1.pdf
dec2bin1.dot: dec2bin1.v
	yosys -s dec2bin1.ys
dec2bin1_tb: dec2bin1.v dec2bin1_tb.v
	iverilog -y . -g2005-sv -o dec2bin1_tb dec2bin1_tb.v
#
clean:
	rm -f *.vcd
	rm -f $B $Q
	rm -f *.o
	rm -f Vccc9_classes.mk Vccc9.mk Vccc9__ALL.a Vccc9.cpp Vccc9.h 
	rm -f Vccc10_classes.mk Vccc10.mk Vccc10__ALL.a Vccc10.cpp Vccc10.h 
	rm -f Vccc12_classes.mk Vccc12.mk Vccc12__ALL.a Vccc12.cpp Vccc12.h 
	rm -f Vccc18_classes.mk Vccc18.mk Vccc18__ALL.a Vccc18.cpp Vccc18.h 
	rm -f Vdod2_classes.mk Vdod2.mk Vdod2__ALL.a Vdod2.cpp Vdod2.h 
	rm -f V*__*.cpp V*__*.d V*__*.dat V*__*.h
	rm -f ccc12.dot ccc18.dot ccc9.dot d132x5.dot dec2bin1.dot decade3.dot
	rm -f decade6.dot decchk1.dot delay1.dot delay2.dot docount1.dot
	rm -f dodecode1.dot dodecode2.dot e2bcd3.dot latch1.dot latch2.dot pcg4.dot
	rm -f rlim4.dot sim1403x3.dot ss2.dot trigger2.dot x2821.dot
	rm -f d132x5.pdf dec2bin1.pdf decade4.pdf decade6.pdf
	rm -f delay1.pdf latch2.pdf pcg4.pdf rlim4.pdf trigger2.pdf
	rm -f testccc10 testccc18 testdod2
	rm -f d132x5_tb decade3_tb decade6_tb decchk1_tb delay1_tb
	rm -f delay2_tb docount1_tb dodecode1_tb dodecode2_tb e2bcd3_tb
	rm -f latch1_tb latch2_tb pcg4_tb rlim4_tb
	rm -f sim1403x3_tb ss2_tb trigger2_tb
