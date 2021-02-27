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

int aflag;
int tflag;
int vflag;
int hflag;
int nflag;

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
	case 0:
		if (e == 0x40)
			return catstr(cp, "sp");
		if (e == 0)
			return catstr(cp, "nul");
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

unsigned char e_to_bcd[4096];

void
generate_prototype()
{
	int b;
	int v;
	int ix;
	memset(e_to_bcd, 0377, sizeof e_to_bcd);
	for (b = 0; b < 64; ++b)
	{
		ix = b_to_e[b];
		if (ix == 0) continue;
		e_to_bcd[ix] = b;
		if (ix >= 0xc1 && ix <= 0xc9
		|| ix >= 0xd1 && ix <= 0xd9
		|| ix >= 0xe2 && ix <= 0xe9) {
			ix &= ~0x40;	// uc to lc
			e_to_bcd[ix] = b;
		}
	}
	// handle the 4 characters dualed between AN and HN
	// page 33 A24-3312-7_2821_Component_Descr_Nov69.pdf
	e_to_bcd[0x7e] = e_to_bcd[0x7b];	// # =
	e_to_bcd[0x7d] = e_to_bcd[0x7c];	// @ '
	e_to_bcd[0x4d] = e_to_bcd[0x6c];	// % (
	e_to_bcd[0x5d] = e_to_bcd[0x4c];	// square )
}

void
do_match_pattern(char *pat)
{
	char *cp, *cp2, *cp3;
	int m, n, e;
	int tt;
	char temp[512];
	char t2[512];
	if ((cp = strchr(pat, ' ')))
		*cp = 0;
	m = n = 0;
	for (cp = pat; *cp; ++cp)
	{
		m <<= 1;
		n <<= 1;
		switch(*cp) {
		case '1':
			n |= 1;
		case '0': 
			m |= 1;
		case '-':
			continue;
		default:
			fprintf(stderr,
				"Unexpected char <%c> in pattern <%s>\n",
				*cp, pat);
			return;
		}
	}
	*temp = 0;
	cp = temp;
	cp2 = catstr(t2, " ");
	for (e = 0; e < 255; ++e) {
		tt = e_to_bcd[e];
		if (tt == 0377 && !aflag)
			continue;

		if ((e & m) != n) continue;

		cp3 = cat_pchar(cp2, e);
		if (cp3 - cp2 > 1) {
			if (!nflag)
				cp2 = catstr(cp3, " ");
		} else {
			cp = catstr(cp, cp2);
		}
	}
	*--cp2 = 0;
	printf ("%s %s%s\n",
		pat, temp, t2);
}

int
main(int ac, char **av)
{
	char *ap;
	int r = 0;
	int f;
	int m;
	f = 0;
	generate_prototype();
	r = 0;
	while (--ac > 0) if (*(ap = *++av) == '-' && ap[1]) while (*++ap) switch (*ap) {
//	case 't':
//		++tflag;
//		break;
//	case 'v':
//		++vflag;
//		break;
	case 'a':
		++aflag;
		break;
//	case 'f':
//		++fflag;
//		break;
//	case 'h':
//		++hflag;
//		break;
	case 'n':
		++nflag;
		break;
	default:
		fprintf(stderr,"Bad switch <%c>\n", *ap);
	Usage:
		fprintf(stderr,"Usage: ./e2b3 [-af] [h]\n");
		exit(1);
	} else {
		f = 1;
		do_match_pattern(ap);
	}
	if (!f) {
		r = 0;
		char bu[512];
		while (fgets(bu, sizeof bu, stdin)) {
			if ((ap = strchr(bu, '\n')))
				*ap = 0;
			if (*bu == '.' || *bu == '#' || !*bu || *bu == '=') {
				printf ("%s\n", bu);
				continue;
			}
			do_match_pattern(bu);
		}
	}
	exit(r);
}
