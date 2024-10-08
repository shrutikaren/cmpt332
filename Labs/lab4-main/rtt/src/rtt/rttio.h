/****************************************************************************
 * 
 * rttio.h
 * 
 * Header file for I/O module.
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

#ifndef RTTIO_H
#define RTTIO_H

/* I/O operation types */
#define READ        ((char)1)
#define RCVF        ((char)2)
#define WRITE       ((char)3)
#define ACC         ((char)4)
#define CONN        ((char)5)
#define RCVM        ((char)6)
#define SNDM        ((char)7)
#define READN       ((char)8)
#define WRITEN      ((char)9)

#ifdef ASYNCIO
#define _RT_AIOWAIT	    ((char)10)
#endif

/* 
  Max file descriptor size we'll allow for AIX (default is in
  <sys/select.h> and is currently 2048.  64 seems to be what
  SunOs and Solaris allow so it should be a reasonable value.
*/
#ifdef ibm
#undef FD_SETSIZE
#define FD_SETSIZE	64
#endif

/* no longer necessary to explicitly set this value DJM 2010 */
/* #define _FILE_OFFSET_BITS 64 */

/*#define __USE_FILE_OFFSET64 */


void InitIO_();
RTTTHREAD NullThread_();
void IoHandler_();

void RttPerror(char *msg);
int RttReadN(int fd, char *buf, int numbytes);
int RttWriteN(int fd, char *buf, int numbytes);


#endif /* RTTIO_H */
