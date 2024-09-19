#include <stdio.h>
#include <list.h>

/*
 * Purpose: initializes an empty List to be further used by other functions.
 * Returns: a list pointer or NULL on error
 */
LIST *ListCreate() {
    printf("Got to procedure ListCreate\n");
    return NULL;
}

/*
 * Purpose: inserts an item into the list after the current item
 * Returns: 0 on success, -1 on failure
 */
int ListAdd(LIST *list, void *item) {
    if (!list) {
        printf("Error in procedure ListAdd: list is NULL\n");
        return -1;
    }
    if (!item) {
        printf("Error in procedure ListAdd: item is NULL\n");
        return -1;
    }
    printf("Got to procedure ListAdd\n");
    return 0;
}

/*
 * Purpose: inserts an item into the list before the current item
 * Returns: 0 on success, -1 on failure
 */
int ListInsert(LIST *list, void *item) {
    if (!list) {
        printf("Error in procedure ListInsert: list is NULL\n");
        return -1;
    }
    if (!item) {
        printf("Error in procedure ListInsert: item is NULL\n");
        return -1;
    }
    printf("Got to procedure ListInsert\n");
    return 0;
}

/*
 * Purpose: appends an item to the end of the list
 * Returns: 0 on success, -1 on failure
 */
int ListAppend(LIST *list, void *item) {
    if (!list) {
        printf("Error in procedure ListAppend: list is NULL\n");
        return -1;
    }
    if (!item) {
        printf("Error in procedure ListAppend: item is NULL\n");
        return -1;
    }
    printf("Got to procedure ListAppend\n");
    return 0;
}

/*
 * Purpose: prepends an item to the start of the list
 * Returns: 0 on success, -1 on failure
 */
int ListPrepend(LIST *list, void *item) {
    if (!list) {
        printf("Error in procedure ListPrepend: list is NULL\n");
        return -1;
    }
    if (!item) {
        printf("Error in procedure ListPrepend: item is NULL\n");
        return -1;
    }
    printf("Got to procedure ListPrepend\n");
    return 0;
}

/*
 * Purpose: adds list2 to the end of list1
 * Effects: list2 is destroyed
 */
void ListConcat(LIST *list1, LIST *list2) {
    if (!list1) {
        printf("Error in procedure ListConcat: list1 is NULL\n");
        return;
    }
    if (!list2) {
        printf("Error in procedure ListConcat: list2 is NULL\n");
        return;
    }
    printf("Got to procedure ListConcat\n");
    return;
}


