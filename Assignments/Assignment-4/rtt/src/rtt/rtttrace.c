/****************************************************************************
 * 
 * rtttrace.c
 * 
 * Tracing module.
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

#ifdef WIN32
#define fprintf RttFprintf
#define fflush(X) 
#endif /* WIN32 */

static RttTraceStruct traceDummy;
RttTraceStruct *_RttTrace_ = &traceDummy;
int _MaxRttTraces_ = 1;
int _RttTracer_ = 0;

static FILE *fp;

static int traceInitialized = 0;

#define RTTTRACEOUT stderr

#define TNAMESTRING(X) ((X) ? GetTname(X) : "???")


/*------------------------------------------------------------------------
 * RttTraceOpen  --  enable tracing, specifying a file (or RTTSTDOUT or 
 *                   RTTSTDERR) and size of trace array (in trace lines)
 *------------------------------------------------------------------------
 */
int RttTraceOpen(char *filename, int size)
{
  if (traceInitialized) {
    return (RTTFAILED);
  }
  
  if (filename) {
    if (!(strcmp(filename, RTTSTDOUT))) {
      fp = stdout;
    }
    else if (!(strcmp(filename, RTTSTDERR))) {
      fp = stderr;
    }
    else if ((fp = fopen(filename, "w")) == NULL) {
      fprintf(stderr, "RttTracePrint: unable to open file %s\n", filename);
      return (RTTFAILED);
    }
  }
  else {
    fp = RTTTRACEOUT;
  }

  if ((_RttTrace_ = RttMalloc(size*sizeof(RttTraceStruct))) == NULL) {
    return (RTTFAILED);
  }
  else {
    _RttTracer_ = 0;
    _MaxRttTraces_ = size;
    traceInitialized = 1;
    return (RTTOK);
  }
}

/*------------------------------------------------------------------------
 * RttTraceDump  --  dump contents of trace array to file specified in
 *                   RtttraceOpen(), resetting the trace array
 *------------------------------------------------------------------------
 */
int RttTraceDump()
{
  int lc;
  RttTraceStruct trace, trace2;

  if (!traceInitialized) {
    return (RTTFAILED);
  }

  /*fprintf(fp, "**************************************************\n");
  fprintf(fp, "      RttTraceDump: count = %d\n", _RttTracer_);
  fprintf(fp, "**************************************************\n");*/

  for (lc = 0; lc < _RttTracer_; lc++) {
    trace = _RttTrace_[lc];
    trace2 = _RttTrace_[lc+1%_RttTracer_];

    if (trace2.format && (lc < (_RttTracer_-1))) {
      fprintf(fp, trace.format, trace.val1, trace.val2, trace.val3, 
	      trace.val4, trace.val5);
    }
    else {
      lc++;
      fprintf(fp, trace.format, trace.val1, trace.val2, trace.val3, 
	      trace.val4, trace.val5, trace2.val1, trace2.val2, trace2.val3,
	      trace2.val4, trace2.val5);
    }
  }
  fflush(fp);
  _RttTracer_ = 0;
  return (RTTOK);
}

/*------------------------------------------------------------------------
 * RttTraceClose  --  disable tracing, closing the file opened with 
 *                    RttTraceOpen()
 *------------------------------------------------------------------------
 */
int RttTraceClose()
{
  if (!traceInitialized) {
    return (RTTFAILED);
  }

  if (fp != RTTTRACEOUT) {
    fclose(fp);
  }
  traceInitialized = 0;
  
  return (RTTOK);
}
