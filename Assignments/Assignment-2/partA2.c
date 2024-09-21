/*
 * Jack Donegan, Shruti Kaur
 * lvf165, ich524
 * 11357744, 11339265
 */

#include <stdio.h>
#include <stdlib.h>
#include "square.h"
#include <pthread.h>
#include <signal.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdbool.h>

/* Thread structure to store thread information */
typedef struct {
	int idnum;
	int numSquare;
	struct timeval startTime, endTime; /*in-built structure*/
	bool finished;	
} Thread_Info;

/*
 * Purpose: To help us work with the threads to go into the square functions
 */
void* ThreadFunction(void* param){
	Thread_Info *thread_id = (Thread_Info*) param;
	int count = 0, i;
    	double elapsedTime;

	gettimeofday(&thread_id->startTime, NULL);

	for (i=1; i< thread_id->numSquare; i++){
		square(i);
		count++;
	}

	gettimeofday(&thread_id->endTime, NULL);
	thread_id->finished = true;

	elapsedTime = (thread_id->endTime.tv_sec - 
			thread_id->startTime.tv_sec) * 1000 + 
			(thread_id->endTime.tv_usec - 
			thread_id->startTime.tv_usec) * 1000;

	printf("Got to procedure ThreadFunc for the thread %d\n", 
		thread_id->idnum);
	printf("Thread %d: Elapsed time is %f milliseconds, "
            "number of innovations are %d\n", 
            thread_id->idnum, elapsedTime, count);
	return NULL;
}

/*
 * Purpose: Create the threads and ensure the agruments passed are valid
 */
int main(int argc, char * argv[]) {
	
	pthread_t * threads;
	int num_of_threads, deadline, size, i;
	Thread_Info * thread_data;
	
	if (argc != 4) {
		printf("Error in procedure main: Invalid number of"
			" parameters\n");
		return -1;
	}

	/* Parsing the arguments */
	
	num_of_threads = atoi(argv[1]);
	deadline = atoi(argv[2]);
	size = atoi(argv[3]);

	if (num_of_threads <= 0){
		printf("Error in procedure main: Invalid # of threads\n");
		return -1;
 	}

	if (deadline <= 0){
		printf("Error in procedure main: Invalid # of deadline\n");
		return -1;
	}

	if (size <= 0){
		printf("Error in procedure main: Invalid # of size\n");
		return -1;
	}
	
	threads = (pthread_t *)malloc(num_of_threads * sizeof(pthread_t));
	thread_data = (Thread_Info *) malloc(
			num_of_threads * sizeof(Thread_Info));

	if (!threads || !thread_data) {
		printf("Error in procedure main: Main allocation failed\n");
		return -1;
	}

	/* creating the threads */
	for (i = 0; i < num_of_threads; i++){
		thread_data[i].idnum = i + 1;
		thread_data[i].numSquare = size;
		thread_data[i].finished = false;
		if (pthread_create (&threads[i], NULL, ThreadFunction, 
		&thread_data[i])!=0){
			printf("Error in procedure CreateThread: Failed to" 
			"create thread %d\n", i);
			return -1;
		}
	}

	sleep(deadline*1000);
	
 	for (i = 0; i < num_of_threads; i++){
		if (thread_data[i].finished){
			pthread_join(threads[i], NULL);
		} 
		else if (!thread_data[i].finished){
			pthread_cancel(threads[i]);
		}
	}
	free(threads);
	free(thread_data);

	return 0;
}
