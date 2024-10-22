#define LIST_IMPLEMENTATION
#include <stdio.h>
#include <stdlib.h>
#include "list.h"

#define UNUSED_NODE -1

NodePool nodePool = {NULL, NULL, 0, 0};
ListPool listPool = {NULL, NULL, 0, 0};

void initializePools(void){

    int i;

    if(nodePool.nodes == NULL){
        nodePool.totalNodes = MIN_NODES;
        nodePool.nodes = malloc(sizeof(NODE) * nodePool.totalNodes);
        nodePool.freeNodes = malloc(sizeof(int) * nodePool.totalNodes);
        for (i = 0; i < nodePool.totalNodes; i++) {
            nodePool.freeNodes[i] = nodePool.totalNodes - i - 1; 
        }
        nodePool.freeNodeCount = nodePool.totalNodes;
    }

    if(listPool.lists == NULL){
        listPool.totalLists = MIN_LISTS;
        listPool.lists = malloc(sizeof(LIST) * listPool.totalLists);
        listPool.freeLists = malloc(sizeof(int) * listPool.totalLists);
        for (i = 0; i < listPool.totalLists; i++) {
            listPool.lists[i].inUse = 0;
            listPool.freeLists[i] = listPool.totalLists - i - 1;
        }
        listPool.freeListCount = listPool.totalLists;
    }

}

/* Allocate a node from the pool */
int allocateNode(void) {

    int i;

    if (nodePool.freeNodeCount == 0) {
        /* Expand node pool */
        int newTotalNodes = nodePool.totalNodes * 2;
        NODE *newNodes = realloc(nodePool.nodes, sizeof(NODE) * newTotalNodes);
        if(newNodes == NULL){
            LOG_ERROR("Failed to realloc nodePool.nodes");
        }

        int *newFreeNodes = realloc(nodePool.freeNodes,
                                    sizeof(int) * newTotalNodes);
        if(newFreeNodes == NULL){
            LOG_ERROR("Failed to realloc nodePool.freeNodes");
        }

        for (i = nodePool.totalNodes; i < newTotalNodes; i++) {
            newFreeNodes[nodePool.freeNodeCount++] = i;
        }
        nodePool.nodes = newNodes;
        nodePool.freeNodes = newFreeNodes;
        nodePool.totalNodes = newTotalNodes;
    }

    return nodePool.freeNodes[--nodePool.freeNodeCount];

}

/* Free a node back to the pool */
void freeNode(int index) {
    nodePool.freeNodes[nodePool.freeNodeCount++] = index;
}

/* Allocate a list from the pool */
int allocateList(void) {

    int i, index;

    if (listPool.freeListCount == 0) {
        /* Expand list pool */
        int newTotalLists = listPool.totalLists * 2;
        LIST *newLists = realloc(listPool.lists,
                                 sizeof(LIST) * newTotalLists);
        int *newFreeLists = realloc(listPool.freeLists,
                                    sizeof(int) * newTotalLists);
        for (i = listPool.totalLists; i < newTotalLists; i++) {
            newLists[i].inUse = 0;
            newFreeLists[listPool.freeListCount++] = i;
        }
        listPool.lists = newLists;
        listPool.freeLists = newFreeLists;
        listPool.totalLists = newTotalLists;
    }
    index = listPool.freeLists[--listPool.freeListCount];
    listPool.lists[index].inUse = 1;
    listPool.lists[index].head = UNUSED_NODE;
    listPool.lists[index].tail = UNUSED_NODE;
    listPool.lists[index].current = UNUSED_NODE;
    listPool.lists[index].count = 0;
    return index;
}

/* Free a list back to the pool */
void freeList(int index) {
    if(index < 0 || index >= listPool.totalLists){
        LOG_ERROR("Attempt to free invalid list index.");
    }
    listPool.lists[index].inUse = 0;
    listPool.freeLists[listPool.freeListCount++] = index;
}

void ListDispose(void){
    if(nodePool.nodes != NULL){
        free(nodePool.nodes);
        nodePool.nodes = NULL;
    }

    if(nodePool.freeNodes!= NULL){
        free(nodePool.freeNodes);
        nodePool.freeNodes = NULL;
    }

    if(listPool.lists!= NULL){
        free(listPool.lists);
        listPool.lists = NULL;
    }

    if(listPool.freeLists!= NULL){
        free(listPool.freeLists);
        listPool.freeLists = NULL;
    }
}

