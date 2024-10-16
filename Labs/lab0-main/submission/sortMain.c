//Name: KAUR Shruti
//Student Number: 11339265
//NSID: ICH524

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

enum sType{
    STRING, INTEGER, DOUBLE, COMPLEX
};

#define MAXLINES 100
char *lineptr[MAXLINES];

int main(int argc, char *argv[]){

    int nlines = 0;
    enum sType sortType = STRING;
    int (*comparing)(void*, void*);

    // ./myQsort sortType
    if (argc != 2){
      perror("Usage: perror. wrong number of arguments");
      return -1;
    }

    sortType = atoi(argv[1]);
	
    // switch statments are faster than if's.
    switch(sortType){
			case STRING: comparing = (Comparator) strcmp;
				break;
			case INTEGER: comparing = compareInt;
				break;
			case DOUBLE: comparing = compareDouble;
				break;
			case COMPLEX: comparing = compareComplex;
				break;
	}
			
    if ((nlines = readlines(lineptr, MAXLINES)) >=0){ 
//added pointer here so int is checked against int instead of int*
        printf("UNSORTED ORDER\n");
        writelines(lineptr, nlines);

        myQsort ((void **)lineptr, 0, nlines-1, comparing);

        printf("\nSORTED ORDER \n");

        writelines(lineptr, nlines);
        return 0;
    }
    else{
      perror("problem with input");
      return 1;
    }

}                    
