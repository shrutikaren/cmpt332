#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include "list.h"

/* Comparator function for testing ListSearch */
int intComparator(void *pItem, void *pComparisonArg) {
    return (*(int *)pItem == *(int *)pComparisonArg);
}

/* Checking if list was created */
void test_ListCreate() {
    LIST* list = ListCreate();
    assert(list != NULL);
    assert(ListCount(list) == 0);
    printf("test_ListCreate passed.\n");
    ListFree(list, NULL);
}

/* Checking if list created with one item */
void test_ListAdd() {
    LIST* list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int result;
    *item1 = 3;

    result = ListAdd(list, item1);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    assert(*(int*)ListCurr(list) == 3);
    printf("test_ListAdd passed.\n");

    ListFree(list, free);
}

void test2_ListAdd() {
    LIST* list = NULL;
    int *item1 = malloc(sizeof(int));
    int result;
    *item1 = 4;

    result = ListAdd(list, item1);
    assert(result == EXIT_FAILURE);
    free(item1);
    printf("test2_ListAdd passed.\n");
}

void test3_ListAdd() {
    LIST* list = ListCreate();
    void* item = NULL;
    int result = ListAdd(list, item);
    assert(result == EXIT_SUCCESS);
    printf("test3_ListAdd passed.\n");
    ListFree(list, NULL);
}

void test4_ListAdd() {
    LIST* list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int *item3 = malloc(sizeof(int));
    int *item4 = malloc(sizeof(int));
    int *item5 = malloc(sizeof(int));
    int r1, r2, r3, r4;

    *item1 = 4;
    *item3 = 0;
    *item4 = 10000;
    *item5 = 200;

    r1 = ListAdd(list, item1);
    r2 = ListAdd(list, item3);
    r3 = ListAdd(list, item4);
    r4 = ListAdd(list, item5);

    assert(r1 == EXIT_SUCCESS);
    assert(r2 == EXIT_SUCCESS);
    assert(r3 == EXIT_SUCCESS);
    assert(r4 == EXIT_SUCCESS);
    assert(*(int*)ListCurr(list) == 200);
    assert(ListCount(list) == 4);
    printf("test4_ListAdd passed.\n");

    ListFree(list, free);
}

void test5_ListAdd() {
    LIST* list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int *item2 = malloc(sizeof(int));
    int r1, r2;

    *item1 = 4;
    *item2 = -1; /* UNUSED_NODE */

    r1 = ListAdd(list, item1);
    r2 = ListAdd(list, item2);
    assert(r1 == EXIT_SUCCESS);
    assert(r2 == EXIT_SUCCESS);
    assert(*(int*)ListCurr(list) == -1);
    printf("test5_ListAdd passed.\n");

    ListFree(list, free);
}

void test6_ListAdd() {
    int i, result;
    LIST* list = ListCreate();
    const int numitems = 1000000;

    for (i = 0; i < numitems; i++) {
        int *item = (int *)malloc(sizeof(int));
        *item = i;
        result = ListAdd(list, item);
        assert(result == EXIT_SUCCESS);
        assert(ListCount(list) == i + 1);
        assert(*(int *)ListCurr(list) == i);
    }

    ListFirst(list);
    for (i = 0; i < numitems; i++) {
        assert(*(int*)ListCurr(list) == i);
        if (i < numitems - 1) {
            assert(ListNext(list) != NULL);
        }
    }

    for (i = 0; i < numitems; i++) {
        void* item = ListRemove(list);
        free(item);
    }

    assert(ListCount(list) == 0);

    ListFree(list, NULL);
    printf("test6_ListAdd passed.\n");
}

void test7_ListInsert() {
    LIST* list = ListCreate();
    int i, result;
    const int numitems = 5;
    int *items[numitems];

    for (i = 0; i < numitems; i++) {
        items[i] = malloc(sizeof(int));
        *items[i] = i;
        result = ListInsert(list, items[i]);
        assert(result == EXIT_SUCCESS);
    }
    assert(*(int *)ListCurr(list) == 4); /* Last inserted item */
    assert(ListCount(list) == 5);
    printf("test7_ListInsert passed.\n");

    ListFree(list, free);
}

