#include <assert.h>
#include <stdio.h>
#include "list.h"
#include <assert.h>
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

    ListDispose();
    printf("test_10_ListPrepend() passed\n");
    /*printf("%d this is the count\n",ListCount(list));*/
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

void test12_ListDispose(){
    LIST* list = ListCreate();
    int i, result, total;
    total = 100;
    for (i = 0; i < total; i ++){
	result = ListAppend(list, &i);
    }

    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 100);
    assert(*(int*)ListCurr(list) == 100);

    ListDispose();
    assert(ListCount(list) == 100);
    assert((int *)ListCurr(list) == NULL);
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
    test12_ListDispose();
    test13_ListFirst();
    return EXIT_SUCCESS;
}
