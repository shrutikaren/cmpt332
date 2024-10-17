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
