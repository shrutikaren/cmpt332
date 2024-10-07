/****************************************************************************
 * 
 * rttremoteitc.c
 * 
 * Remote (cross address space) inter-thread communication module.
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

#include "rttkernel.h"
#include "rttremoteitc.h"
#ifndef WIN32
#include <sys/uio.h>
#endif /* WIN32 */

#include <rpc/types.h>
#include <rpc/xdr.h>

#define RTTTIMEVALEQUAL(t1, t2) (((t1).seconds == (t2).seconds)  \
				 && ((t1).microseconds == (t2).microseconds))

#define min(X,Y) ((X) < (Y) ? (X) : (Y))

static int netInitialized = 0;
#define NUMITCSERVERS 1

struct ITCinfo {
  int type;
  int typeSpecific;
  u_int slen;
  u_int rlen;
  RttThreadId sender;
  RttThreadId receiver;
  RttTimeValue timestamp;
};
typedef struct ITCinfo ITCinfo;

#ifdef __linux
#define msg_accrights msg_control
#define msg_accrightslen msg_controllen
#endif

#ifdef Darwin
#define msg_accrights msg_control
#define msg_accrightslen msg_controllen
#endif

#ifdef i386
#ifndef solaris
#define msg_accrights msg_control
#define msg_accrightslen msg_controllen
#endif
#endif


/* packet types */
#define ITCREQUEST    1
#define ITCREQUESTACK 2
#define ITCREPLY      3
#define ITCREPLYACK   4

static char *typeStrings[4] = {"ITCREQUEST", "ITCREQUESTACK", 
				 "ITCREPLY", "ITCREPLYACK"};
#define TYPESTRING(X) typeStrings[(X)-1]

#define ITCMAXUDPPACKETLEN      9000
#define ITCMAXUDPDATALEN        (ITCMAXUDPPACKETLEN - sizeof(ITCinfo))
#define ITCMAXRETRIES           20
#define ITCTIMEOUTSECONDS       0
#define ITCTIMEOUTMICROSECONDS  500000
#define ITCUDPREPLY             1
#define ITCTCPREPLY             2
#define ONEMILLION              1000000

static RttTimeValue timeout = {ITCTIMEOUTSECONDS, ITCTIMEOUTMICROSECONDS};

static int localSd;

#ifndef WIN32
#include <netinet/tcp.h>
#endif /* WIN32 */

#define DPRINTF (void)
/*#define RPRINTF if(GetIpAddrFromThreadId(msg->sender) == 0xc6a226f8) printf*/
#define RPRINTF (void)


#ifdef WIN32
#define RttPerror  perror
#define bzero(X,Y) memset(X,0,Y)
#define EWOULDBLOCK             WSAEWOULDBLOCK
#endif /* WIN32 */

#include <string.h>

#define ITCMAXACTIVEREQUESTS NUMBTCBS /* NUMBTCBS defined in rttconfig.h */

typedef enum {ITCNOTINUSE = 0, ITCAWAITINGREQUESTACK = 1,
		ITCAWAITINGREPLY = 2, ITCHANDLINGREQUEST = 3, 
		ITCGOTREPLY = 4} ItcState;

#define MAXSTATE ITCGOTREPLY

static char *stateStrings[] = {"ITCNOTINUSE", "ITCAWAITINGREQUESTACK",
				 "ITCAWAITINGREPLY", "ITCHANDLINGREQUEST", 
				 "ITCGOTREPLY"};

#define StateToString(X) ((  ((X) >= 0) && ((X) <= MAXSTATE)  ) ? \
			  stateStrings[X] : "UNKNOWN STATE")

typedef struct {
  ItcState state;
  void *data;
  RttThreadId thread;
  int next;
} ArtEntry;

typedef struct {
  RttTimeValue timestamp;
  RttSem replySem;
} ArtData;

static int artHead, artTail;
static int artFree;

static RttSem artMutex;

ArtEntry art[ITCMAXACTIVEREQUESTS];

/*------------------------------------------------------------------------
 * artInit  --  initialize active request table
 *------------------------------------------------------------------------
 */
static int artInit()
{
  static int initialized = 0;
  int i;

  if (initialized) {
    return (RTTFAILED);
  }

  initialized = 1;
  
  for (i = 0; i < ITCMAXACTIVEREQUESTS - 1; i++) {
    art[i].state = ITCNOTINUSE;
    art[i].next = i + 1;
  }
  art[ITCMAXACTIVEREQUESTS - 1].next = -1;
  artHead = artTail = -1;
  artFree = 0;

  RttAllocSem(&artMutex, 1, RTTPRIORITY);

  return (RTTOK);
}

/*------------------------------------------------------------------------
 * artAdd  --  add thread to active request table
 *------------------------------------------------------------------------
 */
static int artAdd(RttThreadId thread, ItcState state, void *data)
{
  int artNew;

  if (artFree == -1) {
    return (RTTFAILED);
  }

  RttP(artMutex);

  artNew = artFree;
  artFree = art[artFree].next;

  art[artNew].thread = thread;
  art[artNew].state = state;
  art[artNew].data = data;

  art[artNew].next = artHead;

  if (artHead == -1) {
    artTail = artNew;
  }
  artHead = artNew;

  RttV(artMutex);

  return (RTTOK);
}

