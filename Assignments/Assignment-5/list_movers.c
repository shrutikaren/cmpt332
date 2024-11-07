#define LIST_IMPLEMENTATION
#include <stdlib.h>
#include <list.h>

#define UNUSED_NODE -1

/* Extern pools from list_adders.c */
extern NodePool nodePool;
extern ListPool listPool;

/* Get the count of items in the list */
int ListCount(LIST *pList) {
    if(pList == NULL || !pList->inUse){
        return EXIT_FAILURE;
    }
    return pList->count;
}

/* Move current to the first item */
void *ListFirst(LIST *pList) {
    if(pList == NULL || pList->head == UNUSED_NODE){
        return NULL;
    }
    pList->current = pList->head;
    return nodePool.nodes[pList->current].item;
}

/* Move current to the last item */
void *ListLast(LIST *pList) {
    if(pList == NULL || pList->tail == UNUSED_NODE){
        return NULL;
    }
    pList->current = pList->tail;
    return nodePool.nodes[pList->current].item;
}

/* Return the current item */
void *ListCurr(LIST *pList) {
    if(pList == NULL || pList->current == UNUSED_NODE){
        return NULL;
    }
    return nodePool.nodes[pList->current].item;
}

/* Move current to the next item */
void *ListNext(LIST *pList) {
    int nextNode;
    if(pList == NULL || pList->current == UNUSED_NODE){
        return NULL;
    }
    nextNode = nodePool.nodes[pList->current].next;
    if(nextNode == UNUSED_NODE){
        pList->current = UNUSED_NODE;
        return NULL;
    }
    pList->current = nextNode;
    return nodePool.nodes[pList->current].item;
}

/* Move current to the previous item */
void *ListPrev(LIST *pList) {
    int prevNode;
    if(pList == NULL || pList->current == UNUSED_NODE){
        return NULL;
    }
    prevNode = nodePool.nodes[pList->current].prev;
    if(prevNode == UNUSED_NODE){
        pList->current = UNUSED_NODE;
        return NULL;
    }
    pList->current = prevNode;
    return nodePool.nodes[pList->current].item;
}

/* Search the list starting from current */
void *ListSearch(LIST *pList,
                 int (*comparator)(void *, void *), void *pComparisonArg) {

    int nodeIndex; 

    if(pList == NULL || comparator == NULL){
        return NULL;
    }
    
    nodeIndex = pList->current;
    
    while (nodeIndex != UNUSED_NODE) {
        void* item = nodePool.nodes[nodeIndex].item;
        if(comparator(item,pComparisonArg) == 1){
            pList->current = nodeIndex;
            return item;
        }
        nodeIndex = nodePool.nodes[nodeIndex].next;
    }
    
    pList->current = UNUSED_NODE;
    
    return NULL;

}
