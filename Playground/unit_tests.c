#include <assert.h>
#include <stdio.h>
#include "list.h"

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
int main(int argc, char *argv[]){
    
    test_ListCreate();
    test_ListAdd();
    test2_ListAdd();
    /* Remove all the memory at the end. */
    ListDispose();

    return EXIT_SUCCESS;

}
