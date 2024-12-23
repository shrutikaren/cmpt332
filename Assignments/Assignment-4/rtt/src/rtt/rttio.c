/****************************************************************************
 * 
 * rttio.c
 * 
 * I/O module.
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
 * RT Threads is provided as is. The UBC Department of Computer Science
 * makes no warranty as to the correctness or fitness for use of the
 * RT Threads code or environment.
 * 
 ***************************************************************************
 */

#include "rttkernel.h"

#include <sys/ioctl.h>
#include <stdarg.h>

#define DPRINTF (void)

#ifdef solaris
#define SOLPRINTF (void)
/*#define NO_SIGIO_FOR_SOCKETS*/
#define USE_POLL
#include <sys/filio.h>
#include <sys/sockio.h>
#ifdef USE_POLL
#include <stropts.h>
#include <poll.h>
#endif /* USE_POLL */
#define RTTENOTTY EINVAL
#define RTTWOULDBLOCK EAGAIN
#else
#define SOLPRINTF (void)
#define RTTENOTTY ENOTTY
#define RTTWOULDBLOCK EWOULDBLOCK
#endif /*solaris */

#ifdef i386freebsd
#define RTTALREADY EALREADY
#else
#define RTTALREADY EAGAIN
#endif /* i386freebsd */

#ifdef hp700
#ifndef FIOSETOWN
#define FIOSETOWN FIOSSAIOOWN
#endif
#define SELECT(A,B,C,D,E) select(A,(int *)(B),(int *)(C),(int *)(D),E)
#else
#ifdef USE_POLL
#define SELECT(A,B,C,D,E) poll(PollInfo, fdwidth, 0)
#else
#define SELECT(A,B,C,D,E) select(A,B,C,D,E)
#endif /* USE_POLL */
#endif /* hp700 */

#define MAXFDWIDTH 64
#ifdef USE_POLL
static struct pollfd PollInfo[MAXFDWIDTH];
#endif /* USE_POLL */

static int fdwidth;
static fd_set fdmask, riomask, wiomask, eiomask;
TCB *NullThread_Proc;

static struct timeval zero_tv;

extern int *WatchPointer[], WatchValue[], WatchCounter;

#ifdef ASYNCIO
static RttAIOPrivate *aioQueue;
#ifdef ibm
#define NUMLIOARRAYS 256
#define MAXLIOREQUESTS 64
static struct liocb *liocbList[(NUMLIOARRAYS * MAXLIOREQUESTS) + 1];
static struct liocb **liocbArrays[NUMLIOARRAYS + 1];
static int lioListHead;
static int lioListTail;
static int lioArrayHead;
static int lioArrayTail;
static RttSem lioArrayMutex;
#define CHECKAIORESULT() 
static void initAIO()
{
  int   lc;

  assert(RttAllocSem(&lioArrayMutex, NUMLIOARRAYS, RTTPRIORITY) == RTTOK);
  
  lioArrayHead = 1;
  lioListHead = 1;
  lioArrayTail = 0;
  lioListTail = 0;
  for (lc = 1; lc < ((MAXLIOREQUESTS * NUMLIOARRAYS) + 1); lc++)
    {
      liocbList[lc] = (struct liocb *)SysMalloc_(sizeof(struct liocb));
    }
  for (lc = 1; lc < (NUMLIOARRAYS + 1); lc++)
    {
      liocbArrays[lc] = 
	(struct liocb **)SysMalloc_(sizeof(struct liocb *) * MAXLIOREQUESTS);
    }

  aioQueue = NULL;
}
#else
#define NUMAIORESULTS 2048
#define WATERMARK 128
static aio_result_t *aioResultArray[NUMAIORESULTS + 1];
static int aioArrayHead;
static int aioArrayTail;
static RttSem aioArrayMutex;
static int outstandingAioResults;
     
#define AIOGETINUSE(X) ((X)->aio_errno & (0x1 << 16))
#define AIOSETINUSE(X)  ((X)->aio_errno = ((X)->aio_errno | (0x1 << 16)))
#define AIOCLEARINUSE(X) ((X)->aio_errno = 0)
#define CHECKAIORESULT() { \
         aio_result_t *waitp; \
	 do{ \
	   waitp = aiowait(&zero_tv); \
	   if (((int)waitp != 0) && ((int)waitp != -1)){ \
	     RETURNAIORESULTP(waitp); \
	   } \
	 }while (((int)waitp != 0) && ((int)waitp != -1)); \
	 }
			     
#define GETAIORESULTP(X) { \
	 aio_result_t *tempp; \
	 if (!INOSCTXT) RttP(aioArrayMutex); \
	 tempp = aioResultArray[aioArrayHead]; \
	 AIOCLEARINUSE(tempp); \
	 (*(X)) = tempp; \
	 aioArrayHead++; \
	 if (aioArrayHead == (NUMAIORESULTS + 1)) \
	 { \
	   aioArrayHead = 0; \
	 } \
	 outstandingAioResults++; \
	 if ((outstandingAioResults + WATERMARK) > NUMAIORESULTS) \
	 { \
	    WatermarkHit(); \
	 } \
	 if (!INOSCTXT) RttV(aioArrayMutex); \
	 }
/*
  RETURNAIORESULTP should always be called from the OS context
  */
#define RETURNAIORESULTP(X) { \
	 if (!(AIOGETINUSE(X))) \
	 { \
	   AIOSETINUSE(X); \
	 } \
	 else \
	 { \
	   aioResultArray[aioArrayTail] = (X); \
	   aioArrayTail++; \
	   if (aioArrayTail == (NUMAIORESULTS + 1)) \
	   { \
	     aioArrayTail = 0; \
	   } \
	   outstandingAioResults--; \
	 } \
	 }

static void initAIO()
{
  int   lc;

  assert(RttAllocSem(&aioArrayMutex, NUMAIORESULTS, RTTPRIORITY) == RTTOK);
  aioArrayHead = 1;
  aioArrayTail = 0;
  for (lc = 1; lc < (NUMAIORESULTS + 1); lc++)
    {
      aioResultArray[lc] = (aio_result_t *)SysMalloc_(sizeof(aio_result_t));
    }
  outstandingAioResults = 0;

  aioQueue = NULL;
}
#endif  /* IBM */
#else
#define CHECKAIORESULT()
#define initAIO() 
#endif /* ASYNCIO */

static void WatermarkHit()
{
  printf("Watermark hit!\n");
}


#define MAXIMUM(X,Y) (((X) < (Y))?(Y):(X))

#ifdef USE_POLL
#define RIOMASK (POLLIN | POLLRDNORM | POLLRDBAND | POLLPRI)
#define WIOMASK (POLLOUT)
#else
#define RIOMASK &riomask
#define WIOMASK &wiomask
#endif /* USE_POLL */

#define VERIFYANDDEQEUE(MTID, MRES, MINSTANCE, MQUEUE)          \
{                                                               \
  if( GetInstance(MTID) == MINSTANCE )/* thread not killed */   \
    {                                                           \
      SetIoRes(MTID, MRES);                                     \
      SetState(MTID, THREAD_READY);                             \
      DEQUEUE_ITEM(QTBL[MQUEUE], MTID, TCB, queueMgmtInfo);     \
      EnqueueEdfHead_(MTID);                                    \
    }                                                           \
}


int RttReadN(int fd, char*buf, int numbytes);
int RttWriteN(int fd, char *buf, int numbytes);

/*------------------------------------------------------------------------
 * printMask  --  for debugging purposes only
 *------------------------------------------------------------------------
 */  
static void printMask(fd_set *mask, int width) {
  int fd;
  
  for (fd = 0; fd < width; fd++) {
    printf("%d ", FD_ISSET(fd, mask) ? 1 : 0);
  }
  printf("\n");
}

/*------------------------------------------------------------------------
 * enableSigio  --  generate SIGIOs for given file descriptor
 *------------------------------------------------------------------------
 */
static int enableSigio(int fd)
{
  int flag, owner;
  
/* DJM 2010  flag = 1;
  if (ioctl(fd, FIONBIO, &flag) < 0) {
    return (0);
  }
 */ 
  owner = getpid();
/* DJM 2010 #ifdef __linux  */
  {
    int retVal;
    ENTERINGOS;
    if ((retVal = fcntl(fd, F_SETOWN, owner)) == -1 && (errno != ENOTTY)) {
      char errbuf[80];
      sprintf( errbuf, "fcntl(%d,F_SETOWN,%d)->%d", fd, owner, errno );
      perror(errbuf);
    }
    LEAVINGOS;
    return (retVal);
  }

/* DJM 2010
#else
  ioctl(fd, FIOSETOWN, &owner);
#endif  DJM 2010 */ /* __linux */
  
/*  return (0); */
}

/*------------------------------------------------------------------------
 * RttRegisterDescriptor  --  enable SIGIO and generate mask for a
 *                            descriptor obtained by a non-RTT call
 *------------------------------------------------------------------------
 */
int RttRegisterDescriptor(int fd) {
  int res = RTTOK;
  int dummy;
  
  if (enableSigio(fd) == -1) {
    res = RTTFAILED;
  }
  else {
#ifdef USE_POLL
    PollInfo[fd].fd = fd;
    PollInfo[fd].events = 0;
    fdwidth = MAXIMUM(fd + 1, fdwidth);
#else
    FD_SET(fd, &fdmask);
    fdwidth = MAXIMUM(fd + 1, fdwidth);
    
    riomask = wiomask = eiomask = fdmask;
    SELECT(fdwidth, &riomask, &wiomask, &eiomask, &zero_tv);
#endif /* USE_POLL */
  }
    
  return (res);
} 
  