/*------------------------------------------------------------------------
 * artSetState  --  set state of thread in active request table
 *------------------------------------------------------------------------
 */
static int artSetState(RttThreadId thread, ItcState state)
{
  int i;

  RttP(artMutex);
 
  for (i = artHead; i != -1; i = art[i].next) {
    if (RTTTHREADEQUAL(thread, art[i].thread)) {
      art[i].state = state;
      RttV(artMutex);
      return (RTTOK);
    }
  }

  RttV(artMutex);

  return (RTTFAILED);
}

/*------------------------------------------------------------------------
 * artSetValues  --  set state of thread and data in active request 
 *                   table
 *------------------------------------------------------------------------
 */
static int artSetValues(RttThreadId thread, ItcState state, void *data)
{
  int i;

  RttP(artMutex);
 
  for (i = artHead; i != -1; i = art[i].next) {
    if (RTTTHREADEQUAL(thread, art[i].thread)) {
      art[i].state = state;
      art[i].data = data;
      RttV(artMutex);
      return (RTTOK);
    }
  }

  RttV(artMutex);

  return (RTTFAILED);
}

/*------------------------------------------------------------------------
 * artLookup  --  look up thread in active request table
 *------------------------------------------------------------------------
 */
static int artLookup(RttThreadId thread, ItcState *state, void **data)
{
  int i;

  RttP(artMutex);
 
  for (i = artHead; i != -1; i = art[i].next) {
    if (RTTTHREADEQUAL(thread, art[i].thread)) {

      *state = art[i].state;
      *data = art[i].data;
      RttV(artMutex);
      return (RTTOK);
    }
  }

  RttV(artMutex);

  return (RTTFAILED);
}
  
/*------------------------------------------------------------------------
 * artRemove  --  remove thread from active request table
 *------------------------------------------------------------------------
 */
static int artRemove(RttThreadId thread, void(*freeRoutine)(void *))
{
  int i, prev;

  RttP(artMutex);
 
  for (i = prev = artHead; i != -1; i = art[i].next) {
    if (RTTTHREADEQUAL(thread, art[i].thread)) {
      art[i].state = ITCNOTINUSE;

      if (freeRoutine != NULL) {
	(*freeRoutine)(art[i].data);
      }
      if (i == artHead) {
	artHead = art[i].next;
      }
      else {
	art[prev].next = art[i].next;
      }
      art[i].next = artFree;
      artFree = i;
      RttV(artMutex);
      return (RTTOK);
    }
    prev = i;
  }

  RttV(artMutex);

  return (RTTOK);
}
  
/*------------------------------------------------------------------------
 * freeArtData  --  routine passed into artRemove to free data
 *------------------------------------------------------------------------
 */
static void freeArtData(void *data)
{
  if (data != NULL) {
    RttFreeSem(((ArtData *)data)->replySem);
    RttFree(data);
  }
}

/*------------------------------------------------------------------------
 * xdr_RttThreadId  --  XDR encode/decode routine for RttThreadId
 *------------------------------------------------------------------------
 */
bool_t xdr_RttThreadId(XDR *xdrs, RttThreadId *objp)
{
  if (!xdr_u_long(xdrs, &objp->hid)) {
    return (FALSE);
  }
  if (!xdr_u_long(xdrs, &objp->lid)) {
    return (FALSE);
  }
  return (TRUE);
}


/*------------------------------------------------------------------------
 * encodeInfo  --  encode ITCinfo structure using hton* routines
 *------------------------------------------------------------------------
 */
static void encodeInfo(ITCinfo *info, ITCinfo *einfo)
{
  einfo->type = htonl(info->type);
  einfo->typeSpecific = htonl(info->typeSpecific);
  einfo->slen = htonl(info->slen);
  einfo->rlen = htonl(info->rlen);
  einfo->sender.lid = htonl(info->sender.lid);
  einfo->sender.hid = htonl(info->sender.hid);
  einfo->receiver.lid = htonl(info->receiver.lid);
  einfo->receiver.hid = htonl(info->receiver.hid);
  einfo->timestamp.seconds = htonl(info->timestamp.seconds);
  einfo->timestamp.microseconds = htonl(info->timestamp.microseconds);
}

/*------------------------------------------------------------------------
 * decodeInfo  --  decode ITCinfo structure using ntoh* routines
 *------------------------------------------------------------------------
 */
static void decodeInfo(ITCinfo *info, ITCinfo *dinfo)
{
  dinfo->type = ntohl(info->type);
  dinfo->typeSpecific = ntohl(info->typeSpecific);
  dinfo->slen = ntohl(info->slen);
  dinfo->rlen = ntohl(info->rlen);
  dinfo->sender.lid = ntohl(info->sender.lid);
  dinfo->sender.hid = ntohl(info->sender.hid);
  dinfo->receiver.lid = ntohl(info->receiver.lid);
  dinfo->receiver.hid = ntohl(info->receiver.hid);
  dinfo->timestamp.seconds = ntohl(info->timestamp.seconds);
  dinfo->timestamp.microseconds = ntohl(info->timestamp.microseconds);
}

