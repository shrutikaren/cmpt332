#include <stdio.h>
#include <list.h>

/*
 * Purpose: counts the number of items in the list
 * Returns: the number of items in the list
 */
int ListCount(LIST *list) {
    if (!list) {
        printf("Error in procedure ListCount: list is NULL\n");
        return -1;
    }
    printf("Got to procedure ListCount\n");
    return 0;
}

/*
 * Purpose: provides a pointer to the first item of the list
 * Effects: the current item becomes the first item
 * Returns: a pointer to the first item of the list
 */
void *ListFirst(LIST *list) {
    if (!list) {
        printf("Error in procedure ListFirst: list is NULL\n");
        return NULL;
    }
    printf("Got to procedure ListFirst\n");
    return NULL;
}

/*
 * Purpose: provides a pointer to the last item of the list
 * Effects: the current item becomes the last item
 * Returns: a pointer to the last item of the list
 */
void *ListLast(LIST *list) {
    if (!list) {
        printf("Error in procedure ListLast: list is NULL\n");
        return NULL;
    }
    printf("Got to procedure ListLast\n");
    return NULL;
}

/*
 * Purpose: provides a pointer to the item next to the current item
 * Effects: the current item becomes the item next to it
 * Returns: a pointer to the item next to the current item
 */
void *ListNext(LIST *list) {
    if (!list) {
        printf("Error in procedure ListNext: list is NULL\n");
        return NULL;
    }
    printf("Got to procedure ListNext\n");
    return NULL;
}

/*
 * Purpose: provides a pointer to the item previous to the current item
 * Effects: the current item becomes the item previous to it
 * Returns: a pointer to the item previous to the current item
 */
void *ListPrev(LIST *list) {
    if (!list) {
        printf("Error in procedure ListPrev: list is NULL\n");
        return NULL;
    }
    printf("Got to procedure ListPrev\n");
    return NULL;
}

/*
 * Purpose: provides a pointer to the current item
 * Returns: a pointer to the current item
 */
void *ListCurr(LIST *list) {
    if (!list) {
        printf("Error in procedure ListCurr: list is NULL\n");
        return NULL;
    }
    printf("Got to procedure ListCurr\n");
    return NULL;
}

/* 
 * Purpose: searchs the list for comparisonArg using the comparator function
 * Effects: current item becomes the found item, or is set to the last item
 * Returns: a pointer to the item if found, else NULL
 */
void *ListSearch(LIST *list, 
	int (*comparator)(void *, void *), 
	void *comparisonArg) {
    if (!list) {
        printf("Error in procedure ListSearch: list is NULL\n");
        return NULL;
    }
    if (!comparator) {
        printf("Error in procedure ListSearch: comparator is NULL\n");
        return NULL;
    }
    if (!comparisonArg) {
        printf("Error in procedure ListSearch: comparisonArg is NULL\n");
        return NULL;
    }

    printf("Got to procedure ListSearch\n");
    return NULL;
}


