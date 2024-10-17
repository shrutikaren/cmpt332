#include <stdlib.h>
#include "list.h"

#define UNUSED_NODE -1

/* Extern pools from list_adders.c */
extern NodePool nodePool;
extern ListPool listPool;

/* Get the count of items in the list */
int ListCount(LIST *pList) {
    return 0;
}

/* Move current to the first item */
void *ListFirst(LIST *pList) {
    return NULL;
}

/* Move current to the last item */
void *ListLast(LIST *pList) {
    return NULL;
}

/* Return the current item */
void *ListCurr(LIST *pList) {
    return NULL;
}

/* Move current to the next item */
void *ListNext(LIST *pList) {
    return NULL;
}

/* Move current to the previous item */
void *ListPrev(LIST *pList) {
    return NULL;
}

/* Search the list starting from current */
void *ListSearch(LIST *pList,
                 int (*comparator)(void *, void *), void *pComparisonArg) {
    return NULL;
}