/*------------------------------------------------------------------------
 * createAndBindSocket  --  creates a socket and binds to the given port,
 *                          returning the socket descriptor. If 0 is given
 *                          for port, one will be chosen and returned by
 *                          reference in 'chosenPort'
 *------------------------------------------------------------------------
 */
static int createAndBindSocket(int type, u_short port, u_short *chosenPort) {
  struct sockaddr_in sockaddr;
  socklen_t namelen = sizeof(struct sockaddr_in);
  int sd;

  if ((sd = RttSocket(AF_INET, type, 0)) < 0) {
    RttPerror("RttSocket");
    return (RTTFAILED);
  }
  bzero(&sockaddr, sizeof(sockaddr));
  sockaddr.sin_family = AF_INET;
  sockaddr.sin_port = htons(port);
  sockaddr.sin_addr.s_addr = INADDR_ANY;
  
  if (RttBind(sd, (struct sockaddr *)&sockaddr, sizeof(sockaddr)) != 0) {
    RttPerror("RttBind");
    return (RTTFAILED);
  }

  if (port == 0) {
    if (RttGetsockname(sd, (struct sockaddr *)&sockaddr, &namelen) == -1) {
    RttPerror("RttGetsockname");
      return (RTTFAILED);
    }
    *chosenPort = ntohs(sockaddr.sin_port);
  }
  else {
    *chosenPort = port;
  }

  return (sd);
}

/*------------------------------------------------------------------------
 * tcpConnect  --  connect to given IP address and port
 *------------------------------------------------------------------------
 */
static int tcpConnect(int sd, u_long addr, u_short port) 
{
  struct sockaddr_in sockaddr;
  int optval = 1;

  bzero(&sockaddr, sizeof(sockaddr));
  sockaddr.sin_family = AF_INET;
  sockaddr.sin_port = htons(port);
  sockaddr.sin_addr.s_addr = htonl(addr);
  if (RttConnect(sd, (struct sockaddr *)&sockaddr, sizeof(sockaddr))) {
    RttPerror("RttConnect");
    return (RTTFAILED);
  }

  /* XXX need better way to get TCP protocol number (6) here, getprotoent()? */
  if (RttSetsockopt(sd, 6 , TCP_NODELAY, (char *)&optval, sizeof(int)) == -1) {
    perror("RttSetsockopt");
    return (RTTFAILED);
  }

  return (RTTOK);
}

/*------------------------------------------------------------------------
 * tcpAccept  --  accept connection on a listening socket
 *------------------------------------------------------------------------
 */
static int tcpAccept(int sd)
{
  struct sockaddr_in sockaddr;
  socklen_t namelen = sizeof(struct sockaddr_in);
  int tcpSd;
  int optval = 1;

  if ((tcpSd = RttAccept(sd, (struct sockaddr *)&sockaddr, &namelen))
      == RTTFAILED) 
    {
      RttPerror("RttAccept");
      return (RTTFAILED);
    }

  /* XXX need better way to get TCP protocol number (6) here, getprotoent()? */
  if (RttSetsockopt(tcpSd, 6, TCP_NODELAY,(char *)&optval,sizeof(int)) == -1) {
    perror("RttSetsockopt");
    return (RTTFAILED);
  }

  return (tcpSd);
}

/*------------------------------------------------------------------------
 * getLocalIP  --  returns local IP address (the first one found)
 *------------------------------------------------------------------------
 */
static u_long getLocalIP()
{  
  char hn[40];
  struct hostent *hp;
  static u_int localIp = 0;

  if (localIp) {
    return localIp;
  }

  gethostname(hn, 40);
  hp = gethostbyname(hn);
  if(hp == 0) {
    return (RTTFAILED); 
  }

  localIp = ntohl(*((long *) hp->h_addr));

  return (localIp);
}

/*------------------------------------------------------------------------
 * udpSend  --  send a UDP packet to given IP address and port
 *------------------------------------------------------------------------
 */
static int udpSend(int sd, u_long remoteIp, 
		   u_short remotePort, ITCinfo *info, char *buf, int len) {
#define IOVLEN 2
  struct sockaddr_in sin;
  struct msghdr msg;
  struct iovec iov[IOVLEN];
  int res;
  
  bzero((char *) &sin, sizeof(struct sockaddr_in));
  sin.sin_family = AF_INET;
  sin.sin_port = htons(remotePort);
  sin.sin_addr.s_addr = htonl(remoteIp);

  iov[0].iov_base = (char *)info;
  iov[0].iov_len = sizeof(ITCinfo);
  iov[1].iov_base = buf;
  iov[1].iov_len = len;

  msg.msg_name = (char *) &sin;
  msg.msg_namelen = sizeof(struct sockaddr_in);
  msg.msg_iov = iov;
  msg.msg_iovlen = IOVLEN;
  msg.msg_accrights = NULL;
  msg.msg_accrightslen = 0;

  if((res = RttSendmsg(sd, &msg, 0)) < 0) {
    RttPerror("RttSendmsg");
  }

  return (res);
}