#ifdef hp700
/*------------------------------------------------------------------------
 * enableSigioFile  --  enableSigio for a file descriptor (for hp700)
 *------------------------------------------------------------------------
*/
static int enableSigioFile(int fd)
{
  int retVal;
  int flag, owner;
      
  flag = 1;
  if ((retVal = ioctl(fd, FIOSSAIOSTAT, &flag) && (errno != RTTENOTTY)) == -1)
    {
      perror("ioctl(fd, FIOSSAIOSTAT, &flag)");
      return (retVal);
    }
      
  owner = getpid();
  if ((retVal = ioctl(fd, FIOSSAIOOWN, &owner) && (errno != RTTENOTTY)) == -1)
    {
      perror("ioctl(fd, FIOSSAIOOWN, &flag)");
    }
      
  return (retVal);
}
  
/*------------------------------------------------------------------------
 * enableSigioSocket  --  enableSigio for a socket descriptor (for hp700)
 *------------------------------------------------------------------------
 */
static int enableSigioSocket(int fd)
{
  int retVal;
  int flag, owner;
  
  flag = 1;
  if ((retVal = ioctl(fd, FIOASYNC, &flag)) == -1) {
    perror("ioctl(fd, FIOASYNC, &flag)");
    return (retVal);
  }
  
  owner = getpid();
  if ((retVal = ioctl(fd, SIOCSPGRP, &owner)) == -1) {
    perror("ioctl(fd, SIOCSPGRP, &owner)");
  }
  
  return (retVal);
}

#else
#define enableSigioFile(X)    enableSigio(X)  
#define enableSigioSocket(X)  enableSigio(X) 
#endif /* hp700 */
  

static void sigpipeHandler()
{
  fprintf(stderr, "\n\n***** SIGPIPE *****\n\n");
}

/*------------------------------------------------------------------------
 * InitIO_  --  initialize I/O module
 *------------------------------------------------------------------------
 */
void InitIO_()
{
  int currflags;
#ifdef USE_POLL
  int i;
  
  fdwidth = 3;
      
  for (i = 3; i < MAXFDWIDTH; i++)
    {
      PollInfo[i].fd = -1;
    }
  
  PollInfo[0].fd = 0;
  PollInfo[0].events = (POLLIN | POLLRDNORM | POLLRDBAND | POLLPRI);
  PollInfo[1].fd = 1;
  PollInfo[1].events = (POLLOUT | POLLWRBAND);
  PollInfo[2].fd = 2;
  PollInfo[2].events = (POLLOUT | POLLWRBAND);
#else
  fdwidth = 3;
  FD_ZERO(&fdmask);
  FD_ZERO(&riomask);
  FD_ZERO(&wiomask);
  FD_ZERO(&eiomask);
  
  FD_SET(0, &fdmask);
  FD_SET(1, &fdmask);
  FD_SET(2, &fdmask);
#endif /* USE_POLL */
  
#ifdef i386freebsd
  enableSigio(0);
#endif /* i386freebsd */
  
  zero_tv.tv_sec = 0;
  zero_tv.tv_usec = 0;

  {
    sigset_t mask;
    struct sigaction action;


    sigemptyset(&mask);
    sigaddset(&mask, SIGPIPE);

    action.sa_handler = sigpipeHandler;
    action.sa_mask = mask;
    action.sa_flags = 0;

    sigaction(SIGPIPE, &action, NULL);
  }
  
  initAIO();
}
  
/*------------------------------------------------------------------------
 * RttErrno  --  return value of errno from the last time it was set
 *               for current thread
 *------------------------------------------------------------------------
 */
int RttErrno()
{
  return (GetErrno(currthread));
}
  
/*------------------------------------------------------------------------
 * RttPerror  --  Print errno message from the last time errno was set
 *                for current thread
 *------------------------------------------------------------------------
 */
void RttPerror(char *msg)
{
  int oldErrno;
  
  ENTERINGOS;
  oldErrno = errno;
  errno = GetErrno(currthread);
  perror(msg);
  errno = oldErrno;
  LEAVINGOS;
}

/*------------------------------------------------------------------------
 * RttThreadErrno  --  return value of errno from the last time it was set
 *                     for given thread
 *------------------------------------------------------------------------
 */
int RttThreadErrno(RttThreadId thread)
{
  TCB *tcbPtr;
  int res;
  
  ENTERINGOS;
  tcbPtr = getTcbFromThreadId(thread);
  res = GetErrno(tcbPtr);
  LEAVINGOS;
  
  return (res);
}

/*------------------------------------------------------------------------
 * RttOpen  --  obtain file descriptor
 *------------------------------------------------------------------------
 */
int RttOpen(char *file, int flags, ...)
{
  int currflags, res, mode;
  va_list ap;
  
  if(flags & O_CREAT) {
    va_start(ap, flags);
    mode = va_arg(ap, int);
    res = open(file, flags, mode);
    va_end(ap);
  }
  else {
    res = open(file, flags);
  }
  
  if(res >= 0) {
    enableSigioFile(res);
#ifndef USE_POLL
    FD_SET(res, &fdmask);
#endif /* USE_POLL */
    fdwidth = MAXIMUM(res + 1, fdwidth);
    
#ifndef USE_POLL
    riomask = wiomask = eiomask = fdmask;
    SELECT(fdwidth, &riomask, &wiomask, &eiomask, &zero_tv);
#endif /* USE_POLL */
    
    currflags = fcntl(res, F_GETFL, 0);
    fcntl(res, F_SETFL, currflags | O_NDELAY);
  }
  else if (currthread) {
    SetErrno(currthread, errno);
  }
  
  return(res);
}

/*------------------------------------------------------------------------
 * RttPipe  --  obtain file descriptors for a pipe (actually uses
 *              socketpair because pipes do not support SIGIO on ibm)
 *------------------------------------------------------------------------
 */
int RttPipe(int *fds)  /* create a pipe */
{
  int res, currflags, i;
  
  /*  res = pipe(fds);*/
  res = socketpair(AF_UNIX, SOCK_STREAM, 0, fds);
  
  for (i = 0; res >= 0, i < 2; i++) {
    if (enableSigio(fds[i]) == -1)
      {
	close(fds[0]);
	close(fds[1]);
	return (-1);
      }
    
#ifdef USE_POLL
    PollInfo[fds[i]].fd = fds[i];
    PollInfo[fds[i]].events = 0;
    fdwidth = MAXIMUM(fds[i] + 1, fdwidth);
#else    
    FD_SET(fds[i], &fdmask);
    fdwidth = MAXIMUM(fds[i] + 1, fdwidth);
    
    riomask = wiomask = eiomask = fdmask;
    SELECT(fdwidth, &riomask, &wiomask, &eiomask, &zero_tv);
#endif /* USE_POLL */
    
    /* set pipe descriptors to non blocking */
    currflags = fcntl(fds[i], F_GETFL, 0);
    fcntl(fds[i], F_SETFL, currflags | O_NDELAY);
  }
  
  if ((res < 0) && currthread) {
    SetErrno(currthread, errno);
  }
  
  return(res);
}

/*------------------------------------------------------------------------
 * RttSocket  --  obtain socket descriptor
 *------------------------------------------------------------------------
 */
int RttSocket(int domain, int type, int protocol)
{
  int res, currflags;
  
  ENTERINGOS;
  res = socket(domain, type, protocol);
  LEAVINGOS;
  
  if(res >= 0) {
    currflags = fcntl(res, F_GETFL, 0);
    fcntl(res, F_SETFL, currflags | O_NDELAY);
#ifndef NO_SIGIO_FOR_SOCKETS
    if (enableSigioSocket(res) == -1) {
      close(res);
      res = -1;
    }
    else
#endif
      {
#ifdef USE_POLL
	PollInfo[res].fd = res;
	PollInfo[res].events = 0;
	fdwidth = MAXIMUM(res + 1, fdwidth);
#else
	FD_SET(res, &fdmask);
	fdwidth = MAXIMUM(res + 1, fdwidth);
	
	riomask = wiomask = eiomask = fdmask;
	SELECT(fdwidth, &riomask, &wiomask, &eiomask, &zero_tv);
#endif /* USE_POLL */
      }
  }
  else if (currthread) {
    SetErrno(currthread, errno);
  }
  
  return(res);
}

/*------------------------------------------------------------------------
 * RttClose  --  clear masks and close object
 *------------------------------------------------------------------------
 */
int RttClose(int fd)
{
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
#ifndef USE_POLL
  FD_CLR(fd, &fdmask);
  FD_CLR(fd, &riomask);
  FD_CLR(fd, &wiomask);
  FD_CLR(fd, &eiomask);
#endif
  
  if (((res = close(fd)) < 0) && currthread) {
    SetErrno(currthread, errno);
  }
  return(res);
}

/*------------------------------------------------------------------------
 * RttGetsockopt  --  wrapper for getsockopt
 *------------------------------------------------------------------------
 */
int RttGetsockopt(int s, int level, int optname, char *optval, 
	socklen_t *optlen)
{
  int res;
  
  if ((res = getsockopt(s, level, optname, optval, optlen)) < 0) {
    SetErrno(currthread, errno);
  }
  return(res);
}

/*------------------------------------------------------------------------
 * RttSetsockopt  --  wrapper for setsockopt
 *------------------------------------------------------------------------
 */
int RttSetsockopt(int s, int level, int optname, char *optval, int optlen)
{  
  int res;
  
  if ((res = setsockopt(s, level, optname, optval, optlen)) < 0) {
    SetErrno(currthread, errno);
  }
  return(res);
}

