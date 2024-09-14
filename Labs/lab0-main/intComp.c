/* intComp.c
 * Implementation of comparison function
 * @author Dwight Makaroff
 * @date: July 2023
 */


/* returns -1 if first < second
 * returns 0 if first == second
 * returns 1 if first > second
 */

#include <stdio.h>
#include <stdlib.h>

#include "qsort.h"

int compareInt(void *first, void *second){

    int *dFirst  = (int*) first;
    int *dSecond = (int*) second;

    /* fill in the details of comparing 2 doubles */
    if(*dFirst < *dSecond){ return -1; }

    else if(*dFirst > *dSecond){ return 1; }

    else{ return 0; }

}