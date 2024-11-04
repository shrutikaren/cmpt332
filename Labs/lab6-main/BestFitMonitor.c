/*
 * Name: KAUR Shruti
 * NSID: ICH524
 * Student Number: 11339265
 * */

#include <stdio.h>
#include <BestFitMonitor.h>
#include <stdint.h>

#define DEBUG 0

/* Variabls defined ouside the function */
static int totalMem = memsize;
static MemSpace* list = NULL;

/*
 * Intialize(void) has a void parameter with a void 
 * return type. This helps to iniialize our list with
 * the data type of MemSpace.
 * */
void Initialize(void){
	if (DEBUG) {printf("Initializing the monitor.\n");}
	MonInit();
	if (DEBUG) {printf("Coming out of the monitor initialization.\n");}
	list = (MemSpace*)malloc(sizeof(MemSpace));

	/* Case One: list is empty */
	if (list == NULL){
		printf("Failed to allocate memory to our memory list\n");
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
void* BF_Allocate(int size){
	MemSpace* current;
	MemSpace* previous;
	MemSpace* bestfit;
	MemSpace* bestfitprev;	
		
	/*if(DEBUG){ printf("Initializing the monitor.\n"); }
	MonInit();
	if(DEBUG){ printf("Initialized the monitor.\n"); }
	*/

	if(DEBUG){ printf("Entering the monitor.\n"); }
	
 	MonEnter();
	
	/* Creating four main spaces*/
	if(DEBUG){ printf("Entered the monitor.\n"); }
	
	if (list == NULL){
		LOG_ERROR("Error: Memory List is Null");
		MonLeave();
		return NULL;
	}
	
	current = list;
	previous = NULL;
	bestfit = NULL;
	bestfitprev = NULL;
	
	/* Adding this part of the code to try to resolve see fault */
	if (current == NULL){
		MonLeave();
		LOG_ERROR("Error: List is NULL.");
		return NULL;
	}	
	
	
	if(DEBUG){ printf("Entering the while loop.\n"); }
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
	
	if(DEBUG){ printf("FInished the while loop .\n"); }
	/* By now, you should either have a list or not. Now, 
 	   handling the case when we don't have a suitable list. */
	if (bestfit == NULL){
		MonWait(Read);
		MonLeave();
		/* Prevously, I was returning the startAddress of a block. 
 		   that is not acceptable because by this pont, we would
		   have current as NULL so we were trying to access a
		   NULL pointer. */
		return NULL;
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
	
	MonLeave();	
	return (void*)(uintptr_t) bestfit->startAddress;
}

void BF_Free(int startAddress, int size){
	MemSpace* newblock;
	MemSpace* current;
	MemSpace* previous;

	current = list;
	previous = NULL;

	MonEnter();
	
	newblock = (MemSpace*)malloc(sizeof(MemSpace));
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
			list = newblock;
		} else {
			previous->next = newblock;
		}

	}

	/* By now, we have successfully added our newblock between the
 	   current and previous blocks. We will now combine the free
	   blocks if two blocks are close to each other. */
	current = list; 
	while (current != NULL && current->next != NULL){
		/* If the starting address of where I am ending my current
 		   and where my current-> next starts is the same then it 
		   means that I can free that specific block */
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
		else{
			current = current->next;
		}
	}
	MonSignal(Read);
	MonLeave();
}
