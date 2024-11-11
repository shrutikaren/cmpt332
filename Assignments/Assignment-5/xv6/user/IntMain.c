#include <kernel/types.h>
#include <user/user.h>


/* Copied from grind.c for now */
/* from FreeBSD. */
int
do_rand(unsigned long *ctx)
{
/*
 * Compute x = (7^5 * x) mod (2^31 - 1)
 * without overflowing 31 bits:
 *      (2^31 - 1) = 127773 * (7^5) + 2836
 * From "Random number generators: good ones are hard to find",
 * Park and Miller, Communications of the ACM, vol. 31, no. 10,
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
    hi = x / 127773;
    lo = x % 127773;
    x = 16807 * lo - 2836 * hi;
    if (x < 0)
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
    *ctx = x;
    return (x);
}

unsigned long rand_next = 1;

int
rand(void)
{
    return (do_rand(&rand_next));
}


int square(int value){
	return value * value;
}

int main(){
	int sleeping, square_limit, square_count, obtained_value;
	int child_proc = 10; /* Randomly picked a number for the child process*/
	int Pid;

	/* Iterating through the number of child process */
	for (int i = 0; i < child_proc; i++){
		Pid = fork();
		
		/* If neg number, then that's a problem */
		if (Pid < 0) {
			printf("The obtained Pid value is invalid.\n");
			exit(1);
		}	

		/* If it is 0, we have  child process */
		else if (Pid == 0){
			/* Using modulus because I want it to be between 0 and 
  			999 and stay within this limit */
			sleeping = rand() % 1000;
			square_limit = 100; /* Could be any number */
			square_count = rand() % square_limit;
			obtained_value = 0;

			for (int i = 0; i < square_count; i++){
				obtained_value = square(i);
			}
			
			sleep(sleeping * 1000);
			
			printf("Child process obtained successfully with the Pid is %i and the obtained value is %i.\n", getpid(), obtained_value);
			exit(0);
		}
	}
	
	/* Now, we want to make sure that all the child processes are done 
  	before we leave so we would have to wait for all of them to complete */
	for (int i = 0; i < child_proc; i++){
		wait(0);		
	}

	printf("Our testing is done and we reached the end of our main() function.\n");
}
