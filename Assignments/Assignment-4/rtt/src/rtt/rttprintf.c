/****************************************************************************
 * 
 * RttPrintf.c
 * 
 * Formatted print module.
 * 
 ***************************************************************************
 * 
 * This code is Copyright 1994, 1995, 1996 by the Department of Computer
 * Science, University of British Columbia, British Columbia, Canada.
 * 
 * No part of of this code may be sold or used for any commercial purposes
 * without the expressed written permission of the University of
 * British Columbia.
 * 
 * RT Threads may be freely used, copied, modified, or distributed for
 * noncommercial purposes, provided that this copyright notice is
 * included in all sources.
 * 
 * RT Threads is provided as is.  The UBC Department of Computer Science
 * makes no warranty as to the correctness or fitness for use of the
 * RT Threads code or environment.
 * 
 ***************************************************************************
 */

#define NUMBUF (32)

#include <RttKernel.h>

#include <string.h>
#include <stdarg.h>
#include <ctype.h>

#ifndef sun4
#ifndef bcopy
#define bcopy(X,Y,Z) memmove(Y,X,Z)
#endif
#endif

int atoi(char *);

/*
 * num()
 *	Convert number to string
 *
 * Returns length of resulting string
 */
static int num(char *buf, unsigned int x, unsigned int base, int is_unsigned)
{
    char *p = buf+NUMBUF;
    unsigned int c, len = 1, neg = 0;

    /*
     * Only decimal is signed
     */
    if ((base == 10) && !is_unsigned) {
	if ((int)x < 0) {
	    neg = 1;
	    x = -(int)x;
	}
    }
    *--p = '\0';
    do {
	c = (x % base);
	if (c < 10) {
	    *--p = '0'+c;
	} else {
	    *--p = 'a'+(c-10);
	}
	len += 1;
	x /= base;
    } while (x != 0);
    
    /*
     * Add leading '-' if negative
     */
    if (neg) {
	*--p = '-';
	len += 1;
    }
    
    /*
     * Move numeric image to front of buffer
     */
    bcopy(p, buf, len);
    return(len-1);
}

/*
 * baseof()
 *	Given character, return base value
 */
static int baseof(char c)
{
    switch (c) {
    case 'u':
    case 'd':
    case 'U':
    case 'D':
	return(10);
    case 'x':
    case 'X':
	return(16);
    case 'o':
    case 'O':
	return(8);
    default:
	return(10);
    }
}

/*
 * doprnt()
 *	Do printf()-style printing
 */
void doprnt(char *buf, char *fmt, va_list args)
{
    char *p = fmt, c, *s;
    char numbuf[NUMBUF];
    int adj, width, zero, longfmt, x, is_unsigned;

    while ((c = *p++)) {
	/*
	 * Non-format; use character
	 */
	if (c != '%') {
	    *buf++ = c;
	    continue;
	}
	c = *p++;

	/*
	 * Leading '-'; toggle default adjustment
	 */
	if (c == '-') {
	    adj = 1;
	    c = *p++;
	}
	else {
	    adj = 0;
	}

	/*
	 * Leading 0; zero-fill
	 */
	if (c == '0') {
	    zero = 1;
	    c = *p++;
	}
	else {
	    zero = 0;
	}

	/*
	 * Numeric; field width
	 */
	if (isdigit(c)) {
	    width = atoi(p-1);
	    while (isdigit(*p))
		++p;
	    c = *p++;
	}
	else {
	    width = 0;
	}

	/*
	 * 'l': "long" format.  XXX Use this when sizeof(int)
	 * stops being sizeof(long).
	 */
	if (c == 'l') {
	    longfmt = 1;
	    c = *p++;
	} else {
	    longfmt = 0;
	}

	/*
	 * 'u': unsigned
	 */
	if (c == 'u') {
	    is_unsigned = 1;
	} else {
	    is_unsigned = 0;
	}

	/*
	 * Format
	 */
	switch (c) {
	case 'X':
	case 'O':
	case 'D':
	case 'U':
	    longfmt = 1;
	    /* VVV fall into VVV */

	case 'x':
	case 'o':
	case 'd':
	case 'u':
	    x = num(numbuf, va_arg(args, unsigned), baseof(c), is_unsigned);
	    if (!adj) {
		for ( ; x < width; ++x) {
		    *buf++ = zero ? '0' : ' ';
		}
	    }
	    strcpy(buf, numbuf);
	    buf += strlen(buf);
	    if (adj) {
		for ( ; x < width; ++x) {
		    *buf++ = ' ';
		}
	    }
	    break;

	case 's':
	    s = va_arg(args, char *);
	    if (s == NULL) {
		s = "(null)";
	    }
	    x = strlen(s);
	    if (!adj) {
		for ( ; x < width; ++x) {
		    *buf++ = ' ';
		}
	    }
	    strcpy(buf, s);
	    buf += strlen(buf);
	    if (adj) {
		for ( ; x < width; ++x) {
		    *buf++ = ' ';
		}
	    }
	    break;

	case 'c':
	    *buf++ = va_arg(args, char);
	    break;

	default:
	    *buf++ = c;
	    break;
	}
    }
    *buf = '\0';
}


#define MAXPRINTLEN 1024

void RttPrintf(char *format, ...)
{
    va_list args;
    char buffer[MAXPRINTLEN];

    va_start(args, format);
    doprnt(buffer, format, args);
    va_end(args);
    RttWriteN(1, buffer, strlen(buffer));
	/*printf("%s", buffer, strlen(buffer));*/
	/*ENTERINGOS;
	write(1, buffer, strlen(buffer));
	LEAVINGOS;*/
}

void RttFprintf(FILE *fp, char *format, ...)
{
    va_list args;
    char buffer[MAXPRINTLEN];

    va_start(args, format);
    doprnt(buffer, format, args);
    va_end(args);
	if (fp == stdout) {
		RttWriteN(1, buffer, strlen(buffer));
	}
	if (fp == stderr) {
		RttWriteN(2, buffer, strlen(buffer));
	}
	else {
		ENTERINGOS;
		fwrite(buffer, 1, strlen(buffer), fp);
		LEAVINGOS;
	}
}

int RttSprintf(char *buffer, char *format, ...)
{
    va_list args;

    va_start(args, format);
    doprnt(buffer, format, args);
    va_end(args);

    return(strlen(buffer));
}
