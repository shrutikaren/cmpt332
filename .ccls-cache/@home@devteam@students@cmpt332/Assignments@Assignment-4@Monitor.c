/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include "list.h"
#include <Monitor.h>

static Monitor mon;

/* CMPT 332 GROUP 34 Change, Fall 2024 */
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
            LOG_ERROR("Failed to create entry semaphore in MonInit.");
        }

        mon.conVars[i].semaphore = NewSem(0);
        if(mon.conVars[i].waitList == NULL){
            LOG_ERROR("Failed to create entry semaphore in MonInit.");
        }

    }

}

void MonEnter(){

}

void MonLeave(){

}

void MonWait(int var){

    if(var < 0 || var >= k){
        exit(EXIT_FAILURE);
    }

}

void MonSignal(int var){

    if(var < 0 || var >= k){
        exit(EXIT_FAILURE);
    }

    /* Check if there are threads waiting on the condition varaible. */
    if(ListCount(mon.conVars[var].waitList) > 0){
        /* Remove the first thread from the condition variables queue. */ 
        if ( == NULL){

        }

        /* Signal the cv's semaphore to wake up the waiting thread */
    }
}
