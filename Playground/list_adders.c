#define LIST_IMPLEMENTATION
#include <stdio.h>
#include <stdlib.h>
#include <list.h>

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
    return 0;
}

int allocateList(void){
    
    int i = 0; 
    
    if(listPool.freeListCount == 0){
        /* Expand list pool */ 
        int newTotalLists = listPool.totalLists * 2;
        LIST * newLists = realloc(
            listPool.lists,
            sizeof(LIST) * newTotalLists
        );
        int * newFreeLists = realloc(
            listPool.freeLists,
            sizeof(int) * newTotalLists
        );
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
    /* Case 1: The item doesn't exist */
    if (pItem == NULL){
	return -1;
    }
    
    /* Case 2: The list is full */
    if (pList->count >= MAX_SIZE){
	return -1;
    }

    struct NODE addingItem;
    addingItem.item = pItem;
    addingItem.prev = pList->tail;

    /* Case 3: The list doesn't exist */
    if (pList->head == -1){
	addingItem.item = NULL;
	addingItem.prev = NULL;
    }
    pList.count++;
    return 0;
	
    }
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
