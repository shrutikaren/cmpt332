/*
	Shruti Kaur
	ICH524
	11339265
*/

#include "monitor.h"
#include "rtthreads.h"

#define k 5 /*picked an arbitarily number*/

Monitor monitor;
ConditionVariables conV[k];

void RttMonInit(int numI){
	monitor.enterq = ListCreate(); /*Create a list for the enter queue*/
	
	return NULL;
}

void RttMonEnter(){
	return NULL;
}

void RttMonLeave(){
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
