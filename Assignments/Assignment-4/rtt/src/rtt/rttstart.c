/****************************************************************************
 * 
 * rttstart.c
 * 
 * Startup module.
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

struct globals _Globals_;

RttTimeValue RTTNODEADLINE; 
RttTimeValue RTTINFINITE;
RttTimeValue RTTZEROTIME;

/*------------------------------------------------------------------------
 * osInit  --  global initialization for queues, timers, TCBs, etc
 *------------------------------------------------------------------------
 */
static void osInit()
{
  currthread = TNULL;
  inOsFlag = 0;

  SetNameServerCreated(0);

  RTTNODEADLINE.seconds = DEFAULT_D_SECONDS;
  RTTNODEADLINE.microseconds = DEFAULT_D_MICROSECONDS;
  RTTINFINITE.seconds = DEFAULT_INFINITE;
  RTTINFINITE.microseconds = DEFAULT_INFINITE;
  RTTZEROTIME.seconds = 0;
  RTTZEROTIME.microseconds = 0;
  
  InitReadyQueue_();
  InitThreadMgmt_();
  InitIO_();
#ifdef WIN32
  InitTimeOfDay_();
#endif /* WIN32 */

#ifdef NATIVE_THREADS
  InitOsMutex_();
#endif /* NATIVE_THREADS */
}

static struct {
  int argc;
  char **argv;
} argStruct;

/*------------------------------------------------------------------------
 * mainThread  --  main thread (calls mainp)  
 *------------------------------------------------------------------------
 */
RTTTHREAD mainThread()
{
  mainp(argStruct.argc, argStruct.argv);
}

/*------------------------------------------------------------------------
 * startup  --  initialize and start the threads environment   
 *------------------------------------------------------------------------
 */
void startup()
{
  RttSchAttr attr;
  RttThreadId nullThreadId, mainThreadId;

  
  setvbuf(stdout,(char *) NULL, _IONBF, 0);
  setvbuf(stderr,(char *) NULL, _IONBF, 0);

  PTRACE_INIT();

  osInit();

  attr.startingtime = RTTZEROTIME;
  attr.priority = NULP;
  attr.deadline = RTTNODEADLINE;

  RttCreate(&nullThreadId, (void(*)())NullThread_, 65536, "NullThread", 
	    (void *)0, attr, RTTSYS); 
  NullThread_Proc = getTcbFromThreadId(nullThreadId);

  /* 
   * the main thread, which calls mainp(), is given the highest possible 
   * priority, but will not be scheduled until StartOs_ is called
   */
  attr.priority = 0;
  attr.deadline = RTTZEROTIME;
  RttCreate(&mainThreadId, (void(*)())mainThread, 4194304, "MainThread", 
	    (void *)0, attr, RTTUSR); 

  StartOs_();
}

/*------------------------------------------------------------------------
 * main  --  main routine to start the threads environment   
 *------------------------------------------------------------------------
 */
int main(int argc, char **argv)
{
  argStruct.argc = argc;
  argStruct.argv = argv;

  startup();

#ifdef NATIVE_THREADS
  while (1) {
    SuspendThread(GetCurrentThread()); 
    /* XXX you can resume from debugger and look at traces or whatever */
    printf("back from suspend\n");
    /*RttQueuePrint();*/
    RttTraceDump();
    printf("----- RttTraceDump is done -----\n");
  }
  return 0;
#endif /* NATIVE_THREADS */
}

#ifdef WIN32
/*------------------------------------------------------------------------
 * RttMain  --  main routine to start the threads environment in a Windows
 *              application  
 *------------------------------------------------------------------------
 */
RttMain(int argc, char **argv)
{
  argStruct.argc = argc;
  argStruct.argv = argv;

  startup();
}
#endif /* WIN32 */
