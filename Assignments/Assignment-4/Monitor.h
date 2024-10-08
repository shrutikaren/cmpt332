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

/* UBC Threads */
#include <os.h>

/* Our List functions*/
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
    int semaphore;
    LIST* waitList;
} CondVar;

typedef struct Monitor{
    int lock;
    int entrySem;
    LIST* entryList;
    CondVar conVars[k];
} Monitor;

void MonEnter();
void MonLeave();
void MonWait(int);
void MonSignal(int);
void MonInit();

#endif /* MONITOR_H */
