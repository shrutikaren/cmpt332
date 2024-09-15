#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include "square.h"

// Global flag to control thread execution
volatile BOOL keepRunning = TRUE;

// Thread function skeleton
DWORD WINAPI ThreadFunc(LPVOID param) {
	
    int threadId = *(int*)param;
    
	printf("Got to procedure ThreadFunc for thread %d\n", threadId);

    return 0;
}

int main(int argc, char *argv[]) {
    printf("Got to procedure main\n");

    // Check if the correct number of arguments are passed
    if (argc != 4) {
        printf("Error in procedure main: Invalid number of parameters\n");
        return -1;
    }

    // Parse arguments
    int threads = atoi(argv[1]);
    int deadline = atoi(argv[2]);
    int size = atoi(argv[3]);

    // Validate arguments
    if (threads <= 0) {
        printf("Error in procedure main: Invalid # of threads\n");
        return -1;
    }
    if (deadline <= 0) {
        printf("Error in procedure main: Invalid # of deadline\n");
        return -1;
    }
    if (size <= 0) {
        printf("Error in procedure main: Invalid # of size\n");
        return -1;
    }

    // Allocate memory for thread handles and IDs
    HANDLE *threadHandles = (HANDLE*)malloc(sizeof(HANDLE) * threads);
    int *threadIds = (int*)malloc(sizeof(int) * threads);
    if (!threadHandles || !threadIds) {
        printf("Error in procedure main: Memory allocation failed\n");
        return -1;
    }

    // Create threads
    for (int i = 0; i < threads; i++) {
        threadIds[i] = i;
        threadHandles[i] = CreateThread(NULL, 0, ThreadFunc, &threadIds[i], 0, NULL);
        if (threadHandles[i] == NULL) {
            printf("Error in procedure CreateThread: Failed to create thread %d\n", i);
            return -1;
        }
    }

    // Sleep for the deadline (in milliseconds)
    Sleep(deadline * 1000);

    // Cleanup
    for (int i = 0; i < threads; i++) {
        CloseHandle(threadHandles[i]);
    }

    free(threadHandles);
    free(threadIds);

    printf("Got to procedure main: Terminating successfully\n");
    return 0;
}
