/*
 * Name: KAUR Shruti
 * NSID: ICH524
 * Student Number: 11339265
 * */

#include <os.h>
#include <standards.h>
#include <stdlib.h>
#include <stdio.h>
#include <BestFitMonitor.h>
#include <Monitor.h>

void* thread_creation(void* arg){
	int thread_id, seed, i;
	thread_id = *(int*)arg;

	/* Logic: Have time(NULL) to produce the seeconds. If I didn't use
 	   XOR as my operation, every thread would be having the same
	   random number if all the threads were generated so closely with
	   each other. */
	srand(time(NULL) ^ (thread_id << 16);
	
	for (i = 0; i < numberOfIterations; i ++){
		
	}
}

int mainp(){
	/* Initialize the memory space */
	Initialize();
		
	
	
}
