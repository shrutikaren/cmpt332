#include <assert.h>
#include <stdio.h>
#include "list.h"

/* Checking if list was created */
void test_ListCreate(){
    LIST* list = ListCreate();
    assert(list != NULL);
    assert(ListCount(list) == 0);
    printf("test_ListCreate passed.\n");
    ListFree(list, NULL);
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

    printf("test6_ListAdd passed. \n");
}


int main(){
    
    test_ListCreate();
    test_ListAdd();
    test2_ListAdd();
    test3_ListAdd();
    test4_ListAdd(); 
    test5_ListAdd();
    test6_ListAdd();

    /* Remove all the memory at the end. */
    ListDispose();

    return EXIT_SUCCESS;

}
