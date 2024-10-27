/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>
#include <stdlib.h>

static Monitor mon;
#define s 10 /*picked a random number*/


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
    mon.entrySem = ListCreate();
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

        mon.conVars[i].semaphore = ListCreate();
        if(mon.conVars[i].waitList == NULL){
            LOG_ERROR("Failed to create waitList for cv MonInit.");
        }

        mon.conVars[i].semaphore = NewSem(0);
        if(mon.conVars[i].waitList == NULL){
            LOG_ERROR("Failed to create semaphore for cv's MonInit.");
        }
    }

}

void MonEnter(){

    PID* currentPid;

    currentPid = (PID*)malloc(sizeof(PID));

    if(currentPid == NULL){
        LOG_ERROR("Dailed to allocate memory for PID in MonEnter.");
    }

    *currentPid = MyPid();

    /* TODO: Add the thread to the entryList */
    P(mon.entrySem);
    ListPrepend(mon.entryList, (void*)currentPid);
    V(mon.entrySem);
    
    /* TODO: Acquire the mutex */
    P(mon.mutex);
    
    /* TODO: Remove self from the entryList */
    P(mon.entrySem);
    void* trimmedPid = ListTrim(mon.entryList);
    if (trimmedPid != NULL) {
        free(trimmedPid); 
    } else {
        LOG_ERROR("Failed to trim from entryList in MonEnter.");
    }
    V(mon.entrySem);
}

void MonLeave(){
    /* TODO: Check if there are threads waiting in the entery List */
    P(mon.entrySem);
    
    if (ListCount(mon.entryList) > 0) {
        /* Signal the next thread waiting to enter the monitor */
        void* trimmedPid = ListTrim(mon.entryList);
        if (trimmedPid != NULL) {
            free(trimmedPid); 
            V(mon.lock);      
        } else {
            LOG_ERROR("Failed to trim from entryList in MonLeave.");
        }
    } else {
        /* If threads waiting to enter release the mutex */
        V(mon.lock);
    }
    V(mon.entrySem);
    
}

void MonWait(int cvar){

    if(cvar < 0 || cvar >= k){
        LOG_ERROR("Invalid condition variable ID in MonWait");
    }

    /* Add the thread to the condition variable's wait queue */
    PID* myPid = (PID*)malloc(sizeof(PID));
    if (myPid == NULL) {
        LOG_ERROR("Failed to allocate memory for PID in MonWait");
    }
    *myPid = MyPid();

    ListPrepend(mon.conVars[cvar].waitList, (void*)myPid);

    /* Release the mutex before waiting */
    MonLeave();

    /* Wait on the condition variable's semaphore */
    P(mon.conVars[cvar].semaphore);

    /* Re-acquire the mutex after being signaled */
    MonEnter();

}

void MonSignal(int cvar){

    if(cvar < 0 || cvar >= k){
        LOG_ERROR("Invalid condition variable ID in MonWait");
    }

    /* Check if there are threads waiting on the condition varaible. */
    if (ListCount(mon.conVars[cvar].waitList) > 0) {
        /* Remove the first thread from the condition variable's waitList. */ 
        PID* waitingPid = (PID*)ListTrim(mon.conVars[cvar].waitList);
        if (waitingPid == NULL) {
            LOG_ERROR("Failed to trim from condition variable in MonSignal.");
            //fprintf(stderr, "MonSignal: Failed to trim from condition variable %d wait_queue\n", cvar);
        }

        /* Signal the cv's semaphore to wake up the waiting thread */
        V(mon.conVars[cvar].semaphore);
    }

}
