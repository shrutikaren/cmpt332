/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>

static Monitor mon;

/* CMPT 332 GROUP 34 Change, Fall 2024 */
/* Phase 1 */

// Condition Variables
/* 
 *  Objective: 
 *  ----------
 *
 *  Implement a monitor facility in C using only
 *  semaphore operations P() and V(). 
 *
 *  Key Points:
 *  -----------
 *
 *  Mutual Exclusion: Only one thread executes within the monitor at any given
 *  time.
 *  
 *  Condition Variables: Synchronize between threads using MonWait() and 
 *  MonSignal.
 *
 */ 

void MonInit(){

    /* Initialize the mutex semaphore to 1 (unlock) */ 
    mon.mutex = NewSem(1);
    if(mon.mutex < 0){
        printf(stderr, "Unable to create mutex semaphore");
        exit(EXIT_FAILURE);
    }

    /* Initialize the enter queue and its semaphore */  
    mon.enterQueue = ListCreate();
    if(mon.enterQueue == NULL){


    }

}

void MonEnter(){

}

void MonLeave(){

}

void MonWait(int var){

}

void MonSignal(int var){

    if(var < 0 || var >= k){
        exit(EXIT_FAILURE);
    }

    /* Check if there are threads waiting on the condition varaible. */

}
