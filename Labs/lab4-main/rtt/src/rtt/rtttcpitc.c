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

static int netInitialized = 0;
#define NUMITCSERVERS 1

struct ITCinfo {
  u_int slen;
  u_int rlen;
  RttThreadId sender;
  RttThreadId receiver;
};
typedef struct ITCinfo ITCinfo;

struct ReplyInfo {
  int retCode;
  u_int replyLen;
};
typedef struct ReplyInfo ReplyInfo;

struct AcceptInfo {
  int sd;
  u_long senderAddr;
};
typedef struct AcceptInfo AcceptInfo;

static int encodeInfo(ITCinfo *, char *, int);
static int decodeInfo(ITCinfo *, char *, int);
static RTTTHREAD itc_worker(void *);
static int local_sd;

#ifndef WIN32
#include <netinet/tcp.h>
#define USE_XDR
#endif /* WIN32 */

#define DPRINTF (void)

#ifdef WIN32
#define RttPerror  perror
#define bzero(X,Y) memset(X,0,Y)
#define EWOULDBLOCK             WSAEWOULDBLOCK
#endif /* WIN32 */

#include <rpc/types.h>
#include <rpc/xdr.h>
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

#ifdef USE_XDR
/*------------------------------------------------------------------------
 * xdr_ITCinfo  --  XDR routine for ITCinfo structure
 *------------------------------------------------------------------------
 */
static bool_t xdr_ITCinfo(XDR *xdrs, ITCinfo *objp)
{
  if (!xdr_u_int(xdrs, &objp->slen)) {
    return (FALSE);
  }
  if (!xdr_u_int(xdrs, &objp->rlen)) {
    return (FALSE);
  }
  if (!xdr_RttThreadId(xdrs, &objp->sender)) {
    return (FALSE);
  }
  if (!xdr_RttThreadId(xdrs, &objp->receiver)) {
    return (FALSE);
  }
  return (TRUE);
}

/*------------------------------------------------------------------------
 * encodeInfo  --  encode ITCinfo structure using XDR routine
 *------------------------------------------------------------------------
 */
static int encodeInfo(ITCinfo *info, char *buf, int len)
{
  XDR xdrs;
  int buflen;

  xdrmem_create(&xdrs, buf, len, XDR_ENCODE);

  if (xdr_ITCinfo(&xdrs, info) == FALSE) {
    return (RTTFAILED);
  }

  buflen = xdr_getpos(&xdrs);

  xdr_destroy(&xdrs);

  return (buflen);
}

/*------------------------------------------------------------------------
 * decodeInfo  --  decode ITCinfo structure using XDR routine
 *------------------------------------------------------------------------
 */
static int decodeInfo(ITCinfo *info, char *buf, int len)
{
  XDR xdrs;
  int buflen;

  xdrmem_create(&xdrs, buf, len, XDR_DECODE);

  if (xdr_ITCinfo(&xdrs, info) == FALSE) {
    return (RTTFAILED);
  }

  buflen = xdr_getpos(&xdrs);

  xdr_destroy(&xdrs);

  return (buflen);
}
#else
/*------------------------------------------------------------------------
 * encodeInfo  --  encode ITCinfo structure using hton* routines
 *------------------------------------------------------------------------
 */
static int encodeInfo(ITCinfo *info, char *buf, int len)
{
  ITCinfo *infobuf = (ITCinfo *)buf;

  infobuf->slen = htonl(info->slen);
  infobuf->rlen = htonl(info->rlen);
  infobuf->sender.lid = htonl(info->sender.lid);
  infobuf->sender.hid = htonl(info->sender.hid);
  infobuf->receiver.lid = htonl(info->receiver.lid);
  infobuf->receiver.hid = htonl(info->receiver.hid);

  return (len);
}

/*------------------------------------------------------------------------
 * decodeInfo  --  decode ITCinfo structure using ntoh* routines
 *------------------------------------------------------------------------
 */
static int decodeInfo(ITCinfo *info, char *buf, int len)
{
  ITCinfo *infobuf = (ITCinfo *)buf;

  info->slen = ntohl(infobuf->slen);
  info->rlen = ntohl(infobuf->rlen);
  info->sender.lid = ntohl(infobuf->sender.lid);
  info->sender.hid = ntohl(infobuf->sender.hid);
  info->receiver.lid = ntohl(infobuf->receiver.lid);
  info->receiver.hid = ntohl(infobuf->receiver.hid);

  return (len);
}
#endif /* USE_XDR */

