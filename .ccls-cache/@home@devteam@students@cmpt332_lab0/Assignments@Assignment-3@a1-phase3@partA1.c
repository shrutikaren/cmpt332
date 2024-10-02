#include <stdio.h>
#include <stdlib.h>
#include <square.h>
#include <windows.h>
#include <time.h> 

/* Thread structure to store thread information */
typedef struct {
    int idnum;
    int numSquare;    
    int squareCount;
    volatile bool finished;
} Thread_Info;


volatile bool keepRunning = true ; 

/*
 * Purpose: To help us work with the threads to go into the square functions
 */
DWORD WINAPI ThreadFunction(LPVOID param){

    Thread_Info *thread_id = (Thread_Info*) param;
    int threadId = thread_id->idnum;
    int count = 0, i;
    double elapsedTime;
    LARGE_INTEGER frequency, startCount, endCount;
    
    printf("Got to procedure ThreadFunc for the thread %d\n", threadId);

    /* 
     * Alternative way to GetSystemTime()
     * https://learn.microsoft.com/en-us/windows/win32/sysinfo/time-functions
    */

    QueryPerformanceFrequency(&frequency);
    QueryPerformanceCounter(&startCount);
    
    for (i=0; i< thread_id->numSquare && keepRunning; i++){
        square(i, &thread_id->squareCount);
        count++;
        printf("This is the %d iteration\n", count);
    }

    QueryPerformanceCounter(&endCount);
    elapsedTime = (double)(endCount.QuadPart - startCount.QuadPart); 
    elapsedTime *= (1000.0 / frequency.QuadPart); 

    printf("Thread %d: Elapsed time is %f milliseconds, "
            "number of innovations are %d\n", 
            thread_id->idnum, elapsedTime, thread_id->squareCount);

    thread_id->finished = true;

    return ERROR_SUCCESS;
}

/*
 * Purpose: Create the threads and ensure the agruments passed are valid
 */
int main(int argc, char * argv[]) {
    
    HANDLE * threads;
    int num_of_threads, deadline, size, i, j;
    bool allThreadsFinished;
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
        if(threads) { free(threads); }
        if(thread_data) { free(thread_data); }
        return ERROR_OUTOFMEMORY;
    }

    for(i = 0; i < num_of_threads; i++){
        thread_data[i].numSquare = size;
        thread_data[i].idnum=i+1;
        thread_data[i].squareCount=0;
        thread_data[i].finished = false;
    }

    /* creating the threads */
    for (i = 0; i < num_of_threads; i++){
        threads[i] = CreateThread(
            NULL, 
            0, 
            ThreadFunction, 
            &thread_data[i], 
            0, 
            NULL
        );
        
        if (threads[i] == NULL){
            printf("Error in procedure CreateThread: Failed to" 
            "create thread %d\n", i);
            
            for(j = 0; j < i; j++){
                CloseHandle(threads[j]);
            }

            free(threads);
            free(thread_data);
            return GetLastError();
        }
    }

    Sleep(deadline*1000);
    
    keepRunning=false;    

    do{
        allThreadsFinished = true;
        for(i = 0; i < num_of_threads; i++){
            if(!thread_data[i].finished){
                allThreadsFinished = false;
                break;
            }
        }
        if(!allThreadsFinished){
            Sleep(100);
        }
    }while(!allThreadsFinished);

    for(i = 0; i < num_of_threads; i++){
        CloseHandle(threads[i]);
    }

    for(i = 0; i < num_of_threads; i++){
        printf("Thread %d: square() was called %d times inside square.\n",
               thread_data[i].idnum, thread_data[i].squareCount);
    }

    free(threads);
    free(thread_data);

    return ERROR_SUCCESS;
}
