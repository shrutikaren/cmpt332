/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>
#include <stdlib.h>

static Monitor mon;

/* CMPT 332 GROUP  Change, Fall 2024 */
/* Phase 1 */

/**
 *  Initialize the monitor.
 */ 
void MonInit(){

    int i;

    /* Initialize the mutex semaphore to 1 (unlock) */ 
    mon.lock = NewSem(1);
    if(mon.lock < 0){
        LOG_ERROR("Failed to create lock mutex in MonInit.");
    }

    /* Initialize the enter queue and its semaphore */  
    mon.entryList = ListCreate();
    if(mon.entryList == NULL){
        LOG_ERROR("Failed to create entry queue in MonInit.");
    }

    /* Initialize the enterSem. */
    mon.entrySem = NewSem(1);
    if(mon.entrySem < 0){
        LOG_ERROR("Failed to create entry semaphore in MonInit.");
    }

    /* Initialize all conditional variables */
    for(i = 0; i < k; i++){

        mon.conVars[i].waitList = ListCreate();
        if(mon.conVars[i].waitList == NULL){
            LOG_ERROR("Failed to create waitList for cv MonInit.");
        }

        mon.conVars[i].semaphore = NewSem(0);
        if(mon.conVars[i].waitList == NULL){
            LOG_ERROR("Failed to create semaphore for cv's MonInit.");
        }
    }
    return NULL;
}

void MonEnter(){

    PID* currentPid;

    currentPid = (PID*)malloc(sizeof(PID));

    if(currentPID == NULL){
        LOG_ERROR("Dailed to allocate memory for PID in MonEnter.");
    }

    /* TODO: Add the thread to the entryList */

    /* TODO: Acquire the mutex */

    /* TODO: Remove self from the entryList */
    return NULL;
}

void MonLeave(){

    /* TODO: Check if there are threads waiting in the entery List */

    /* Signal the next thread waiting to enter the monitor */

    /* If threads waiting to enter release the mutex */
    return NULL;
}

void MonWait(int var){

    if(var < 0 || var >= k){
        LOG_ERROR("Invalid condition variable ID in MonWait");
    }

    /* Add the thread to the condition variable's waitList */

    /* Release the mutex before waiting */

    /* Wait on the condition variable's semaphore */ 

    /* Re-acquire the mutex after being signaled */
    return NULL;
}

void MonSignal(int var){

    if(var < 0 || var >= k){
        LOG_ERROR("Invalid condition variable ID in MonWait");
    }

    /* Check if there are threads waiting on the condition varaible. */

    /* Remove the first thread from the condition variable's waitList. */ 

    /* Signal the cv's semaphore to wake up the waiting thread */
    return NULL;
}
