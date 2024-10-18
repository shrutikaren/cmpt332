#include <assert.h>
#include <stdio.h>
#include "list.h"

void test_ListCreate(){
    LIST* list = ListCreate();
    assert(list != NULL);
    assert(ListCount(list) == 0);
    ListFree(list, NULL);
    printf("test_ListCreate passed.\n");
}

int main(int argc, char *argv[]){
    
    test_ListCreate();
    return EXIT_SUCCESS;

}
