#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "list.h"


#define BUFFER_SIZE 10

/* Implementing a bounded buffer and semaphore*/
typedef struct thread_info_t{
	LIST* buffer;
	int sempahore;
}

thread_info_t thread_info = malloc(sizeof(BUFFER_SIZE));


