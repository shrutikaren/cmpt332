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
    
    if(pList == NULL){ return; }

    int nodeIndex = pList->head;

    while (nodeIndex != UNUSED_NODE) {

        int nextNode = nodePool.nodes[nodeIndex].next;
        if(itemFree != NULL && nodePool.nodes[nodeIndex].item != NULL){
            itemFree(nodePool.nodes[nodeIndex].item);
        }
        freeNode(nodeIndex);
        nodeIndex = nextNode;

    }

    int listIndex = pList - listPool.lists;
    freeList(listIndex);
  
}