/* Testing for the edge cases */
void test8_ListInsert() {
    LIST* list = NULL;
    int result;
    int *item1 = malloc(sizeof(int));
    *item1 = 5;

    result = ListInsert(list, item1);
    assert(result == EXIT_FAILURE);
    free(item1);
    printf("test8_ListInsert passed.\n");
}

void test9_ListInsert() {
    LIST* list = ListCreate();
    int i, result, resultappend;
    int item;
    const int totaliter = 1000000;
    int *items[totaliter];

    for (i = 0; i < totaliter; i++) {
        items[i] = malloc(sizeof(int));
        *items[i] = i;
        result = ListInsert(list, items[i]);
        assert(result == EXIT_SUCCESS);
    }

    item = 9;
    int *item_ptr = malloc(sizeof(int));
    *item_ptr = item;
    resultappend = ListAppend(list, item_ptr);
    assert(resultappend == EXIT_SUCCESS);
    /* 9 should be sitting at the cursor */
    assert(*(int*)ListCurr(list) == 9);
    assert(ListCount(list) == totaliter + 1);
    printf("test9_ListInsert passed.\n");

    ListFree(list, free);
}

void test10_ListPrepend() {
    LIST* list = ListCreate();
    int i, iteritem, result, resultprepend;
    int *item_ptr;
    int *items[10];

    iteritem = 10;
    for (i = 0; i < iteritem; i++) {
        items[i] = malloc(sizeof(int));
        *items[i] = i;
        result = ListInsert(list, items[i]);
        assert(result == EXIT_SUCCESS);
    }
    assert(*(int*)ListCurr(list) == 9);
    assert(ListCount(list) == 10);

    i = 20;
    item_ptr = malloc(sizeof(int));
    *item_ptr = i;
    resultprepend = ListPrepend(list, item_ptr);
    assert(resultprepend == EXIT_SUCCESS);
    assert(*(int*)ListCurr(list) == 20);
    assert(ListCount(list) == 11);

    printf("test10_ListPrepend passed.\n");

    ListFree(list, free);
}

void test11_ListConcat() {
    LIST* list_1 = ListCreate();
    LIST* list_2 = ListCreate();
    int iter_1, iter_2;
    int i;
    int *items1[10], *items2[20];

    iter_1 = 10;
    iter_2 = 20;
    for (i = 0; i < iter_1; i++) {
        items1[i] = malloc(sizeof(int));
        *items1[i] = iter_1;
        ListPrepend(list_1, items1[i]);
    }
    assert(ListCount(list_1) == 10);

    for (i = 0; i < iter_2; i++) {
        items2[i] = malloc(sizeof(int));
        *items2[i] = iter_2;
        ListPrepend(list_2, items2[i]);
    }
    assert(ListCount(list_2) == 20);

    ListConcat(list_1, list_2);
    assert(ListCount(list_1) == 30);
    assert(*(int*)ListCurr(list_1) == 20);
    printf("test11_ListConcat passed.\n");

    ListFree(list_1, free);
}

void test13_ListFirst() {
    LIST* list = ListCreate();
    int i, iter;
    int *item;
    int *items[15];

    iter = 15;
    for (i = 0; i < iter; i++) {
        items[i] = malloc(sizeof(int));
        *items[i] = i;
        ListAppend(list, items[i]);
    }
    item = ListFirst(list);
    assert(*item == 0);
    printf("test13_ListFirst passed.\n");

    ListFree(list, free);
}

void test_ListAppend() {
    LIST *list = ListCreate();
    int result;
    int *item1 = malloc(sizeof(int));
    *item1 = 20;
    result = ListAppend(list, item1);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    assert(*(int *)ListLast(list) == 20);
    ListFree(list, free);
    printf("test_ListAppend passed.\n");
}

