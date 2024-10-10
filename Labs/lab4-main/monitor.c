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
    if (cv < 0 || cv >= k) {
        return;  /* Invalid condition variable index */
    }
    msgType = WAIT_MSG;
    size = sizeof(cv);
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), &cv, &size);
}

/* RttMonSignal: Signal a waiting process on a condition variable */
void RttMonSignal(int cv) {
    int msgType;
    unsigned int size;
    if (cv < 0 || cv >= k) {
        return;  /* Invalid condition variable index */
    }
    msgType = SIGNAL_MSG;
    size = sizeof(cv);
    RttSend(RttMyThreadId(), &msgType, sizeof(msgType), &cv, &size);
}

/* MonServer: Monitor server handling messages and coordinating synchronization */
void MonServer() {
    while (1) {
        int msgType;
	unsigned size;
        RttThreadId sender, next;
        int cv;

        /* Wait to receive a message */
	size = sizeof(msgType);
        RttReceive(&sender, &msgType, &size);

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
                    next = (RttThreadId)ListRemove(monitor.urgentq);
                    RttReply(next, NULL, 0);
                } else if (!ListIsEmpty(monitor.enterq)) {
                    /* Reply to item in enter queue */
                    next = (RttThreadId)ListRemove(monitor.enterq);
                    RttReply(next, NULL, 0);
                } else {
                    /* Monitor becomes unoccupied */
                    monitor.lock = 0;
                    RttReply(sender, NULL, 0);
                }
                break;

            case WAIT_MSG:
		size = sizeof(cv);
                RttReceive(&sender, &cv, size);
                ListAppend(monitor.conVars[cv].waitlist, (void*)sender);
                if (!ListIsEmpty(monitor.urgentq)) {
                    next = (RttThreadId)ListRemove(monitor.urgentq);
                    RttReply(next, NULL, 0);
                } else if (!ListIsEmpty(monitor.enterq)) {
                    next = (RttThreadId)ListRemove(monitor.enterq);
                    RttReply(next, NULL, 0);
                } else {
                    monitor.lock = 0;
                }
                break;

            case SIGNAL_MSG:
		size = sizeof(cv);
                RttReceive(&sender, &cv, size);
                if (!ListIsEmpty(monitor.conVars[cv].waitlist)) {
                    next = (RttThreadId)ListRemove(monitor.conVars[cv].waitlist);
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

