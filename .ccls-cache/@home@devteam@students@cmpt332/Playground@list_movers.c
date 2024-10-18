#define LIST_IMPLEMENTATION
#include <stdlib.h>
#include <list.h>

#define UNUSED_NODE -1

/* Extern pools from list_adders.c */
extern NodePool nodePool;
extern ListPool listPool;

/* Get the count of items in the list */
int ListCount(LIST *pList) {
    if(pList == NULL){
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
    return NULL;
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
    if(pList == NULL || pList->current == UNUSED_NODE){
        return NULL;
    }
    int nextNode = nodePool.nodes[pList->current].next;
    if(nextNode == UNUSED_NODE){
        pList->current = UNUSED_NODE;
        return NULL;
    }
    pList->current = nextNode;
    return nodePool.nodes[pList->current].item;
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
