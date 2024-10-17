#include <stdio.h>
#include <stdlib.h>
#include "list.h"

#define UNUSED_NODE -1

static void initializePools(void){

}

static int allocateNode(void){
    return 0;
}

static void freeNode(int index){

}

static int allocateList(void){
    return 0;
}

static void freeList(int index){

}

LIST *ListCreate(void){
    return NULL;
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
