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
int square(int N){

    // int counter -> (*counter)++

	if (N == 0) {
 		return 0;
	}
	return square(N - 1) + N + N - 1; 
}
