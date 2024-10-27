#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "uthread.h"

#define FULL_BUFFER_SIZE 10

/* Implementing a bounded buffer and mutex*/
int buffer[FULL_BUFFER_SIZE];
int left;
int right;
int buffer_count; /* The shared variable*/
mutex_t* mutex;

/* Produces an item inside the buffer */
void P(void){
	while (1){
		mtx_lock(mutex->locked);
		if (buffer_count < FULL_BUFFER_SIZE){
			buffer_count ++;
		}	
		mtx_unlock(mutex->locked);
	}
	thread_yield(); /* Put it into a RUNNABLE state*/
}

void V(void){
	while(1){
	/* Check if the buffer is full */
		mtx_lock(mutex->locked);
		if (buffer_count > 0){
			buffer_count --;
		}
		mtx_unlock(mutex->unlocked);
	 		
	}
	thread_yield(); /* Put it into the RUNNABLE queue*/
}

int main(int argc, char *argv[]){
	mutex = mtx_create(0);
	thread_init();
	thread_create(P);
	thread_create(V);
	return 0;
}
