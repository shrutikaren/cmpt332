i#include <stdio.h>
#include <stdlib.h>
#include <square.h>
#include <stdbool.h>
#include <windows.h>
#include <time.h> 

/* Thread structure to store thread information */
typedef struct {
	int idnum;
	int numSquare;	
} Thread_Info;

volatile BOOL keepRunning = TRUE;

/*
 * Purpose: To help us work with the threads to go into the square functions
 */
DWORD WINAPI ThreadFunction(LPVOID param){
	int threadId = *(int*)param;
	printf("Got to procedure ThreadFunc for the thread %d\n", threadId);
	return 0;
}

/*
 * Purpose: Create the threads and ensure the agruments passed are valid
 */
int main(int argc, char * argv[]) {
	
	HANDLE * threads;
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
	
	threads = (HANDLE *)malloc(num_of_threads * sizeof(HANDLE));
	thread_data = (Thread_Info *) malloc(
			num_of_threads * sizeof(Thread_Info));

	if (!threads || !thread_data) {
		printf("Error in procedure main: Main allocation failed\n");
		return -1;
	}

	/* creating the threads */
	for (i = 0; i < num_of_threads; i++){
		threads[i] = CreateThread(NULL, 0, ThreadFunction, 
				&thread_data[i], 0, NULL);
		if (threads[i] == NULL){
			printf("Error in procedure CreateThread: Failed to" 
			"create thread %d\n", i);
			return -1;
		}
	}

	Sleep(deadline*1000);

	WaitForMultipleObjects(num_of_threads, threads, true, INFINITE);

	free(threads);
	free(thread_data);

	return 0;
}


