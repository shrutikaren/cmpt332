// uthead.h

#ifndef UTHEAD_H  // Include guard to prevent multiple inclusions
#define UTHEAD_H

#include <stdint.h>

// Possible states of a thread
#define FREE        0x0
#define RUNNING     0x1
#define RUNNABLE    0x2

#define STACK_SIZE  8192
#define MAX_THREAD  4

// Mutex constants
#define MUTEX_SIZE  256

// Thread structure
struct thread {
    char       stack[STACK_SIZE]; /* The thread's stack */
    int        state;             /* FREE, RUNNING, RUNNABLE */
    
    /* Saved registers */
    uint64_t   s0;
    uint64_t   s1;
    uint64_t   s2;
    uint64_t   s3;
    uint64_t   s4; 
    uint64_t   s5;
    uint64_t   s6;
    uint64_t   s7;
    uint64_t   s8;
    uint64_t   s9;
    uint64_t   s10;
    uint64_t   s11;
};

// Mutex structure
typedef struct mutex_t {
    int locked; /* Locked state */
} mutex_t;

// External declarations for global variables
extern struct thread all_thread[MAX_THREAD];
extern struct thread *current_thread;
extern struct mutex_t* all_m[MUTEX_SIZE];

// Function prototypes
void thread_init(void);
void thread_schedule(void);
void thread_create(void (*func)());
void thread_yield(void);
void thread_a(void);
void thread_b(void);
void thread_c(void);

// Mutex functions
int mtx_create(int locked);
int mtx_lock(int lock_id);
int mtx_unlock(int lock_id);

#endif // UTHEAD_H

