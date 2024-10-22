#include <assert.h>
#include <stdio.h>
#include "list.h"
#include <assert.h>

/* Comparator function for testing ListSearch */
int intComparator(void *pItem, void *pComparisonArg) {
    return (*(int *)pItem == *(int *)pComparisonArg);
}

/* Checking if list was created */
void test_ListCreate(){
    LIST* list = ListCreate();
    assert(list != NULL);
    assert(ListCount(list) == 0);
    printf("test_ListCreate passed.\n");
}

/* Checking if list created with one item */
void test_ListAdd(){
    LIST* list = ListCreate();
    int item1 = 3;
    int result = ListAdd(list, &item1);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    assert(*(int*)ListCurr(list) == 3);
    printf("test_ListAdd passed.\n");
}

void test2_ListAdd(){
    LIST* list = NULL;
    int item1 = 4;
    int result = ListAdd(list, &item1);
    assert(result==EXIT_FAILURE);
    printf("test2_ListAdd passed.\n");
}

void test3_ListAdd(){
    LIST* list = ListCreate();
    void* item = NULL;
    int result = ListAdd(list, &item);
    assert(result==EXIT_SUCCESS);
    printf("test3_ListAdd passed. \n");
}

void test4_ListAdd(){
    LIST* list = ListCreate();
    int item1 = 4;
    int item3 = 0;
    int item4 = 10000;
    int item5 = 200;
    int r1 = ListAdd(list, &item1);
    int r2 = ListAdd(list, &item3);
    int r3 = ListAdd(list, &item4);
    int r4 = ListAdd(list, &item5);
    assert(r1 == EXIT_SUCCESS);
    assert(r2 == EXIT_SUCCESS);
    assert(r3 == EXIT_SUCCESS);
    assert(r4 == EXIT_SUCCESS);
    assert(*(int*)ListCurr(list) == 200);
    assert(ListCount(list) == 4);
    printf("test4_ListAdd passed. \n");
}

void test5_ListAdd(){
    LIST* list = ListCreate();
    int item1 = 4;
    int item2 = -1; /* UNUSED_NODE */
    int r1 = ListAdd(list, &item1);
    int r2 = ListAdd(list, &item2);
    assert(r1 == EXIT_SUCCESS);
    assert(r2 == EXIT_SUCCESS);
    assert(*(int*)ListCurr(list) == -1);
    printf("test5_ListAdd passed. \n");
}

void test6_ListAdd(){

    int i, result;
    LIST* list = ListCreate();
    const int numitems = 1000000;

    for(i = 0; i < numitems; i ++){
        int *item = (int *)malloc(sizeof(int));
        *item = i;
        result = ListAdd(list, item);
        assert(result==EXIT_SUCCESS);
	assert(ListCount(list) == i + 1);
        assert(*(int *)ListCurr(list) == i);
    }

    ListFirst(list);
    for (i = 0; i < numitems; i++) {
        assert(*(int*)ListCurr(list) == i);
        if(i < numitems - 1){
            assert(ListNext(list) != NULL);
        }
    }

    for(i = 0; i < numitems; i++){
        void* item = ListRemove(list);
        free(item);
    }

    assert(ListCount(list) == 0);

    printf("test6_ListAdd passed. \n");
}

void test7_ListInsert(){
    LIST* list = ListCreate();
    int i;
    int result;
    const int numitems =  5;

    for (i = 0; i < numitems; i++){
	result = ListInsert(list, &i);
    } 	
    assert(result == EXIT_SUCCESS);
    assert(*(int *)ListCurr(list) == 5);
    assert(ListCount(list) == 5);
    printf("test7_ListInsert() passed. \n");
}

/* Testing for the edge cases */
void test8_ListInsert(){
    LIST*  list = NULL;
    int result;
    int item1 = 5;
    result = ListInsert(list, &item1);
    assert(result == EXIT_FAILURE);
    printf("test8_ListInsert() passed \n");
}

void test9_ListInsert(){ 
    LIST* list = ListCreate();
    int i, result, resultappend;
    int item;
    int totaliter = 1000000;
    for (i = 0; i < totaliter; i++){
	result = ListInsert(list, &i);
    }
    assert(result == EXIT_SUCCESS);
    
    item = 9;
    resultappend = ListAppend(list, &item);
    assert(resultappend == EXIT_SUCCESS);
    /* 9 should be sitting at the cursor */
    assert(*(int*)ListCurr(list)==9);
    assert(ListCount(list) == 1000001);
    printf("test9_ListInsert() passed\n");
}