/*------------------------------------------------------------------------
 * sleepThread  --  put the given thread to sleep for time value
 *------------------------------------------------------------------------
 */
static void sleepThread(RttThreadId thread, RttTimeValue timeVal)
{
  RttSchAttr attrs;
  RttTimeValue wakeTime;

  RttGetThreadSchedAttr(thread, &attrs);
  RttGetTimeOfDay(&wakeTime);
  wakeTime.seconds += timeVal.seconds;
  wakeTime.microseconds += timeVal.microseconds;
  if (wakeTime.microseconds > ONEMILLION) {
    wakeTime.seconds++;
    wakeTime.microseconds -= ONEMILLION;
  }
  attrs.startingtime = wakeTime;
  RttSetThreadSchedAttr(thread, attrs);
}

/*------------------------------------------------------------------------
 * suspendThread  --  put the given thread to sleep indefinitely
 *------------------------------------------------------------------------
 */
static void suspendThread(RttThreadId thread)
{
  RttSchAttr attrs;

  RttGetThreadSchedAttr(thread, &attrs);
  attrs.startingtime = RTTINFINITE;
  RttSetThreadSchedAttr(thread, attrs);
}

/*------------------------------------------------------------------------
 * wakeThread  --  wake up the given thread
 *------------------------------------------------------------------------
 */
static void wakeThread(RttThreadId thread)
{
  RttSchAttr attrs;

  RttGetThreadSchedAttr(thread, &attrs);
  attrs.startingtime = RTTZEROTIME;
  RttSetThreadSchedAttr(thread, attrs);
}

/*------------------------------------------------------------------------
 * itcWorker  --  worker thread reads message via XTP and does local 
 *                RttSend, sending the reply to the client via XTP
 *------------------------------------------------------------------------
 */
static RTTTHREAD itcWorker(void *arg) {
  int sd;
  ITCinfo *info, reply;
  char *sData, *rData, *udpData;
  int udpDataLen, tcpDataLen;
  u_short chosenPort, tcpPort;
  RttThreadId me;
  unsigned long ackFlag = 0;
  int retries = 0;

  info = (ITCinfo *)arg;

  tcpPort = (u_short)info->typeSpecific;

  /* create send data buffer and copy data from UDP request into it */
  if (info->slen) {
    sData = (char *) RttMalloc(info->slen);
    udpDataLen = min(info->slen, ITCMAXUDPDATALEN);
    memmove(sData, (char *)(info + 1), udpDataLen);
    tcpDataLen = info->slen - udpDataLen;
  }
  else {
    sData = NULL;
    udpDataLen = tcpDataLen = 0;
  }

  DPRINTF("itcWorker: tcpDataLen = %d, info->rlen = %d\n", 
	  tcpDataLen, info->rlen);

  /* if more data is coming, connect to sender and receive it */
  if (tcpDataLen) {
    int numRead;

    if ((sd = createAndBindSocket(SOCK_STREAM, 0, &chosenPort)) == RTTFAILED) {
      fprintf(stderr, "itcWorker: createAndBindSocket failed\n");
      /* XXX need to return error code to sender, but for now... */
      RttExit();
    }

    DPRINTF("itcWorker: doing connect to 0x%x %u\n", 
	    GetIpAddrFromThreadId(info->sender), tcpPort);

    if (tcpConnect(sd, GetIpAddrFromThreadId(info->sender), tcpPort) 
	== RTTFAILED) 
      {
	fprintf(stderr, "itcWorker: tcpConnect failed\n");
	/* XXX need to return error code to sender, but for now...  */
	RttExit();
      }

    DPRINTF("itcWorker: did connect, sd = %d, reading %d bytes\n", 
	    sd, tcpDataLen);

    /* read the rest of the send data */
    if ((numRead = RttReadN(sd, sData + udpDataLen, tcpDataLen)) == RTTFAILED){
      RttPerror("RttReadN");
      RttClose(sd);
      RttFree(sData);
      /* XXX is this the best thing to do? */
      RttExit();
    }
    DPRINTF("itcWorker: read sender data, %d bytes\n", numRead);
  }

  /* allocate a buffer for the reply */
  if (info->rlen) {
    rData = (char *)RttMalloc(info->rlen);
  }
  else {
    rData = NULL;
  }

  /* some RT Threads magic so RttReceive() will return the remote thread id */
  SetRemoteItc(currthread, 1);
  SetRemoteThreadId(currthread, info->sender);

  DPRINTF("itcWorker: doing local RttSend\n");

  /* do the local RttSend() */
  if ((info->typeSpecific = RttSend(info->receiver, sData, info->slen, 
				    rData, &(info->rlen))) != RTTOK) 
    {
      info->rlen = 0;
    }

  DPRINTF("itcWorker: back from local RttSend, info->rlen = %d\n", info->rlen);

  SetRemoteItc(currthread, 0);

  RttFree(sData);

  /* 
   * send a reply packet to sender; if we are using TCP at all, this packet
   * will contain no reply data, just control information
   */
  info->type = ITCREPLY;
  me = RttMyThreadId();
  info->receiver = me;

  udpDataLen = 
    (tcpDataLen == 0) && (info->rlen < ITCMAXUDPDATALEN) ? info->rlen : 0;

  encodeInfo(info, &reply);

  RttSetData(me, ackFlag); /* Dwight change 2018 */

  DPRINTF("itcWorker: sending reply packet to sender 0x%x %u\n",
	  GetIpAddrFromThreadId(info->sender), 
	  GetPortNoFromThreadId(info->sender));

  /* send UDP data packet until we get an ACK (XXX check all for NULL) */
  while (!ackFlag && (retries++ < ITCMAXRETRIES)) {

    DPRINTF("itcWorker: sending packet %d, udpDataLen = %d\n", 
	    retries, udpDataLen);

    DPRINTF("!!! %d %d !!!\n", *(int *)rData, *((int *)rData+1));

    if (udpSend(localSd, GetIpAddrFromThreadId(info->sender), 
		GetPortNoFromThreadId(info->sender),
		&reply, rData, udpDataLen) < 0) 
      {
	fprintf(stderr, "itcWorker: udpSend failed\n");
	/* XXX how to deal with this failure? for now...*/
	RttExit();
      }

    sleepThread(me, timeout);
    RttGetData(me, (void *) &ackFlag);
    DPRINTF("itcWorker: ackFlag = %d\n", ackFlag);
  }

  /* timed out */
  if (ackFlag == 0) {
    DPRINTF("itcWorker: TIMED OUT\n");
    /* XXX how to deal with this failure? for now...*/
    RttExit();
  }
  else {
    DPRINTF("itcWorker: got reply ACK\n");
  }

  if (tcpDataLen || (info->rlen > ITCMAXUDPDATALEN)) {
    /* if tcpDataLen is not 0, connect has already been done */
    if (tcpDataLen == 0) {
      if ((sd = createAndBindSocket(SOCK_STREAM, 0, &chosenPort)) 
	  == RTTFAILED)
	{
	  fprintf(stderr, "itcWorker: createAndBindSocket failed\n");
	  /* XXX need to return error code to sender, but for now... */
	  RttExit();
	}

      DPRINTF("itcWorker: connecting to 0x%x %u\n", 
	      GetIpAddrFromThreadId(info->sender), tcpPort);

      if (tcpConnect(sd, GetIpAddrFromThreadId(info->sender), tcpPort) 
	  == RTTFAILED) 
	{
	  fprintf(stderr, "itcWorker: tcpConnect failed\n");
	  /* XXX need to return error code to sender, but for now... */
	  RttExit();
	}
    }
    if (info->rlen) {
      DPRINTF("itcWorker: doing write of rData (0x%x), length %d\n", 
	      rData, info->rlen);
      if (rData) DPRINTF("itcWorker: rData: %d %d\n", *(int *)rData,
			 *((int *)rData + 1));
      if (RttWriteN(sd, rData, info->rlen) == RTTFAILED) {
	RttPerror("RttWriteN");
      }
    }
    RttClose(sd);
  }
  RttFree(info);
  RttFree(rData);
}

