#ifndef LIST_H
#define LIST_H

/* Including necessary libraries */
#include <stdio.h>
#include <stdlib.h>

/* Logging Errors in our code. */
#define LOG_ERROR(msg) do {                             \
    fprintf(stderr, "Log [Error] - %s: %s at %s:%d\n",  \
        msg, strerror(errno), __FILE__, __LINE__);      \
    exit(EXIT_FAILURE);                                 \
}while(0)

#endif 