void test10_ListPrepend(){
    LIST* list = ListCreate();
    int i,iteritem, result, resultprepend;
    iteritem = 10;
    for (i = 0; i < iteritem; i++){
	result = ListInsert(list, &i);
    }
    assert(result == EXIT_SUCCESS);
    assert(*(int*)ListCurr(list) == 10);
    assert(ListCount(list) == 10);

    i = 20;
    resultprepend = ListPrepend(list, &i);
    assert(resultprepend == EXIT_SUCCESS);
    assert(*(int*)ListCurr(list)==20);
    assert(ListCount(list) == 11);

    printf("test_10_ListPrepend() passed\n");
}

void test11_ListConcat(){
    LIST* list_1 = ListCreate();
    LIST* list_2 = ListCreate();

    int iter_1, iter_2;
    int i;
    iter_1 = 10;
    iter_2 = 20;
    for (i = 0; i < iter_1; i ++){
	ListPrepend(list_1, &iter_1);
    }
    assert(ListCount(list_1) == 10);
    for (i = 0; i < iter_2; i ++){
	ListPrepend(list_2, &iter_2);
    }
    assert(ListCount(list_2) == 20);
    ListConcat(list_1, list_2);
    assert(ListCount(list_1) == 30);
    assert(*(int*)ListCurr(list_1) == 10);
    printf("test11_ListConcat() passed\n");
}

void test13_ListFirst(){
    LIST* list = ListCreate();
    int i, iter;
    int* item;
    iter = 15;
    for (i = 0; i < iter; i ++){
 	ListAppend(list, &i);
    }
    item = ListFirst(list);
    printf("%d item", *item);
}

void test_ListAppend() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 20;
    int result = ListAppend(list, item1);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    assert(*(int *)ListLast(list) == 20);
    ListFree(list, free);
    printf("test_ListAppend passed.\n");
}

void test_ListPrepend() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 30;
    int result = ListPrepend(list, item1);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    assert(*(int *)ListFirst(list) == 30);
    ListFree(list, free);
    printf("test_ListPrepend passed.\n");
}

void test_ListRemove() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 40;
    ListAdd(list, item1);
    int *removedItem = ListRemove(list);
    assert(removedItem == item1);
    assert(ListCount(list) == 0);
    free(removedItem);
    ListFree(list, NULL);
    printf("test_ListRemove passed.\n");
}

void test_ListTrim() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 50;
    ListAdd(list, item1);
    int *trimmedItem = ListTrim(list);
    assert(trimmedItem == item1);
    assert(ListCount(list) == 0);
    free(trimmedItem);
    ListFree(list, NULL);
    printf("test_ListTrim passed.\n");
}

void test_ListConcat() {
    LIST *list1 = ListCreate();
    LIST *list2 = ListCreate();

    int *item1 = malloc(sizeof(int));
    *item1 = 60;
    int *item2 = malloc(sizeof(int));
    *item2 = 70;

    ListAdd(list1, item1);
    ListAdd(list2, item2);

    ListConcat(list1, list2);

    assert(ListCount(list1) == 2);
    assert(*(int *)ListFirst(list1) == 60);
    assert(*(int *)ListLast(list1) == 70);

    ListFree(list1, free);
    printf("test_ListConcat passed.\n");
}

void test_ListSearch() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 80;
    int *item2 = malloc(sizeof(int));
    *item2 = 90;
    int target = 90;

    ListAdd(list, item1);
    ListAdd(list, item2);
    ListFirst(list);

    int *foundItem = ListSearch(list, intComparator, &target);
    assert(foundItem != NULL);
    assert(*foundItem == 90);

    ListFree(list, free);
    printf("test_ListSearch passed.\n");
}

void test_ListNext() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 100;
    int *item2 = malloc(sizeof(int));
    *item2 = 110;

    ListAdd(list, item1);
    ListAdd(list, item2);
    ListFirst(list);

    void *nextItem = ListNext(list);
    assert(nextItem == item2);

    ListFree(list, free);
    printf("test_ListNext passed.\n");
}

void test_ListPrev() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 120;
    int *item2 = malloc(sizeof(int));
    *item2 = 130;

    ListAdd(list, item1);
    ListAdd(list, item2);
    ListLast(list);

    void *prevItem = ListPrev(list);
    assert(prevItem == item1);

    ListFree(list, free);
    printf("test_ListPrev passed.\n");
}

void test_ListCount() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 140;
    int *item2 = malloc(sizeof(int));
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
    *item = 160;
    int result = ListAdd(list, item);
    assert(result == EXIT_FAILURE);
    free(item);
    printf("test_ListAdd_NullList passed.\n");
}

