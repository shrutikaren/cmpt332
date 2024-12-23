/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include "monitor.h"

/* Define the monitor instance */
Monitor monitor;

/* RttMonInit: Initialize monitor */
void RttMonInit() {
    int i;
    monitor.lock = 0;
    monitor.entrysem = 0;
    monitor.urgentq = ListCreate();  /* Initialize the urgent queue */
    monitor.enterq = ListCreate();   /* Initialize the enter queue */
    
    /* Initialize condition variables */
    for (i = 0; i < k; i++) {
        monitor.conVars[i].semaphores = 0;
        monitor.conVars[i].waitlist = ListCreate();
    }
}

/* RttMonEnter: Process enters the monitor */
void RttMonEnter() {
    int msgType;
    msgType = ENTER_MSG;
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), NULL, NULL);
}

/* RttMonLeave: Process leaves the monitor */
void RttMonLeave() {
    int msgType;
    msgType = LEAVE_MSG;
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), NULL, NULL);
}

/* RttMonWait: Process waits on condition variable */
void RttMonWait(int cv) {
    int msgType;
    unsigned int size;
    
    /* Invalid condition variable index */
    if (cv < 0 || cv >= k) {
        return;
    }
    msgType = WAIT_MSG;
    size = sizeof(cv);
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), &cv, &size);
}

/* RttMonSignal: Signal a waiting process on a condition variable */
void RttMonSignal(int cv) {
    int msgType;
    unsigned int size;
    
    /* Invalid condition variable index */
    if (cv < 0 || cv >= k) {
        return; 
    }
	
    msgType = SIGNAL_MSG;
    size = sizeof(cv);
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), &cv, &size);
}

/* MonServer: Monitor server handling messages and coordinating 
 * synchronization */
void MonServer() {
    while (RUN_SERVER) {
        int msgType;
        unsigned size;
        RttThreadId sender, *next;
        int cv;

        /* Wait to receive a message */
        size = sizeof(msgType);
        RttReceive(&sender, &msgType, &size);

        switch (msgType) {
            case ENTER_MSG:
                if (monitor.lock) {
                    /* Monitor is occupied, add sender to enter queue */
                    ListAppend(monitor.enterq, (void*)&sender);
                } else {
                    /* Set monitor to occupied and reply to sender */
                    monitor.lock = 1;
                    RttReply(sender, NULL, 0);
                }
                break;

            case LEAVE_MSG:
                if (ListCount(monitor.urgentq) > 0) {
                    /* Reply to item in urgent queue */
                    next = (RttThreadId*)ListRemove(monitor.urgentq);
                    RttReply(*next, NULL, 0);
                } else if (ListCount(monitor.enterq) > 0) {
                    /* Reply to item in enter queue */
                    next = (RttThreadId*)ListRemove(monitor.enterq);
                    RttReply(*next, NULL, 0);
                } else {
                    /* Monitor becomes unoccupied */
                    monitor.lock = 0;
                    RttReply(sender, NULL, 0);
                }
                break;

            case WAIT_MSG:
                size = sizeof(cv);
                RttReceive(&sender, &cv, &size);
                ListAppend(monitor.conVars[cv].waitlist, (void*)&sender);
                if (ListCount(monitor.urgentq) > 0) {
                    next = (RttThreadId*)ListRemove(monitor.urgentq);
                    RttReply(*next, NULL, 0);
                } else if (ListCount(monitor.enterq) > 0) {
                    next = (RttThreadId*)ListRemove(monitor.enterq);
                    RttReply(*next, NULL, 0);
                } else {
                    monitor.lock = 0;
                }
                break;

            case SIGNAL_MSG:
                size = sizeof(cv);
                RttReceive(&sender, &cv, &size);
                if (ListCount(monitor.conVars[cv].waitlist) > 0) {
                    next = (RttThreadId*)ListRemove(monitor.conVars[cv].waitlist);
                    ListAppend(monitor.urgentq, (void*)&sender);
                    RttReply(*next, NULL, 0);
                } else {
                    ListAppend(monitor.urgentq, (void*)&sender);
                    RttReply(sender, NULL, 0);
                }
                break;

            default:
                /* Handle unknown message types */
                RttReply(sender, NULL, 0);
                break;
        }
    }
}
