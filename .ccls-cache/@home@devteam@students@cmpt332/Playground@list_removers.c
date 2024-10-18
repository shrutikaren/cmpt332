#define LIST_IMPLEMENTATION
#include <stdlib.h>
#include "list.h"

#define UNUSED_NODE -1

/* Extern pools from list_adders.c */
extern NodePool nodePool;
extern ListPool listPool;

/* Remove the current item */
void *ListRemove(LIST *pList) {

    if(pList == NULL || pList->current == UNUSED_NODE){
        return NULL;
    }

    int nodeIndex = pList->current;
    void* item = nodePool.nodes[nodeIndex].item;
    int prevNode = nodePool.nodes[nodeIndex].prev;
    int nextNode = nodePool.nodes[nodeIndex].next;

    if(prevNode != UNUSED_NODE){
        nodePool.nodes[prevNode].next = nextNode;
    }
    else{
        pList->head = nextNode;
    }

    if(nextNode != UNUSED_NODE){
        nodePool.nodes[nextNode].prev = prevNode;
    }
    else{
        pList->tail = prevNode;
    }
    pList->current = nextNode;
    freeNode(nodeIndex);
    pList->count--;

    return item;
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

    /* Reset the list's pointers */
    pList->head = UNUSED_NODE;
    pList->tail = UNUSED_NODE;
    pList->current = UNUSED_NODE;
    pList->count = 0;
    pList->inUse = 0;

    /* Return the list to the pool */
    int listIndex = pList - listPool.lists;
    freeList(listIndex);
  
}