void test_ListInsert_NullList() {
    LIST *list = NULL;
    int *item = malloc(sizeof(int));
    *item = 170;
    int result = ListInsert(list, item);
    assert(result == EXIT_FAILURE);
    free(item);
    printf("test_ListInsert_NullList passed.\n");
}

void test_ListAppend_NullList() {
    LIST *list = NULL;
    int *item = malloc(sizeof(int));
    *item = 180;
    int result = ListAppend(list, item);
    assert(result == EXIT_FAILURE);
    free(item);
    printf("test_ListAppend_NullList passed.\n");
}

void test_ListPrepend_NullList() {
    LIST *list = NULL;
    int *item = malloc(sizeof(int));
    *item = 190;
    int result = ListPrepend(list, item);
    assert(result == EXIT_FAILURE);
    free(item);
    printf("test_ListPrepend_NullList passed.\n");
}

void test_ListSearch_NullComparator() {
    LIST *list = ListCreate();
    int *item = malloc(sizeof(int));
    *item = 200;
    ListAdd(list, item);
    void *foundItem = ListSearch(list, NULL, NULL);
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
    for (int i = 0; i < 5; i++) {
        lists[i] = ListCreate();
        int *item = malloc(sizeof(int));
        *item = i * 10;
        ListAdd(lists[i], item);
        assert(ListCount(lists[i]) == 1);
    }
    for (int i = 0; i < 5; i++) {
        ListFree(lists[i], free);
    }
    printf("test_MultipleLists passed.\n");
}

void test_ListOperationsAfterFree() {
    LIST *list = ListCreate();
    int *item = malloc(sizeof(int));
    *item = 210;
    ListAdd(list, item);
    ListFree(list, free);

    /* Try to operate on the freed list */
    int count = ListCount(list);
    assert(count == EXIT_FAILURE);
    printf("test_ListOperationsAfterFree passed.\n");
}

void test_ExhaustNodePool() {
    LIST *list = ListCreate();
    int numNodes = 200; // Exceed initial MIN_NODES
    for (int i = 0; i < numNodes; i++) {
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
    int numLists = 20; // Exceed initial MIN_LISTS
    LIST *lists[numLists];
    for (int i = 0; i < numLists; i++) {
        lists[i] = ListCreate();
        assert(lists[i] != NULL);
    }
    for (int i = 0; i < numLists; i++) {
        ListFree(lists[i], NULL);
    }
    printf("test_ExhaustListPool passed.\n");
}

void test_ListAddAfterRemoveAll() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 220;
    ListAdd(list, item1);
    ListRemove(list);
    int *item2 = malloc(sizeof(int));
    *item2 = 230;
    ListAdd(list, item2);
    assert(ListCount(list) == 1);
    assert(*(int *)ListCurr(list) == 230);
    ListFree(list, free);
    printf("test_ListAddAfterRemoveAll passed.\n");
}

void test_ListSearchNotFound() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 240;
    int target = 250;
    ListAdd(list, item1);
    ListFirst(list);
    void *foundItem = ListSearch(list, intComparator, &target);
    assert(foundItem == NULL);
    ListFree(list, free);
    printf("test_ListSearchNotFound passed.\n");
}

void test_ListNextBeyondEnd() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 260;
    ListAdd(list, item1);
    ListNext(list);
    void *nextItem = ListNext(list);
    assert(nextItem == NULL);
    ListFree(list, free);
    printf("test_ListNextBeyondEnd passed.\n");
}

void test_ListPrevBeyondStart() {
    LIST *list = ListCreate();
    int *item1 = malloc(sizeof(int));
    *item1 = 270;
    ListAdd(list, item1);
    ListPrev(list);
    void *prevItem = ListPrev(list);
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


int main(){
    
    test_ListCreate();
    test_ListAdd();
    test2_ListAdd();
    test3_ListAdd();
    test4_ListAdd(); 
    test5_ListAdd();
    test6_ListAdd();
		
    test7_ListInsert();
    /* Remove all the memory at the end. */
    test8_ListInsert();

    /* Works on both list append and list insert */
    test9_ListInsert();
    test10_ListPrepend();
    test11_ListConcat();
    test13_ListFirst();


    test_ListAppend();
    test_ListPrepend();
    test_ListRemove();
    test_ListTrim();
    test_ListConcat();
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
    test_ListOperationsAfterFree();
    test_ExhaustNodePool();
    test_ExhaustListPool();
    test_ListAddAfterRemoveAll();
    test_ListSearchNotFound();
    test_ListNextBeyondEnd();
    test_ListPrevBeyondStart();
    test_ListAddNullItem();
    test_ListInsertNullItem();
    test_ListRemoveFromEmpty();
    test_ListTrimFromEmpty();

    return EXIT_SUCCESS;
}
