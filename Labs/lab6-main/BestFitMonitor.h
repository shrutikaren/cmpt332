/*
 * Name: KAUR Shruti
 * NSID: ICH524
 * Student Number: 11339265
 * */

#ifndef BESTFITMONITOR_H
#define BESTFITMONITOR_H

#include <stdio.h>
#include <Monitor.h>

#define maxSleepTime 2
#define maxAllocation 20480
#define freeProability 0.3
#define numberOfIterations 1000
#define memsize 102400
#define CondVariables 15
#define Write 1
#define Read 0
#define memAvail 0 

typedef struct MemSpace{
	int size;
	int startAddress;
	struct Memspace* next;
}MemSpace;

/*void Free(int startAddress, int size);*/
void BF_Allocate(int size);
void Initialize(void);

#endif /* BESTFITMONIOR_H */
