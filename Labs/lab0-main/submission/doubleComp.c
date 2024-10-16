//Name: KAUR Shruti
//Student Number: 11339265
//NSID: ICH524

/* intComp.cd
 * Implementation of comparison function
 * @author Dwight Makaroff
 * @date: July 2023
 */


/* returns -1 if first < second
 * returns 0 if first == second
 * returns 1 if first > second
 */

#include <stdlib.h>
#include <qsort.h>

int compareDouble(void *first, void *second){
  /* fill in the details of comparing 2 doubles */
  double dFst = strtod((char*) first, NULL);
  double dSnd = strtod((char *) second, NULL);

  if (dFst < dSnd){
    return -1;
  } else if (dFst > dSnd){
    return 1;
  } else{
    return 0;
  }

}
