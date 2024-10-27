#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include <stdint.h>
/* CMPT 332 GROUP 01, FALL 2024*/
#include <stddef.h>

/* Possible states of a thread: */
#define FREE        0x0
#define RUNNING     0x1
#define RUNNABLE    0x2

#define STACK_SIZE  8192
#define MAX_THREAD  4

/* CMPT 332 GROUP 01, FALL 2024*/
#define MUTEX_SIZE  256
typedef struct mutex_t{
  int locked; /* locked state */
} mutex_t;

struct thread {
  char       stack[STACK_SIZE]; /* the thread's stack */
  int        state;             /* FREE, RUNNING, RUNNABLE */
  
  /* CMPT 332 GROUP 01, FALL 2024 */
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
struct thread all_thread[MAX_THREAD];
struct thread *current_thread;
extern void thread_switch(uint64, uint64);

/* CMPT 332 GROUP 01, FALL 2024*/
struct mutex_t* all_m[MUTEX_SIZE];
static int m_count = 0;

void 
thread_init(void)
{
  // main() is thread 0, which will make the first invocation to
  // thread_schedule().  it needs a stack so that the first thread_switch() can
  // save thread 0's state.  thread_schedule() won't run the main thread ever
  // again, because its state is set to RUNNING, and thread_schedule() selects
  // a RUNNABLE thread.
  current_thread = &all_thread[0];
  current_thread->state = RUNNING;
}

void 
thread_schedule(void)
{

  /* CMPT 332 GROUP 01, FALL 2024 */
  /* initializing the threads first */
  /*struct thread *t = (struct thread*)malloc(sizeof(struct thread));*/
  struct thread *next_thread = (struct thread*)malloc(sizeof(struct thread));
  uint64_t current_stack, next_stack;
  current_stack = (uint64_t)current_thread->stack; 
  next_stack = (uint64_t)next_thread->stack;

  /* Find another runnable thread. */
  next_thread = 0;
  current_thread = current_thread + 1;
  for(int i = 0; i < MAX_THREAD; i++){
    if(t >= all_thread + MAX_THREAD)
      t = all_thread;
    if(t->state == RUNNABLE) {
      next_thread = t;
      break;
    }
    t = t + 1;
  }

  if (next_thread == 0) {
    printf("thread_schedule: no runnable threads\n");
    exit(-1);
  }

  if (current_thread != next_thread) {         /* switch threads?  */
    next_thread->state = RUNNING;
    t = current_thread;
    current_thread = next_thread;

    /* CMPT 332 GROUP 01, FALL 2024 */
    thread_switch(current_stack, next_stack);
  } else
    next_thread = 0;
}

void 
thread_create(void (*func)())
{
  
  /* CMPT 332 GROUP 01, FALL 2024 */
  struct thread *t = (struct thread *) malloc (sizeof(struct thread));

  for (t = all_thread; t < all_thread + MAX_THREAD; t++) {
    if (t->state == FREE) break;
  }
  t->state = RUNNABLE;
  
}

void 
thread_yield(void)
{
  current_thread->state = RUNNABLE;
  thread_schedule();
}

volatile int a_started, b_started, c_started;
volatile int a_n, b_n, c_n;

void 
thread_a(void)
{
  int i;
  printf("thread_a started\n");
  a_started = 1;
  while(b_started == 0 || c_started == 0)
    thread_yield();
  
  for (i = 0; i < 100; i++) {
    printf("thread_a %d\n", i);
    a_n += 1;
    thread_yield();
  }
  printf("thread_a: exit after %d\n", a_n);

  current_thread->state = FREE;
  thread_schedule();
}

void 
thread_b(void)
{
  int i;
  printf("thread_b started\n");
  b_started = 1;
  while(a_started == 0 || c_started == 0)
    thread_yield();
  
  for (i = 0; i < 100; i++) {
    printf("thread_b %d\n", i);
    b_n += 1;
    thread_yield();
  }
  printf("thread_b: exit after %d\n", b_n);

  current_thread->state = FREE;
  thread_schedule();
}

void 
thread_c(void)
{
  int i;
  printf("thread_c started\n");
  c_started = 1;
  while(a_started == 0 || b_started == 0)
    thread_yield();
  
  for (i = 0; i < 100; i++) {
    printf("thread_c %d\n", i);
    c_n += 1;
    thread_yield();
  }
  printf("thread_c: exit after %d\n", c_n);

  current_thread->state = FREE;
  thread_schedule();
}

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_create(int locked){
   int locked_id;
   if (m_count > MUTEX_SIZE){
	return -1;
   }
   mutex_t *m = (mutex_t *)malloc(sizeof(mutex_t));
   
   if (m == NULL){
	return -1;
   }
   m->locked = locked;
   all_m[m_count++] = m;

   locked_id = m_count++;
   return locked_id;
}

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_lock(int lock_id){
   mutex_t* m = all_m[lock_id];
   while (m->locked){
	/* wait indefinitely */
   }
   m->locked = 0;
   return 0;
}

/* CMPT 332 GROUP 01, FALL 2024*/
int mtx_unlock(int lock_id){
   mutex_t* m = all_m[lock_id];
   while (!m->locked){return -1;}
   m->locked = 1;
   return 0;
}

int main(int argc, char *argv[]) 
{
  a_started = b_started = c_started = 0;
  a_n = b_n = c_n = 0;
  thread_init();
  thread_create(thread_a);
  thread_create(thread_b);
  thread_create(thread_c);
  thread_schedule();
  exit(0);
}
