/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

/* CMPT 332 GROUP 34 Change, Fall 2024 */
/* Phase 1 */

#ifndef MONITOR_H 
#define MONITOR_H

/* Default C-Library */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

/* UBC Threads */
#include <os.h>

/* Our List functions */
#include <list.h>


/* Define the number of condition variables (k) */
#define k 10

typedef struct CondVar {
    int semaphore; /* semaphore for condition variable */
    LIST* waitList; /* list of threads waiting */
} CondVar;

typedef struct Monitor {
    int lock; /* semaphore used as the monitor lock */
    CondVar conVars[k]; 
} Monitor;

void MonInit();
void MonEnter();
void MonLeave();
void MonWait(int);
void MonSignal(int);

#endif /* MONITOR_H */
