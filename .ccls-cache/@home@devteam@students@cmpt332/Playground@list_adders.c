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

int allocateNode(void){
    return 0;
}

void freeNode(int index){

}

int allocateList(void){
    return 0;
}

void freeList(int index){

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
    return 0;
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
