#include <stdio.h>
#include <list.h>

/*
 * Purpose: pops the current item from the list
 * Effects: current item becomes it's next item
 * Returns: a pointer to the current item
 */
void *ListRemove(LIST *list) {
    if (!list) {
        printf("Error in procedure ListRemove: list is NULL\n");
        return NULL;
    }
    printf("Got to procedure ListRemove\n");
    return NULL;
}

/*
 * Purpose: deletes the list, itemFree is used to delete individual items
 */
void ListFree(LIST *list, void (*itemFree)(void *)) {
    if (!list) {
        printf("Error in procedure ListFree: list is NULL\n");
        return;
    }
    if (!itemFree) {
        printf("Error in procedure ListFree: itemFree is NULL\n");
        return;
    }
    printf("Got to procedure ListFree\n");
    return;
}

/*
 * Purpose: pops the item from the end of the list
 * Effects: the current item is set to the new last item
 * Returns: a pointer to this item
 */
void *ListTrim(LIST *list) {
    if (!list) {
        printf("Error in procedure ListTrim: list is NULL\n");
        return NULL;
    }
    printf("Got to procedure ListTrim\n");
    return NULL;
}


