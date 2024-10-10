/*
	Shruti Kaur
	ICH524
	11339265
*/

#ifndef MONITOR_H
#define MONITOR_H

/* Including necessary libraries */
#include <stdio.h>
#include <stdlib.h>
#include <rtthreads.h>
#include <list.h>

/* Picked an arbitarily number */
#define k 5 

/* Variable to run server. */
#define RUN_SERVER 1

/* Define constants for message types */
#define ENTER_MSG 0
#define LEAVE_MSG 1
#define WAIT_MSG 2
#define SIGNAL_MSG 3

/* Loggin Errors in our code. */

#define LOG_ERROR(msg) do {                             \
    fprintf(stderr, "Log [Error] - %s: %s at %s:%d\n",  \
        msg, strerror(errno), __FILE__, __LINE__);      \
    exit(EXIT_FAILURE);                                 \
}while(0)

/* Define a struct for Condition Variables */
typedef struct ConditionVariables {
    int semaphores;
    LIST* waitlist;  /* List of threads waiting on this CV */
} ConditionVariables;

/* Define a struct for the Monitor */
typedef struct Monitor {
    int lock;           /* Used as a mutex */
    int entrysem;       /* Semaphore for entry */
    LIST* urgentq;      /* Urgent queue */
    LIST* enterq;       /* Enter queue */
    ConditionVariables conVars[k];  /* Array of condition variables */
} Monitor;

/* Function prototypes */
void RttMonInit();
void RttMonEnter();
void RttMonLeave();
void RttMonWait(int cv);
void RttMonSignal(int cv);
void MonServer();

#endif /* MONITOR_H */
