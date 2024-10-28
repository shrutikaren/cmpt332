#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "uthread.h"
#define FULL_BUFFER_SIZE 10

mutex_t * mutex;
/* Implementing a bounded buffer and mutex*/
int buffer[FULL_BUFFER_SIZE];
int left;
int right;
int buffer_count; /* The shared variable*/
int mutex_id;

/* Produces an item inside the buffer */
void P(void){
	while (1){
		mutex = malloc(sizeof(mutex_t));
		mtx_lock(mutex->locked);
		if (buffer_count < FULL_BUFFER_SIZE){
			buffer_count ++;
		}	
		mtx_unlock(mutex_id);
	}
	thread_yield(); /* Put it into a RUNNABLE state*/
}

void V(void){
	while(1){
	/* Check if the buffer is full */
		mutex = malloc(sizeof(mutex_t));
		mtx_lock(mutex->locked);
		if (buffer_count > 0){
			buffer_count --;
		}
		mtx_unlock(mutex_id);
	 		
	}
	thread_yield(); /* Put it into the RUNNABLE queue*/
}

int main(int argc, char *argv[]){
	mutex_id = mtx_create(0);
	thread_init();
	thread_create(P);
	thread_create(V);
	return 0;
}





