/* intComp.cd
 * Implementation of comparison function
 * @author Dwight Makaroff
 * @date: July 2023
 */

#include "qsort.h"

/* returns -1 if first < second
 * returns 0 if first == second
 * returns 1 if first > second
 */
int compareDouble(void *first, void *second){

    double *dFirst  = (double*) first;
    double *dSecond = (double*) second;

    /* fill in the details of comparing 2 doubles */
    if(*dFirst < *dSecond){ return -1; }

    else if(*dFirst > *dSecond){ return 1; }

    else{ return 0; }

}
