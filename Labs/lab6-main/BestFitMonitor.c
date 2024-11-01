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
 * 
 * */
void BF-Allocate(int size){
}

void Free(){}
