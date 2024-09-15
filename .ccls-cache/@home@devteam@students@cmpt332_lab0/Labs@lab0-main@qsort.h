// We use header gaurds so that way we do not redeclare!

#ifndef QSORT_H
#define QSORT_H

// We are building our own data type.
// Computer DataTypes -> int, double, flout, char
typedef struct{

    // Structs by default are public
    double real;
    double imag;

} Complex;


typedef int (*Comparator)(void*, void*);

int compareComplex(void *first, void *second);
int compareInt(void *first, void *second);
int compareDouble(void *first, void *second);
int myGetline(char s[], int lim);
int *readlines(char *lineptr[], int maxlines);
void writelines(char *lineptr[], int nlines);
void myQsort(void *v[], int left, int right, Comparator comp);
void swap(void  *v[], int i, int j);                            // Done

#endif // ! QSORT_H