void test_ListPrepend() {
    LIST *list = ListCreate();
    int result;
    int *item1 = malloc(sizeof(int));
    *item1 = 30;
    result = ListPrepend(list, item1);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    assert(*(int *)ListFirst(list) == 30);
    ListFree(list, free);
    printf("test_ListPrepend passed.\n");
}

void test_ListRemove() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int *removedItem;
    *item1 = 40;
    ListAdd(list, item1);
    removedItem = ListRemove(list);
    assert(removedItem == item1);
    assert(ListCount(list) == 0);
    free(removedItem);
    ListFree(list, NULL);
    printf("test_ListRemove passed.\n");
}

void test_ListTrim() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int *trimmedItem;
    *item1 = 50;
    ListAdd(list, item1);
    trimmedItem = ListTrim(list);
    assert(trimmedItem == item1);
    assert(ListCount(list) == 0);
    free(trimmedItem);
    ListFree(list, NULL);
    printf("test_ListTrim passed.\n");
}

void test_ListSearch() {
    LIST *list = ListCreate();
    int target;
    int *foundItem;
    int *item1 = malloc(sizeof(int));
    int *item2 = malloc(sizeof(int));
    *item1 = 80;
    *item2 = 90;
    target = 90;

    ListAdd(list, item1);
    ListAdd(list, item2);
    ListFirst(list);

    foundItem = ListSearch(list, intComparator, &target);
    assert(foundItem != NULL);
    assert(*foundItem == 90);

    ListFree(list, free);
    printf("test_ListSearch passed.\n");
}

void test_ListNext() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int *item2 = malloc(sizeof(int));
    void *nextItem;
    *item1 = 100;
    *item2 = 110;

    ListAdd(list, item1);
    ListAdd(list, item2);
    ListFirst(list);

    nextItem = ListNext(list);
    assert(nextItem == item2);

    ListFree(list, free);
    printf("test_ListNext passed.\n");
}

void test_ListPrev() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int *item2 = malloc(sizeof(int));
    void *prevItem;
    *item1 = 120;
    *item2 = 130;

    ListAdd(list, item1);
    ListAdd(list, item2);
    ListLast(list);

    prevItem = ListPrev(list);
    assert(prevItem == item1);

    ListFree(list, free);
    printf("test_ListPrev passed.\n");
}

void test_ListCount() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int *item2 = malloc(sizeof(int));
    *item1 = 140;
    *item2 = 150;

    ListAdd(list, item1);
    ListAdd(list, item2);

    assert(ListCount(list) == 2);

    ListFree(list, free);
    printf("test_ListCount passed.\n");
}

void test_ListCurr_Null() {
    LIST *list = ListCreate();
    void *currItem = ListCurr(list);
    assert(currItem == NULL);
    ListFree(list, NULL);
    printf("test_ListCurr_Null passed.\n");
}

void test_ListFirst_Null() {
    LIST *list = ListCreate();
    void *firstItem = ListFirst(list);
    assert(firstItem == NULL);
    ListFree(list, NULL);
    printf("test_ListFirst_Null passed.\n");
}

void test_ListLast_Null() {
    LIST *list = ListCreate();
    void *lastItem = ListLast(list);
    assert(lastItem == NULL);
    ListFree(list, NULL);
    printf("test_ListLast_Null passed.\n");
}

void test_ListRemove_Null() {
    LIST *list = ListCreate();
    void *removedItem = ListRemove(list);
    assert(removedItem == NULL);
    ListFree(list, NULL);
    printf("test_ListRemove_Null passed.\n");
}

void test_ListTrim_Null() {
    LIST *list = ListCreate();
    void *trimmedItem = ListTrim(list);
    assert(trimmedItem == NULL);
    ListFree(list, NULL);
    printf("test_ListTrim_Null passed.\n");
}

