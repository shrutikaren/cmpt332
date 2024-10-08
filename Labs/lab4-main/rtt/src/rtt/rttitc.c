/****************************************************************************
 * 
 * rttitc.c
 * 
 * Inter-thread communication module.
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

#define min(X,Y) (X < Y ? X : Y)

#ifdef WIN32
#include <memory.h>
#endif /* WIN32 */

static void addWaitingSender(TCB *);
static void dequeueSender(TCB *);
static TCB *getTcbFromRemoteThreadId(RttThreadId);

/*------------------------------------------------------------------------
 * addWaitingSender  --  put caller in list of senders waiting to deliver 
 *                       message to "to"
 *------------------------------------------------------------------------
 */
static void addWaitingSender(TCB *to)
{
  if(GetWaitingFirst(to) != TNULL) {
    SetWaitingPrev(currthread, GetWaitingLast(to));
    SetWaitingNext(GetWaitingLast(to), currthread);
  }
  else {   /* no one is currently waiting to send a message to "to" */
    SetWaitingFirst(to, currthread);
    SetWaitingPrev(currthread, TNULL);
  }   
  
  SetWaitingNext(currthread, TNULL);
  SetWaitingLast(to, currthread);
}

/*------------------------------------------------------------------------
 * dequeueSender  --  take sender off of his waiting list
 *------------------------------------------------------------------------
 */
static void dequeueSender(TCB *tcbPtr)
{
  TCB *prev, *next;
  
  prev = GetWaitingPrev(tcbPtr);
  next = GetWaitingNext(tcbPtr);
  
  if(prev == TNULL)
    SetWaitingFirst(GetPeer(tcbPtr), next);

  else SetWaitingNext(prev, next);
  
  if(next == TNULL)
    SetWaitingLast(GetPeer(tcbPtr), prev);

  else SetWaitingPrev(next, prev);
  
  SetWaitingNext(tcbPtr, TNULL);
  SetWaitingPrev(tcbPtr, TNULL);
}

/*------------------------------------------------------------------------
 * getTcbFromRemoteThreadId  -- search TCBTBL for matching remote thread id
 *
 * Notes:                       must be called in OS (it is, in RttReply)
 *------------------------------------------------------------------------
 */
static TCB *getTcbFromRemoteThreadId(RttThreadId thread)
{
  TCB *retVal;
  TCB *tcbPtr;
  int tcbNo;
  
  retVal = TNULL;

  tcbNo = 0;
  while((tcbNo < NUMBTCBS) && (retVal == TNULL)) {
    tcbPtr = &(TCBTBL[tcbNo++]);
    if(GetInUse(tcbPtr) 
       && GetRemoteItc(tcbPtr) 
       && RTTTHREADEQUAL(thread, GetRemoteThreadId(tcbPtr))) {

      retVal = tcbPtr;
    }
  }
  
  return (retVal);
}


/*------------------------------------------------------------------------
 * ItcThreadCleanup_  --  to be called for every thread leaving the system 
 *------------------------------------------------------------------------
 */
void ItcThreadCleanup_(TCB *tcbPtr)
{
  TCB *wtTh;
  
  while((wtTh = GetWaitingFirst(tcbPtr)) != TNULL) {
    dequeueSender(wtTh);
    DEQUEUE_ITEM(QTBL[SBLK], wtTh, TCB, queueMgmtInfo);
    SetState(wtTh, THREAD_READY);
    EnqueueEdfTail_(wtTh);
    /* XXX shouldn't we be marking these as having failed? */
  }
}

/*------------------------------------------------------------------------
 * RttSend  --  send a message to another thread     
 *------------------------------------------------------------------------
 */
int RttSend(RttThreadId to,void *sData, unsigned int slen, void *rData, 
		   unsigned int *rlen)
{
  TCB *pptr, *toPtr;
  int retcode;
  
  ENTERINGOS;
  
  /* local? */
  if ((GetIpAddrFromThreadId(to) == GetIpAddr(currthread)) && 
      (GetPortNoFromThreadId(to) == GetPortNo(currthread))) {
    
    /* XXX
     *
     * This is a somewhat hokey way to find the nameserver thread. This is
     * not the most efficient place to do it, but it allows us to find
     * the nameserver on the local machine. 
     */
    if (GetInstanceFromThreadId(to) == 0) {
      if (!GetNameServerCreated()) {
	LEAVINGOS;
	return (RTTNOSUCHTHREAD);
      }
      toPtr = getTcbFromThreadId(GetNameServerId());
    }
    else {
      toPtr = getTcbFromThreadId(to);
    }
    
    SetReceivedMsg(currthread, rData);

    /* is "to" waiting for a msg? */
    if (pptr = (FindThreadOnQ_(RBLK, toPtr))) {
      slen = min(slen, GetReceivedLen(pptr));
      memmove(GetReceivedMsg(pptr), sData, slen);
      SetReceivedLen(pptr,slen);
      SetPeer(pptr, currthread);          /* record message source */
      SetState(currthread, WTFR);
      SetState(pptr, THREAD_READY);
      DEQUEUE_ITEM(QTBL[RBLK], pptr,TCB, queueMgmtInfo);
      EnqueueEdfHead_(pptr);
    }
    else {     /* "to" is not waiting for a msg */
      if(ThreadExists(toPtr)) {  /* make sure "to" is valid */
	addWaitingSender(toPtr);
	SetSendMsg(currthread, sData);
	SetSendLen(currthread, slen);
	SetPeer(currthread, toPtr);
	SetState(currthread, SBLK);
      }
      else {
	LEAVINGOS;
	return (RTTNOSUCHTHREAD);
      }
    }
    
    SchedM;    /* implicitly does a LEAVINGOS */
        
    /* XXX shouldn't we be checking if we failed because the receiver 
           terminated? */

    if (rlen != NULL) {
      *rlen  = GetReceivedLen(currthread);
    }

    return(RTTOK);
  }
  else {       /* "to" is a remote RttThreadId */
    SetSendMsg(currthread, sData);
    SetSendLen(currthread, slen);
    SetReceivedMsg(currthread, rData);

    LEAVINGOS;

    return (ExecuteRemoteRequest_(to, slen, sData, rlen, rData));
  }
}

