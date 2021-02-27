#include <stdio.h>
#include <stdlib.h>
#include "codes.h"

typedef unsigned short uint16;
typedef unsigned char uint8;

char *convert_te09(int holes, char *buf)
{
	char *r = buf;
	char *cp = buf;
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
	return r;
}

int
main(int ac, char **av)
{
	int i, j, e;
	int h;
	char buf[512];
	printf ("");
	for (j = 0; j < 16; ++j)
		printf ((j == 15 ? "   %xx\n" : " %3xx "), j);
	for (i = 0; i < 16; ++i)
	{
	printf ("x%x ", i);
	for (j = 0; j < 16; ++j)
	{
		e = j*16 + i;
		h = e_to_pc[e];
		printf ((j == 15 ? "%s\n" : "%-6s"),
			convert_te09(h, buf));
	}
	}
}