void test_ListAdd_NullList() {
    LIST *list = NULL;
    int *item = malloc(sizeof(int));
    int result;
    *item = 160;
    result = ListAdd(list, item);
    assert(result == EXIT_FAILURE);
    free(item);
    printf("test_ListAdd_NullList passed.\n");
}

void test_ListInsert_NullList() {
    LIST *list = NULL;
    int *item = malloc(sizeof(int));
    int result;
    *item = 170;
    result = ListInsert(list, item);
    assert(result == EXIT_FAILURE);
    free(item);
    printf("test_ListInsert_NullList passed.\n");
}

void test_ListAppend_NullList() {
    LIST *list = NULL;
    int *item = malloc(sizeof(int));
    int result;
    *item = 180;
    result = ListAppend(list, item);
    assert(result == EXIT_FAILURE);
    free(item);
    printf("test_ListAppend_NullList passed.\n");
}

void test_ListPrepend_NullList() {
    LIST *list = NULL;
    int *item = malloc(sizeof(int));
    int result;
    *item = 190;
    result = ListPrepend(list, item);
    assert(result == EXIT_FAILURE);
    free(item);
    printf("test_ListPrepend_NullList passed.\n");
}

void test_ListSearch_NullComparator() {
    LIST *list = ListCreate();
    int *item = malloc(sizeof(int));
    void *foundItem;
    *item = 200;
    ListAdd(list, item);
    foundItem = ListSearch(list, NULL, NULL);
    assert(foundItem == NULL);
    ListFree(list, free);
    printf("test_ListSearch_NullComparator passed.\n");
}

void test_ListConcat_NullLists() {
    LIST *list1 = NULL;
    LIST *list2 = NULL;
    ListConcat(list1, list2);
    printf("test_ListConcat_NullLists passed.\n");
}

void test_ListFree_NullList() {
    ListFree(NULL, NULL);
    printf("test_ListFree_NullList passed.\n");
}

void test_MultipleLists() {
    LIST *lists[5];
    int i;
    for (i = 0; i < 5; i++) {
        lists[i] = ListCreate();
        int *item = malloc(sizeof(int));
        *item = i * 10;
        ListAdd(lists[i], item);
        assert(ListCount(lists[i]) == 1);
    }
    for (i = 0; i < 5; i++) {
        ListFree(lists[i], free);
    }
    printf("test_MultipleLists passed.\n");
}

void test_ListOperationsAfterFree() {
    LIST *list = ListCreate();
    int *item = malloc(sizeof(int));
    int count;
    *item = 210;
    ListAdd(list, item);
    ListFree(list, free);

    /* Try to operate on the freed list */
    count = ListCount(list);
    assert(count == EXIT_FAILURE);
    printf("test_ListOperationsAfterFree passed.\n");
}

void test_ExhaustNodePool() {
    LIST *list = ListCreate();
    int i;
    int numNodes = 200; /* Exceed initial MIN_NODES */
    for (i = 0; i < numNodes; i++) {
        int *item = malloc(sizeof(int));
        *item = i;
        ListAdd(list, item);
    }
    assert(ListCount(list) == numNodes);

    /* Clean up */
    ListFree(list, free);
    printf("test_ExhaustNodePool passed.\n");
}

void test_ExhaustListPool() {
    int i;
    const int numLists = 20; /* Exceed initial MIN_LISTS */
    LIST *lists[20]; /* Fixed-size array */
    for (i = 0; i < numLists; i++) {
        lists[i] = ListCreate();
        assert(lists[i] != NULL);
    }
    for (i = 0; i < numLists; i++) {
        ListFree(lists[i], NULL);
    }
    printf("test_ExhaustListPool passed.\n");
}

void test_ListAddAfterRemoveAll() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    int *item2 = malloc(sizeof(int));
    *item1 = 220;
    ListAdd(list, item1);
    ListRemove(list);
    *item2 = 230;
    ListAdd(list, item2);
    assert(ListCount(list) == 1);
    assert(*(int *)ListCurr(list) == 230);
    ListFree(list, free);
    printf("test_ListAddAfterRemoveAll passed.\n");
}

