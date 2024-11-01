/*
 * Name: KAUR Shruti
 * NSID: ICH524
 * Student Number: 11339265
 * */

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

typedef struct MemSpace{
	int size;
	int startAddress;
	struct Memspace* next;
}MemSpace;


/* Variabls defined ouside the function */
static int totalMem = memsize;
static MemSpace* list = NULL;

/*
 * Intialize(void) has a void parameter with a void 
 * return type. This helps to iniialize our list with
 * the data type of MemSpace.
 * */
void Initialize(void){
	list = (MemSpace*)malloc(sizeof(MemSpace));

	/* Case One: list is empty */
	if (list == NULL){
		printf("Failed to allocate memory to our memory list");
		return;
	}
	
	/* Case Two: list is not empty */
	list->size = totalMem;
	list->startAddress = 0;
	list->next = NULL;
}

/*
 * BF-Allocate is responsible for allocating memory. 
 * The parameter size is the size of the memory that we
 * are trying to allocate. 
 * */
void BF-Allocate(int size){
	MonEnter();
	
	/* Creating four main spaces*/
	MemSpace* current = list;
	MemSpace* previous = NULL;
	MemSpace* bestfit = NULL;
	MemSpace* bestfitprev = NULL;

	/* Iterate through list and find the best-fit block */
	while (current != NULL){
		if (current->size >= size){
			/* Case One: bestfit block is NULL, or
 			   Case Two: current-> size is smaller
			   than what we have inside our bestfit
			   block */
			if (bestfit == NULL || current->size < bestfit->size){
				bestfit = current;
				bestfitprev = prev;
			}
		}
		/* Move the current block to the next block */
		prev = current;
		current = current->next;
	}
	
	/* By now, you should either have a list or not. Now, 
 	   handling the case when we don't have a suitable list. */
	if (bestfit == NULL){
		MonWait(Read);
		MonLeave();
		return;
	}

	/* If a bestfit list exists, we will allocate the block */
	if (bestfit->size > size){
		MemSpace* newblock = (MemSpace*)malloc(sizeof(MemSpace));
		newblock->startAddress = bestfit->startAddress + size; 
		newblock->size = bestfit->size - size;
		newblock->next = bestfit->next;
		bestfit->next = newblock;
	}

	/* Upating the best-fit spacee */
	if (bestfitprev == NULL){
		list = bestfit->next;
	} else{
		bestfitprev->next = bestfit->next;
	}
	
	free(bestfit);
	MonLeave();	
}

void Free(int startAddress, int size){
	MonEnter();
	
}