/*------------------------------------------------------------------------
 * itcServer  --  server thread listens for TCP connection requests
 *------------------------------------------------------------------------
 */
static RTTTHREAD itcServer() {
  RttSchAttr attr;
  RttThreadId workerThread;
  u_short itc_port, chosenPort;
  struct sockaddr_in sockaddr;
  socklen_t namelen = sizeof(struct sockaddr_in);
  ITCinfo ack, *msg, *info;
  int msgLen;
  ItcState state;
  ArtData *artData;

  msg = (ITCinfo *)RttMalloc(ITCMAXUDPPACKETLEN);

  for (;;) {
    if ((msgLen = RttRecvfrom(localSd, (char *)msg, ITCMAXUDPPACKETLEN, 0,
			  (struct sockaddr *)&sockaddr, &namelen))
	== RTTFAILED) {
      RttPerror("RttRecvfrom");
      SysExit_(-1);
    }

    /* if the sender didn't send it's IP address, fill it in (XXX both?) */
    if (GetIpAddrFromThreadId(msg->sender) == 0) {
      SetThreadIdIpAddr(msg->sender, sockaddr.sin_addr.s_addr);
    }
    if (GetIpAddrFromThreadId(msg->receiver) == 0) {
      SetThreadIdIpAddr(msg->receiver, sockaddr.sin_addr.s_addr);
    }

    decodeInfo(msg, msg);

    DPRINTF("itcServer: msg type %d, sender 0x%x %u, receiver 0x%x %u\n", 
	    msg->type, GetIpAddrFromThreadId(msg->sender),
	    GetPortNoFromThreadId(msg->sender),
	    GetIpAddrFromThreadId(msg->receiver), 
	    GetPortNoFromThreadId(msg->receiver));

    switch (msg->type) {

    case ITCREQUEST:
      RPRINTF("\nITCREQUEST, sender 0x%x %u, receiver 0x%x %u\n", 
	      GetIpAddrFromThreadId(msg->sender),
	      GetPortNoFromThreadId(msg->sender),
	      GetIpAddrFromThreadId(msg->receiver), 
	      GetPortNoFromThreadId(msg->receiver));
      if (artLookup(msg->sender, &state, (void **)&artData) == RTTFAILED) {
	/* new request */
	RPRINTF("not found, *new request*\n");
	artData = (ArtData *)RttMalloc(sizeof(ArtData));
	artData->timestamp = msg->timestamp;
	if (RttAllocSem(&(artData->replySem), 0, RTTFCFS) != RTTOK) {
	  fprintf(stderr, "itcServer: RttAllocSem failed\n");
	  RttFree(artData);
	}
	else if (artAdd(msg->sender, ITCHANDLINGREQUEST, artData) 
	    != RTTOK) 
	  {
	    RttFree(artData);
	    DPRINTF("itcServer: artAdd failed\n");
	    /* XXX send an RTTFAILED reply to the sender */
	  }

	DPRINTF("itcServer: sending ITCREQUESTACK to 0x%x %u\n",
		GetIpAddrFromThreadId(msg->sender), 
		GetPortNoFromThreadId(msg->sender));

	/* send ACK */
	msg->type = ITCREQUESTACK;
	encodeInfo(msg, &ack); /* XXX use original? */
	if (udpSend(localSd, GetIpAddrFromThreadId(msg->sender), 
		    GetPortNoFromThreadId(msg->sender),
		    &ack, NULL, 0) < 0) 
	  {
	    /* XXX how to deal with this failure? for now... */
	    artRemove(msg->sender, freeArtData);
	    break;
	  }

	attr.startingtime = RTTZEROTIME;
	attr.priority = 9;
	attr.deadline = RTTNODEADLINE;

	/* copy the message to pass on to the worker thread */
	info = (void *)RttMalloc(msgLen);
	memmove(info, msg, msgLen);

	if (RttCreate(&workerThread, (void(*)()) itcWorker, 8192, "itcWorker", 
		      info, attr, RTTUSR) == RTTFAILED) {
	  DPRINTF("itcServer: RttCreate failed\n");
	  /* XXX send an RTTFAILED reply to the sender, but for now... */
	  artRemove(msg->sender, freeArtData);
	  break;
	}
      }
      else {
	if (RTTTIMEVALEQUAL(msg->timestamp, artData->timestamp)) {
	  RPRINTF("found, same timestamp, duplicate\n");
	  /* duplicate request, send ACK and then discard */
	  ack.type = ITCREQUESTACK;
	  encodeInfo(msg, &ack); /* XXX use original? */
	  if (udpSend(localSd, GetIpAddrFromThreadId(msg->sender), 
		      GetPortNoFromThreadId(msg->sender),
		      &ack, NULL, 0) < 0) 
	    {
	      /* XXX how to deal with this failure? */
	    }
	}
	else {
	  /* XXX new request, client must be reincarnation WHAT TO DO?   */
	  /* I think, purge current entry from art, and put this one in. */
	  /* Might need some other cleanup if current request was in     */
	  /* progress. If reply has been sent, I think we can consider   */
	  /* this an implicit ACK.                                       */
	  RPRINTF("found, different timestamp, huh?\n");
	  DPRINTF("itcServer: found in art, different timestamp, state = %s\n",
		  StateToString(state));
	}
      }
      break;

    case ITCREQUESTACK:
      /* if we don't find the request, it's a duplicate ack (ignore) */
      if (artLookup(msg->sender, &state, (void **)&artData) == RTTOK) {
	if (state == ITCAWAITINGREPLY) {
	  RttSetData(msg->sender, 1); /* flag says we got an ACK */
	  /* Change 2018 Dwight */
	  wakeThread(msg->sender);
	}
	else {
	  DPRINTF("got ITCREQUESTACK, but state was %d\n", state);
	}
      }
      else {
	DPRINTF("got ITCREQUESTACK, not found in art\n");
      }
      break;

    case ITCREPLY:
      /* XXX what's the deal with timestamps here? */
      if (artLookup(msg->sender, &state, (void **)&artData) == RTTOK) {
	DPRINTF("itcServer: got reply, found in art\n");
	info = (void *)RttMalloc(msgLen);
	memmove(info, msg, msgLen);
	RttSetData(msg->sender, (unsigned long) info); /* fixing 2018 */
	RttV(artData->replySem);
	RttGetTimeOfDay(&(artData->timestamp));
	/* XXX do we really need to keep it around? */
	artSetState(msg->sender, ITCGOTREPLY); 
      }
      else {
	DPRINTF("itcServer: got reply, NOT found in art\n");
	/* XXX ??? */
      }

      DPRINTF("itcServer: sending ITCREPLYACK to 0x%x %u\n",
	      GetIpAddrFromThreadId(msg->receiver), 
	      GetPortNoFromThreadId(msg->receiver));

      /* XXX send ACK (always?) */
      msg->type = ITCREPLYACK;
      encodeInfo(msg, &ack); /* XXX use original? */
      /* the receiver changed the receiver thread id to that of the worker */
      if (udpSend(localSd, GetIpAddrFromThreadId(msg->receiver), 
		  GetPortNoFromThreadId(msg->receiver),
		  &ack, NULL, 0) < 0) 
	{
	  /* XXX how to deal with this failure? */
	}
      
      break;

    case ITCREPLYACK:
      /* if we don't find the request, it's a duplicate ack (ignore) */
      if (artLookup(msg->sender, &state, (void **)&artData) == RTTOK) {
	DPRINTF("itcServer: got reply ACK, found in art\n");
	if (artRemove(msg->sender, freeArtData) != RTTOK) {
	  fprintf(stderr, "itcServer: artRemove failed\n");
	}
	RttSetData(msg->receiver, 1); /* flag says we got an ACK */
	/* Dwight change 2018 */
	wakeThread(msg->receiver);
      }
      else {
	DPRINTF("itcServer: got reply ACK, NOT found in art\n");
      }
      break;

    default:
      fprintf(stderr, "itcServer: unknown message type: %d\n", msg->type);
      break;
    }
  }
}

