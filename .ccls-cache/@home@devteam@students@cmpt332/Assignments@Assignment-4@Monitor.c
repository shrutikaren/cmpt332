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
        perror("Log [Error] - Failed to create lock mutex in MonInit.");
        exit(EXIT_FAILURE);
    }

    /* Initialize the enter queue and its semaphore */  
    mon.entryList = ListCreate();
    if(mon.entryList == NULL){
        perror("Log [Error] - Failed to create entry queue in MonInit.");
        exit(EXIT_FAILURE);
    }

    /* Initialize the enterSem. */
    mon.entrySem = NewSem(1);
    if(mon.entrySem < 0){
        perror("Log [Error] - Failed to create entry semaphore in MonInit.");
        exit(EXIT_FAILURE);
    }

    /* Initialize all conditional variables */
    for(i = 0; i < k; i++){

        mon.conVars[i].waitList = ListCreate();
        if(mon.conVars[i].waitList == NULL){
            fprintf(stderr, "%s\n");
            exit(EXIT_FAILURE);
        }

        mon.conVars[i].semaphore = NewSem(0);
        if(mon.conVars[i].waitList == NULL){
            fprintf(stderr, "%s\n");
            exit(EXIT_FAILURE);
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
