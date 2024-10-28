/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>
#include <list.h>

static Monitor mon;

/* Queues and Semaphores for Monitor Entry and Urgent Signals */
static LIST* urgentQueue;
static LIST* enterQueue;
static int enterQueueSem;
static int urgentSem;

/* Initialize the monitor */
void MonInit(void) {
    int i;

    /* Initialize the monitor lock semaphore to 1 (unlocked) */ 
    mon.lock = NewSem(1);
    if (mon.lock < 0) {
        LOG_ERROR("Failed to create monitor lock in MonInit.");
    }

    /* Initialize queues for entering the monitor and urgent signals */
    urgentQueue = ListCreate();
    if (!urgentQueue) {
        LOG_ERROR("Failed to create urgentQueue in MonInit.");
    }

    enterQueue = ListCreate();
    if (!enterQueue) {
        LOG_ERROR("Failed to create enterQueue in MonInit.");
    }

    /* Initialize semaphores */
    urgentSem = NewSem(0);
    if (urgentSem < 0) {
        LOG_ERROR("Failed to create urgentSem in MonInit.");
    }

    enterQueueSem = NewSem(1);
    if (enterQueueSem < 0) {
        LOG_ERROR("Failed to create enterQueueSem in MonInit.");
    }

    /* Initialize all condition variables */
    for (i = 0; i < NUM_COND_VARS; i++) {
        mon.condVars[i].waitList = ListCreate();
        if (!mon.condVars[i].waitList) {
            LOG_ERROR("Failed to create waitList for condition variable %d in MonInit.");
        }

        mon.condVars[i].semaphore = NewSem(0);
        if (mon.condVars[i].semaphore < 0) {
            LOG_ERROR("Failed to create semaphore for condition variable %d in MonInit.");
        }
    }
}

/* Enter the monitor */
void MonEnter(void) {
    PID* myPid = malloc(sizeof(PID));
    if (!myPid) {
        LOG_ERROR("Failed to allocate memory for PID in MonEnter.");
    }
    *myPid = MyPid();

    /* Add the thread to the enterQueue */
    P(enterQueueSem);
    ListPrepend(enterQueue, myPid);
    V(enterQueueSem);

    /* Acquire the monitor lock */
    P(mon.lock);
}

/* Leave the monitor */
void MonLeave(void) {
    PID* pid;

    /* Give priority to threads in the urgentQueue */
    if (ListCount(urgentQueue) > 0) {
        pid = (PID*)ListTrim(urgentQueue);
        if (pid) {
            free(pid);
            V(urgentSem);
        }
    }
    /* Otherwise, allow a thread from the enterQueue to enter */
    else if (ListCount(enterQueue) > 0) {
        pid = (PID*)ListTrim(enterQueue);
        if (pid) {
            free(pid);
            V(mon.lock);
        }
    }
    /* No threads are waiting; monitor remains unlocked */
}

/* Wait on a condition variable */
void MonWait(int cvar) {
    PID* myPid;

    if (cvar < 0 || cvar >= NUM_COND_VARS) {
        LOG_ERROR("Invalid condition variable ID in MonWait.");
    }

    myPid = malloc(sizeof(PID));
    if (!myPid) {
        LOG_ERROR("Failed to allocate memory for PID in MonWait.");
    }
    *myPid = MyPid();

    /* Add the thread to the condition variable's wait queue */
    ListPrepend(mon.condVars[cvar].waitList, myPid);

    /* Allow another thread to enter the monitor */
    if (ListCount(urgentQueue) > 0) {
        PID* pid = (PID*)ListTrim(urgentQueue);
        if (pid) {
            free(pid);
            V(urgentSem);
        }
    } else if (ListCount(enterQueue) > 0) {
        PID* pid = (PID*)ListTrim(enterQueue);
        if (pid) {
            free(pid);
            V(mon.lock);
        }
    } else {
        /* No threads are waiting; release the monitor lock */
        V(mon.lock);
    }

    /* Wait on the condition variable's semaphore */
    P(mon.condVars[cvar].semaphore);

    /* Re-acquire the monitor lock after being signaled */
    P(mon.lock);
}

/* Signal a condition variable */
void MonSignal(int cvar) {
    PID* myPid;
    PID* waitingPid;

    if (cvar < 0 || cvar >= NUM_COND_VARS) {
        LOG_ERROR("Invalid condition variable ID in MonSignal.");
    }

    /* Check if there are threads waiting on the condition variable */
    if (ListCount(mon.condVars[cvar].waitList) > 0) {
        myPid = malloc(sizeof(PID));
        if (!myPid) {
            LOG_ERROR("Failed to allocate memory for PID in MonSignal.");
        }
        *myPid = MyPid();

        /* Add the signaling thread to the urgentQueue for priority */
        ListPrepend(urgentQueue, myPid);

        /* Remove a waiting thread from the condition variable's wait list */
        waitingPid = (PID*)ListTrim(mon.condVars[cvar].waitList);
        if (waitingPid) {
            V(mon.condVars[cvar].semaphore);
            free(waitingPid);

            /* Wait until the monitor is available again */
            P(urgentSem);
        } else {
            free(myPid);
        }
    }
}
