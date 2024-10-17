#ifndef LIST_H
#define LIST_H

/* Including necessary libraries */
#include <stdio.h>
#include <stdlib.h>

#define MIN_LISTS 10
#define MIN_NODES 100

/* Logging Errors in our code. */
#define LOG_ERROR(msg) do {                             \
    fprintf(stderr, "Log [Error] - %s: %s at %s:%d\n",  \
        msg, strerror(errno), __FILE__, __LINE__);      \
    exit(EXIT_FAILURE);                                 \
}while(0)

/* Forward declarations */
typedef struct NODE NODE;
typedef struct LIST LIST;

/* Function Prototypes */





#endif 
