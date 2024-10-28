/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#include <Monitor.h>
#include <stdlib.h>


/* Static Monitor Instance */
static Monitor mon;

/**
 * Initialize the monitor.
 */ 
void MonInit(void) {
    int i;

    /* Initialize queues used for debugging purposes */
    mon.urgent_queue = ListCreate();
    if (mon.urgent_queue == NULL) {
        LOG_ERROR("Failed to create urgent_queue in MonInit.");
    }

    mon.enter_queue = ListCreate();
    if (mon.enter_queue == NULL) {
        LOG_ERROR("Failed to create enter_queue in MonInit.");
    }

    /* Initialize semaphores for entering monitor and accessing queues */
    mon.urgent_sem = NewSem(0);
    if (mon.urgent_sem < 0) {
        LOG_ERROR("Failed to create urgent_sem in MonInit.");
    }

    mon.enter_mtx = NewSem(1);  
    if (mon.enter_mtx < 0) {
        LOG_ERROR("Failed to create enter_mtx in MonInit.");
    }

    mon.enter_queue_sem = NewSem(1);
    if (mon.enter_queue_sem < 0) {
        LOG_ERROR("Failed to create enter_queue_sem in MonInit.");
    }

    /* Initialize all condition variables */
    for (i = 0; i < k; ++i) {
        mon.cond_vars[i].wait_queue = ListCreate();
        if (mon.cond_vars[i].wait_queue == NULL) {
            LOG_ERROR("Failed to create wait_queue for condition variable in MonInit.");
        }

        mon.cond_vars[i].sem = NewSem(0);   /* Initialize semaphore to 0 */
        if (mon.cond_vars[i].sem < 0) {
            LOG_ERROR("Failed to create semaphore for condition variable in MonInit.");
        }
    }

    printf("Monitor initialized successfully.\n");
}

/**
 * Enter the monitor.
 */ 
void MonEnter(void) {
    PID* my_pid;

    /* Allocate memory for the current PID */
    my_pid = malloc(sizeof(PID));
    if (my_pid == NULL) {
        LOG_ERROR("Failed to allocate memory for PID in MonEnter.");
    }

    /* Get the current thread's PID */
    *my_pid = MyPid();
    printf("MonEnter: Thread %d is attempting to enter the monitor.\n", *my_pid);

    /* Add the thread to the enter_queue */
    P(mon.enter_queue_sem);
    ListAppend(mon.enter_queue, (void*)my_pid);  /* Use ListAppend for FIFO */
    printf("MonEnter: Thread %d added to enter_queue.\n", *my_pid);
    V(mon.enter_queue_sem);

    /* Acquire the monitor lock */
    P(mon.enter_mtx);
    printf("MonEnter: Thread %d acquired the monitor lock.\n", *my_pid);
}

/**
 * Leave the monitor.
 */ 
void MonLeave(void) {
    PID* trimmed_pid;

    printf("MonLeave: Thread leaving the monitor.\n");

    /* Check if there are urgent threads waiting */
    if (ListCount(mon.urgent_queue) > 0) {
        /* Remove the first thread from urgent_queue */
        trimmed_pid = (PID*)ListRemove(mon.urgent_queue); /* FIFO */
        if (trimmed_pid == NULL) {
            LOG_ERROR("Failed to remove from urgent_queue in MonLeave.");
        }
        printf("MonLeave: Signaling urgent thread %d.\n", *trimmed_pid);
        free(trimmed_pid);
        V(mon.urgent_sem);  /* Signal the urgent semaphore */
    }
    /* Else, check if there are threads waiting to enter the monitor */
    else if (ListCount(mon.enter_queue) > 0) {
        /* Remove the first thread from enter_queue */
        trimmed_pid = (PID*)ListRemove(mon.enter_queue); /* FIFO */
        if (trimmed_pid == NULL) {
            LOG_ERROR("Failed to remove from enter_queue in MonLeave.");
        }
        printf("MonLeave: Signaling thread %d to enter the monitor.\n", *trimmed_pid);
        free(trimmed_pid);
        V(mon.enter_mtx);  /* Signal the enter mutex semaphore */
    }
    /* If no threads are waiting, simply release the monitor lock */
    else {
        V(mon.enter_mtx);
        printf("MonLeave: Monitor lock released, no waiting threads.\n");
    }
}

/**
 * Wait on a condition variable.
 */ 
void MonWait(int cv) {
    PID* my_pid;

    /* Validate condition variable ID */
    if (cv < 0 || cv >= k) {
        LOG_ERROR("Invalid condition variable ID in MonWait.");
    }

    /* Allocate memory for the current PID */
    my_pid = malloc(sizeof(PID));
    if (my_pid == NULL) {
        LOG_ERROR("Failed to allocate memory for PID in MonWait.");
    }

    /* Get the current thread's PID */
    *my_pid = MyPid();
    printf("MonWait: Thread %d is waiting on condition variable %d.\n", *my_pid, cv);

    /* Add the thread to the condition variable's wait_queue */
    ListAppend(mon.cond_vars[cv].wait_queue, (void*)my_pid);  /* Use ListAppend for FIFO */
    printf("MonWait: Thread %d added to condition variable %d's wait_queue.\n", *my_pid, cv);

    /* Release the monitor lock */
    MonLeave();

    /* Wait on the condition variable's semaphore */
    P(mon.cond_vars[cv].sem);
    printf("MonWait: Thread %d was signaled on condition variable %d.\n", *my_pid, cv);

    /* Re-acquire the monitor lock */
    MonEnter();
}

/**
 * Signal a condition variable.
 */ 
void MonSignal(int cv) {
    PID* waiting_pid;

    /* Validate condition variable ID */
    if (cv < 0 || cv >= k) {
        LOG_ERROR("Invalid condition variable ID in MonSignal.");
    }

    /* Check if there are threads waiting on the condition variable */
    if (ListCount(mon.cond_vars[cv].wait_queue) > 0) {
        /* Remove the first thread from the condition variable's wait_queue */
        waiting_pid = (PID*)ListRemove(mon.cond_vars[cv].wait_queue);  /* FIFO */
        if (waiting_pid == NULL) {
            LOG_ERROR("Failed to remove from condition variable's wait_queue in MonSignal.");
        }

        printf("MonSignal: Signaling thread %d on condition variable %d.\n", *waiting_pid, cv);

        /* Signal the condition variable's semaphore to wake up the waiting thread */
        V(mon.cond_vars[cv].sem);

        /* No need to add to urgent_queue or allocate new PIDs */
        free(waiting_pid);
    } else {
        printf("MonSignal: No threads waiting on condition variable %d.\n", cv);
    }
}
