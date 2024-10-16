/*
 * Shruti Kaur
 * ich524
 * 11339265
 */

#ifndef LIST_H
#define LIST_H

#define UNUSED 0xffffffff

/* Reallocing moves memory arround unpredictably. So instead of using a list
 * pointer we will be using an index. */
typedef unsigned int LIST_HANDLE;
typedef unsigned int NODE_HANDLE;

typedef struct node {
    void *item;
    NODE_HANDLE next;
    NODE_HANDLE prev;
} NODE;

typedef struct list {
    NODE_HANDLE head;
    NODE_HANDLE tail;
    NODE_HANDLE cursor;
    unsigned int count;
} LIST;

/* Function prototypes */
LIST_HANDLE ListCreate();
unsigned int ListCount(LIST_HANDLE list);
void *ListFirst(LIST_HANDLE list);
void *ListLast(LIST_HANDLE list);
void *ListNext(LIST_HANDLE list);
void *ListPrev(LIST_HANDLE list);
void *ListCurr(LIST_HANDLE list);
int ListAdd(LIST_HANDLE list, void *item);
int ListInsert(LIST_HANDLE list, void *item);
int ListAppend(LIST_HANDLE list, void *item);
int ListPrepend(LIST_HANDLE list, void *item);
void *ListRemove(LIST_HANDLE list);
void ListConcat(LIST_HANDLE list1, LIST_HANDLE list2);
void ListFree(LIST_HANDLE list, void (*itemFree)(void *));
void *ListTrim(LIST_HANDLE list);
void *ListSearch(LIST_HANDLE list, int (*comparator)(void *, void *), 
void *comparisonArg);

#endif 