/*------------------------------------------------------------------------
 * RttGetsockname  --  wrapper for getsockname
 *------------------------------------------------------------------------
 */
int RttGetsockname(int s, struct sockaddr *name, socklen_t *namelen)
{
  int res;
  
  if ((res = getsockname(s, name, namelen)) < 0) {
    SetErrno(currthread, errno);
  }
  return(res);
}

/*------------------------------------------------------------------------
 * RttListen  --  wrapper for listen
 *------------------------------------------------------------------------
 */
int RttListen(int s, int backlog)
{
  int res;
  
  if ((res = listen(s, backlog)) < 0) {
    SetErrno(currthread, errno);
  }
  return(res);
}

/*------------------------------------------------------------------------
 * RttBind  --  wrapper for bind
 *------------------------------------------------------------------------
 */
int RttBind(int s, struct sockaddr *name, int namelen)
{
  int res;
  
  /* 
   * XXX setsockopt so that address (port) can be reused right away.This
   *     *should* be done by user. For RTT remote ITC, this would
   *     have to be done within the ItcWorker_ thread. Perhaps if
   *     RttNetInit() port is 0, don't do it, o/w do ???
   */
  int val = 1;
  if (setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&val, sizeof(int))
      == -1) {
    perror("RttBind: setsockopt");
  }
  
  if ((res = bind(s, name, namelen)) < 0) {
    SetErrno(currthread, errno);
  }
  return(res);
}

/*------------------------------------------------------------------------
 * RttAccept  --  accept a new connection
 *------------------------------------------------------------------------
 */
int RttAccept(int fd, struct sockaddr *addr, socklen_t *addrlen)
{
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  res = accept(fd, addr, addrlen);
  SetErrno(currthread, errno);
  if (res == -1)
    {
      if (errno == EWOULDBLOCK)
	{
#ifdef USE_POLL
	  PollInfo[fd].events |= RIOMASK;
#else
	  RttRegisterDescriptor(fd);
#endif /* USE_POLL */
	  SetIoOp(currthread, ACC);
	  SetIoA1(currthread, fd);
	  SetIoA2(currthread, (void *)addr); /* 2018 Dwight */
	  SetIoA3(currthread, (long)addrlen);
	  SetIoRes(currthread, 0);
	  SetState(currthread, IOBK);
	  SchedM;    /* implicitly makes call to LEAVINGOS */
	  res = GetIoRes(currthread);
	  if (res >= 0) {RttRegisterDescriptor(res);}
	  return res;
	}
      else
	{
	  LEAVINGOS;
	  return res;
	}
    }
  else {
    RttRegisterDescriptor(res);
  }
  
  LEAVINGOS;
  return res;
}

/*------------------------------------------------------------------------
 * doAccept  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
/* perform the blocking operation. This is called by the IO thread.    */
void doAccept(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  struct sockaddr *addr;
  unsigned int addrlen;  /* 2018 Dwight */
  
  fd      = GetIoA1(tcbPtr);
  addr    = (struct sockaddr *) GetIoA2(tcbPtr);
  addrlen = GetIoA3(tcbPtr); /* 2018 Dwight */
  inst    = GetInstance(tcbPtr);
  
  res = accept(fd, addr, (socklen_t *) &addrlen);
  
  if (res == -1) {
    if (errno == EWOULDBLOCK) {
      return;
    }
    SetErrno(tcbPtr, errno);
    if (errno == EISCONN) {
      res = 0;
    }
  }
  
  VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
}

/*------------------------------------------------------------------------
 * RttConnect  --  wrapper for connect
 *------------------------------------------------------------------------
 */
int RttConnect(int fd, struct sockaddr *name, int namelen)
{  
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  
  res = connect(fd, name, namelen);
  SetErrno(currthread, errno);
  
  if (res == -1)
    {
      if ((errno == EINPROGRESS) || (errno == EAGAIN))
	{
#ifdef USE_POLL
	  PollInfo[fd].events |= RIOMASK;
#endif /* USE_POLL */
	  SetIoOp(currthread, CONN);
	  SetIoA1(currthread, fd);
	  SetIoA2(currthread, name);  /* 2018 Dwight */
	  SetIoA3(currthread, (u_int)namelen);
	  SetIoRes(currthread, 0);
	  SetState(currthread, IOBK);
	  SchedM;    /* implicitly makes call to LEAVINGOS */
	  res = GetIoRes(currthread);
	  return res;
	}
      else
	{
	  LEAVINGOS;
	  return res;
	}
    }
  
  LEAVINGOS;
  return res;
}

/*------------------------------------------------------------------------
 * doConnect  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
/* perform the blocking operation. This is called by the IO thread.    */
void doConnect(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  struct sockaddr *addr;
  int addrlen;
  
  fd      = GetIoA1(tcbPtr);
  addr    = (struct sockaddr *)GetIoA2(tcbPtr);
  addrlen = (int)GetIoA3(tcbPtr);
  inst    = GetInstance(tcbPtr);
  
  res = connect(fd, addr, addrlen); 
  
  if (res == -1) {
    if ((errno == EINPROGRESS) || (errno == RTTALREADY)) {
      return;
    }
    SetErrno(tcbPtr, errno);
    if ((res == -1) && (errno == EISCONN)) {
      res = 0;
    }
  }
    
  VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
}
  
/*------------------------------------------------------------------------
 * RttNonBlkWrite  --  Not used anymore.
 *------------------------------------------------------------------------
 */
int RttNonBlkWrite(int fd, char *buf, int numbytes)
{
  return (RttWrite(fd, buf, numbytes));
}

/*------------------------------------------------------------------------
 * RttNonBlkRead  --  Not used anymore.
 *------------------------------------------------------------------------
 */
int RttNonBlkRead(int fd, char *buf, int numbytes)
{
  return (RttRead(fd, buf, numbytes));
}

/*------------------------------------------------------------------------
 * RttSeekNRead  --  seek to position, then read
 *------------------------------------------------------------------------
 */
int RttSeekNRead(int fd, char *buf, int numbytes, int seekpos, int seekmode)
{
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  if(lseek(fd, seekpos, seekmode) == -1 ) {
    SetErrno(currthread, errno);
    LEAVINGOS;
    return (RTTFAILED);
  }
  LEAVINGOS;

  return(RttReadN(fd, buf, numbytes));
}

/*------------------------------------------------------------------------
 * RttRead  --  read data
 *------------------------------------------------------------------------
 */
int RttRead(int fd, char *buf, int numbytes)
{
  int res;
  int err;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }

  ENTERINGOS;

  /* XXX temporary soln for standard input */
  if (fd) {
    do
      {
	res = read(fd, buf, numbytes);
      } while ((res == -1) && (errno == EINTR));
    
    if ((res >= 0) || ((res == -1) && (errno != RTTWOULDBLOCK)))
      {
	SetErrno(currthread, errno);
	LEAVINGOS;
	return res;
      }
  }
    /* record operation info and put on IOBK q */
#ifdef USE_POLL
  PollInfo[fd].events |= RIOMASK;
#else
  FD_SET(fd, &fdmask);
#endif /* USE_POLL */
  SetIoOp(currthread, READ) ;
  SetIoA1(currthread, fd)  ;
  SetIoBuf(currthread, buf);
  SetIoRes(currthread, 0);
  SetIoNumBytes(currthread, numbytes);
  SetState(currthread, IOBK);
  SchedM;    /* implicitly makes call to LEAVINGOS */
  res = GetIoRes(currthread);
    
  return(res);
}

/*------------------------------------------------------------------------
 * doRead  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
void doRead(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  char *buf;
  int numBytes;
  
  fd       = GetIoA1(tcbPtr);
  inst     = GetInstance(tcbPtr);
  buf      = GetIoBuf(tcbPtr);
  numBytes = GetIoNumBytes(tcbPtr);
  
  /* read what is now available, then return */
  do {
    res = read(fd, buf, numBytes);
  } while ((res == -1) && (errno == EINTR));
  SetErrno(tcbPtr, errno);
  
  VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
}

#include <sys/file.h>
#ifdef ASYNCIO
int doAsyncIO(int iotype, int fd, char *buf, int numbytes)
{
  RttAIOCommand ioCmd;
  RttAIOStatus status;
  RttAIOList ioList;
  RttAIOList *ioLists[1];
      
  ioCmd.iotype = iotype;
  ioCmd.offset = 0;
  ioCmd.whence = L_SET;
  ioCmd.numbytes = numbytes;
  ioCmd.fd = fd;
  ioCmd.buffer = buf;

  ioList.numCommands = 1;
  ioList.commandList = &ioCmd;
  ioList.status = RTTAIOINPROGRESS;

  status = RttAIORequest(&ioList);

  ioLists[0] = &ioList;
  status = RttAIOWait(ioLists, 1);
  return (ioCmd.ioreturn);
}
#endif /* ASYNCIO */

/*------------------------------------------------------------------------
 * RttReadAsync  --  like RttRead, except uses asynchronous I/O 
 *                   facilities so that other threads can run during 
 *                   large file reads
 *------------------------------------------------------------------------
 */
int RttReadAsync(int fd, char *buf, int numbytes)
{
#ifdef ASYNCIO
  return (doAsyncIO(RTTAIOREAD, fd, buf, numbytes));
#else
  return (RttRead(fd, buf, numbytes));
#endif /* ASYNCIO */
}

/*------------------------------------------------------------------------
 * RttWriteAsync  --  like RttWrite, except uses asynchronous I/O 
 *                    facilities so that other threads can run during 
 *                    large file writes
 *------------------------------------------------------------------------
 */
