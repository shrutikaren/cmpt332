#include <stdio.h>
#include <stdlib.h>
#include "square.h"
#include <pthread.h>
#include <sys/time.h>
#include <unistd.h>
#include <stdbool.h>

/* Thread structure to store thread information */
typedef struct {
    int idnum;
    int numSquare;
    struct timeval startTime, endTime;
    volatile bool finished;    
} Thread_Info;

/* Global variables required by square.c */
volatile bool keepRunning = true;
volatile int *squareCounts = NULL;
volatile thread_id_t *thread_ids = NULL;
int num_of_threads = 0;

/*
 * Thread function that performs square calculations.
 */
void* ThreadFunction(void* param) {
    Thread_Info *thread_info = (Thread_Info *)param;
    int i;

    /* Store current thread ID */
    thread_id_t current_thread_id = pthread_self();

    /* Save thread ID in global array */
    int threadIndex = thread_info->idnum - 1;
    thread_ids[threadIndex] = current_thread_id;

    /* Start timing */
    gettimeofday(&thread_info->startTime, NULL);

    /* Perform calculations */
    for (i = 0; i < thread_info->numSquare && keepRunning; i++) {
        square(i);
        printf("Thread %d: Iteration %d\n", thread_info->idnum, i + 1);
    }

    /* End timing */
    gettimeofday(&thread_info->endTime, NULL);
    thread_info->finished = true;

    printf("Got to procedure ThreadFunction for thread %d\n", thread_info->idnum);

    return NULL; /* Exit the thread */
}


int main(int argc, char *argv[]) {
    pthread_t *threads;
    int deadline, size, i;
    Thread_Info *thread_data;
    long elapsed_time;

    if (argc != 4) {
        printf("Error in main: Invalid number of parameters\n");
        return -1;
    }

    /* Parsing the arguments */
    num_of_threads = atoi(argv[1]);
    deadline = atoi(argv[2]);
    size = atoi(argv[3]);

    if (num_of_threads <= 0 || deadline <= 0 || size <= 0) {
        printf("Error in main: Invalid arguments\n");
        return -1;
    }

    /* Allocate memory for threads and thread data */
    threads = (pthread_t *)malloc(num_of_threads * sizeof(pthread_t));
    thread_data = (Thread_Info *)malloc(num_of_threads * sizeof(Thread_Info));
    squareCounts = (volatile int *)malloc(num_of_threads * sizeof(int));
    thread_ids = (volatile thread_id_t *)malloc(num_of_threads * sizeof(thread_id_t));

    if (!threads || !thread_data || !squareCounts || !thread_ids) {
        printf("Error in main: Memory allocation failed\n");
        return -1;
    }

    /* Initialize thread data and create threads */
    for (i = 0; i < num_of_threads; i++) {
        thread_data[i].idnum = i + 1;
        thread_data[i].numSquare = size;
        thread_data[i].finished = false;
        squareCounts[i] = 0;
        thread_ids[i] = 0;

        /* Create thread */
        if (pthread_create(&threads[i], NULL, ThreadFunction, &thread_data[i]) != 0) {
            printf("Error in pthread_create: Failed to create thread %d\n", i);
            return -1;
        }
    }

    sleep(deadline); /* Wait for the deadline */

    /* Terminate threads that haven't finished */
    keepRunning = false;

    for (i = 0; i < num_of_threads; i++) {
        if (!thread_data[i].finished) {
            pthread_cancel(threads[i]);
            gettimeofday(&thread_data[i].endTime, NULL);

            elapsed_time = ((thread_data[i].endTime.tv_sec - 
		    		thread_data[i].startTime.tv_sec) * 1000) +
                           ((thread_data[i].endTime.tv_usec - t
		    		hread_data[i].startTime.tv_usec) / 1000);

            printf("Thread %d terminated after %ld milliseconds\n", 
		    thread_data[i].idnum, elapsed_time);
        } else {
            elapsed_time = ((thread_data[i].endTime.tv_sec - 
		    		thread_data[i].startTime.tv_sec) * 1000) +
                           ((thread_data[i].endTime.tv_usec - 
		    		thread_data[i].startTime.tv_usec) / 1000);

            printf("Thread %d completed in %ld milliseconds\n", 
		    thread_data[i].idnum, elapsed_time);
        }
    }

    /* Join threads */
    for (i = 0; i < num_of_threads; i++) {
        pthread_join(threads[i], NULL);
    }

    /* Print the number of times square() was called by each thread */
    for (i = 0; i < num_of_threads; i++) {
        printf("Thread %d: square() was called %d times\n", 
		thread_data[i].idnum, squareCounts[i]);
    }

    /* Free allocated memory */
    free(threads);
    free(thread_data);
    free((void *)squareCounts);
    free((void *)thread_ids);

    return 0;
}