/*------------------------------------------------------------------------
 * createAndBindSocket  --  creates a socket and binds to the given port,
 *                          returning the socket descriptor. If 0 is given
 *                          for port, one will be chosen and returned by
 *                          reference in 'chosenPort'
 *------------------------------------------------------------------------
 */
static int createAndBindSocket(u_short port, u_short *chosenPort) {
  struct sockaddr_in sockaddr;
  int namelen = sizeof(struct sockaddr_in);
  int sd;
  int retries = 0;

  if ((sd = RttSocket(AF_INET, SOCK_STREAM, 0)) < 0) {
    RttPerror("RttSocket");
    return (RTTFAILED);
  }
  bzero(&sockaddr, sizeof(sockaddr));
  sockaddr.sin_family = AF_INET;
  sockaddr.sin_port = htons(port);
  sockaddr.sin_addr.s_addr = INADDR_ANY;
  
  while (RttBind(sd, (struct sockaddr *)&sockaddr, sizeof(sockaddr)) != 0) {
    RttPerror("RttBind");
    if (RttErrno() == EINVAL) {
      if (retries++ < 5) {
	continue;
      }
      else {
	fprintf(stderr, "giving up...\n");
      }
    }
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
static int tcpConnect(int sd, u_long addr, u_short port) {
  struct sockaddr_in sockaddr;

  bzero(&sockaddr, sizeof(sockaddr));
  sockaddr.sin_family = AF_INET;
  sockaddr.sin_port = htons(port);
  sockaddr.sin_addr.s_addr = htonl(addr);
  if (RttConnect(sd, (struct sockaddr *)&sockaddr, sizeof(sockaddr))) {
    RttPerror("RttConnect");
    return (RTTFAILED);
  }

  return (RTTOK);
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
 * itcWorker  --  worker thread reads message via XTP and does local 
 *                RttSend, sending the reply to the client via XTP
 *------------------------------------------------------------------------
 */
static RTTTHREAD itcWorker(void *arg) {
  char rbuf[sizeof(ITCinfo)];
  ITCinfo info;
  int sd;
  char *sData, *rData;
  char *encodedInfo;
  ReplyInfo *replyInfo;
  int retCode;
  int numRead;
  AcceptInfo *acceptInfo;

  DPRINTF("itcWorker: entering\n");
  RttTrace("itcWorker: entering\n");

  acceptInfo = (AcceptInfo *)arg;
  sd = acceptInfo->sd;

  /* read the control information */
  if ((numRead = RttReadN(sd, rbuf, sizeof(ITCinfo))) == RTTFAILED) {
    RttPerror("RttReadN");
    RttClose(sd);
    return;
  }
  assert(numRead == sizeof(ITCinfo));

  decodeInfo(&info, rbuf, sizeof(ITCinfo));

  if (info.slen) {

    sData = (char *) RttMalloc(info.slen);

    /* read the send data */
    if (RttReadN(sd, sData, info.slen) == RTTFAILED) {
      RttPerror("RttReadN");
      RttClose(sd);
      RttFree(sData);
      return;
    }
  }
  else {  /* XXX how should we deal with zero length messages? */
    /*fprintf(stderr, "itcWorker: info =\n   slen = %d\n   rlen = %d\n", 
	   info.slen, info.rlen);
    fprintf(stderr, "   sender = 0x%x\n   receiver = 0x%x\n", 
	   info.sender.lid, info.receiver.lid);*/
    sData = NULL;
  }

  rData = (char *) RttMalloc(info.rlen + sizeof(ReplyInfo));

  if (GetIpAddrFromThreadId(info.sender) == 0) {
    SetThreadIdIpAddr(info.sender, ntohl(acceptInfo->senderAddr));
  }
  RttFree(acceptInfo);

  SetRemoteItc(currthread, 1);
  SetRemoteThreadId(currthread, info.sender);

  if ((retCode = RttSend(info.receiver, sData, info.slen, 
			 rData + sizeof(ReplyInfo), &info.rlen)) != RTTOK) {
    info.rlen = 0;
  }
  replyInfo = (ReplyInfo *)rData;
  replyInfo->retCode = htonl(retCode);
  replyInfo->replyLen = htonl(info.rlen);

  SetRemoteItc(currthread, 0);

  RttFree(sData);

  if (RttWriteN(sd, rData, info.rlen + sizeof(ReplyInfo)) == RTTFAILED) {
    RttPerror("RttWriteN");
  }

  RttFree(rData);
  RttClose(sd);

  DPRINTF("itcWorker: leaving\n");
  RttTrace("itcWorker: leaving\n");
}

/*------------------------------------------------------------------------
 * itcServer  --  server thread listens for TCP connection requests
 *------------------------------------------------------------------------
 */
static RTTTHREAD itcServer() {
  int lsd, sd;
  RttSchAttr attr;
  RttThreadId workerThread;
  u_short itc_port, chosenPort;
  struct sockaddr_in sockaddr;
  int namelen = sizeof(struct sockaddr_in);
  AcceptInfo *acceptInfo;

  lsd = local_sd;

  if (RttListen(lsd, 5)) {
    RttPerror("RttListen");
    SysExit_(-1);
  }

  for (;;) {
    if ((sd = RttAccept(lsd, (struct sockaddr *)&sockaddr, &namelen))
	== RTTFAILED) {
      RttPerror("RttAccept");
      SysExit_(-1);
    }
    acceptInfo = (AcceptInfo *)RttMalloc(sizeof(AcceptInfo));
    acceptInfo->sd = sd;
    acceptInfo->senderAddr = sockaddr.sin_addr.s_addr;

    attr.startingtime = RTTZEROTIME;
    attr.priority = 9;
    attr.deadline = RTTNODEADLINE;

	DPRINTF("ItcServer_: creating worker\n");

    if (RttCreate(&workerThread, (void(*)()) itcWorker, 8192, "itcWorker", 
	      (void *)acceptInfo, attr, RTTUSR) == RTTFAILED) {
      fprintf(stderr, "ItcServer_: RttCreate failed, exiting.\n");
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
  int sd;
  ITCinfo info;
  char encodedInfo[sizeof(ITCinfo)];
  int encodedLen;
  char *rbuf;
  ReplyInfo replyInfo;
  u_short chosenPort = 0;
  int numRead;

  info.slen = slen;
  info.rlen = *rlen;
  info.sender = getThreadIdFromTcb(currthread);
  info.receiver = to;

  if ((sd = createAndBindSocket(0, &chosenPort)) == RTTFAILED) {
    fprintf(stderr, "ExecuteRemoteRequest_: createAndBindSocket failed\n");
    return (RTTFAILED);
  }

  if (tcpConnect(sd, GetIpAddrFromThreadId(to), GetPortNoFromThreadId(to)) 
      == RTTFAILED) {
    fprintf(stderr, "ExecuteRemoteRequest_: tcpConnect failed\n");
    return (RTTFAILED);
  }
  
  {
    int optval = 1;

    /* XXX need a better way to get TCP protocol number (6) here */
    /* Maybe getprotoent(). */
    if (RttSetsockopt(sd, 6 , TCP_NODELAY, (char *)&optval, sizeof(int)) 
	== -1) {
      perror("RttSetsockopt");
      return (RTTFAILED);
    }
  }

  encodedLen = encodeInfo(&info, encodedInfo, sizeof(ITCinfo));
  
  /* write the control info */
  {
    int num;
    
    if ((num = RttWriteN(sd, encodedInfo, encodedLen)) == RTTFAILED) {
      RttPerror("RttWriteN");
      RttClose(sd);
      return (RTTFAILED);
    }
  }
  
  /* write the send data */
  if (RttWriteN(sd, sData, slen) == RTTFAILED) {
    RttPerror("RttWriteN");
    RttClose(sd);
    return (RTTFAILED);
  }

  /* read the reply length */
  numRead = RttReadN(sd, (void *)&replyInfo, sizeof(ReplyInfo));
  if (numRead != sizeof(ReplyInfo)) {
    RttClose(sd);
    if (numRead == -1) {
      RttPerror("RttReadN");
    }
    return (RTTFAILED);
  }

  replyInfo.retCode = ntohl(replyInfo.retCode);
  if (replyInfo.retCode != RTTOK) {
    RttClose(sd);
    return (replyInfo.retCode);
  }
  replyInfo.replyLen = ntohl(replyInfo.replyLen);

  /* read the reply */
  numRead = RttReadN(sd, (void *)rData, replyInfo.replyLen);
  if (numRead != replyInfo.replyLen) {
    RttClose(sd);
    if (numRead == -1) {
      RttPerror("RttReadN");
    }
    return (RTTFAILED);
  }

  *rlen = replyInfo.replyLen;

  RttClose(sd);

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

  if ((local_sd = createAndBindSocket(port, &chosenPort)) == RTTFAILED) {
    return (RTTFAILED); /* XXX set RttErrno? */
  }

  SetLid(chosenPort);

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

  *port = GetLid();

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
