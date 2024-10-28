/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#ifndef MONITOR_H 
#define MONITOR_H

/* Standard Libraries */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

/* UBC Threads */
#include <os.h>

/* Custom List Functions */
#include <list.h>

/* Define the number of condition variables (k) */
#define k 10

typedef struct CondVar {
    int semaphore;   /* Semaphore for the condition variable */
    LIST* waitList;  /* List of threads waiting on the condition variable */
} CondVar;

/* Struct for Entry Control */
typedef struct EntryControl {
    LIST* urgentWaitList;    /* List of threads with urgent priority */
    LIST* entryWaitList;     /* List of threads waiting to enter */
    int entryWaitSem;        /* Semaphore for accessing entryWaitList */
    int urgentWaitSem;       /* Semaphore for urgent waiting threads */
} EntryControl;

typedef struct Monitor {
    int lock;                 /* Semaphore used as the monitor lock */
    CondVar condVars[k];      /* Array of condition variables */
    EntryControl entryCtrl;   /* Entry control for the monitor */
} Monitor;

/* Function Declarations */
void MonInit();
void MonEnter();
void MonLeave();
void MonWait(int cvar);
void MonSignal(int cvar);

#endif /* MONITOR_H */
