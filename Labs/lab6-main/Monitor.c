/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>

static Monitor mon;

void MonInit() {
    int i;

    /* Initialize the monitor lock semaphore to 1 (unlocked) */ 
    mon.lock = NewSem(1);
    if (mon.lock < 0) {
        LOG_ERROR("Failed to create monitor lock in MonInit.");
    }

    /* Initialize entry control variables */
    mon.entryCtrl.urgentWaitList = ListCreate();
    if (!mon.entryCtrl.urgentWaitList) {
        LOG_ERROR("Failed to create urgentWaitList in MonInit.");
    }

    mon.entryCtrl.entryWaitList = ListCreate();
    if (!mon.entryCtrl.entryWaitList) {
        LOG_ERROR("Failed to create entryWaitList in MonInit.");
    }

    mon.entryCtrl.urgentWaitSem = NewSem(0);
    if (mon.entryCtrl.urgentWaitSem < 0) {
        LOG_ERROR("Failed to create urgentWaitSem in MonInit.");
    }

    mon.entryCtrl.entryWaitSem = NewSem(1);
    if (mon.entryCtrl.entryWaitSem < 0) {
        LOG_ERROR("Failed to create entryWaitSem in MonInit.");
    }

    /* Initialize all condition variables */
    for (i = 0; i < k; i++) {
        mon.condVars[i].waitList = ListCreate();
        if (!mon.condVars[i].waitList) {
            LOG_ERROR("Failed to create waitList for cv's in MonInit.");
        }

        mon.condVars[i].semaphore = NewSem(0);
        if (mon.condVars[i].semaphore < 0) {
            LOG_ERROR("Failed to create semaphore for cv's in MonInit.");
        }
    }
}

void MonEnter() {
    PID* myPid = malloc(sizeof(PID));
    if (myPid == NULL) {
        LOG_ERROR("Failed to allocate memory for PID in MonEnter.");
    }
    *myPid = MyPid();

    /* Add the thread to the entryWaitList */
    P(mon.entryCtrl.entryWaitSem);
    ListPrepend(mon.entryCtrl.entryWaitList, myPid);
    V(mon.entryCtrl.entryWaitSem);

    /* Acquire the monitor lock */
    P(mon.lock);
}

void MonLeave() {
    PID* pid;

    /* Give priority to threads in the urgentWaitList */
    if (ListCount(mon.entryCtrl.urgentWaitList) > 0) {
        pid = (PID*)ListTrim(mon.entryCtrl.urgentWaitList);
        if (pid) {
            free(pid);
            V(mon.entryCtrl.urgentWaitSem);
        }
    }
    /* Otherwise, allow a thread from the entryWaitList to enter */
    else if (ListCount(mon.entryCtrl.entryWaitList) > 0) {
        pid = (PID*)ListTrim(mon.entryCtrl.entryWaitList);
        if (pid) {
            free(pid);
            V(mon.lock);
        }
    }
    /* No threads are waiting; monitor remains unlocked */
}

void MonWait(int cvar) {
    PID* myPid;

    if (cvar < 0 || cvar >= k) {
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
    if (ListCount(mon.entryCtrl.urgentWaitList) > 0) {
        PID* pid = (PID*)ListTrim(mon.entryCtrl.urgentWaitList);
        if (pid) {
            free(pid);
            V(mon.entryCtrl.urgentWaitSem);
        }
    } else if (ListCount(mon.entryCtrl.entryWaitList) > 0) {
        PID* pid = (PID*)ListTrim(mon.entryCtrl.entryWaitList);
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

void MonSignal(int cvar) {
    PID* myPid;
    PID* waitingPid;

    if (cvar < 0 || cvar >= k) {
        LOG_ERROR("Invalid condition variable ID in MonSignal.");
    }

    /* Check if there are threads waiting on the condition variable */
    if (ListCount(mon.condVars[cvar].waitList) > 0) {
        myPid = malloc(sizeof(PID));
        if (!myPid) {
            LOG_ERROR("Failed to allocate memory for PID in MonSignal.");
        }
        *myPid = MyPid();

        /* Add the signaling thread to the urgentWaitList for priority */
        ListPrepend(mon.entryCtrl.urgentWaitList, myPid);

        /* Remove a waiting thread from the condition variable's wait list */
        waitingPid = (PID*)ListTrim(mon.condVars[cvar].waitList);
        if (waitingPid) {
            V(mon.condVars[cvar].semaphore);
            free(waitingPid);

            /* Wait until the monitor is available again */
            P(mon.entryCtrl.urgentWaitSem);
        } else {
            free(myPid);
        }
    }
}

