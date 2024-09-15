#include <stdio.h>
#include "list.h"

int main() {

    printf("Got to procedure main\n");

    LIST *myList = ListCreate();

    // Checks to see if we allocated the list.
    if (myList == NULL) {
        printf("Error: Failed to create list\n");
        return 1;
    }

    return 0;

}

