/* Name: KAUR Shruti
Student Number: 11339265
NSID: ICH524 */

/*
 * @author Dwight Makaroff
 * @date: July 2023
 */

#include <stdlib.h>
#include <qsort.h>

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
  double sizeFirst;
  double sizeSecond;
  /* Allocate */
  Complex *cFirst = (Complex *) malloc(sizeof(Complex));
  Complex *cSnd = (Complex *) malloc(sizeof(Complex));
  char * index = NULL;

  /* Failed to allocate properly */
  if(cFirst == NULL || cSnd == NULL){
	return 0;
  }

  cFirst->real = strtod((char*)first, &index);
  cFirst->imag = strtod(index, NULL);
  cSnd->real = strtod((char*)second, &index);
  cSnd->imag = strtod(index, NULL);

  sizeFirst = cFirst->real * cFirst->real + cFirst->imag * cFirst->imag;
  sizeSecond = cSnd->real * cSnd->real + cSnd->imag * cSnd->imag;

  /* Free memory NO MEMORY LEAKS!! */
  free(cFirst);
  free(cSnd);

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
