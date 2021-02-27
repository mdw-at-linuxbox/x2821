// ebcdic to bcd(modified) conversion
// chain order:
// A24-3312-7_2821_Component_Descr_Nov69.pdf
//	AN print train
//	pages 48-49 (pdf pages 48-50)
//	figures 12,13
// character sequence:
// 223-2590_CE_Instruction_1414_Models_3456_and_8.pdf
//	figure 53 on page 58 (pdf 61)
// wp/s360.37
// testbed for ebcdic to bcd converter function
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
typedef unsigned short uint16;
typedef unsigned char uint8;
#include "codes.h"
#include "ptt8.h"
#include "etoa.h"
#include "e2bcd.h"

int aflag;
int tflag;
int vflag;
int hflag;

// 48 characters as 2 x 4 encoding (4 x 12): [0123][1-c]
unsigned char b_to_e[]= {
   0, 0xf1, 0xf2, 0xf3, 0xf4, 0xf5, 0xf6, 0xf7,	// `1234567
0xf8, 0xf9, 0xf0, 0x7b, 0x7c,    0,    0,    0,	// 890#@```
   0, 0x61, 0xe2, 0xe3, 0xe4, 0xe5, 0xe6, 0xe7,	// `/STUVWX
0xe8, 0xe9, 0x50, 0x6b, 0x6c,    0,    0,    0,	// YZ&,%```
   0, 0xd1, 0xd2, 0xd3, 0xd4, 0xd5, 0xd6, 0xd7,	// `JKLMNOP
0xd8, 0xd9, 0x60, 0x5b, 0x5c,    0,    0,    0,	// QR-$*```
   0, 0xc1, 0xc2, 0xc3, 0xc4, 0xc5, 0xc6, 0xc7,	// `ABCDEFG
0xc8, 0xc9, 0x4e, 0x4b, 0x4c,    0,    0,    0,	// HI+.<```
};

int countbits(unsigned x)
{
	int r = 0;
	while (x) {
		if (x&1) ++r;
		x >>= 1;

	}
	return r;
}

char *catstr(char *d, char *s)
{
	while (*d++ = *s++)
		;
	return --d;
}

char *cat_pchar(char *cp, unsigned char e)
{
	unsigned char p = e_to_ptt[e];
	unsigned char a = etoa[e];
	if (a <= 32 || a >= 0x7f || a == '\\') switch(p & 077)
	{
	// GA24-3231-7_360-30_funcChar.pdf page 62
	case 014: return catstr(cp, "pn");
	case 015: return catstr(cp, "rs");
	case 016: return catstr(cp, "uc");
	case 017: return catstr(cp, "eot");
	case 034: return catstr(cp, "byp");
	case 035: return catstr(cp, "lf");
	case 036: return catstr(cp, "eob");
	case 037: return catstr(cp, "pre");
	case 054: return catstr(cp, "res");
	case 055: return catstr(cp, "nl");
	case 056: return catstr(cp, "bs");
	case 057: return catstr(cp, "il");
	case 074: return catstr(cp, "pf");
	case 075: return catstr(cp, "ht");
	case 076: return catstr(cp, "lc");
	case 077: return catstr(cp, "del");
	case 0: return catstr(cp, "sp");
	default:
		sprintf (cp, "\\x%02x", e);
		while (*cp)
			++cp;
		return cp;
	}
	*cp++ = a;
	*cp = 0;
	return cp;
}

