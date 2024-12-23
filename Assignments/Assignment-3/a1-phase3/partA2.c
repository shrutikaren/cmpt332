/* Jack Donegan, Shruti Kaur
   lvf165, ich524
   11357744, 11339265 */


#include <stdio.h>
#include <stdlib.h>
#include <square.h>
#include <sys/time.h>

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

/* Defined a reasonable stack size 8MB */
#define STACK_SIZE (2 << 22) 

/*
 * Thread function that performs square calculations.
 */
void ThreadFunction() {
    Thread_Info *thread_info;
    PID sender_pid;
    int len, threadIndex;
    int i;
    thread_id_t current_thread_id;

    /* Store current thread ID */
    current_thread_id = MyPid();
	
    /* Receive the Thread_Info structure from main */
    thread_info = (Thread_Info *) Receive(&sender_pid, &len);

    /* Save thread ID in global array */
    threadIndex = thread_info->idnum - 1;
    thread_ids[threadIndex] = current_thread_id;

    /* Start timing */
    gettimeofday(&thread_info->startTime, NULL);

    /* Perform calculations */
    for (i = 0; i < thread_info->numSquare; i++) {
        square(i);
        printf("Thread %d: Iteration %d\n", thread_info->idnum, i + 1);
    }

    /* End timing */
    gettimeofday(&thread_info->endTime, NULL);
    thread_info->finished = true;

    printf("Got to procedure ThreadFunction for thread %d\n", 
	thread_info->idnum);

    Pexit(); /* Exit the thread */
}

/*
 * Main function that creates threads and manages their execution.
 */
int mainp(int argc, char *argv[]) {
    PID *pids;
    int deadline, size, i, msg_len;
    Thread_Info *thread_data;
    double elapsed_time;

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
    pids = (PID *)malloc(num_of_threads * sizeof(PID));
    thread_data = (Thread_Info *)malloc(num_of_threads * sizeof(Thread_Info));
    squareCounts = (volatile int *)malloc(num_of_threads * sizeof(int));
    thread_ids = (volatile thread_id_t *)malloc(num_of_threads * 
		sizeof(thread_id_t));

    if (!pids || !thread_data || !squareCounts || !thread_ids) {
        printf("Error in main: Memory allocation failed\n");
        return -1;
    }

    /* Initialize thread data and create threads */
    for (i = 0; i < num_of_threads; i++) {
        thread_data[i].idnum = i + 1;
        thread_data[i].numSquare = size;
        thread_data[i].finished = false;
        squareCounts[i] = 0;
        thread_ids[i] = PNUL;

       /* Create thread */
        pids[i] = Create(ThreadFunction, STACK_SIZE, "Thread", &thread_data[i], NORM, USR);
        if (pids[i] == PNUL) {
            printf("Error in CreateThread: Failed to create thread %d\n", i);
            return -1;
        }
        printf("Created thread %d with PID %ld\n", i+1, pids[i]);

        /* Send Thread_Info to the thread */
        msg_len = sizeof(Thread_Info);
        if (Send(pids[i], &thread_data[i], &msg_len) != 0) {
            printf("Error in Send: Failed to send message to thread %d\n", i);
            return -1;
        }
        printf("Sent Thread_Info to thread %d\n", i);
    }

    Sleep(deadline); /* Wait for the deadline */

    /* Kill threads that haven't finished */
    for (i = 0; i < num_of_threads; i++) {
        if (!thread_data[i].finished) {
            Kill(pids[i]);
            gettimeofday(&thread_data[i].endTime, NULL);

            elapsed_time = ((thread_data[i].endTime.tv_sec - 
		    		thread_data[i].startTime.tv_sec) * 1000.0) +
                           ((thread_data[i].endTime.tv_usec - 
		    		thread_data[i].startTime.tv_usec) / 1000.0);

            printf("Thread %d terminated after %.3f milliseconds\n",
		    thread_data[i].idnum, elapsed_time);
        } else {
            elapsed_time = ((thread_data[i].endTime.tv_sec - 
		    		thread_data[i].startTime.tv_sec) * 1000.0) +
                           ((thread_data[i].endTime.tv_usec - 
		    		thread_data[i].startTime.tv_usec) / 1000.0);

            printf("Thread %d completed in %.3f milliseconds\n", 
		    thread_data[i].idnum, elapsed_time);
        }
    }

    /* Print the number of times square() was called by each thread */
    for (i = 0; i < num_of_threads; i++) {
        printf("Thread %d: square() was called %d times\n", 
		thread_data[i].idnum, squareCounts[i]);
    }

    /* Free allocated memory */
    free(pids);
    free(thread_data);
    free((void *)squareCounts);
    free((void *)thread_ids);

    return 0;
}