int RttWriteAsync(int fd, char *buf, int numbytes)
{
#ifdef ASYNCIO
  return (doAsyncIO(RTTAIOWRITE, fd, buf, numbytes));
#else
  return (RttRead(fd, buf, numbytes));
#endif /* ASYNCIO */
}

/*------------------------------------------------------------------------
 * RttRecvfrom  --  receive UDP packet
 *------------------------------------------------------------------------
 */
int RttRecvfrom(int fd, char *buf, int numbytes, int flags, 
		struct sockaddr *from, socklen_t *fromlen)
{
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  
  do {
    res = recvfrom(fd, buf, numbytes, flags,from,fromlen);
  } while ((res == -1) && (errno == EINTR));
  SetErrno(currthread, errno);
  if (res == -1)
    {
      if (errno == EWOULDBLOCK)
	{
#ifdef USE_POLL
	  PollInfo[fd].events |= RIOMASK;
#endif /* USE_POLL */
	  SetIoOp(currthread, RCVF);
	  SetIoA1(currthread, fd);
	  SetIoBuf(currthread, buf);
	  SetIoRes(currthread, 0);
	  SetIoNumBytes(currthread, numbytes);
	  SetIoFlags(currthread, flags);
	  SetIoSrcBuf(currthread, (char *)from);
	  SetIoSblPtr(currthread, fromlen);
	  SetState(currthread, IOBK);
	  SchedM;    /* implicitly makes call to LEAVINGOS */
	  res = GetIoRes(currthread);
	  return res;
	}
    }
  
  LEAVINGOS;
  return(res);
}

/*------------------------------------------------------------------------
 * doRecvfrom  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
void doRecvfrom(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  char *buf;
  int numBytes;
  int flags;
  struct sockaddr *from;
  socklen_t *fromlen;
  
  fd       = GetIoA1(tcbPtr);
  inst     = GetInstance(tcbPtr);
  buf      = GetIoBuf(tcbPtr);
  numBytes = GetIoNumBytes(tcbPtr);
  flags    = GetIoFlags(tcbPtr);
  from     = (struct sockaddr *)GetIoSrcBuf(tcbPtr);
  fromlen  = GetIoSblPtr(tcbPtr);
  
  /* read what is now available, then return */
  do {
    res = recvfrom(fd, buf, numBytes, flags, from, fromlen);
  } while ((res == -1) && (errno == EINTR));
  SetErrno(tcbPtr, errno);
  
  VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
}

/*------------------------------------------------------------------------
 * RttSendto  --  send UDP packet
 *------------------------------------------------------------------------
 */
int RttSendto(int fd, char *msg, size_t len, int flags, struct sockaddr *to, 
	      size_t tolen)
{
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  
  if((res = sendto(fd, msg, len, flags, to, tolen)) == -1) {
    if (errno == EWOULDBLOCK) {
#ifdef USE_POLL
      PollInfo[fd].events |= (POLLOUT);
#endif /* USE_POLL */
      SetIoOp(currthread, SNDM);
      SetIoA1(currthread, fd);
      SetIoBuf(currthread, msg);
      SetIoRes(currthread, 0);
      SetIoA2(currthread, (void *) len); /* dwight 2018 */
      SetIoFlags(currthread, flags);
      SetIoSrcBuf(currthread, (char *)to);
      SetIoA3(currthread, tolen);
      SetState(currthread, IOBK);
      SchedM;    /* implicitly makes call to LEAVINGOS */
      res = GetIoRes(currthread);
    }
    else {
      SetErrno(currthread, errno);
      LEAVINGOS;
    }
  }
  else {
    LEAVINGOS;
  }
  
  return(res);
}

/*------------------------------------------------------------------------
 * doSendto  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
void doSendto(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  char *buf;
  size_t len;
  int flags;
  struct sockaddr *to;
  int tolen;
  
  fd      = GetIoA1(tcbPtr);
  inst    = GetInstance(tcbPtr);
  buf     = GetIoBuf(tcbPtr);
  len     = (size_t) GetIoA2(tcbPtr);
  flags   = GetIoFlags(tcbPtr);
  to      = (struct sockaddr *)GetIoSrcBuf(tcbPtr);
  tolen   = GetIoA3(tcbPtr);
  
  res = sendto(fd, (char *)buf, len, flags, to, tolen);
  SetErrno(tcbPtr, errno);
  
  VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
}

/*------------------------------------------------------------------------
 * RttRecvmsg  --  receive UDP packet using scatter/gather
 *------------------------------------------------------------------------
 */

#ifdef __OLDlinux
int recvmsg( int fd, struct msghdr *msg, int flags )
{
  if( ! msg ) {
    return readv( fd, msg->msg_iov, msg->msg_iovlen );
  } else {
    int len, rv, i;
    void *buf;
    
    for( i=len=0 ; i<msg->msg_iovlen ; i++ )
      len += msg->msg_iov[i].iov_len;
    buf = (void*) RttMalloc( len );
    rv = recvfrom( fd, buf, len, flags,
		  (struct sockaddr*)msg->msg_name, &msg->msg_namelen );
    for( len=i=0 ; i<msg->msg_iovlen ; i++ ) {
      if( rv - len < 1 ) {
	break; /* we're out of data to copy */
      } else if( rv - len > msg->msg_iov[i].iov_len ) {
	memcpy( msg->msg_iov[i].iov_base, buf+len, msg->msg_iov[i].iov_len );
	len += msg->msg_iov[i].iov_len;
      } else {
	memcpy( msg->msg_iov[i].iov_base, buf+len, rv - len );
	len = rv; /* that's all folks */
      }
    }
    RttFree( buf ); return rv;
  }
}
#endif /* __OLDlinux */

int RttRecvmsg(int fd, struct msghdr *msg, int flags)
{
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  
  /*
    Bug (?) in SunOS -- if no data at the socket, subsequent recvmsg() will
    not fill in the source address
    */
#ifdef sun4old
  {
    fd_set rmask;

    FD_SET(fd, &rmask);
    SELECT(fd+1, &rmask, 0, 0, &zero_tv);
    if (FD_ISSET(fd, &rmask))
      {
	do {
	  res = recvmsg(fd, msg, flags);
	} while ((res == -1) && (errno == EINTR));
      }
    else
      {
	res = -1;
	errno = EWOULDBLOCK;
      }
  }
#else
  do {
    res = recvmsg(fd, msg, flags);
  } while ((res == -1) && (errno == EINTR));
#endif
  
  if (res == -1)
    {
      if (errno == EWOULDBLOCK)
	{
	  /* record operation info and put on IOBK q */
#ifdef USE_POLL
	  PollInfo[fd].events |= RIOMASK;
#endif /* USE_POLL */
	  SetIoOp(currthread, RCVM);
	  SetIoA1(currthread, fd);
	  SetIoBuf(currthread, (char *)msg);
	  SetIoRes(currthread, 0);
	  SetIoFlags(currthread, flags);
	  SetState(currthread, IOBK);
	  SchedM;    /* implicitly makes call to LEAVINGOS */
	  res = GetIoRes(currthread);
	  return res;
	}
      else {
	SetErrno(currthread, errno);
      }
    }
  
  LEAVINGOS;
  return res;
}

/*------------------------------------------------------------------------
 * doRecvmsg  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
void doRecvmsg(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  struct msghdr *msg;
  int flags;
  
  fd      = GetIoA1(tcbPtr);
  inst    = GetInstance(tcbPtr);
  msg     = (struct msghdr *)GetIoBuf(tcbPtr);
  flags   = GetIoFlags(tcbPtr);
  
  do {
    res = recvmsg(fd, msg, flags);
  } while ((res == -1) && (errno == EINTR));
  SetErrno(tcbPtr, errno);
  
  /* 
   * XXX what if we get EWOULDBLOCK here? 
   *
   * should stay on queue and return BUT it should never happen in the
   * first place (where have i heard that before?)
   */
  
  VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
}

/*------------------------------------------------------------------------
 * RttSendmsg  --  send UDP packet using scatter/gather
 *------------------------------------------------------------------------
 */

#ifdef __oldlinux
int sendmsg( int fd, struct msghdr *msg, int flags )
{
  if( msg->msg_name && msg->msg_namelen ) {
    int i, len = 0;
    void *buf;
    
    for( i=0 ; i<msg->msg_iovlen ; i++ )
      len += msg->msg_iov[i].iov_len;
    buf = (void*) RttMalloc( len );
    for( len=i=0 ; i<msg->msg_iovlen ; i++ ) {
      if( msg->msg_iov[i].iov_len < 1 ) continue;
      memcpy( buf+len, msg->msg_iov[i].iov_base, msg->msg_iov[i].iov_len );
      len += msg->msg_iov[i].iov_len;
    }
    len = sendto( fd, buf, len, flags,
		 (struct sockaddr*)msg->msg_name, msg->msg_namelen );
    RttFree( buf ); return len;
  } else {
    return writev( fd, msg->msg_iov, msg->msg_iovlen );
  }
}
#endif /* __OLDlinux */

int RttSendmsg(int fd, struct msghdr *msg, int flags)
{
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  
  if((res = sendmsg(fd, msg, flags)) == -1) {
    if ((errno == EWOULDBLOCK) || (errno == ENOBUFS)) {
#ifdef USE_POLL
      PollInfo[fd].events |= (POLLOUT);
#endif /* USE_POLL */
      SetIoOp(currthread, SNDM);
      SetIoA1(currthread, fd);
      SetIoBuf(currthread, (char *)msg);
      SetIoRes(currthread, 0);
      SetIoFlags(currthread, flags);
      SetState(currthread, IOBK);
      SchedM;    /* implicitly makes call to LEAVINGOS */
      res = GetIoRes(currthread);
    }
    else {
      SetErrno(currthread, errno);
      LEAVINGOS;
    }
  }
  else {
    LEAVINGOS;
  }
    
  return(res);
}
  