/*------------------------------------------------------------------------
 * RttMsgWaits  --  check if there is a message waiting to be received
 *------------------------------------------------------------------------
 */
int RttMsgWaits()
{
  return (GetWaitingFirst(currthread) == TNULL ? 0 : 1);
}

/*------------------------------------------------------------------------
 * RttReceive  --  receive a message from another thread
 *------------------------------------------------------------------------
 */
int RttReceive(RttThreadId *thread, void *Data, unsigned int *len)  
{
  TCB *sender;
  u_int slen;
  
  int doCtxtsw = 0;
  
  ENTERINGOS;
  
  sender = GetWaitingFirst(currthread);

  /* XXX
   *
   * Either both of the parameters must be null, or both must be non-null
   * for the proper semantics of receiving a message. If they are not,
   * then, the programmer made some sort of error. Return Failed.
   */
  if (((Data == NULL) && (len != NULL)) || 
      ((Data != NULL) && (len == NULL)) || (thread == NULL) ) {
    LEAVINGOS;
    return(RTTFAILED);
  }
  
  SetReceivedMsg(currthread,Data);
  
  /* is there a message waiting? */
  if(sender != TNULL) {
    if (len != NULL) slen = min(*len, GetSendLen(sender)); else slen = 0;
    memmove(GetReceivedMsg(currthread), GetSendMsg(sender), slen);
    SetReceivedLen(currthread,slen);
    SetPeer(currthread, sender);
    dequeueSender(sender);

    /* XXX
     *
     * Sender is swapped from "send blocked queue" to "wait for reply"
     * queue. Is there really a need for both queues?
     */
    SetState(sender, WTFR);
    DEQUEUE_ITEM(QTBL[SBLK], sender,TCB, queueMgmtInfo);
    ENQUEUE_HEAD(QTBL[WTFR], sender, TCB, queueMgmtInfo,WTFR);
  }
  else {    /* no message waiting, block */
    if (len != NULL) {
      SetReceivedLen(currthread, *len);
    }
    SetState(currthread, RBLK);
    doCtxtsw = 1;
  }
  
  if(doCtxtsw) {
    SchedM;       /* implicitly does a LEAVINGOS */
    ENTERINGOS;
  }

  sender = GetPeer(currthread);

  SetPeer(currthread, TNULL);
  
  if (len != NULL)
    *len =  GetReceivedLen( currthread );

  if (GetRemoteItc(sender)) {
    *thread = GetRemoteThreadId(sender);
  }
  else {
    *thread = getThreadIdFromTcb(sender);
  }

  LEAVINGOS;

  return (RTTOK);
}

/*------------------------------------------------------------------------
 * RttReply  --  non-blocking reply to
 *------------------------------------------------------------------------
 */
int RttReply(RttThreadId sndr, void *Data, unsigned int len) 
{
  int result;
  TCB *sender, *sndrPtr;
  
  ENTERINGOS;
  
  /* is reply to a local RttThreadId ? */
  if ((GetIpAddrFromThreadId(sndr) == GetIpAddr(currthread)) && 
      (GetPortNoFromThreadId(sndr) == GetPortNo(currthread))) {
    sndrPtr = getTcbFromThreadId(sndr);
  }
  else {
    sndrPtr = getTcbFromRemoteThreadId(sndr);
  }
    
  if(sender = (FindThreadOnQ_(WTFR, sndrPtr))) {
    if (GetReceivedMsg(sender) != NULL) {
      /* XXX is this a bug? Shouldn't the minimum be used? */
      memmove(GetReceivedMsg(sender), Data, len);
    }
    SetReceivedLen( sender,len );
    result = RTTOK;
    SetState(sender, THREAD_READY);
    SetPeer(sender, TNULL);
    DEQUEUE_ITEM(QTBL[WTFR], sender,TCB, queueMgmtInfo);
    EnqueueEdfHead_(sender);
  }
  else {
    result = RTTNOTBLOCKED; 
  }

  SchedM; /* implicitly does a LEAVINGOS */
  
  return(result);
}

/*------------------------------------------------------------------------
 * getLocalIP  --  returns local IP address (the first one found)
 *------------------------------------------------------------------------
 */
static u_int getLocalIP()
{  
  char hn[40];
  struct hostent *hp;
  static u_int localIp = 0;

  if (localIp) {
    return localIp;
  }

  gethostname(hn, 40);
  hp = gethostbyname( hn );
  if( hp == 0 ) {
    return (RTTFAILED); 
  }

  localIp = ntohl(*((long *) hp->h_addr));

  return localIp;
}
