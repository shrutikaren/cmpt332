/*
 * Name: KAUR Shruti
 * NSID: ICH524
 * Student Number: 11339265
 * */

#include <standards.h>
#include <BestFitMonitor.h>
#include <Monitor.h>
#include <time.h>
#include <pthread.h>
#include <stdint.h>
static int numThreads = 5;
void* thread_creation(void* arg){
	int rand_value, req_size, thread_id, i;
	void* address;
	thread_id = *(int*)arg;
	
	/* Logic: Have time(NULL) to produce the seeconds. If I didn't use
 	   XOR as my operation, every thread would be having the same
	   random number if all the threads were generated so closely with
	   each other. */
	srand(time(NULL) ^ (thread_id << 16));
	
	for (i = 0; i < numberOfIterations; i ++){
		/* Ensure that the req_size is always within the boundaries
 		   of maxAllocation */
		req_size = rand() % maxAllocation;			
		address = BF_Allocate(req_size);
		if (address != NULL){
			printf("Successfully went into BF_Allocate!\n");
			sleep((rand() % maxSleepTime));

			/* The RAND_MAX is basically a macro defined in the
 			   libraries. This rand_value will give us a value
			   between 0 and 1. */
			rand_value = (rand()/(float)RAND_MAX);
			
			/* We are checking if our rand_value that we obtained
 			   is less than our freeProbility and if it is then
			   we will go ahead and BF_Free our memory block */
			if (rand_value < freeProability){
				BF_Free((int)(uintptr_t)address, req_size);
				printf("Our %d of %p address is free\n", 
				thread_id, address);
			}
		} else{
			MonWait(memAvail);
 		}
	}
	return NULL;
}

int mainp(){
	/* Initialize the memory space */
	int i;
	pthread_t* threads = (pthread_t*)malloc(sizeof(pthread_t) * numThreads);
	int* threadid = (int*)malloc(sizeof(int) * numThreads);
	
	if (threads == NULL || threadid == NULL){
		fprintf(stderr, "Memory allocation failed");
		exit(1);
	}
	
	/* We will initialize our memory space */
	/* Initialize(); */
	Initialize();
	
	/* Create our threads to access our thread_creation function */
	for (i = 0; i < numThreads; i ++){
		threadid[i] = i ; /*Initializing my threadid array */
		if (pthread_create(&threads[i], NULL, thread_creation, 
		&threadid[i]) != 0){
			perror("Failed to create a thread!");
		}
	}	

	/* Join all our threads */
	for (i = 0; i < numThreads; i ++){
		pthread_join(threads[i], NULL);
	}

	/* If everything works well then we would print off everything */
	printf("All the threads have been joined successful-Completed Lab 6");
	return 0;
	
}