/*------------------------------------------------------------------------
 * doSendmsg  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
void doSendmsg(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  struct msghdr *msg;
  int flags;
  
  fd      = GetIoA1(tcbPtr);
  inst    = GetInstance(tcbPtr);
  msg     = (struct msghdr *)GetIoBuf(tcbPtr);
  flags   = GetIoFlags(tcbPtr);
  
  res = sendmsg(fd, msg, flags);
  SetErrno(tcbPtr, errno);
  
  VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
}

/*------------------------------------------------------------------------
 * RttReadN  --  read exactly numbytes - blocking if necessary
 *------------------------------------------------------------------------
 */
int RttReadN (int fd, char *buf, int numbytes)
{
  int res;
  int num = 0;

  ENTERINGOS;

  while (1) {
    do {
      res = read(fd, buf+num, numbytes-num);
    } while ((res == -1) && (errno == EINTR));
    SetErrno(currthread, errno);
/*printf("(RN:%d:%d)", res, errno);*/
    if(res == -1) {
      if ((errno == EINTR) || (errno == EWOULDBLOCK)) {
	break;
      }
      else {
/*printf("(*RN:%d:%d:%d)", res, errno, GetErrno(currthread));*/
	LEAVINGOS;
	return (-1);
      }
    }

    num += res;

    if ((num == numbytes) || (res == 0)) {
      LEAVINGOS;
      return (num);
    }
  }

#ifdef USE_POLL
  PollInfo[fd].events |= RIOMASK;
#else
  FD_SET(fd, &fdmask);
#endif /* USE_POLL */
  SetIoOp(currthread, READN) ;
  SetIoA1(currthread, fd)  ;
  SetIoBuf(currthread, buf);
  SetIoRes(currthread, num);
  SetIoNumBytes(currthread, numbytes);

  SetState(currthread, IOBK);
  SchedM;    /* implicitly makes call to LEAVINGOS */

  return(GetIoRes(currthread));
}
  
void doReadN(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  char *buf;
  int num;      /* number of bytes read this time   */
  int prevNum;  /* number of bytes read up till now */
  int totalNum; /* bytes to read in total           */
  
  fd       = GetIoA1(tcbPtr);
  inst     = GetInstance(tcbPtr);
  buf      = GetIoBuf(tcbPtr);
  totalNum = GetIoNumBytes(tcbPtr);
  prevNum  = GetIoRes(tcbPtr);
  
  do {
    do {
      res = read(fd, buf+prevNum, totalNum-prevNum );
    } while ((res == -1) && (errno == EINTR));
    SetErrno(tcbPtr, errno);

    if(res == -1) {
      if ((errno == EINTR) || (errno == EWOULDBLOCK)) {
	if(inst == GetInstance(tcbPtr)) {
#ifdef USE_POLL
	  PollInfo[fd].events |= RIOMASK;
#endif /* USE_POLL */
	  SetIoRes(tcbPtr, prevNum);
	}	
	return;
      }
      else {
	break;
      }
    }
    prevNum += res;
  } while ((prevNum < totalNum) && res);

  VERIFYANDDEQEUE(tcbPtr, prevNum, inst, IOBK);
}

/*------------------------------------------------------------------------
 * RttSeekNWrite  --  seek to position, then write
 *------------------------------------------------------------------------
 */
int RttSeekNWrite(int fd, char *buf, int numbytes, int seekpos,int seekmode)
{
  int res;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  if(lseek(fd, seekpos, seekmode) == -1 ) {
    SetErrno(currthread, errno);
    LEAVINGOS;
    return (RTTFAILED);
  }
  LEAVINGOS;

  return(RttWriteN(fd, buf, numbytes));
}

/*------------------------------------------------------------------------
 * RttWrite  --  write data
 *------------------------------------------------------------------------
 */
int RttWrite(int fd, char *buf, int numbytes)
{
  int res;
  int err;
  
  if ((fd < 0) || (fd > fdwidth)) {
    return (RTTFAILED);
  }
  
  ENTERINGOS;
  
  do
    {
      res = write(fd, buf, numbytes);
    } while ((res == -1) && (errno == EINTR));

    if ((res >= 0) || ((res == -1) && (errno != RTTWOULDBLOCK)))
      {
	SetErrno(currthread, errno);
	LEAVINGOS;
	return res;
      }
  
  /* record operation info and put on IOBK q */
#ifdef USE_POLL
  PollInfo[fd].events |= (POLLOUT);
#else
  FD_SET(fd, &fdmask);
#endif /* USE_POLL */
  SetIoOp(currthread, WRITE) ;
  SetIoA1(currthread, fd)  ;
  SetIoBuf(currthread, buf);
  SetIoRes(currthread, 0);
  SetIoNumBytes(currthread, numbytes);
  SetState(currthread, IOBK);
  SchedM;    /* implicitly makes call to LEAVINGOS */
  res = GetIoRes(currthread);
  
  return(res);
}

/*------------------------------------------------------------------------
 * doWrite  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
void doWrite(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  char *buf;
  int numBytes;
  
  fd       = GetIoA1(tcbPtr);
  inst     = GetInstance(tcbPtr);
  buf      = GetIoBuf(tcbPtr);
  numBytes = GetIoNumBytes(tcbPtr);
  
  do
    {
      res = write(fd, buf, numBytes);
    } while ((res == -1) && (errno == EINTR));
  SetErrno(tcbPtr, errno);
  
  VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
}

/*------------------------------------------------------------------------
 * RttWriteN  --  write exactly numbytes (blocking if necessary)
 *------------------------------------------------------------------------
 */
int RttWriteN(int fd, char *buf, int numbytes)  
{
  int res;
  int num;      /* number of bytes written this time   */
  
  /* write what we can, but don't return until numbytes are written. */
  do {
    num = write(fd, buf, numbytes);
  } while ((num == -1) && (errno == EINTR));
  SetErrno(currthread, errno);
  
  /* if interrupted or would block: none written this time... */
  if((num == -1) && ((errno == EINTR)||(errno == EWOULDBLOCK))) { 
    num = 0;
  }
  
  res = (num == -1) ? -1 : num;
  
  if((res == numbytes) || (res == -1)) {
    return (res);
  }
  else {
    
    /* record operation info and put on IOBK q */
#ifdef USE_POLL
    PollInfo[fd].events |= (POLLOUT);
#else
    FD_SET(fd, &fdmask);
#endif /* USE_POLL */
    SetIoOp(currthread, WRITEN) ;
    SetIoA1(currthread, fd)  ;
    SetIoBuf(currthread, buf);
    SetIoRes(currthread, num);
    SetIoNumBytes(currthread, numbytes);
      
    ENTERINGOS;
    SetState(currthread, IOBK);
    SchedM;    /* implicitly makes call to LEAVINGOS */
    
    return(GetIoRes(currthread));
  }
}

/*------------------------------------------------------------------------
 * doWriteN  --  perform the blocking operation, called by SIGIO handler
 *------------------------------------------------------------------------
 */
void doWriteN(TCB *tcbPtr)
{
  int res;
  int inst;
  int fd;
  char *buf;
  int num;      /* number of bytes written this time   */
  int prevNum;  /* number of bytes written up till now */
  int totalNum; /* bytes to write in total           */

  fd       = GetIoA1(tcbPtr);
  inst     = GetInstance(tcbPtr);
  buf      = GetIoBuf(tcbPtr);
  totalNum = GetIoNumBytes(tcbPtr);
  prevNum  = GetIoRes(tcbPtr);
  
  /* write what we can, but don't return until ionumbytes are written. */
  do {
    num = write( fd, buf + prevNum, totalNum - prevNum );
  } while ((num == -1) && (errno == EINTR));
  SetErrno(tcbPtr, errno);
  
  /* if interrupted or would block: none written this time... */
  if((num == -1) && ((errno == EINTR)||(errno == EWOULDBLOCK))) { 
    num = 0;
  }
  
  res = (num == -1) ? -1 : (prevNum + num);
  
  if((res == totalNum) || (res == -1)) {
    VERIFYANDDEQEUE(tcbPtr, res, inst, IOBK);
  }
  else {
    if(inst == GetInstance(tcbPtr)) {
#ifdef USE_POLL
      PollInfo[fd].events |= (POLLOUT);
#endif /* USE_POLL */
      SetIoRes(tcbPtr, res);
    }
  }
}

#ifdef ASYNCIO
/*------------------------------------------------------------------------
 * RttAIORequest --  Submit a list of I/O requests to be done
 *       asynchronously.
 *------------------------------------------------------------------------
 */

