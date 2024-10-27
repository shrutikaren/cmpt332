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

/* Loggin Errors in our code. */

#define LOG_ERROR(msg) do {                             \
    fprintf(stderr, "Log [Error] - %s: %s at %s:%d\n",  \
        msg, strerror(errno), __FILE__, __LINE__);      \
    exit(EXIT_FAILURE);                                 \
}while(0)

/* Define the number of condition variables (k) */
#define k 10

typedef struct CondVar{
    int semaphore; /* int to control access */
    LIST* waitList; /* list of threads waiting */
} CondVar;

typedef struct Monitor{
    int lock; /* used to access shared resources */
    int entrySem; /* used to access entry */
    LIST* entryList; /* threads to enter into the list */
    CondVar conVars[k]; 
} Monitor;

void MonInit();
void MonEnter();
void MonLeave();
void MonWait(int);
void MonSignal(int);

#endif /* MONITOR_H */