unsigned char
e2bcd(unsigned char e)
{
	int e0,e1,e2,e3,e4,e5,e6,e7;
	int r1,r2,r4,r8,rA,rB;
	int r = 0;
	int s, b;

	e0 = !!(e&128);
	e1 = !!(e&64);
	e2 = !!(e&32);
	e3 = !!(e&16);
	e4 = !!(e&8);
	e5 = !!(e&4);
	e6 = !!(e&2);
	e7 = !!(e&1);

	s = /* !e0 & */ !e2 & !e3 & !e4 & !e5 & !e6 & !e7;
	b = s | !(
		e0 & e1 & e2 & e3 & !e4 |		// 01234567
/*(*/		!e0 & e1 & e3 & e4 & e5 & !e6 |		// *)@'
		!e0 & e1 & e2 & e3 & e4 & e5 & !e7 |	// @=
		!e0 & e1 & !e2 & !e3 & e4 & e5 & !e7 |	// <+
		!e0 & e1 & !e2 & e4 & e5 & !e6 |	// <(*)
		!e0 & e1 & e2 & !e3 & !e4 & !e5 & !e6 |	// -/
		!e0 & e1 & !e2 & e3 & !e4 & !e5 & !e6 & !e7 |	// &
		!e0 & e1 & e4 & !e5 & e6 & e7 |		// .$,#
		!e0 & e1 & e4 & e5 & !e6 & !e7 |	// <*%@
		e0 & !e2 & !e4 & e7 |			// acegjlnpACEGJLNP
		e0 & (e1 | !e2 | !e3) & e4 & !e5 & !e6 |// 89HIQRYZhiqryz
		e0 & (!e2 | !e3) & !e4 & (e5 | e6)	// BCDEFGKLMNOPSTUVWXbcdefgklmnopstuvwx
		);
	r1 = e2 & e4 & e5 & e6 |		// =
		(!e5 | !e4) & e7 |		// .$/,#acijlrtzACIJLRTZ139
						// /acegjlnptvxACEGJLNPTVX1357
		e2 & !e3 & e7 |			// /,tvxzTVXZ
		e6 & e7;			// .$,#cglptxCGLPTX37
	r2 = !( !e6 & (e4 | e5 | e7) |
		!e0 & !e2 & !e3 & !e6 |		// <(
/*)*/		e0 & e2 & !e3 & !e6		// uvyzUVYZ
	);
	r4 = !(	(e2 | !e3) & e4 & e6 & !e7 |	// +=
		!e5				// .&$-/,#abchijklqrstyzABCHIJKLQRSTYZ012389
		);
	r8 = e0 & !e2 & !e5 & !e6 & !e7 |	// hqHQ
		!e0 & e2 & !e5 & !e6 & !e7 |	// -
		e3 & !e5 & !e6 & !e7 |		// &qQ08
		e4;				// .<(+$*),%#@'=hiqryzHIQRYZ89
	rA = !e0 & !e2 & !e4 & !e5 & !e6 & !e7 |	// &
		e0 & !e1 & !e2 & e4 & !e5 & e6 & e7 |	// 
		!e2 & e4 &e5 & !e6 & e7 |		// ()
		!e3 & (e7 | e6 | e5 | e4 | e0);	// %(+,./<ABCDEFGHISTUVWXYZabcdefghistuvwxyz
	rB = !e0 & !e3 & !e4 & !e5 & !e6 & !e7 |	// -
		!e2 & e3 & (e0 | e7) |			// jklmnopqrJKLMNOPQR
							// $)jlnprJLNPR
		!e2 & e4 & !e7 |			// <+*hqHQ
		!e2 & !e5 & e7 |			// .$acijlrACIJLR
		!e2 & !e4 & e5 |			// defgmnopDEFGMNOP
		!e2 & e6;				// .+$bcfgklopBCFGKLOP

	r = (r1<<0) | (r2<<1) | (r4<<2)
		| (r8<<3) | (rA<<4) | (rB<<5);
	r |= (s << 6);	// space
	r |= (b << 7);	// unprintable

//printf ("X %x %d%d%d%d%d %d%d%d%d%d %d %d %d ; %d\n", e,
//ta,tb,tc,td,te,ua,ub,uc,ud,ue, h, t, u, r);
	return r;
}

int
e_to_flags(unsigned char e)
{
	int e0,e1,e2,e3,e4,e5,e6,e7;
	int z4567;
	int s, b;
	int r;

	e0 = !!(e&128);
	e1 = !!(e&64);
	e2 = !!(e&32);
	e3 = !!(e&16);
	e4 = !!(e&8);
	e5 = !!(e&4);
	e6 = !!(e&2);
	e7 = !!(e&1);
	z4567 = (!e4 & !e5 & !e6 & !e7);	// 50 60 f0: &-0
	s = /* !e0 & */ !e2 & !e3 & !e4 & !e5 & !e6 & !e7;
	b = // s |
		!e0 & !e1 |
		!e0 & !e4 & (e5 | e6) |
		e0 & e4 & (e5 | e6) |
		!e1 & e2 & e3 |
		!e0 & e4 & !e5 & !e6 |
		!e0 & !e2 & !e3 & !e4 |
		!e0 & e3 & !e4 & e7 |
		e0 & e2 & !e3 & !e4 & !e5 & !e6 |
		!e0 & !e5 & e6 & !e7 |
		e4 & e5 & e6 & e7 |
		e0 & !e2 & z4567 |
		e2 & !e3 & e4 & e5 & !e6 & e7 |
		!e2 & e3 & e4 & e6 & !e7 |
		e2 & !e3 & e4 & e6 & !e7 |
		!e0 & e2 & e3 & !e4;
	r = (s << 6) |		// space
		(b << 7);	// unprintable
	return r;
}