#ifdef ibm
int RttAIORequest(RttAIOList *aioList)
{
  int lc;
  int size;
  int fd;
  int result = 0;
  int status = RTTAIOINPROGRESS;
  struct liocb *lioinfo;
  struct liocb **lioArray;
  
  size = MAXIMUM(aioList->numCommands, MAXLIOREQUESTS);
  RttP(lioArrayMutex);
  
  /*
    1. Get an lio array
    2. Get enough lio entries to fill array
    */
  if ((lioArrayHead == lioArrayTail) || (size > MAXLIOREQUESTS))
    {
      lioArray = (struct liocb **)RttMalloc(sizeof(struct liocb *) * size);
    }
  else
    {
      lioArray = liocbArrays[lioArrayHead];
      lioArrayHead++;
      if (lioArrayHead == (NUMLIOARRAYS + 1))
	{
	  lioArrayHead = 0;
	}
    }    
  for (lc = 0; lc < aioList->numCommands; lc++)
    {
      if (lioListHead == lioListTail)
	{
	  lioArray[lc] = (struct liocb *)RttMalloc(sizeof(struct liocb));
	}
      else
	{
	  lioArray[lc] = liocbList[lioListHead];
	  lioListHead++;
	  if (lioListHead == ((NUMLIOARRAYS * MAXLIOREQUESTS + 1)))
	    {
	      lioListHead = 0;
	    }
	}
    }
  RttV(lioArrayMutex);
  aioList->aioPrivate.aioInfo = (void *)lioArray;
  for (lc = 0; lc < aioList->numCommands; lc++)
    {
      lioinfo = lioArray[lc];
      if (aioList->commandList[lc].numbytes == 0)
	{
	  /*fprintf(stderr, "!!!!AIORequest with read of zero bytes!!!!\n"); */
	  lioinfo->lio_opcode = LIO_NOP;
	  continue;
	}
      switch(aioList->commandList[lc].iotype)
	{
	case RTTAIOREAD:
	  lioinfo->lio_opcode = LIO_READ;
	  break;
	case RTTAIOWRITE:
	  lioinfo->lio_opcode = LIO_WRITE;
	  break;
	default:
	  printf("Unknown AIO type %d\n", aioList->commandList[lc].iotype);
	  /*
	    For now return as an error, don't attempt to continue
	    */
	  return (RTTAIOERROR);
	  lioinfo->lio_opcode = LIO_NOP;
	  break;
	}      
      lioinfo->lio_fildes = aioList->commandList[lc].fd;
      lioinfo->lio_aiocb.aio_whence = aioList->commandList[lc].whence;
      lioinfo->lio_aiocb.aio_offset = aioList->commandList[lc].offset;
      lioinfo->lio_aiocb.aio_buf = aioList->commandList[lc].buffer;
      lioinfo->lio_aiocb.aio_nbytes = aioList->commandList[lc].numbytes;
      lioinfo->lio_aiocb.aio_flag = 0;
      lioinfo->lio_aiocb.aio_errno = 0;
      aioList->commandList[lc].status = RTTAIOINPROGRESS;
    }
  ENTERINGOS;
  result = lio_listio(LIO_ASIG, lioArray, aioList->numCommands, NULL);
  SetErrno(currthread, errno);
  if (result != 0)
    {
      status = RTTAIOERROR;
    }
  else
    {
      aioList->aioPrivate.handle = aioList;
      aioList->aioPrivate.thread = (void *)currthread;
      if (aioQueue == NULL)
	{
	  aioQueue = &aioList->aioPrivate;
	  aioQueue->next = NULL;
	}
      else
	{
	  aioList->aioPrivate.next = aioQueue;
	  aioQueue = &aioList->aioPrivate;
	}
    }
  aioList->status = status;
  LEAVINGOS;
  return status;
}

#else /* ibm not defined --> Sparc/Intel-Solaris */

int RttAIORequest(RttAIOList *aioList)
{
  int lc;
  int fd;
  int result;
  int status = RTTAIOINPROGRESS;
  aio_result_t *aioinfo;
  
  aioList->status = RTTAIOINPROGRESS;
  aioList->commandsCompleted = 0;
  for (lc = 0; lc < aioList->numCommands; lc++)
    {
      GETAIORESULTP(&aioinfo);
      fd = aioList->commandList[lc].fd;
      aioList->commandList[lc].aioPrivate.handle = aioList;
      aioList->commandList[lc].aioPrivate.thread = (void *)currthread;
      aioList->commandList[lc].aioPrivate.aioInfo = (void *)aioinfo;
      aioList->commandList[lc].aioPrivate.result = AIO_INPROGRESS;
      aioinfo->aio_return = AIO_INPROGRESS;
      ENTERINGOS;
      switch(aioList->commandList[lc].iotype)
	{
	case RTTAIOREAD:
	  result = aioread(fd, aioList->commandList[lc].buffer,
			   aioList->commandList[lc].numbytes,
			   aioList->commandList[lc].offset,
			   aioList->commandList[lc].whence,
			   aioinfo);
	  break;
	case RTTAIOWRITE:

	  result = aiowrite(fd, aioList->commandList[lc].buffer,
			    aioList->commandList[lc].numbytes,
			    aioList->commandList[lc].offset,
			    aioList->commandList[lc].whence,
			    aioinfo);

	  break;
	default:
	  printf("Unknown AIO type %d\n", aioList->commandList[lc].iotype);
	  result = -1;
	  break;
	}
      SetErrno(currthread, errno);
      if (result < 0)
	{
	  AIOSETINUSE(aioinfo);
	  RETURNAIORESULTP(aioinfo);
	  aioList->commandList[lc].aioPrivate.aioInfo = NULL;
	  aioList->commandList[lc].status = RTTAIOERROR;
	  aioList->commandList[lc].errNo = GetErrno(currthread);
	  aioList->commandList[lc].ioreturn = result;
	  aioList->commandList[lc].aioPrivate.result = result;
	  status = RTTAIOERROR;
	  aioList->commandsCompleted++;
	}
      else
	{
	  aioList->commandList[lc].status = RTTAIOINPROGRESS;
	  if (aioQueue == NULL)
	    {
	      aioQueue = &aioList->commandList[lc].aioPrivate;
	      aioQueue->next = NULL;
	    }
	  else
	    {
	      aioList->commandList[lc].aioPrivate.next = aioQueue;
	      aioQueue = &aioList->commandList[lc].aioPrivate;
	    }
	}
      LEAVINGOS;
    }
  return RTTAIOINPROGRESS;
}


#endif


/*------------------------------------------------------------------------
 * RttAIOWait --  Wait until some set of AIO requests submitted with
 *    RttAIORequest has completed.
 *------------------------------------------------------------------------
 */
#ifdef ibm
int RttAIOWait(RttAIOList *aioList[], int size)
{
  int lc;
  int lc2;
  int status;
  int doReturn;
  int validEntryExists;
  struct aiocb *aioinfo;
  struct liocb  **lioarray;
  struct liocb *entry;
  
  status = RTTAIOCOMPLETED;
  for (;;)
    {
      /*
	Must check inside OS, as possible race condition exists.
	*/
      
      validEntryExists = 0;
      doReturn = 0;
      ENTERINGOS;
      for (lc = 0; ((lc < size) && !doReturn); lc++)
	{
	  if ((aioList[lc] == NULL) || (aioList[lc]->commandList == NULL)) 
	    continue;
	  validEntryExists = 1;
	  if (aioList[lc]->status != RTTAIOINPROGRESS) doReturn = 1;
	}
      if (!validEntryExists || doReturn)
	{
	  LEAVINGOS;
	  
	  for (lc = 0; lc < size; lc++)
	    {
	      if ((aioList[lc] == NULL) || (aioList[lc]->commandList == NULL))
		continue;
	      if (aioList[lc]->status != RTTAIOINPROGRESS)
		{
		  lioarray = (struct liocb  **)aioList[lc]->aioPrivate.aioInfo;
		  for (lc2 = 0; lc2 < aioList[lc]->numCommands; lc2++)
		    {
		      if (aioList[lc]->commandList[lc2].status ==RTTAIOINPROGRESS)
			{
			  aioinfo = &(lioarray[lc2]->lio_aiocb);
			  aioList[lc]->commandList[lc2].ioreturn = 
			    aio_return(aioinfo->aio_handle);
			  if (aio_return(aioinfo->aio_handle) == -1)
			    {
			      aioList[lc]->commandList[lc2].status = RTTAIOERROR;
			      aioList[lc]->commandList[lc2].errNo = 
				aio_error(aioinfo->aio_handle);
			      aioList[lc]->status = RTTAIOERROR;
			      status = RTTAIOERROR;
			    }
			  else
			    {
			      aioList[lc]->commandList[lc2].status = 
				RTTAIOCOMPLETED;
			    }
			}
		      else
			{
			  if (aioList[lc]->commandList[lc2].status == RTTAIOERROR)
			    {
			      status = RTTAIOERROR;
			      aioList[lc]->status = RTTAIOERROR;
			    }
			}
		      entry = lioarray[lc2];
		      RttP(lioArrayMutex);
		      if (((lioListHead != 0) && 
			   ((lioListTail + 1) !=  lioListHead)) ||
			  ((lioListHead == 0) && 
			   (lioListTail != ((NUMLIOARRAYS*MAXLIOREQUESTS)+1))))
			{
			  liocbList[lioListTail] = entry;
			  lioListTail++;
			  if (lioListTail == 
			      ((NUMLIOARRAYS * MAXLIOREQUESTS) + 1))
			    {
			      lioListTail = 0;
			    }
			}
		      else
			{
			  RttFree(entry);
			}
		      RttV(lioArrayMutex);
		    }
		  RttP(lioArrayMutex);
		  if (((lioArrayHead != 0) && ((lioArrayTail + 1) != 
					       lioArrayHead)) ||
		      ((lioArrayHead == 0) && (lioArrayTail != 
					       (NUMLIOARRAYS + 1))))
		    {
		      liocbArrays[lioArrayTail] = lioarray;
		      lioArrayTail++;
		      if (lioArrayTail == (NUMLIOARRAYS + 1))
			{
			  lioArrayTail = 0;
			}
		    }
		  else
		    {
		      RttFree(lioarray);
		    }
		  RttV(lioArrayMutex);
		}
	    }
	  return status;
	}
      SetIoOp(currthread, _RT_AIOWAIT);
      SetIoRes(currthread, RTTAIOINPROGRESS);
      SetState(currthread, IOBK);
      SchedM;
    }
}

