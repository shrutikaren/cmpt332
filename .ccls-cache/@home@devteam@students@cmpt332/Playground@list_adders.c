#define LIST_IMPLEMENTATION
#include <stdio.h>
#include <stdlib.h>
#include "list.h"

#define UNUSED_NODE -1

NodePool nodePool = {NULL, NULL, 0, 0};
ListPool listPool = {NULL, NULL, 0, 0};

void initializePools(void){

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
