#ifndef MONITOR_H 
#define MONITOR_H

/* Standard Libraries */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

<<<<<<< HEAD
void MonEnter(void);
void MonLeave(void);
void MonWait(int);
void MonSignal(int);
void MonInit();
=======
/* UBC Threads */
#include <os.h>

/* Custom List Functions */
#include <list.h>

/* Number of Condition Variables */
#define NUM_COND_VARS 10

typedef struct CondVar {
    int semaphore;   /* Semaphore for the condition variable */
    LIST* waitList;  /* List of threads waiting on the condition variable */
} CondVar;

typedef struct Monitor {
    int lock;                 /* Semaphore used as the monitor lock */
    CondVar condVars[NUM_COND_VARS]; 
} Monitor;

/* Function Declarations */
void MonInit();
void MonEnter();
void MonLeave();
void MonWait(int cvar);
void MonSignal(int cvar);

>>>>>>> refs/remotes/origin/main
#endif /* MONITOR_H */
