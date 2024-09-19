i#include <stdio.h>
#include <list.h>

int main() {
    LIST* list = ListCreate();
    ListAdd(list, NULL);
    ListInsert(list, NULL);
    ListAppend(list, NULL);
    ListPrepend(list, NULL);
    ListConcat(list, NULL);
    ListCount(list);
    ListFirst(list);
    ListLast(list);
    ListNext(list);
    ListPrev(list);
    ListCurr(list);
    ListSearch(list, NULL, NULL);
    ListRemove(list);
    ListFree(list, NULL);
    ListTrim(list);

    return 0;
}


