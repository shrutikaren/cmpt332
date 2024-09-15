#include <stdio.h>
#include "list.h"

int main() {

    printf("Got to procedure main\n");

    LIST *myList = ListCreate();
    if (myList == NULL) {
        printf("Error: Failed to create list\n");
        return 1;
    }

    int item1 = 10;
    int item2 = 20;

    if (ListAdd(myList, &item1) != 0) {
        printf("Error: ListAdd failed\n");
    }

    if (ListInsert(myList, &item2) != 0) {
        printf("Error: ListInsert failed\n");
    }

    ListFree(myList, NULL);

    return 0;

}

