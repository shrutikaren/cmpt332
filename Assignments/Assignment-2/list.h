#ifndef LIST_H
#define LIST_H

typedef struct node {
    void *item;
    struct node *next;
    struct node *prev;
} NODE;

typedef struct list {
    NODE *head;
    NODE *tail;
    NODE *cursor;
    int count;
} LIST;

/* Function prototypes */
LIST *ListCreate();
int ListCount(LIST *list);
void *ListFirst(LIST *list);
void *ListLast(LIST *list);
void *ListNext(LIST *list);
void *ListPrev(LIST *list);
void *ListCurr(LIST *list);
int ListAdd(LIST *list, void *item);
int ListInsert(LIST *list, void *item);
int ListAppend(LIST *list, void *item);
int ListPrepend(LIST *list, void *item);
void *ListRemove(LIST *list);
void ListConcat(LIST *list1, LIST *list2);
void ListFree(LIST *list, void (*itemFree)(void *));
void *ListTrim(LIST *list);
void *ListSearch(LIST *list, int (*comparator)(void *, void *), 
void *comparisonArg);

#endif 



