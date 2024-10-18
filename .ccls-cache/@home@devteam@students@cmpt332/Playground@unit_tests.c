#include <assert.h>
#include <stdio.h>
#include "list.h"

void test_ListCreate(){
    LIST* list = ListCreate();
    assert(list != NULL);
    assert(ListCount(list) == 0);
    printf("test_ListCreate passed.\n");
}

void test_ListAdd(){
    LIST* list = ListCreate();
    int item1 = 1;
    int result = ListAdd(list, &item1);
    assert(result == EXIT_SUCCESS);
    assert(ListCount(list) == 1);
    printf("test_ListCreate passed.\n");
}

int main(int argc, char *argv[]){
    
    test_ListCreate();
    test_ListAdd();

    /* Remove all the memory at the end. */
    ListDispose();

    return EXIT_SUCCESS;

}
