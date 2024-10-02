#include <stdio.h>
#include <stdlib.h>
#include <square.h>
#include <windows.h>
#include <time.h> 

/* Thread structure to store thread information */
typedef struct {
    int idnum;
    int numSquare;    
} Thread_Info;


volatile bool keepRunning = true ; 

/*
 * Purpose: To help us work with the threads to go into the square functions
 */
DWORD WINAPI ThreadFunction(LPVOID param){
    int threadId = *(int*)param;

    Thread_Info *thread_id = (Thread_Info*) param;
    int count = 0;
    double elapsedTime;
    LARGE_INTEGER frequency, startCount, endCount;
    
    printf("Got to procedure ThreadFunc for the thread %d\n", threadId);

    /* 
     * Alternative way to GetSystemTime()
     * https://learn.microsoft.com/en-us/windows/win32/sysinfo/time-functions
    */

    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&startCount);
    
    for (int i=0; i< thread_id->numSquare && keepRunning; i++){
        square(i);
        count++;
        printf("This is the %d iteration\n", count);
    }

    QueryPerformanceCounter(&endCount);
    elapsedTime = (double)(endCount.QuadPart - startCount.QuadPart); 
    elapsedTime *= (1000.0 / frequency); 

    printf("Got to procedure ThreadFunc for the thread %d\n", 
            thread_id->idnum);
    printf("Thread %d: Elapsed time is %f milliseconds, "
            "number of innovations are %d\n", 
            thread_id->idnum, elapsedTime, count);
    count = 0; /*place it back to zero*/
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
        return ERROR_INVALID_DATA;
    }

    /* Parsing the arguments */
    
    num_of_threads = atoi(argv[1]);
    deadline = atoi(argv[2]);
    size = atoi(argv[3]);

    if (num_of_threads <= 0){
        printf("Error in procedure main: Invalid # of threads\n");
        return ERROR_INVALID_DATA;
     }

    if (deadline <= 0){
        printf("Error in procedure main: Invalid # of deadline\n");
        return ERROR_INVALID_DATA;
    }

    if (size <= 0){
        printf("Error in procedure main: Invalid # of size\n");
        return ERROR_INVALID_DATA;
    }
    
    threads = (HANDLE *)malloc(num_of_threads * sizeof(HANDLE));
    thread_data = (Thread_Info *) malloc(
            num_of_threads * sizeof(Thread_Info));

    if (!threads || !thread_data) {
        printf("Error in procedure main: Main allocation failed\n");
        free(threads);
        free(thread_data);
        return ERROR_OUTOFMEMORY;
    }

    /* creating the threads */
    for (i = 0; i < num_of_threads; i++){
        thread_data[i].numSquare = size;
        thread_data[i].idnum=i+1;
        threads[i] = CreateThread(NULL, 0, ThreadFunction, 
                &thread_data[i], 0, NULL);
        
        if (threads[i] == NULL){
            printf("Error in procedure CreateThread: Failed to" 
            "create thread %d\n", i);
            return GetLastError();
        }
    }

    Sleep(deadline*1000);
    
    keepRunning=FALSE;    

    WaitForMultipleObjects(num_of_threads, threads, true, INFINITE);

    free(threads);
    free(thread_data);

    return 0;
}
