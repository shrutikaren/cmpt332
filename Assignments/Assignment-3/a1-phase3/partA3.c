#include <stdio.h>
#include <stdlib.h>
#include <square.h>
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
	int count;
} Thread_Info;

/*
 * Purpose: To help us work with the threads to go into the square functions
 */

volatile int threads_done = 0; 
pthread_mutex_t thread_lock;

void* ThreadFunction(void* param){
	Thread_Info *thread_id = (Thread_Info*) param;
	int i;

	gettimeofday(&thread_id->startTime, NULL);

	for (i=1; i<= thread_id->numSquare; i++){
		square(i);
		thread_id->count++;
		printf("This is iteration number %d\n", thread_id->count);
	}

	gettimeofday(&thread_id->endTime, NULL);
	thread_id->finished = true;
	
	/*working with mutexes to prevent threads_done to be affected*/
	pthread_mutex_lock(&thread_lock);
	threads_done = threads_done + 1;
	pthread_mutex_unlock(&thread_lock);

	printf("Got to procedure ThreadFunc for the thread %d\n", 
		thread_id->idnum);
	return NULL;
}

/*
 * Purpose: Create the threads and ensure the agruments passed are valid
 */
int main(int argc, char * argv[]) {
	
	pthread_t * threads;
	int num_of_threads, deadline, size, i;
	Thread_Info * thread_data;
	long elapsed_time;

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

	sleep(deadline); /*in linux, it is limited to seconds not milliseconds*/
	
 	for (i = 0; i < num_of_threads; i++){
		if (!thread_data[i].finished){
			/*only one argument*/
			pthread_cancel(threads[i]);
			gettimeofday(&thread_data[i].endTime, NULL);

			elapsed_time = ((thread_data[i].endTime.tv_sec - 
				thread_data[i].startTime.tv_sec) * 1000) + 
				((thread_data[i].endTime.tv_usec - 
				thread_data[i].startTime.tv_usec)/ 1000);
		
			printf("Thread %d finished at the elapsed time" 
			" milliseconds of %ld\n",thread_data[i].idnum, 
			elapsed_time);	
		}
		else{ 
			/*if the threads were finished*/
			gettimeofday(&thread_data[i].endTime, NULL);

			elapsed_time = ((thread_data[i].endTime.tv_sec - 
				thread_data[i].startTime.tv_sec) * 1000) +
				((thread_data[i].endTime.tv_usec - 
				thread_data[i].startTime.tv_usec)/ 1000);
		
			printf("Thread %d finished at the elapsed time" 
			" milliseconds of %ld\n",thread_data[i].idnum, 
			elapsed_time);	
		}
	}
	
	/*while loop continues indefinitely until condition is met
  	condition: threads_done == num_of_threads - helps us to wait
	for all threads to finish*/
	while (true){
		pthread_mutex_lock(&thread_lock);
		if (threads_done == num_of_threads){
			pthread_mutex_unlock(&thread_lock); /*avoid deadlock*/
			break;
		}
		pthread_mutex_unlock(&thread_lock);
	}
	free(threads);
	free(thread_data);

	return 0;
}
