/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

/*
 * Lab 6: Scheduler Simulator
 * CMPT 332 Fall 2018
 * University of Saskatchewan
 */

#include <stdio.h>

#include <os.h>
#include <list.h> /* Adding this list.h to our function header*/

#define SCHEDULER_QUANTUM 25

#define BLOCK_MAXIMUM 50
#define BLOCK_CHANCE 3
#define WORK_MAXIMUM 50
#define NUM_PRIORITIES 5

void panic(const char *msg) {
    fprintf(stderr, "[PANIC] %s\n", msg);
    exit(1);
}

void error(const char *msg) {
    fprintf(stderr, "[ERROR] %s\n", msg);
}

enum pstate {NONE, RUNNING, RUNNABLE, BLOCKING};

struct proc {
    PID pid;
    enum pstate state;
    int priority;
};

static int ncpu;

static struct {
    int mutex;
    int running;
    struct proc *procs;
    size_t size;
} ptable;

static PID scheduler_pid;

/* Queue for different priorities */
LIST_HANDLE runningq[NUM_PRIORITIES];

/* Returns the next process to run or NULL if there is nothing runnable */
struct proc *next_proc() {
    struct proc *p;
    int priority;

    /* Go through priority queues starting from the highest priority */
    for (priority = 0; priority < NUM_PRIORITIES; priority++) {
        while ((p = ListFirst(runningq[priority]))) {
            if (p->state == RUNNABLE) {
                return p;
            }
        }
    }
    return NULL;
}

/* Scheduler entry point */
void scheduler(void *arg) {
    struct proc *p;
    (void)arg; /* Suppress unused parameter warning */

    for (;;) {
        if (P(ptable.mutex)) panic("invalid ptable mutex");

        while (ptable.running < ncpu) {
            p = next_proc();
            if (!p) break;
            if (Resume(p->pid)) continue;
            p->state = RUNNING;
            ptable.running += 1;
        }

        if (V(ptable.mutex)) panic("invalid ptable mutex");

        Sleep(SCHEDULER_QUANTUM);
    }
}

/* Sets the process state */
void set_state(enum pstate state) {
    PID pid;
    struct proc *p;
    pid = MyPid();

    if (state == RUNNING && pid != scheduler_pid)
        panic("only the scheduler can set things to running!");

    if (P(ptable.mutex)) panic("invalid ptable mutex");

    for (p = ptable.procs; p < &ptable.procs[ptable.size]; p++) {
        if (p->pid != pid) continue;

        /* Don't do anything if it's the same state */
        if (p->state == state) break;

        /* If the process was running, decrease the running count */
        if (p->state == RUNNING) {
            ptable.running -= 1;
        }

        if (state == RUNNABLE) {
            /* Add to the runnable queue by priority */
            ListAdd(runningq[p->priority], p);
        }

        p->state = state;
        break;
    }

    if (V(ptable.mutex)) panic("invalid ptable mutex");
}

/* Returns the priority of the calling process */
int get_priority() {
    PID pid;
    struct proc *p;
    int priority = -1;

    pid = MyPid();

    if (P(ptable.mutex)) panic("invalid ptable mutex");

    for (p = ptable.procs; p < &ptable.procs[ptable.size]; p++) {
        if (p->pid != pid) continue;
        priority = p->priority;
        break;
    }

    if (V(ptable.mutex)) panic("invalid ptable mutex");

    return priority;
}

/* Causes the running process to yield to others */
void yield() {
    set_state(RUNNABLE);
    Suspend();
}

/* Simulates a blocking call */
void block(unsigned int time) {
    set_state(BLOCKING);
    Sleep(time);
    yield();
}

/* Process entry point */
void process(void *arg) {
    char *name = (char *)arg;

    set_state(RUNNABLE);
    /* We need to wait for the scheduler to let us start. */
    Suspend();

    for (;;) {
        if (rand() % BLOCK_CHANCE == 0) {
            printf("%s is start block.\n", name);
            block(rand() % BLOCK_MAXIMUM);
            printf("%s is done blocking.\n", name);
        } else {
            printf("%s is running. (priority %d)\n", name, get_priority());
            Sleep(rand() % WORK_MAXIMUM);
            yield();
        }
    }
}

/* Main function */
int mainp(int argc, char **argv) {
    PID pid;
    char *name;
    int i;
    struct proc *p;

    srand(0);

    if (argc != 3) {
        printf("usage: %s nproc ncpu\n", argv[0]);
        exit(1);
    }

    ptable.size = atoi(argv[1]);
    if (ptable.size <= 0) {
        printf("nproc must be greater than 0\n");
        exit(1);
    }

    ncpu = atoi(argv[2]);
    if (ncpu <= 0) {
        printf("ncpu must be greater than 0\n");
        exit(1);
    }

    /* Initialize priority queues */
    for (i = 0; i < NUM_PRIORITIES; i++) {
        runningq[i] = ListCreate();
    }

    ptable.running = 0;
    ptable.procs = calloc(ptable.size, sizeof(struct proc));
    if (ptable.procs == NULL) {
        panic("Unable to allocate ptable.");
    }

    ptable.mutex = NewSem(1);
    if (ptable.mutex == -1) {
        panic("Unable to create semaphore for ptable.");
    }

    scheduler_pid = Create(scheduler, 4096, "scheduler", NULL, HIGH, USR);
    if (scheduler_pid == PNUL) {
        panic("Unable to create scheduler thread.");
    }

    for (i = 0; i < ptable.size; i++) {
        name = malloc(32);
        if (name == NULL) {
            panic("Unable to allocate memory for name");
        }
        sprintf(name, "process_%d", i);

        pid = Create(process, 4096, name, name, NORM, USR);
        if (pid == PNUL) {
            panic("Unable to create thread for process.");
        }

        p = &ptable.procs[i];
        p->pid = pid;
        p->state = NONE;
        p->priority = rand() % NUM_PRIORITIES;
    }

    return 0;
}
