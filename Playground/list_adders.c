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
        int *newFreeNodes = realloc(nodePool.freeNodes,
                                    sizeof(int) * newTotalNodes);
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
    int i;

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
    int index = listPool.freeLists[--listPool.freeListCount];
    listPool.lists[index].inUse = 1;
    listPool.lists[index].head = UNUSED_NODE;
    listPool.lists[index].tail = UNUSED_NODE;
    listPool.lists[index].current = UNUSED_NODE;
    listPool.lists[index].count = 0;
    return index;
}

/* Free a list back to the pool */
void freeList(int index) {
    listPool.lists[index].inUse = 0;
    listPool.freeLists[listPool.freeListCount++] = index;
}

LIST *ListCreate(void){
    
    initializePools();
    int index = allocateList();
    if(index < 0){
        return NULL;
    }

    return &listPool.lists[index];

}

void ListFree(LIST *pList, void (*itemFree)(void *pItem)){
    return;
}

int ListAdd(LIST *pList, void *pItem){
    return -1;
}

int ListInsert(LIST *pList, void *pItem){
    return 0;
}

int ListAppend(LIST *pList, void *pItem){
    return 0;
}

int ListPrepend(LIST *pList, void *pItem){
    return 0;
}

void ListConcat(LIST *pList1, LIST *pList2){

}