#else

int RttAIOWait(RttAIOList *aioList[], int size)
{
  int lc;
  int lc2;
  int status;
  int ret;
  int err;
  int doReturn;
  int validEntryExists;
  aio_result_t *aioinfo;
  
  status = RTTAIOCOMPLETED;
  for (;;)
    {
      /*
	Must check inside OS, as possible race condition exists.
	*/
      validEntryExists = 0;
      doReturn = 0;
      ENTERINGOS;
      for (lc = 0; ((lc < size) && !doReturn); lc++)
	{
	  if ((aioList[lc] == NULL) || (aioList[lc]->commandList == NULL)) 
	    continue;
	  validEntryExists = 1;
	  if (aioList[lc]->status != RTTAIOINPROGRESS) doReturn = 1;
	}
      if (!validEntryExists || doReturn)
	{
	  LEAVINGOS;
	  for (lc = 0; lc < size; lc++)
	    {
	      if ((aioList[lc] == NULL) || (aioList[lc]->commandList == NULL))
		continue;
	      validEntryExists = 1;
	      if (aioList[lc]->numCommands == aioList[lc]->commandsCompleted)
		{
		  doReturn = 1;
		  aioList[lc]->status = RTTAIOCOMPLETED;
		  for (lc2 = 0; lc2 < aioList[lc]->numCommands; lc2++)
		    {
		      if (aioList[lc]->commandList[lc2].status ==RTTAIOINPROGRESS)
			{
			  ret =aioList[lc]->commandList[lc2].aioPrivate.result;
			  err = aioList[lc]->commandList[lc2].aioPrivate.errNo;
			  aioList[lc]->commandList[lc2].ioreturn = ret;
			  if (ret == -1)
			    {
			      aioList[lc]->commandList[lc2].status = RTTAIOERROR;
			      aioList[lc]->commandList[lc2].errNo = err;
			      aioList[lc]->status = RTTAIOERROR;
			      status = RTTAIOERROR;
			    }
			  else
			    {
			      aioList[lc]->commandList[lc2].status=
				RTTAIOCOMPLETED;
			      lseek(aioList[lc]->commandList[lc2].fd, ret,
				    aioList[lc]->commandList[lc2].whence);
			    }
			}
		      else
			{
			  if (aioList[lc]->commandList[lc2].status == RTTAIOERROR)
			    {
			      status = RTTAIOERROR;
			      aioList[lc]->status = RTTAIOERROR;
			    }
			}
		    }
		}
	    }
	  return status;
	}
      SetIoOp(currthread, _RT_AIOWAIT);
      SetIoRes(currthread, RTTAIOINPROGRESS);
      SetState(currthread, IOBK);
      SchedM;
    }
}


#endif /* #else (ibm not defined --> Sparc) */

static void CheckAIOWaiter(TCB *tcbPtr, int *res)
{
  int inst;

  if (GetIoRes(tcbPtr) != RTTAIOINPROGRESS)
    {
      inst = GetInstance(tcbPtr);
      *res = *res + 1;
      VERIFYANDDEQEUE(tcbPtr, 0, inst, IOBK);
    }
}
     
#else /* not ASYNCIO */
#ifdef NEVER


/* THIS HAS NEVER BEEN COMPLETED, nor TESTED */
int RttAIORequest(RttAIOList *aioList)
{
  int lc;
  RttSchAttr myAttr;
  RttThreadId me;
  
  me = RttMyThreadId();
  RttGetThreadSchedAttr(me, &myAttr);
  
  if (aioList->numCommands <= 0)
    {
      return RTTAIOCOMPLETED;
    }
  
  if (RttAllocSem(&(aioList->doneSem), (1 - aioList->numCommands), RTTFCFS) 
      != RTTOK)
    {
      fprintf(stderr, "Malloc failure!\n");
      return RTTAIOERROR;
    }
  aioList->status = RTTAIOINPROGRESS;
  
  RttSetThreadSchedAttr(me, superAttr);
  for (lc = 0; lc < aioList->numCommands; lc++)
    {
      if (++NumAIOWorkers == MAXAIOREQUESTS)
	{
	  fprintf(stderr, "OUT OF AIO REQUEST WORKERS!\n");
	  LEAVINGOS;
	  return RTTAIOERROR;
	}
      AIOWorkerList[AIOWorkerHead]->command = &(aioList->commandList[lc]);
      aioList->commandList[lc].aioPrivate = (void *)aioList->doneSem;
      if (lc == 0)
	{
	  AIOWorkerList[AIOWorkerHead]->aioList = aioList;
	  AIOWorkerList[AIOWorkerHead]->sleeping = 0;
	  aioList->aioPrivate = (void *)AIOWorkerList[AIOWorkerHead];
	}
      else
	{
	  AIOWorkerList[AIOWorkerHead]->aioList = NULL;
	}
      RttV(AIOWorkerList[AIOWorkerHead]->WaitSem);
      AIOWorkerHead++;
      if (AIOWorkerHead == MAXAIOREQUESTS)
	{
	  AIOWorkerHead = 0;
	}
    }
  RttSetThreadSchedAttr(me, myAttr);
  return RTTAIOINPROGRESS;
}


int RttAIOWait(RttAIOList *aioList[], int size)
{
  int lc;
  int lc2;
  int status;
  int ret;
  int err;
  int doReturn;
  int validEntryExists;
  int semValue;
  RttSem completedSem;
  RttSchAttr myAttr;
  RttThreadId me = RttMyThreadId();
  
  for (lc = 0; lc < size; lc++)
    {
      if ((aioList[lc] != NULL) && (aioList[lc]->commandList != NULL))
	{
	  validEntryExists = 1;
	}
    }
  if (!validEntryExists)
    {
      return RTTAIOCOMPLETED;
    }
  RttGetThreadSchedAttr(me, &myAttr);
  
  RttSetThreadSchedAttr(me, superAttr);
  for (;;)
    {
      doReturn = 0;
      status = RTTAIOCOMPLETED;
      for (lc = 0; lc < size; lc++)
	{
	  if ((aioList[lc] == NULL) || (aioList[lc]->commandList == NULL))
	    continue;
	  ((AIOWorkerInfo *)aioList[lc]->aioPrivate)->sleeper = me;
	  if (aioList[lc]->status != RTTAIOINPROGRESS)
	    {
	      RttFreeSem(aioList[lc]->doneSem);
	      doReturn = 1;
	      for (lc2 = 0; lc2 < aioList[lc]->numCommands; lc2++)
		{
		  if (aioList[lc]->commandList[lc2].status == RTTAIOERROR)
		    {
		      status = RTTAIOERROR;
		      aioList[lc]->status = RTTAIOERROR;
		    }
		}
	    }
	}
      if (doReturn)
	{
	  RttSetThreadSchedAttr(me, myAttr);

	  return status;
	}
      for (lc = 0; lc < size; lc++)
	{
	  if ((aioList[lc] == NULL) || (aioList[lc]->commandList == NULL)) 
	    continue;
	  ((AIOWorkerInfo *)aioList[lc]->aioPrivate)->sleeping = 1;
	}

      rttSuspend(RttMyThreadId());

      for (lc = 0; lc < size; lc++)
	{
	  if ((aioList[lc] == NULL) || (aioList[lc]->commandList == NULL) ||
	      (aioList[lc]->status != RTTAIOINPROGRESS)) continue;
	  ((AIOWorkerInfo *)aioList[lc]->aioPrivate)->sleeping = 0;
	}
    }
}
#else
int RttAIORequest(RttAIOList *aioList)
{
  static off_t	seekres = 0;
  int lc;
  RttAIOCommand *command;
  

  aioList->status = RTTAIOINPROGRESS;

  for (lc = 0; lc < aioList->numCommands; lc++) {
    command = &(aioList->commandList[lc]);
    ENTERINGOS;
    if((seekres = lseek(command->fd, command->offset, SEEK_SET
	/*command->whence */)) == -1) 
{
      command->status = command->ioreturn = RTTAIOERROR;
      LEAVINGOS;
    }
    else {
      LEAVINGOS;
	printf("SR: %llu\n", seekres);
      switch(command->iotype) {
      case RTTAIOREAD:
	if ((command->ioreturn = 
	     RttReadN(command->fd, command->buffer, command->numbytes)) < 0) {
	  command->status = RTTAIOERROR;
	}
	else {
	  command->status = RTTAIOCOMPLETED;
	}
	break;
      case RTTAIOWRITE:
	if ((command->ioreturn = 
	     RttWriteN(command->fd, command->buffer, command->numbytes)) < 0) {
	  command->status = RTTAIOERROR;
	}
	else {
	  command->status = RTTAIOCOMPLETED;
	}
	break;
      default:
	fprintf(stderr, "Unknown AIO type %d\n", command->iotype);
	command->status = RTTAIOERROR;
	break;
      }
    }
    command->errNo = GetErrno(currthread);
  }

  aioList->status = RTTAIOCOMPLETED;

  return (RTTAIOINPROGRESS);
}

int RttAIOWait(RttAIOList *aioList[], int size)
{
  int lc;
  int lc2;

  for (lc = 0; lc < size; lc++) {
    if ((aioList[lc] != NULL) && (aioList[lc]->commandList != NULL)) {
      assert(aioList[lc]->status != RTTAIOINPROGRESS);
      for (lc2 = 0; lc2 < aioList[lc]->numCommands; lc2++) {
	if (aioList[lc]->commandList[lc2].status == RTTAIOERROR) {
	  aioList[lc]->status = RTTAIOERROR;
	  return (RTTAIOERROR);
	}
      }
      break;
    }
  }
  return (RTTAIOCOMPLETED);
}
#endif
#endif /* ASYNCIO */


