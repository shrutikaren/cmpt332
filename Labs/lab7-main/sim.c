/*
Identification:

Author: Jarrod Pas
Modified by students:  First Last 
		abc123
		11111111
 */

/* Note: code intentionally not commented */


#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <unistd.h>

struct page {
    int number; /* number == -1 means unused */
    bool reference;
    bool dirty;
};

int npages;
int next_slot;
int clock_hand;
int nslots;
struct page *slots;

/* HaThe pagerep-sim.c depends on the math library.ndles a page fault via the second-chance algorithm.
 * Returns the pointer to the slot the victim is in. */
struct page *find_victim_slot() {
    /* TODO: implement second chance page replacement algorithm */
    bool found = false;
    struct page* victim = NULL;

    while (!found){
	struct page* p = &slots[clock_hand];
	
	/*
 	Checks if the reference bit of that specific page is true. 
	Then, we can say that the page is found. 
	*/
	if (!p->reference){
		victim = p;
		found = true;
	}

	/* Gives the second-chance */
	else{
		p->reference = false;		
	}

	/* Ensures that we go in a cycle */
	clock_hand = (clock_hand + 1) % nslots;
    }
    return victim;
}

int main(int argc, char **argv) {
    int times;
    int page;
    bool fault;
    bool write;
    struct page *p;

    if (argc != 3 && argc != 4) {
        printf("usage: %s npages nslots <times>\n", argv[0]);
        exit(1);
    }

    npages = atoi(argv[1]);
    if (npages <= 0) {
        printf("npages must be greater than 0\n");
        exit(1);
    }

    nslots = atoi(argv[2]);
    clock_hand = 0;
    if (nslots <= 0) {
        printf("nslots must be greater than 0\n");
        exit(1);
    }
    next_slot = 0;
    slots = malloc(sizeof(struct page) * nslots);

    if (argc == 4) {
        times = atoi(argv[3]);
        if (times <= 0) {
            printf("times must be greater than 0.\n");
            exit(1);
        }
    } else {
        times = -1;
    }

    for (p = slots; p < &slots[nslots]; p++) {
        p->number = -1;
        p->reference = false;
        p->dirty = false;
    }

    while (times < 0 || times-- > 0) {
        page = npages * sqrt((double) rand() / RAND_MAX);
        write = rand() % 2;

        if (write) {
            printf("RW on page %d.", page);
        } else {
            printf("R  on page %d.", page);
        }

        fault = true;
        for (p = slots; p < &slots[nslots]; p++) {
            if (p->number != page) continue;
            p->reference = true;
            p->dirty |= write;
            fault = false;
            break;
        }

        if (fault) {
            printf(" This triggered a page fault.");
            p = find_victim_slot();
            if (next_slot < nslots) {
                printf(" There was a free slot!");
                p = slots + next_slot++;
            } else {
               	if(p->dirty){
			printf("The chosen victim was %d dirty.", p->number);
		}
else{
		printf(" The chosen victim was page %d.", p->number);
}     
       }
            p->number = page;
            p->reference = true;
            p->dirty = write;
        }

        if (times < 0) usleep(100 * 1000);

        putchar('\n');
    }

    return 0;
}

