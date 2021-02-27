#include <stdio.h>
#include <iostream>
#include <sys/socket.h>
#include <string.h>
#include <cerrno>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vccc10.h"
#include "testb.h"
#include "codes.h"

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

struct MYDATA {
bool x_done = false;
bool starting = 1;
int settle;
int x_val;
int wrong = 0;

std::string convert_te09(int holes)
{
	char x[30];
	char *cp = x;
	if (holes & 0x800) *cp++ = 'T';
	if (holes & 0x400) *cp++ = 'E';
	if (holes & 0x200) *cp++ = '0';
	if (holes & 0x100) *cp++ = '1';
	if (holes & 0x80) *cp++ = '2';
	if (holes & 0x40) *cp++ = '3';
	if (holes & 0x20) *cp++ = '4';
	if (holes & 0x10) *cp++ = '5';
	if (holes & 0x8) *cp++ = '6';
	if (holes & 0x4) *cp++ = '7';
	if (holes & 0x2) *cp++ = '8';
	if (holes & 0x1) *cp++ = '9';
	*cp = 0;
	return std::string(x);
}

int next_value(unsigned short holes)
{
	unsigned short expected = e_to_pc[x_val];
	if (starting) {
		x_val = 0;
		starting = 0;
		settle = 1;
		return x_val;
	}
	if (settle--) return x_val;
	settle = 1;
	printf("%02x %03x %s",
		x_val,
		holes, convert_te09(holes).c_str());
	if (holes != expected) {
		++wrong;
		printf ("; expected h %03x %s", expected,
			convert_te09(expected).c_str());
	}
	printf ("\n");
	++x_val;
	x_done = x_val > 0xff;
	return x_val;
}
bool done()
{
	if (x_done) {
		printf ("%d characters wrong\n",
			wrong);
	}
	return x_done;
}
};

struct CCC1_TB : public TESTB<Vccc10> {
	unsigned long m_tx_busy_count;
//	UARTSIM m_uart;
	MYDATA m_data[1];
	bool m_done;

	CCC1_TB(int port=0) : m_done(false) {}
	void trace(const char *filename) {
		std::cerr << "opening TRACE(" << filename << ")" << std::endl;
		opentrace(filename);
	}
	void close() {
		TESTB<Vccc10>::closetrace();
	}
	void tick() {
		if (m_done) return;
		m_core->i_ebcdic = m_data->next_value(m_core->o_holes);
		TESTB<Vccc10>::tick();
	}
	bool done(void) {
		if (m_done)
			return true;
		if (Verilated::gotFinish() || m_data->done())
			m_done = true;
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

struct ccc10_arg {
	char *vcd_out;
	CCC1_TB *tb;
};

void *
run_ccc10(void *a)
{
	int count;
	auto tb = new CCC1_TB(-1);
	struct ccc10_arg *ap = (struct ccc10_arg *) a;

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
	struct ccc10_arg arg[1];
	int count;
	int r;

	memset(arg, 0, sizeof *arg);
	Verilated::commandArgs(ac, av);
	while (--ac > 0) if (*(ap = *++av) == '-') while (*++ap) switch(*ap) {
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
		std::cerr << "Usage: ccc10 [-o trace.vcd]\n";
		exit(0);
	} else if (!memcmp(ap, "+verilator", 10))
		;
	else {
		std::cerr << "don't know what to do with " << ap << std::endl;
		goto Usage;
	}
	run_ccc10(arg);
	exit(r);
}
