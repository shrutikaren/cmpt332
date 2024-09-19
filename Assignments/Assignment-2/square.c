i#include <square.h>
#include <stdio.h>

volatile int keepRunning = 1; 

/*
 * Purpose: Calculate the square of the number provided in the function
 */
int square(int N){
	if (N == 0) {
 		return 0;
	}
	return square(N - 1) + N + N - 1; 
}


