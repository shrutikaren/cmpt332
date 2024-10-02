/*
 * Jack Donegan, Shruti Kaur
 * lvf165, ich524
 * 11357744, 11339265
 */

#ifndef SQUARE_H
#define SQUARE_H

#include <stdbool.h>

extern volatile bool keepRunning ; 
extern volatile int *squareCounts;
extern volatile DWORD *thread_ids;
extern int num_of_threads;

int square(int N);

#endif
