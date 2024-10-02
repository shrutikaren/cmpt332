/*
 * Jack Donegan, Shruti Kaur
 * lvf165, ich524
 * 11357744, 11339265
 */

#include "square.h"
#include <stdio.h>

/*
 * Purpose: Calculate the square of the number provided in the function
 */
int square(int N, int* count){

    if(!keepRunning){
        return 0;
    }

    (*count)++;

	if (N == 0) {
 		return 0;
	}

	return square(N - 1, count) + N + N - 1; 

}
