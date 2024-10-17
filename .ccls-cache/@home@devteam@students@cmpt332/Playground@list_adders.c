#include <stdio.h>
#include <stdlib.h>
#include "list.h"

#define UNUSED_NODE -1

/* NODE structure */
struct NODE {
    void *item;
    int next;
    int prev;
};

/* LIST structure */
struct LIST {
    int head;
    int tail;
    int current;
    int count;
    int inUse;
};

/* Node Pool structure */
typedef struct {
    NODE *nodes;
    int *freeNodes;
    int totalNodes;
    int freeNodeCount;
} NodePool;


/* List Pool structure */
typedef struct {
    LIST *lists;
    int *freeLists;
    int totalLists;
    int freeListCount;
} ListPool;

/* Global pools */
static NodePool nodePool = {NULL, NULL, 0, 0};
static ListPool listPool = {NULL, NULL, 0, 0};

/* Function prototypes */
static void initializePools(void);
static int allocateNode(void);
static void freeNode(int index);
static int allocateList(void);
static void freeList(int index);


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
