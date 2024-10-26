#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#define FULL_BUFFER_SIZE 10

/* Implementing a bounded buffer and mutex*/
typedef struct buffer{
	int buffer[FULL_BUFFER_SIZE];
	int buffer_size;
	int left;
	int right;
	int mutex; 
}

/* Creating the variables and initializing those variables*/
int main_mutex;
buffer* buffer_created = (struct buffer*)malloc(sizeof(struct buffer));
main_mutex = mtx_create(buffer_created->mutex);

/* Produces an item inside the buffer */
void P(){
	/* Checks if no item in the buffer */
	
	/* If no item inside list*/

	/* If item inside list */

}

void V(){
	/* Check if the buffer is full */

	
}


