#include <stdio.h>
#include <stdlib.h>
#include "square.h"
#include <windows.h>
#include <time.h> 

//thread structure to store thread information  
typedef struct{
	int idnum;
	int numSquare;	
}Thread_Info;

DWORD WINAPI ThreadFunction(LPVOID t){
	(Thread_Info *) thread_data = (Thread_Info *) t;
	int idnum = thread_data->idnum;
	int numSquare = thread_data->numSquare;

	clock_t start_time = clock(); 
	
	int counter = 0; 

	for (int i = 0; (i <= numSquare) && keepRunning; i++){
		Square (i); //perform the square function
		counter ++;
	}
	
	clock_t end_time = clock();
	clock_t time = (start_time - end_time) / CLOCKS_PER_SECOND;
	
	return 0;

}

int main(int argc, char * argv[]){
	int num_of_threads = atoi(argv[1]);
	int deadlines = atoi(argv[2]);
	int size = atoi(argv[3]);

	HANDLE * threads = (HANDLE *)malloc(num_of_threads * sizeof(HANDLE));
	Thread_Info * thread_data = (Thread_Info *)malloc 
					(num_of_threads * sizeof(ThreadData));

	//creating the threads
	for (int i = 0; i < num_of_threads; i++){
		thread_data[i].idnum = i;
		thread_data[i].numSquare = size;
		threads[i] = CreateThread(NULL, 0, ThreadFunction, 
				&thread_data[i], 0, NULL);
	}

	Sleep(deadlines*1000); 

	keepRunning = 0;

	WaitForMultipleObjects(num_of_threads, threads,true, INFINITE);

	free(threads);
	free(malloc);

	return 0;
}
