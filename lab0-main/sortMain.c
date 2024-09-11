/* main program for qSort
 * @author: Kernighan/Ritchie
 * @date: 1978
 * @modified by: Dwight Makaroff
 * July 2023
 */


#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <qsort.h>

enum sType
  {
    STRING, INTEGER, DOUBLE, COMPLEX
  };


#define MAXLINES 100
char *lineptr[MAXLINES];


int main(int argc, char *argv[])
{
  int nlines;
  enum sType sortType = STRING;
  int (*comparing)(void*, void*);
  if (argc != 2)
    {
      perror("Usage: perror. wrong number of arguments");
      return -1;
    }

  sortType = atoi(argv[1]);


  if (sortType == STRING) comparing = (Comparator) strcmp;
  if (sortType == INTEGER) comparing = compareInt;
  if (sortType == DOUBLE) comparing = compareDouble;
  if (sortType == COMPLEX) comparing = compareComplex;



  if ((nlines = readlines(lineptr, MAXLINES)) >=0)
    {
      printf("UNSORTED ORDER\n");
      writelines(lineptr, nlines);

      myQsort ((void **)lineptr, 0, nlines-1, comparing);

      printf("\nSORTED ORDER \n");

      writelines(lineptr, nlines);
      return 0;
    }
  else
    {
      perror("problem with input");
      return 1;
    }
}                    