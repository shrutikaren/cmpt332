/*
 * Jack Donegan, Shruti Kaur
 * lvf165, ich524
 * 11357744, 11339265
 */

#include <square.h>

/*
 * Purpose: Calculate the square of the number provided in the function
 */
int square(int N) {
    int i, currentIndex = -1; 
    bool running = true;

    /* Get the current thread ID */
    thread_id_t currentId;

#ifdef _WIN32
    currentId = GetCurrentThreadId();
#elif defined (USE_UBC_THREADS)
    currentId = MyPid();
#else
    currentId = pthread_self();
#endif

    /* Find the current thread's index */
    for (i = 0; i < num_of_threads && running; i++) {
        if (thread_ids[i] == currentId) {
            running = false;
            currentIndex = i;
        }
    }

    /* Increment the square count for the current thread */
    if (currentIndex < num_of_threads && currentIndex >= 0) {
        squareCounts[currentIndex]++;
    }

    /* Base case */
    if (N == 0) {
        return 0;
    }

    /* Recursive step to calculate the square */
    return square(N - 1) + N + N - 1;

}
