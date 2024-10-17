#ifndef LIST_H
#define LIST_H

/* Including necessary libraries */
#include <stdio.h>
#include <stdlib.h>

#define MIN_LISTS 10
#define MIN_NODES 100

/* Logging Errors in our code. */
#define LOG_ERROR(msg) do {                             \
    fprintf(stderr, "Log [Error] - %s: %s at %s:%d\n",  \
        msg, strerror(errno), __FILE__, __LINE__);      \
    exit(EXIT_FAILURE);                                 \
}while(0)

/* Forward declarations */
typedef struct NODE NODE;
typedef struct LIST LIST;

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

/* Helper Function prototypes */
static void initializePools(void);
static int allocateNode(void);
static void freeNode(int index);
static int allocateList(void);
static void freeList(int index);

/* Function Prototypes */

/* List creation and management */
LIST *ListCreate(void);
void ListFree(LIST *pList, void (*itemFree)(void *pItem));

/* List properties */
int ListCount(LIST *pList);
void *ListFirst(LIST *pList);
void *ListLast(LIST *pList);
void *ListCurr(LIST *pList);

/* List navigation */
void *ListNext(LIST *pList);
void *ListPrev(LIST *pList);

/* List modification */
int ListAdd(LIST *pList, void *pItem);
int ListInsert(LIST *pList, void *pItem);
int ListAppend(LIST *pList, void *pItem);
int ListPrepend(LIST *pList, void *pItem);
void *ListRemove(LIST *pList);
void ListConcat(LIST *pList1, LIST *pList2);
void *ListTrim(LIST *pList);

/* List searching */
void *ListSearch(LIST *pList,
                 int (*comparator)(void *, void *), void *pComparisonArg);

#endif 
