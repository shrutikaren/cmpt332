#ifndef MONITOR_H 
#define MONITOR_H

/* Default C-Library */
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#define NO_CVS 7

<<<<<<< HEAD
/* UBC Threads */
#include <os.h>

/* Our List functions */
#include <list.h>

/* Define the number of condition variables (k) */
#define k 10

typedef struct CV {
    int sem;           /* semaphore for condition variable */
    LIST* wait_queue;  /* list of threads waiting */
} CV;

typedef struct Monitor {
    CV cond_vars[k];          /* array of condition variables */
    int enter_mtx;            /* semaphore for entering monitor */
    int urgent_sem;           /* semaphore for urgent threads */
    int enter_queue_sem;      /* semaphore for accessing enter_queue */
    LIST* urgent_queue;       /* prioritized queue */
    LIST* enter_queue;        /* queue for monitor entry */
} Monitor;

/* Monitor Function Declarations */
void MonInit();
=======
>>>>>>> refs/remotes/origin/main
void MonEnter(void);
void MonLeave(void);
void MonWait(int);
void MonSignal(int);
void MonInit(void);
#endif /* MONITOR_H */
