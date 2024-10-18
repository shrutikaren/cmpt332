#include <assert.h>
#include <stdio.h>
#include "list.h"

void test_ListCreate(){
    LIST* list = ListCreate();
    assert(list != NULL);
    assert(ListCount(list) == 0);
    printf("test_ListCreate passed.\n");
}

int main(int argc, char *argv[]){
    
    test_ListCreate();

    /* Remove all the memory at the end. */
    ListDispose();

    return EXIT_SUCCESS;

}
