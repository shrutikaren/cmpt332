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
				bestfitprev = previous;
			}
		}
		/* Move the current block to the next block */
		previous = current;
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
	
	MemSpace* newblock = (MemSpace*)malloc(sizeof(MemSpace));
	newblock->size = size;
	newblock->startAddress = startAddress;
	newblock->next = NULL;

	/* Insert our block into the freelist */
	if (list == NULL){
		list = newblock;
	}	
	else{
		/* Find a way to put back our block into the free
 		   space that we have available */
		while (current != NULL && current->startAddress < startAddress){
			/* Ensures that the pointers keep moving 
 			   continuously. By the time we get to 
			   the end of the for-loop, current block
			   will be right before the new block. */
			previous = current;
			current = current->next;
		} 
		
		/* newblock can now be inserted just right between
 		   previous and current block */
		newblock->next = current;
		if (previous == NULL){
			list = previous;
		} else {
			previous->next = newblock;
		}

	}

	/* By now, we have successfully added our newblock between the
 	   current and previous blocks. We will now combine the free
	   blocks if two blocks are close to each other. */
	while (current != NULL && current->next != NULL){
		if (current->startAddress + current->size == 
		current->next->startAddress){
			/* To combine the blocks, only two things needs
 			   to be done which is to increase the size and
			   moving the pointer of current->next*/
			current->size += current->next->size;
			current->next = current->next->next;
		}
		/* Helps us to move the pointer which is necessary by
 		   the pointer */
		current->next = current->next->next;
	}
	MonSignal(Read);
	MonLeave();
}
