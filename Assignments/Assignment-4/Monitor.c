/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>
#include <stdlib.h>

static Monitor mon;
#define s 10 /*picked a random number*/


#include "Monitor.h"

/* Static Monitor instance */
static Monitor mon;

/**
 * Initialize the monitor and its condition variables.
 */
void MonInit(void) {
    /* Initialize the mutex semaphore to 1 (unlocked) */
    mon.lock = NewSem(1);
    if (mon.lock < 0) {
        LOG_ERROR("Failed to create lock mutex in MonInit.");
    }

    /* Initialize the semaphore protecting the entryList */
    mon.entrySem = NewSem(1);
    if (mon.entrySem < 0) {
        LOG_ERROR("Failed to create entry semaphore in MonInit.");
    }

    /* Initialize the entryList */
    mon.entryList = ListCreate();
    if (mon.entryList == NULL) {
        LOG_ERROR("Failed to create entry queue in MonInit.");
    }

    /* Initialize all condition variables */
    for (int i = 0; i < K; i++) {
        /* Initialize the waitList */
        mon.conVars[i].waitList = ListCreate();
        if (mon.conVars[i].waitList == NULL) {
            LOG_ERROR("Failed to create waitList for condition variable in MonInit.");
        }

        /* Initialize the semaphore for the condition variable */
        mon.conVars[i].semaphore = NewSem(0);
        if (mon.conVars[i].semaphore < 0) {
            LOG_ERROR("Failed to create semaphore for condition variable in MonInit.");
        }
    }
}

/**
 * Enter the monitor. Provides mutual exclusion.
 */
void MonEnter(void) {
    PID* currentPid = (PID*)malloc(sizeof(PID));
    if (currentPid == NULL) {
        LOG_ERROR("Failed to allocate memory for PID in MonEnter.");
    }
    *currentPid = MyPid();

    /* Add the thread to the entryList */
    P(mon.entrySem);
    ListAppend(mon.entryList, currentPid);
    V(mon.entrySem);

    /* Acquire the mutex */
    P(mon.lock);

    /* Remove self from the entryList */
    P(mon.entrySem);
    LISTNODE* node = ListFirst(mon.entryList);
    while (node != NULL) {
        if (*(PID*)node->item == *currentPid) {
            ListRemove(mon.entryList, node);
            free(currentPid);
            break;
        }
        node = node->next;
    }
    V(mon.entrySem);
}

/**
 * Leave the monitor. Releases mutual exclusion.
 */
void MonLeave(void) {
    /* Release the mutex */
    V(mon.lock);
}

/**
 * Wait on a condition variable.
 * @param cvar The index of the condition variable to wait on.
 */
void MonWait(int cvar) {
    if (cvar < 0 || cvar >= K) {
        LOG_ERROR("Invalid condition variable ID in MonWait.");
    }

    PID* myPid = (PID*)malloc(sizeof(PID));
    if (myPid == NULL) {
        LOG_ERROR("Failed to allocate memory for PID in MonWait.");
    }
    *myPid = MyPid();

    /* Add the thread to the condition variable's waitList */
    P(mon.entrySem);
    ListAppend(mon.conVars[cvar].waitList, myPid);
    V(mon.entrySem);

    /* Release the mutex before waiting */
    V(mon.lock);

    /* Wait on the condition variable's semaphore */
    P(mon.conVars[cvar].semaphore);

    /* Re-acquire the mutex after being signaled */
    P(mon.lock);
}

/**
 * Signal a condition variable.
 * @param cvar The index of the condition variable to signal.
 */
void MonSignal(int cvar) {
    if (cvar < 0 || cvar >= K) {
        LOG_ERROR("Invalid condition variable ID in MonSignal.");
    }

    /* Check if there are threads waiting on the condition variable */
    P(mon.entrySem);
    if (ListCount(mon.conVars[cvar].waitList) > 0) {
        /* Remove the first thread from the condition variable's waitList */
        PID* waitingPid = (PID*)ListTrim(mon.conVars[cvar].waitList);
        if (waitingPid == NULL) {
            LOG_ERROR("Failed to trim from condition variable in MonSignal.");
        }
        free(waitingPid);

        /* Signal the condition variable's semaphore to wake up the waiting thread */
        V(mon.conVars[cvar].semaphore);
    }
    V(mon.entrySem);
}