/*------------------------------------------------------------------------
 * doBlkError  --  called if I/O type is unknown
 *------------------------------------------------------------------------
 */
void doBlkError(TCB *tcbPtr)
{
  int inst;
  
  inst = GetInstance(tcbPtr);
  
  VERIFYANDDEQEUE(tcbPtr, -1, inst, IOBK);
}

#ifdef USE_POLL
#define CheckNDoIO(TCB_PTR,EVENTS,FUNC,RES) {\
          if (PollInfo[GetIoA1(TCB_PTR)].revents & \
	     (EVENTS | POLLERR | POLLHUP | POLLNVAL)){\
             FUNC(TCB_PTR);\
             RES++;\
          }\
	}
#else

#define CheckNDoIO(TCB_PTR,MSK,FUNC,RES) {\
	  if (FD_ISSET(GetIoA1(TCB_PTR),MSK)) {\
            FUNC(TCB_PTR);\
            RES++;\
	  }\
	}
#endif /* USE_POLL */

/*------------------------------------------------------------------------
 * checkBlkIoOperations  --  checks I/O masks and does any ready I/O
 *                           
 * NOTE: this MUST be called in the OS context
 *------------------------------------------------------------------------
 */
int checkBlkIoOperations(int selected)
{
  TCB *tcbPtr;
  TCB *next_tcbPtr;
  int res = 0;
#ifdef ASYNCIO
  RttAIOPrivate **curAIOInfo;
  int count = 0;
#ifdef ibm
  int lc;
  int listDone;
#endif
  
  /* Check AIO Queue for completed operations  */
  
  /*
    aioQueue entries for ibm contain struct liocb which represents all requests
    aioQueue entries for sun[4,4sol] contain individual requests
    */
  curAIOInfo = &aioQueue;
  while ((*curAIOInfo) != NULL)
    {
      count++;
#ifdef ibm
      listDone = 1;
      for (lc=0;((lc < (*curAIOInfo)->handle->numCommands) && (listDone));lc++)
	{
	  if (aio_error(((struct liocb  **)
			 (*curAIOInfo)->aioInfo)[lc]->lio_aiocb.aio_handle) == 
	      EINPROG)
	    {
	      listDone = 0;
	    }
	}
      if (listDone)
	{
	  if ((GetState((TCB *)(*curAIOInfo)->thread) == IOBK) &&
	      (GetIoOp((TCB *)(*curAIOInfo)->thread) == _RT_AIOWAIT))
	    {
	      SetIoRes((TCB *)(*curAIOInfo)->thread, RTTAIOCOMPLETED);
	    }
	  (*curAIOInfo)->handle->status = RTTAIOCOMPLETED;
	  *curAIOInfo = (*curAIOInfo)->next;
	}
#else
      if (((aio_result_t *)(*curAIOInfo)->aioInfo)->aio_return != 
	  AIO_INPROGRESS)
	{
	  (*curAIOInfo)->result = ((aio_result_t *)
				   (*curAIOInfo)->aioInfo)->aio_return;
	  (*curAIOInfo)->errNo = 
	    (((aio_result_t *)(*curAIOInfo)->aioInfo)->aio_errno & 0xFFFF);
	  (*curAIOInfo)->handle->commandsCompleted++;
	  
	  /*      putchar('+');
		  printf("%d,%d ", (*curAIOInfo)->handle->commandsCompleted,
		  (*curAIOInfo)->handle->numCommands);
		  */
	  
	  if (((*curAIOInfo)->handle->commandsCompleted == 
	       (*curAIOInfo)->handle->numCommands))
	    {
	      (*curAIOInfo)->handle->status = RTTAIOCOMPLETED;
	      if ((GetState((TCB *)(*curAIOInfo)->thread) == IOBK) &&
		  (GetIoOp((TCB *)(*curAIOInfo)->thread) == _RT_AIOWAIT))
		{
		  SetIoRes((TCB *)(*curAIOInfo)->thread, RTTAIOCOMPLETED );
		}
	    }
	  RETURNAIORESULTP(((aio_result_t *)(*curAIOInfo)->aioInfo));
	  *curAIOInfo = (*curAIOInfo)->next;
	}
#endif
      else
	{
	  curAIOInfo = &((*curAIOInfo)->next);
	}
    }
#endif /* ASYNCIO */  
  
  
  /* go through each entry on the blocking IO list ... */
  tcbPtr = QUEUE_FIRST(QTBL[IOBK]);
  
  while(tcbPtr != TNULL) {
    
    next_tcbPtr = NEXT(tcbPtr);
    
    switch(GetIoOp(tcbPtr)) {
      
    case CONN:
#ifdef USE_POLL
      /* 
       * XXX temporary solution because poll() doesn't work for connect()
       *     (at least not on Solaris)
       */
      PollInfo[GetIoA1(tcbPtr)].revents |= POLLOUT; 
      selected++; 
#endif /* USE_POLL */
      if (selected > 0) CheckNDoIO(tcbPtr, WIOMASK, doConnect, res); break;
    case ACC:        
      if (selected > 0) CheckNDoIO(tcbPtr, RIOMASK, doAccept, res); break;
    case RCVF:
      if (selected > 0) CheckNDoIO(tcbPtr, RIOMASK, doRecvfrom, res); break;
    case RCVM:
      if (selected > 0) CheckNDoIO(tcbPtr, RIOMASK, doRecvmsg, res); break;
    case SNDM:
      if (selected > 0) CheckNDoIO(tcbPtr, WIOMASK, doSendmsg, res); break;
    case READN:
      if (selected > 0) CheckNDoIO(tcbPtr, RIOMASK, doReadN, res); break;
    case WRITEN:
      if (selected > 0) CheckNDoIO(tcbPtr, WIOMASK, doWriteN, res); break;
    case READ:
      if (selected > 0) CheckNDoIO(tcbPtr, RIOMASK, doRead, res); break;
    case WRITE:
      if (selected > 0) CheckNDoIO(tcbPtr, WIOMASK, doWrite, res); break;
#ifdef ASYNCIO
    case _RT_AIOWAIT:    CheckAIOWaiter(tcbPtr, &res); break;
#endif /* ASYNCIO */
    default:         doBlkError(tcbPtr);   break;
    }
    tcbPtr = next_tcbPtr;
  }
  return (res);
}



#ifdef NO_SIGIO_FOR_SOCKETS
#define DO_SELECT_IN_NULLTHREAD
#endif


/*------------------------------------------------------------------------
 * NullThread_  --  runs when no other threads are ready
 *------------------------------------------------------------------------
 */
RTTTHREAD NullThread_()
{
  fd_set mask;
  
  PTRACE_START(currthread);
  
  LEAVINGOS;
  
  while( 1 ) {
    
#ifdef DO_SELECT_IN_NULLTHREAD 
    /* wait for any I/O which will not generate SIGIO (e.g., pipes) */
    riomask = wiomask = eiomask = fdmask;
    if (SELECT(fdwidth, &riomask, &wiomask, &eiomask, &zero_tv) > 0) {
      SetIoPending(1);
    }
#endif
    
    PTRACE_SYNC();
    PTRACE_CHECK(currthread, "BEFORE pause in null thread");
    PTRACE_WATCH();
    
    pause();  /* process gives up control until there is a signal */
    
    PTRACE_CHECK(currthread, "AFTER pause in null thread");
    
    if( GetNumbThreads() <= GetNumbSysThreads() ) {
      CallExitRoutines_();
      SysExit_(0);
    }
    
    ENTERINGOS;
    SchedM;
  }
}

#define DO_IMMEDIATE_SCHEDM

#define STACKERROR(v) (((u_long)(&v) < (u_long)GetStmembeg(currthread)) \
		     || ((u_long)(&v) > (u_long)GetStkend(currthread)))


/*------------------------------------------------------------------------
 * IoHandler_  --  SIGIO signal handler
 *------------------------------------------------------------------------
 */
void IoHandler_() {
  int retVal;
  sigset_t mask;
  int didSchedM = 0;
  u_long stackVar;

  if (!INOSCTXT)
    {
      /* 
       * XXX  can run into a problem if we get the signal while a
       *      lightweight process is doing asynchronous I/O, and we
       *      end up on its stack. If this happens, defer I/O handling.
       */ 
      if (STACKERROR(stackVar)) {
	SetIoPending(1);
	return;
      }

      SetIoPending(0);
      ENTERINGOS; 
      
      PTRACE_SIGIO();
      PTRACE_WATCH();
      PTRACE_CHECK(currthread, "INSIDE IoHandler_");
      
      riomask = wiomask = eiomask = fdmask;
      
      retVal = SELECT(fdwidth, &riomask, &wiomask, &eiomask, &zero_tv);
      
      if (QUEUE_FIRST(QTBL[IOBK]) != TNULL)
	{
	  CHECKAIORESULT();
	  if (checkBlkIoOperations(retVal))
	    {
	      CHECKAIORESULT();
#ifdef DO_IMMEDIATE_SCHEDM
	      SigMask_(SIG_UNBLOCK, SIGIO);
	      SigMask_(SIG_UNBLOCK, SIGALRM);
	      SchedM;
	      didSchedM = 1;
#endif /* DO_IMMEDIATE_SCHEDM */
	    }
	}
      if (!didSchedM)
	{
	  LEAVINGOS;
	}
    }
  
  else {
    SetIoPending(1);
  }
}
