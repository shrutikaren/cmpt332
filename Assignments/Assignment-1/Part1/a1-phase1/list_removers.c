#include <stdio.h>
#include "list.h"

void *ListRemove(LIST *list) {
    printf("Got to procedure ListRemove\n");
    return NULL;
}

void ListConcat(LIST *list1, LIST *list2) {
    printf("Got to procedure ListConcat\n");
}

void ListFree(LIST *list, void (*itemFree)(void *)) {
    printf("Got to procedure ListFree\n");
}

void *ListTrim(LIST *list) {
    printf("Got to procedure ListTrim\n");
    return NULL;
}

void *ListSearch(LIST *list, int (*comparator)(void *, void *), void *comparisonArg) {
    printf("Got to procedure ListSearch\n");
    return NULL;
}

