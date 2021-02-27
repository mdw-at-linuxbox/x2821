#include <stdio.h>
#include <iostream>
#include <sys/socket.h>
#include <string.h>
#include <cerrno>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vccc12.h"
#include "testb.h"
#include "codes.h"
typedef unsigned short uint16;
typedef unsigned char uint8;

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
int ebits = 0;

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

int h_to_e(uint16 h)
{
	int i;
	for (i = 0; i < 256; ++i)
		if (e_to_pc[i] == h)
			return i;
	return -1;
}

int next_value(unsigned char ebcdic, unsigned char bad)
{
	short expected = h_to_e(x_val);
	if (starting) {
		x_val = 0;
		starting = 0;
		settle = 1;
		return x_val;
	}
	if (settle--) return x_val;
	settle = 1;
	if (bad)
	{
		if (expected >= 0) {
			printf ("BAD(%02x) %03x %s",
				ebcdic,
				x_val, convert_te09(x_val).c_str());
			++wrong;
			printf ("; e should be %02x; x=%x", expected,
				ebcdic ^ expected);
		}
	} else {
		printf("%02x %03x %s",
			ebcdic,
			x_val, convert_te09(x_val).c_str());
		if (ebcdic != expected) {
			++wrong;
			if (expected >= 0)
				ebits += countbits(ebcdic ^ expected);
			printf ("; e should be %02x; x=%x", expected,
				ebcdic ^ expected);
		}
		printf ("\n");
	}
	++x_val;
	x_done = x_val > 0xfff;
	return x_val;
}
bool done()
{
	if (x_done) {
		printf ("%d bits in error; %d characters wrong\n",
			ebits, wrong);
	}
	return x_done;
}
};

struct CCC1_TB : public TESTB<Vccc12> {
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
		TESTB<Vccc12>::closetrace();
	}
	void tick() {
		if (m_done) return;
		m_core->i_holes = m_data->next_value(m_core->o_ebcdic, m_core->o_bad);
		TESTB<Vccc12>::tick();
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

struct ccc12_arg {
	char *vcd_out;
	CCC1_TB *tb;
};

void *
run_ccc12(void *a)
{
	int count;
	auto tb = new CCC1_TB(-1);
	struct ccc12_arg *ap = (struct ccc12_arg *) a;

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
	struct ccc12_arg arg[1];
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
		std::cerr << "Usage: ccc12 [-o trace.vcd]\n";
		exit(0);
	} else if (!memcmp(ap, "+verilator", 10))
		;
	else {
		std::cerr << "don't know what to do with " << ap << std::endl;
		goto Usage;
	}
	run_ccc12(arg);
	exit(r);
}