int
test_e2bcd()
{
	int e;
	int r;
	int ebits = 0;
	int x;
	int wrong = 0;
	int i;
	char buf[30];
	r = 0;
	char xbits[8][20];
	char *oops;

	memset(xbits, 0, sizeof xbits);
	for (e = 0; e < 256; ++e) {
		oops = "";
		int b1, b2, b1x;
		b2 = e_to_bcd[e];
		b2 |= e_to_flags(e);
		b1 = e2bcd(e);
		b1x = b1;
//		if ((b1 & 0xf) < 1 || (b1 & 0xf) > 12)
//			oops = " BAD";
//		if ((b1 & 0200) && aflag)
//			b1 &= ~077;
		cat_pchar(buf, e);
		if (b1 != b2) {
			++wrong;
			x=b1^b2;
			ebits += countbits(x);
			printf ("%2x: (%s) %02o%s should be %02o x=%02x",
				e, buf, b1x, oops, b2, x);
			printf ("\n");
			++r;
		} else if (vflag || *oops) {
			printf ("%2x: (%s) %02o%s\n", e, buf, b1x, oops);
		}
	}
	if (tflag) {
	for (i = 0; i < 8; ++i)
	if (*xbits[i])
		printf ("%d\t%s\n", i, xbits[i]);
	}
	printf ("e2bcd: %d bits in error; %d characters wrong\n", ebits, wrong);
	return !!r;
}

void
print_etable()
{
	int i, j;
	int hex;
	char buf[30];
	char outbuf[90], *bp;
	int m1, m2, mask;
	m1 = 16;
	m2 = 16;
	mask = 15;
	printf ("unsigned char e_to_bcd[256] = {\n");
	for (i = 0; i < m1; ++i) {
		bp = catstr(outbuf, "//");
		for (j = 0; j < m2; ++j) {
			hex = j + (i*m2);
			*buf = 0;
			if (e_to_bcd[hex] != 0xff)
				cat_pchar(buf, hex);
			sprintf (bp, " %3.3s", buf);
			bp += strlen(bp);
		}
		for (;;) {
			--bp;
			if (bp < outbuf+60) break;
			if (*bp != ' ') break;
		}
		*++bp = 0;
		printf ("%s\t// %x - %x", outbuf, hex&~mask, hex | mask);
		printf ("\n   ");
		for (j = 0; j < m2; ++j) {
			hex = j + (i*m2);
			if (e_to_bcd[hex] == 0377)
			strcpy(buf, "~0");
			else if (e_to_bcd[hex])
			snprintf (buf, sizeof buf, "0%o", e_to_bcd[hex]);
			else
			strcpy(buf, "0");
			printf ("%03s,", buf);
		}
		printf ("\n");
	}
	printf ("};\n");
}

int
process_just_one(char *cp)
{
	int e;
	char buf[20];
	e = strtol(cp, 0, 16);
	cat_pchar(buf, e);
	printf ("e %02x -> bcd %02o; %s\n", e, e2bcd(e), buf);
}

int
main(int ac, char **av)
{
	char *ap;
	int r = 0;
	int f;
	f = 0;
	while (--ac > 0) if (*(ap = *++av) == '-' && ap[1]) while (*++ap) switch (*ap) {
	case 't':
		++tflag;
		break;
	case 'v':
		++vflag;
		break;
	case 'a':
		++aflag;
		break;
	case 'h':
		++hflag;
		break;
	default:
		fprintf(stderr,"Bad switch <%c>\n", *ap);
	Usage:
		fprintf(stderr,"Usage: ./e2bcd1 [-te] [h]\n");
		exit(1);
	} else {
		f = 1;
		process_just_one(ap);
	}
	if (!f) {
		r = 0;
		if (hflag)
			print_etable();
		else
			r = test_e2bcd();
	}
	exit(r);
}
