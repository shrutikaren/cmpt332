#define LIST_IMPLEMENTATION
#include <stdlib.h>
#include "list.h"

#define UNUSED_NODE -1

/* Extern pools from list_adders.c */
extern NodePool nodePool;
extern ListPool listPool;

/* Remove the current item */
void *ListRemove(LIST *pList) {

    int nodeIndex, prevNode, nextNode;
    void* item;

    if(pList == NULL || pList->current == UNUSED_NODE){
        return NULL;
    }

    nodeIndex = pList->current;
    item = nodePool.nodes[nodeIndex].item;
    prevNode = nodePool.nodes[nodeIndex].prev;
    nextNode = nodePool.nodes[nodeIndex].next;

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

    if(nextNode != UNUSED_NODE){
        pList->current = nextNode;
    }
    else if (prevNode != UNUSED_NODE){
        pList->current = prevNode;
    }
    else{
        pList->current = UNUSED_NODE;
    }

    freeNode(nodeIndex);
    pList->count--;

    return item;

}

/* Remove and return the last item */
void *ListTrim(LIST *pList) {
    if(pList == NULL || pList->tail == UNUSED_NODE){
        return NULL;
    }
    pList->current = pList->tail;
    return ListRemove(pList);
}

/* Free the list and its nodes */
void ListFree(LIST *pList, void (*itemFree)(void *pItem)) {

    int nodeIndex, listIndex;
    
    if(pList == NULL){ return; }

    nodeIndex = pList->head;

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
    listIndex = pList - listPool.lists;
    freeList(listIndex);
  
}
