/*
 * Jack Donegan, Shruti Kaur
 * lvf165, ich524
 * 11357744, 11339265
 */

#ifndef SQUARE_H
#define SQUARE_H

#include <stdbool.h>

/* Check if compiling for Windows, UBC threads, or POSIX threads */
#ifdef _WIN32
    #include <windows.h>  
    #include <time.h> 
    typedef DWORD thread_id_t;  
#elif defined (USE_UBC_THREADS)
    #include <standards.h>
    #include <os.h>
    typedef PID thread_id_t;
#else
    #include <pthread.h>  
    #include <sys/time.h>  
    typedef pthread_t thread_id_t;
#endif

/* Global variables declared as extern */
extern volatile bool keepRunning;
extern volatile int *squareCounts;
extern volatile thread_id_t *thread_ids;
extern int num_of_threads;

/* Function declaration for the square function */
int square(int N);

#endif
