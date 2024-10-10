/*
	Shruti Kaur
	ICH524
	11339265
*/

#include "monitor.h"
#include "rtthreads.h"
#include "list.h" 

#define k 5 /*picked an arbitarily number*/

Monitor monitor;
ConditionVariables conV[k];

void RttMonInit(int numI){
	monitor.enterq = ListCreate(); /*Create a list for the enter queue*/
	monitor.urgentq = ListCreate(); /*Create a list for hte urgent queue*/
	monitor.lock = 1 ; /*For the mutex lock to be unlocked*/

	for (int i = 0; i < = numI; i ++){
		condV[i].waitlist = ListCreate();
	}		
	return NULL;
}

void RttMonEnter(){
	/* If the monitor is not busy */
	if (monitor.lock == 1){
		monitor.lock = 0; /* Set the lock to be 0 */
		return;
	}
	ListAdd(enterq, rtt_thread);
	return NULL;
}

void RttMonLeave(){
	if (monitor.lock == 0){
		
	}
	monitor.lock = 1; /* Returning it back to being unlocked */
	return NULL;
}

void RttMonSignal(int numS){
	return NULL;
}

void RttMonWait(int numW){
	return NULL;
}

void MonServer(){
	return NULL;
}
