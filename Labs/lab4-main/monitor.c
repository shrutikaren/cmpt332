/*
	Shruti Kaur
	ICH524
	11339265
*/

#include "monitor.h"

/* Define the monitor instance */
Monitor monitor;

/* RttMonInit: Initialize monitor */
void RttMonInit() {
    monitor.lock = 0;
    monitor.entrysem = 0;
    monitor.urgentq = ListCreate();  /* Initialize the urgent queue */
    monitor.enterq = ListCreate();   /* Initialize the enter queue */
    
    /* Initialize condition variables */
    for (int i = 0; i < k; ++i) {
        monitor.conVars[i].semaphores = 0;
        monitor.conVars[i].waitlist = ListCreate();
    }
}

/* RttMonEnter: Process enters the monitor */
void RttMonEnter() {
    int msgType = ENTER_MSG;
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), NULL, NULL);
}

/* RttMonLeave: Process leaves the monitor */
void RttMonLeave() {
    int msgType = LEAVE_MSG;
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), NULL, NULL);
}

/* RttMonWait: Process waits on condition variable */
void RttMonWait(int cv) {
    if (cv < 0 || cv >= k) {
        return;  /* Invalid condition variable index */
    }
    int msgType = WAIT_MSG;
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), &cv, sizeof(cv));
}

/* RttMonSignal: Signal a waiting process on a condition variable */
void RttMonSignal(int cv) {
    if (cv < 0 || cv >= k) {
        return;  /* Invalid condition variable index */
    }
    int msgType = SIGNAL_MSG;
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), &cv, sizeof(cv));
}

/* MonServer: Monitor server handling messages and coordinating synchronization */
void MonServer() {
    while (1) {
        int msgType;
        RttThreadId sender;
        int cv;

        /* Wait to receive a message */
        RttReceive(&sender, &msgType, sizeof(msgType));

        /* Use switch statement to handle different message types */
        switch (msgType) {
            case ENTER_MSG:
                if (monitor.lock) {
                    /* Monitor is occupied, add sender to enter queue */
                    ListAppend(monitor.enterq, (void*)sender);
                } else {
                    /* Set monitor to occupied and reply to sender */
                    monitor.lock = 1;
                    RttReply(sender, NULL, 0);
                }
                break;

            case LEAVE_MSG:
                if (!ListIsEmpty(monitor.urgentq)) {
                    /* Reply to item in urgent queue */
                    RttThreadId next = (RttThreadId)ListRemove(monitor.urgentq);
                    RttReply(next, NULL, 0);
                } else if (!ListIsEmpty(monitor.enterq)) {
                    /* Reply to item in enter queue */
                    RttThreadId next = (RttThreadId)ListRemove(monitor.enterq);
                    RttReply(next, NULL, 0);
                } else {
                    /* Monitor becomes unoccupied */
                    monitor.lock = 0;
                    RttReply(sender, NULL, 0);
                }
                break;

            case WAIT_MSG:
                RttReceive(&sender, &cv, sizeof(cv));
                ListAppend(monitor.conVars[cv].waitlist, (void*)sender);
                if (!ListIsEmpty(monitor.urgentq)) {
                    RttThreadId next = (RttThreadId)ListRemove(monitor.urgentq);
                    RttReply(next, NULL, 0);
                } else if (!ListIsEmpty(monitor.enterq)) {
                    RttThreadId next = (RttThreadId)ListRemove(monitor.enterq);
                    RttReply(next, NULL, 0);
                } else {
                    monitor.lock = 0;
                }
                break;

            case SIGNAL_MSG:
                RttReceive(&sender, &cv, sizeof(cv));
                if (!ListIsEmpty(monitor.conVars[cv].waitlist)) {
                    RttThreadId next = (RttThreadId)ListRemove(monitor.conVars[cv].waitlist);
                    ListAppend(monitor.urgentq, (void*)sender);
                    RttReply(next, NULL, 0);
                } else {
                    ListAppend(monitor.urgentq, (void*)sender);
                    RttReply(sender, NULL, 0);
                }
                break;

            default:
                /* Handle unknown message types (optional) */
                RttReply(sender, NULL, 0);
                break;
        }
    }
}

