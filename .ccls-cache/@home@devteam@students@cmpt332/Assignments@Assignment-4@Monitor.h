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
#include <standards.h>

/* Our List functions*/
#include <list.h>

/* Define the number of condition variables (k) */
#define k 10

typedef struct ConditionVariable{
    LIST* queue;
    int sem;
} ConditionVariable;

typedef struct Monitor{
    LIST* enterQueue;
    int mutex;
    int enterSem;
    ConditionVariable conVals[k];
} Monitor;



void MonEnter();
void MonLeave();
void MonWait(int);
void MonSignal(int);
void MonInit();

#endif /* MONITOR_H */