/*------------------------------------------------------------------------
 * ExecuteRemoteRequest_  --  called by RttSend to send message to remote
 *                            server via TCP, and read the reply
 *------------------------------------------------------------------------
 */
int ExecuteRemoteRequest_(RttThreadId to, u_int slen, void *sData, 
			  u_int *rlen, void *rData) {
  int listenSd, tcpSd;
  int encodedLen;
  int retCode;
  u_short chosenPort = 0;
  int numRead;
  int udpDataLen, tcpDataLen;
  RttThreadId me;
  unsigned long ackFlag = 0;
  int retries = 0;
  int listening = 0;
  ITCinfo info, request, *reply;
  ArtData *artData;

  me = RttMyThreadId();

  info.type = ITCREQUEST;
  info.slen = slen;
  info.rlen = *rlen;
  info.sender = me;
  info.receiver = to;
  RttGetTimeOfDay(&info.timestamp);
  
  udpDataLen = min(slen, ITCMAXUDPDATALEN);

  DPRINTF("ExecuteRemoteRequest_: udpDataLen = %d, slen = %d, *rlen = %d\n", 
	  udpDataLen, slen, *rlen);

  if ((slen > ITCMAXUDPDATALEN) || (*rlen > ITCMAXUDPDATALEN)) {
    if ((listenSd = createAndBindSocket(SOCK_STREAM, 0, &chosenPort))
	== RTTFAILED) 
      {
	fprintf(stderr, "ExecuteRemoteRequest_: createAndBindSocket failed\n");
	return (RTTFAILED);
      }

    if (RttListen(listenSd, 1) != RTTOK) {
      RttPerror("RttListen");
      RttClose(listenSd);
      return (RTTFAILED);
    }
    listening = 1;
    info.typeSpecific = chosenPort;
    DPRINTF("ExecuteRemoteRequest_: listening at port %d\n", chosenPort);
  }
  else {
    info.typeSpecific = 0;
  }

  artData = (ArtData *)RttMalloc(sizeof(ArtData));
  assert(artData);
  artData->timestamp = info.timestamp;
  if (RttAllocSem(&(artData->replySem), 0, RTTFCFS) != RTTOK) {
    fprintf(stderr, "ExecuteRemoteRequest_: RttAllocSem failed\n");
    RttFree(artData);
    if (listening) {
      RttClose(listenSd);
    }
    return (RTTFAILED);
  }

  if (artAdd(info.sender, ITCAWAITINGREPLY, (void *)artData) != RTTOK) {
    fprintf(stderr, "ExecuteRemoteRequest_: artAdd failed\n");
    RttFreeSem(artData->replySem);
    RttFree(artData);
    if (listening) {
      RttClose(listenSd);
    }
    return (RTTFAILED);
  }

  encodeInfo(&info, &request);

  RttSetData(me, ackFlag); /* Dwight 2018 */

  DPRINTF("ExecuteRemoteRequest_: sending UDP data packet to 0x%x %u\n",
	  GetIpAddrFromThreadId(to), GetPortNoFromThreadId(to));

  /* send UDP data packet until we get an ACK */
  while (!ackFlag && (retries++ < ITCMAXRETRIES)) {

    DPRINTF("ExecuteRemoteRequest_: sending packet %d\n", retries);

    if (udpSend(localSd, GetIpAddrFromThreadId(to), GetPortNoFromThreadId(to),
		&request, sData, udpDataLen) < 0) {
      artRemove(info.sender, freeArtData);
      if (listening) {
	RttClose(listenSd);
      }
      fprintf(stderr, "ExecuteRemoteRequest_: udpSend failed\n");
      return (RTTFAILED);
    }

    sleepThread(me, timeout);
    RttGetData(me, &ackFlag);
    DPRINTF("ExecuteRemoteRequest_: ackFlag =  %d\n", ackFlag);
  }

  /* timed out, return error code */
  if (ackFlag == 0) {
    artRemove(info.sender, freeArtData);
    if (listening) {
      RttClose(listenSd);
    }
    fprintf(stderr, "ExecuteRemoteRequest_: timed out\n");
    return (RTTFAILED);
  }

  DPRINTF("ExecuteRemoteRequest_: got ACK\n");

  /* if we are not sending over TCP, get the UDP reply packet */
  if (slen <= ITCMAXUDPDATALEN) {
    DPRINTF("ExecuteRemoteRequest_: no TCP send, get reply packet\n");
    RttP(artData->replySem);
    RttGetData(me, (unsigned long *)&reply);
    retCode = reply->typeSpecific; /* XXX it crashed here! reply = 0x1! */

    if (retCode != RTTOK) {
      artRemove(info.sender, freeArtData);
      RttFree(reply);
      fprintf(stderr, "ExecuteRemoteRequest_: (1) reply not RTTOK\n");
      if (listening) {
	RttClose(listenSd);
      }
      return (retCode);
    }

    /* got it all in the reply packet? (otherwise, all of reply via TCP) */
    if (reply->rlen <= ITCMAXUDPDATALEN) {
      *rlen = reply->rlen;
      memmove(rData, (char *)(reply + 1), reply->rlen);
      artRemove(info.sender, freeArtData);
      RttFree(reply);
      if (listening) {
	RttClose(listenSd);
      }
      return (RTTOK);
    }
  }

  DPRINTF("ExecuteRemoteRequest_: do accept\n");

  /* wait for and accept the TCP connection */
  if ((tcpSd = tcpAccept(listenSd)) == RTTFAILED) {
    artRemove(info.sender, freeArtData);
    RttFree(reply);
    RttClose(listenSd);
    return (RTTFAILED);
  }
  RttClose(listenSd);
  
  tcpDataLen = slen - udpDataLen;

  if (tcpDataLen) {
    int numWritten;

    DPRINTF("ExecuteRemoteRequest_: writing the rest, %d bytes\n", tcpDataLen);

    sData = (void *)((char *)sData + udpDataLen);

    /* send the rest of the data */
    if ((numWritten = RttWriteN(tcpSd, sData, tcpDataLen)) == RTTFAILED) {
      RttPerror("RttWriteN");
      artRemove(info.sender, freeArtData);
      RttFree(reply);
      RttClose(tcpSd);
      return (RTTFAILED);
    }
    DPRINTF("ExecuteRemoteRequest_: numWritten = %d\n", numWritten);
  }

  DPRINTF("ExecuteRemoteRequest_: wait for the reply\n");

  /* reply info will come in a UDP packet */
  if (slen > ITCMAXUDPDATALEN) {
    RttP(artData->replySem);
    RttGetData(me, (unsigned long *)&reply);
    retCode = reply->typeSpecific;

    if (retCode != RTTOK) {
      artRemove(info.sender, freeArtData);
      RttFree(reply);
      fprintf(stderr, "ExecuteRemoteRequest_: (2) reply not RTTOK\n");
      return (retCode);
    }
  }

  /* read the reply */
  numRead = RttReadN(tcpSd, (void *)rData, reply->rlen);
  if (numRead != reply->rlen) {
    artRemove(info.sender, freeArtData);
    RttClose(tcpSd);
    if (numRead == -1) {
      RttPerror("RttReadN");
    }
    else {
      fprintf(stderr, "ExecuteRemoteRequest_: reply wrong length\n");
      fprintf(stderr, "  expected %d got %d\n", reply->rlen, numRead);
    }
    return (RTTFAILED);
  }
  
  *rlen = reply->rlen;
  
  artRemove(info.sender, freeArtData);
  RttFree(reply);
  RttClose(tcpSd);

  return (RTTOK);
}

