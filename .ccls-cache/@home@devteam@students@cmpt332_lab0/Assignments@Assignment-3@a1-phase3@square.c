/*
 * Jack Donegan, Shruti Kaur
 * lvf165, ich524
 * 11357744, 11339265
 */

#include "square.h"
#include <stdio.h>
#include <windows.h>

/*
 * Purpose: Calculate the square of the number provided in the function
 */
int square(int N){

    int i;
    bool running = true;

    DWORD currentId = GetCurrentThreadId();

    for(i = 0; i < num_of_threads && running; i++){
        if(thread_ids[i] == currentId){
            running = false;
        }
    }

    if(i < num_of_threads){
        squareCounts[i]++;
    }

	if (N == 0) {
 		return 0;
	}

	return square(N - 1) + N + N - 1; 

}
