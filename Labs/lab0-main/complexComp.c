/*
 * @author Dwight Makaroff
 * @date: July 2023
 */

#include <stdlib.h>
#include "qsort.h"

/* returns -1 if first < second
 * returns 0 if first == second
 * returns 1 if first > second

 * Note that these void pointers as input are strings. That's
 * why strtol is being used to get the right values in the
 * structure.

 * a complex number is composed of 2 fields: real and imaginary, which are
 * both doubles
 */

int compareComplex(void *first, void *second){

    /*
    // Set to NULL. Don't want dangaling Pointers!
    Complex *cFirst = NULL;
    char    *index  = NULL;
    Complex *cSnd   = NULL;

    int sizeFirst = 0, sizeSecond = 0;

    cFirst->real = strtod(first, &index);
    cFirst->imag = strtod(index, NULL);
    cSnd->real = strtod(second, &index);
    cSnd->imag = strtod(index, NULL);

    */

    Complex * cFirst    = (Complex*) first;
    Complex * cSnd      = (Complex*) second;

    // Note: Sqrt is redundent.
    double sizeFirst = cFirst->real * cFirst->real + cFirst->imag * cFirst->imag;
    double sizeSecond = cSnd->real * cSnd->real + cSnd->imag * cSnd->imag;

    if (sizeFirst < sizeSecond){
        return(-1);
    }
    else if (sizeFirst > sizeSecond){
        return(1);
    }
    else{
        return (0);
    }

}
