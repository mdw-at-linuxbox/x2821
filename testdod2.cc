#include <stdio.h>
#include <iostream>
#include <sstream>
#include <sys/socket.h>
#include <string.h>
#include <cerrno>
#include <functional>
#include "verilated.h"
#include "verilated_vpi.h"
#include "verilated_vcd_c.h"
#include "Vdod2.h"
#include "testb.h"

int vflag;
int exitcode;

#define MAXG 8000
#define UARTSETUP 25

int countbits(unsigned x)
{
	int r = 0;
	while (x) {
		if (x&1) ++r;
		x >>= 1;

	}
	return r;
}

int my_log2(unsigned n)
{
	int r, m;
	for (r = 0, m = 1; m; m<<=1,++r)
		if (m >= n) return r;
	return 0;
}

int dodec(int req)
{
	int r;
	for (r = 12; r > 0; --r) {
		if (req & (1<<(12-r)))
			return r;
	}
	return 0;
}

#define N(a)	(sizeof a/sizeof *a)

struct MYDATA {
bool x_done = false;
bool said_done = false;
int req;
int errors = 0;
MYDATA(){
	x_done = 0;
}

// return: <8> = step
//	<7:0> = next req
int initial_value(int select)
{
	req = 0;
	return req;
}
int next_value(int select)
{
	if (x_done) return 0;
	if (req >= 4095) {
		x_done = 1;
	}
	else ++ req;
	return req;
}
void process_value(int valid, int select)
{
	std::ostringstream ss;
	int f;

	f = 0;
	if (!!req != valid) {
		ss << " select where no req?";
		f = 1;
	}
	if (valid ? (select < 1 || select > 12) : !!select ) {
		if (f) ss << ",";
		ss << " out of range";
		f = 1;
	}
	if (valid & !(req & (1<<(12-select))))
	{
		if (f) ss << ",";
		ss << " selected non-requested";
		f = 1;
	}
	std::string problem { ss.str() };
	int mask;
	mask = (1<<(12-select))-1;
// std::cerr << "req=" << std::hex << req << " mask=" << mask << " select=" << std::dec << select << " valid=" << valid< std::endl;
	if (req & mask) {
		if (f) ss << ",";
		ss << " ignored higher priority";
		f = 1;
	}
	if (vflag || f) {
		std::cout << "req=" << std::hex << req << " select=" << std::dec << select << " valid=" << valid;
		if (f) {
std::cout << " should-be=" << dodec(req);
			std::cout << problem;
		}
		std::cout << std::endl;
	}
	if (f) ++errors;
}
void report()
{
	if (errors) {
		std::cerr << errors << " errors" << std::endl;
		exitcode = 1;
	}
}

bool done()
{
	if (x_done) {
		report();
		said_done = true;
	}
	return said_done;
}
};

struct CCC1_TB : public TESTB<Vdod2> {
	unsigned long m_tx_busy_count;
//	UARTSIM m_uart;
	MYDATA m_data[1];
	bool m_done;
	int look_neg_edge;
	int start_count = 6;

	CCC1_TB(int port=0) : m_done(false) {}
	void trace(const char *filename) {
		std::cerr << "opening TRACE(" << filename << ")" << std::endl;
		opentrace(filename);
	}
	void close() {
		TESTB<Vdod2>::closetrace();
	}
	int before_posedge() {
		if (!m_core->i_reset)
			m_data->process_value(m_core->o_match,m_core->o_out);
		return 1;
	}
	int after_posedge() {
		int q;
		m_done |= m_data->done();
		if (m_done) return 0;
		if (m_core->i_reset)
			q = m_data->initial_value(0);
		else
			q = m_data->next_value(m_core->o_out);
		m_core->i_in = q;
//		m_core->i_step = !!(q & 16);
		return 1;
	}
	bool done(void) {
		if (m_done)
			return true;
		if (Verilated::gotFinish() || m_data->done()) {
			m_done = true;
#if 0
			report_priorities();
#endif
		}
		return m_done;
	}
};

vluint64_t main_time = 0;
double sc_time_stamp()
{
	return main_time;
}

pthread_mutex_t stdio_mutex[1];

void
flush_std_things()
{
	pthread_mutex_lock(stdio_mutex);
	fflush(stdout);
	fflush(stderr);
	pthread_mutex_unlock(stdio_mutex);
}

struct dod2_arg {
	char *vcd_out;
	CCC1_TB *tb;
};

void *
run_dod2(void *a)
{
	int count;
	auto tb = new CCC1_TB(-1);
	struct dod2_arg *ap = (struct dod2_arg *) a;

	ap->tb = tb;
	if (ap->vcd_out)
		tb->trace(ap->vcd_out);
	tb->reset();
//	if (ap->w > 0)
//		tb->m_uart.add_fds(ap->r, ap->w);
	count = 0;
	while (!tb->done()) {
		++main_time;
		tb->tick();
		if (++count > 1000)
		{
			count = 0;
			flush_std_things();
		}
	}
	tb->close();
	ap->tb = 0;
	delete tb;
	return NULL;
}

int
main(int ac, char **av)
{
	char *ap;
	struct dod2_arg arg[1];
	int count;
	int r;

	memset(arg, 0, sizeof *arg);
	Verilated::commandArgs(ac, av);
	while (--ac > 0) if (*(ap = *++av) == '-') while (*++ap) switch(*ap) {
	case 'v':
		++vflag;
		break;
	case 'o':
		if (--ac <= 0) {
			std::cerr << "-o: missing file" << std::endl;
			goto Usage;
		}
		arg->vcd_out = *++av;
		break;
	default:
		std::cerr << "don't grok switch " << *ap << std::endl;
	Usage:
		std::cerr << "Usage: testdod2 [-o trace.vcd]\n";
		exit(0);
	} else if (!memcmp(ap, "+verilator", 10))
		;
	else {
		std::cerr << "don't know what to do with " << ap << std::endl;
		goto Usage;
	}
	run_dod2(arg);
	r = exitcode;
	exit(r);
}