/*------------------------------------------------------------------------
 * RttNetInit  --  enable cross address space ITC
 *------------------------------------------------------------------------
 */
int RttNetInit(unsigned long ipAddr, unsigned short port)
{
  int i;
  char name[20];
  u_short chosenPort;
  RttSchAttr attr;
  RttThreadId itcServerId;
 
  if (ipAddr) {
    SetHid(ipAddr);
  }
  else {
    SetHid(getLocalIP()); /* XXX */
  }

  if ((localSd = createAndBindSocket(SOCK_DGRAM, port, &chosenPort)) 
      == RTTFAILED) 
    {
      return (RTTFAILED); /* XXX set RttErrno? */
    }

  SetLid(chosenPort);

  artInit();

  netInitialized = 1;
  
  attr.startingtime = RTTZEROTIME;
  attr.priority = 2;
  attr.deadline = RTTNODEADLINE;

  for (i = 0; i < NUMITCSERVERS; i++) {
    sprintf(name, "itcServer%d", i);
    if (RttCreate(&itcServerId, (void(*)()) itcServer, 8192, 
		  name, (void *)0, attr, RTTSYS) == RTTFAILED) {
      return (RTTFAILED);
    }
  }
  return (RTTOK);
}

/*------------------------------------------------------------------------
 * RttMyPort  --  get port number for this address space
 *------------------------------------------------------------------------
 */
int RttMyPort(unsigned short *port)
{
  if (!netInitialized) {
    return (RTTFAILED);
  }

  *port = (u_short)GetLid();

  return (RTTOK);
}

/*------------------------------------------------------------------------
 * RttMyIP  --  get IP address for this address space
 *------------------------------------------------------------------------
 */
int RttMyIP(unsigned long *ipAddr)
{
  if (!netInitialized) {
    return (RTTFAILED);
  }

  *ipAddr = GetHid();

  return (RTTOK);
}
