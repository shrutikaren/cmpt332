#define LIST_IMPLEMENTATION
#include <stdlib.h>
#include "list.h"

#define UNUSED_NODE -1

/* Extern pools from list_adders.c */
extern NodePool nodePool;
extern ListPool listPool;

/* Remove the current item */
void *ListRemove(LIST *pList) {
    return NULL;
}

/* Remove and return the last item */
void *ListTrim(LIST *pList) {
    return NULL;
}

/* Free the list and its nodes */
void ListFree(LIST *pList, void (*itemFree)(void *pItem)) {
  
}