LIST *ListCreate(void){
    
    int index;
    initializePools();
    index = allocateList();
    if(index < 0){
        return NULL;
    }

    return &listPool.lists[index];

}

int ListAdd(LIST *pList, void *pItem){

    int newNodeIndex;
    if(pList == NULL){ return EXIT_FAILURE; }

    initializePools();
    newNodeIndex = allocateNode();

    nodePool.nodes[newNodeIndex].item = pItem;
    nodePool.nodes[newNodeIndex].next = UNUSED_NODE;
    nodePool.nodes[newNodeIndex].prev = UNUSED_NODE;

    if(pList->count == 0){
        pList->head = pList->tail = pList->current = newNodeIndex;
    }

    else if (pList->current == UNUSED_NODE){
        nodePool.nodes[newNodeIndex].prev = pList->tail;
        nodePool.nodes[newNodeIndex].next = UNUSED_NODE;
        nodePool.nodes[pList->tail].next = newNodeIndex;
        pList->tail = pList->current = newNodeIndex;
        pList->current = newNodeIndex;
    }

    else{
        int nextNode = nodePool.nodes[pList->current].next;
        nodePool.nodes[newNodeIndex].prev = pList->current;
        nodePool.nodes[newNodeIndex].next = nextNode;
        nodePool.nodes[pList->current].next = newNodeIndex;
        if (nextNode != UNUSED_NODE) {
            nodePool.nodes[nextNode].prev = newNodeIndex;
        }
        else{
            pList->tail = newNodeIndex;
        }
        pList->current = newNodeIndex;
    }
    pList->count++;
            
    return EXIT_SUCCESS;
}

int ListInsert(LIST *pList, void *pItem){

    int newNodeIndex;
    if(pList == NULL || !pList->inUse){
        return EXIT_FAILURE;
    }

    newNodeIndex = allocateNode();
    nodePool.nodes[newNodeIndex].item = pItem;
    nodePool.nodes[newNodeIndex].next = UNUSED_NODE;
    nodePool.nodes[newNodeIndex].prev = UNUSED_NODE;

    if(pList->count == 0){
        pList->head = pList->tail = pList->current = newNodeIndex;
    }
    else if (pList->current == UNUSED_NODE){
        nodePool.nodes[newNodeIndex].next = pList->head;
        nodePool.nodes[pList->head].prev = newNodeIndex;
        pList->head = pList->current = newNodeIndex;
    }
    else{
        int prevNode = nodePool.nodes[pList->current].prev;
        nodePool.nodes[newNodeIndex].next = pList->current;
        nodePool.nodes[newNodeIndex].prev = prevNode;
        nodePool.nodes[pList->current].prev = newNodeIndex;
        if(prevNode != UNUSED_NODE){
            nodePool.nodes[prevNode].next = newNodeIndex;
        }else{
            pList->head = newNodeIndex;
        }
        pList->current = newNodeIndex;
    }
    pList->count++;
    return EXIT_SUCCESS;
}

int ListAppend(LIST *pList, void *pItem){
    if(pList == NULL){
        return EXIT_FAILURE;
    }
    pList->current = pList->tail;
    return ListAdd(pList, pItem);
}

int ListPrepend(LIST *pList, void *pItem){
    if(pList == NULL){
        return EXIT_FAILURE;
    }
    pList->current = pList->head;
    return ListInsert(pList, pItem);
}

void ListConcat(LIST *pList1, LIST *pList2){

    if(pList1 == NULL || pList2 == NULL){
        return;
    }

    if(pList2->count == 0){
        freeList(pList2 - listPool.lists);
        return;
    }

    if(pList1->count == 0){
        pList1->head = pList2->head;
        pList1->tail = pList2->tail;
        pList1->current = pList2->current;
        pList1->count = pList2->count;
    }
    else{
        nodePool.nodes[pList1->tail].next = pList2->head;
        nodePool.nodes[pList2->head].prev = pList1->tail;
        pList1->tail = pList2->tail;
        pList1->count += pList2->count;
        pList1->current = pList2->current;
    }

    pList2->head = pList2->tail = pList2->current = UNUSED_NODE;
    pList2->count = 0;
    pList2->inUse = 0;

    freeList(pList2 - listPool.lists);

}
