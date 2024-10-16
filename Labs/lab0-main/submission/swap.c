/* Name: KAUR Shruti
   Student Number: 11339265
   NSID: ICH524 */

/* swap.c
 * implementation of swap function
 * @author Dwight Makaroff
 * @date: July 2023
 */

#include <qsort.h>

void swap(void  *v[], int i, int j){
  void *temp = v[i];
  v[i] = v[j];
  v[j] = temp;
}
