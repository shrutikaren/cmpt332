/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>
#include <stdlib.h>

/* Static Monitor Instance */
static Monitor mon;

/**
 * Initialize the monitor.
 */ 
void MonInit(){
    int i;

    /* Initialize the monitor lock semaphore to 1 (unlocked) */ 
    mon.lock = NewSem(1);
    if(mon.lock < 0){
        LOG_ERROR("Failed to create lock mutex in MonInit.");
    }
    
    /* Initialize the entry queue and its semaphore */  
    mon.entryList = ListCreate();
    if(mon.entryList == NULL){
        LOG_ERROR("Failed to create entry queue in MonInit.");
    }

    /* Initialize the entrySem semaphore to 1 */
    mon.entrySem = NewSem(1);
    if(mon.entrySem < 0){
        LOG_ERROR("Failed to create entry semaphore in MonInit.");
    }

    /* Initialize all condition variables */
    for(i = 0; i < k; i++){
        /* Initialize the waitList for each condition variable */
        mon.conVars[i].waitList = ListCreate();
        if(mon.conVars[i].waitList == NULL){
            LOG_ERROR("Failed to create waitList for condition variable in MonInit.");
        }

        /* Initialize the semaphore for each condition variable to 0 */
        mon.conVars[i].semaphore = NewSem(0);
        if(mon.conVars[i].semaphore < 0){
            LOG_ERROR("Failed to create semaphore for condition variable in MonInit.");
        }
    }
}

/**
 * Enter the monitor.
 */ 
void MonEnter(){
    PID* currentPid;
    void* trimmedPid;

    /* Allocate memory for the current PID */
    currentPid = (PID*)malloc(sizeof(PID));
    if(currentPid == NULL){
        LOG_ERROR("Failed to allocate memory for PID in MonEnter.");
    }

    /* Get the current thread's PID */
    *currentPid = MyPid();

    /* Add the thread to the entryList */
    P(mon.entrySem);
    ListPrepend(mon.entryList, currentPid);
    V(mon.entrySem);
    
    /* Acquire the monitor lock */
    P(mon.lock);

    /* Remove self from the entryList */
    P(mon.entrySem);
    trimmedPid = ListTrim(mon.entryList);
    if (trimmedPid != NULL) {
        free(trimmedPid); 
    } else {
        LOG_ERROR("Failed to trim from entryList in MonEnter.");
    }
    V(mon.entrySem);
}

/**
 * Leave the monitor.
 */ 
void MonLeave(){
    void* trimmedPid;

    /* Acquire the entrySem semaphore before accessing entryList */
    P(mon.entrySem);
    
    if (ListCount(mon.entryList) > 0) {
        /* Remove the next thread from the entryList */
        trimmedPid = ListTrim(mon.entryList);
        if (trimmedPid != NULL) {
            free(trimmedPid); 
            /* Release the monitor lock for the next thread */
            V(mon.lock);      
        } else {
            LOG_ERROR("Failed to trim from entryList in MonLeave.");
        }
    } else {
        /* If no threads are waiting to enter, release the monitor lock */
        V(mon.lock);
    }
    V(mon.entrySem);
}

/**
 * Wait on a condition variable.
 */ 
void MonWait(int cvar){
    PID* myPid;

    /* Validate condition variable ID */
    if(cvar < 0 || cvar >= k){
        LOG_ERROR("Invalid condition variable ID in MonWait");
    }

    /* Allocate memory for the current PID */
    myPid = (PID*)malloc(sizeof(PID));
    if (myPid == NULL) {
        LOG_ERROR("Failed to allocate memory for PID in MonWait");
    }
    *myPid = MyPid();

    /* Add the thread to the condition variable's waitList */
    ListAppend(mon.conVars[cvar].waitList, (void*)myPid);

    /* Release the monitor lock before waiting */
    MonLeave();

    /* Wait on the condition variable's semaphore */
    P(mon.conVars[cvar].semaphore);

    /* Re-acquire the monitor lock after being signaled */
    MonEnter();
}

/**
 * Signal a condition variable.
 */ 
void MonSignal(int cvar){
    PID* waitingPid;

    /* Validate condition variable ID */
    if(cvar < 0 || cvar >= k){
        LOG_ERROR("Invalid condition variable ID in MonSignal");
    }

    /* Check if there are threads waiting on the condition variable */
    if (ListCount(mon.conVars[cvar].waitList) > 0) {
        /* Set the list's current pointer to the first item */
        ListFirst(mon.conVars[cvar].waitList);
    
        /* Remove the first thread from the condition variable's waitList */
        waitingPid = (PID*)ListRemove(mon.conVars[cvar].waitList);
        if (waitingPid == NULL) {
            LOG_ERROR("Failed to remove from condition variable in MonSignal.");
        }
    
        /* Signal the condition variable's semaphore to wake up the waiting thread */
        V(mon.conVars[cvar].semaphore);
    
        /* Free the PID memory */
        free(waitingPid);
    }
}
