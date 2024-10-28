/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>
#include <stdlib.h>

static Monitor mon;

/**
 * Initialize the monitor.
 */ 
void MonInit() {
    int i;

    /* Initialize the monitor lock semaphore to 1 (unlocked) */ 
    mon.lock = NewSem(1);
    if (mon.lock < 0) {
        LOG_ERROR("Failed to create lock mutex in MonInit.");
    }

    /* Initialize all condition variables */
    for (i = 0; i < k; i++) {
        /* Initialize the waitList */
        mon.conVars[i].waitList = ListCreate();
        if (mon.conVars[i].waitList == 0) {
            LOG_ERROR("Failed to create waitList for cv MonInit.");
        }

        mon.conVars[i].semaphore = NewSem(0);
        if (mon.conVars[i].semaphore == -1) {
            LOG_ERROR("Failed to create semaphore for cv's MonInit.");
        }
    }
}

void MonEnter() {
    /* Acquire the monitor lock */
    P(mon.lock);
}

void MonLeave() {
    /* Release the monitor lock */
    V(mon.lock);
}

void MonWait(int cvar) {
    PID* myPid;

    if (cvar < 0 || cvar >= k) {
        LOG_ERROR("Invalid condition variable ID in MonWait");
    }

    /* Add the thread to the condition variable's wait queue */
    myPid = (PID*)malloc(sizeof(PID));
    if (myPid == NULL) {
        LOG_ERROR("Failed to allocate memory for PID in MonWait");
    }
    *myPid = MyPid();

    /* Use ListAppend to add to the end of the list */
    ListAppend(mon.conVars[cvar].waitList, (void*)myPid);

    /* Release the monitor lock before waiting */
    MonLeave();

    /* Wait on the condition variable's semaphore */
    P(mon.conVars[cvar].semaphore);

    /* Re-acquire the monitor lock after being signaled */
    MonEnter();
}

void MonSignal(int cvar) {
    PID* waitingPid;

    if (cvar < 0 || cvar >= k) {
        LOG_ERROR("Invalid condition variable ID in MonSignal");
    }

    /* Check if there are threads waiting on the condition variable */
    if (ListCount(mon.conVars[cvar].waitList) > 0) {
        /* Set current to the first item */
        ListFirst(mon.conVars[cvar].waitList);

        /* Remove the first thread from the condition variable's waitList */
        waitingPid = (PID*)ListRemove(mon.conVars[cvar].waitList);
        if (waitingPid == NULL) {
            LOG_ERROR("Failed to remove from condition variable in MonSignal.");
        }

        /* Signal the cv's semaphore to wake up the waiting thread */
        V(mon.conVars[cvar].semaphore);

        /* Free the PID */
        free(waitingPid);
    }
}

