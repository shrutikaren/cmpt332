#ifndef MONITOR_H 
#define MONITOR_H

/* Default C-Library */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#define NO_CVS 7

void MonEnter(void);
void MonLeave(void);
void MonWait(int);
void MonSignal(int);
void MonInit(void);
#endif /* MONITOR_H */