void test_ListSearchNotFound() {
    LIST *list = ListCreate();
    int target;
    void *foundItem;
    int *item1 = malloc(sizeof(int));
    *item1 = 240;
    target = 250;
    ListAdd(list, item1);
    ListFirst(list);
    foundItem = ListSearch(list, intComparator, &target);
    assert(foundItem == NULL);
    ListFree(list, free);
    printf("test_ListSearchNotFound passed.\n");
}

void test_ListNextBeyondEnd() {
    LIST *list = ListCreate();
    void *nextItem;
    int *item1 = malloc(sizeof(int));
    *item1 = 260;
    ListAdd(list, item1);
    ListNext(list);
    nextItem = ListNext(list);
    assert(nextItem == NULL);
    ListFree(list, free);
    printf("test_ListNextBeyondEnd passed.\n");
}

void test_ListPrevBeyondStart() {
    LIST *list = ListCreate();
    void *prevItem;
    int *item1 = malloc(sizeof(int));
    *item1 = 270;
    ListAdd(list, item1);
    ListPrev(list);
    prevItem = ListPrev(list);
    assert(prevItem == NULL);
    ListFree(list, free);
    printf("test_ListPrevBeyondStart passed.\n");
}

void test_ListAddNullItem() {
    LIST *list = ListCreate();
    int result = ListAdd(list, NULL);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    assert(ListCurr(list) == NULL);
    ListFree(list, NULL);
    printf("test_ListAddNullItem passed.\n");
}

void test_ListInsertNullItem() {
    LIST *list = ListCreate();
    int result = ListInsert(list, NULL);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    assert(ListCurr(list) == NULL);
    ListFree(list, NULL);
    printf("test_ListInsertNullItem passed.\n");
}

void test_ListRemoveFromEmpty() {
    LIST *list = ListCreate();
    void *item = ListRemove(list);
    assert(item == NULL);
    ListFree(list, NULL);
    printf("test_ListRemoveFromEmpty passed.\n");
}

void test_ListTrimFromEmpty() {
    LIST *list = ListCreate();
    void *item = ListTrim(list);
    assert(item == NULL);
    ListFree(list, NULL);
    printf("test_ListTrimFromEmpty passed.\n");
}

int main() {
    test_ListCreate();
    test_ListAdd();
    test2_ListAdd();
    test3_ListAdd();
    test4_ListAdd();
    test5_ListAdd();
    test6_ListAdd();

    test7_ListInsert();
    test8_ListInsert();
    test9_ListInsert();
    test10_ListPrepend();
    //test11_ListConcat();
    test13_ListFirst();

    test_ListAppend();
    test_ListPrepend();
    test_ListRemove();
    test_ListTrim();
    test_ListSearch();
    test_ListNext();
    test_ListPrev();
    test_ListCount();
    test_ListCurr_Null();
    test_ListFirst_Null();
    test_ListLast_Null();
    test_ListRemove_Null();
    test_ListTrim_Null();
    test_ListAdd_NullList();
    test_ListInsert_NullList();
    test_ListAppend_NullList();
    test_ListPrepend_NullList();
    test_ListSearch_NullComparator();
    test_ListConcat_NullLists();
    test_ListFree_NullList();
    test_MultipleLists();
    //test_ListOperationsAfterFree();
    //test_ExhaustNodePool();
    //test_ExhaustListPool();
    test_ListAddAfterRemoveAll();
    test_ListSearchNotFound();
    test_ListNextBeyondEnd();
    test_ListPrevBeyondStart();
    test_ListAddNullItem();
    test_ListInsertNullItem();
    test_ListRemoveFromEmpty();
    test_ListTrimFromEmpty();

    printf("All tests passed successfully.\n");
    return EXIT_SUCCESS;
}
