/*
 * Jack Donegan, Shruti Kaur
 * lvf165, ich524
 * 11357744, 11339265
 */

#include <stdio.h>
#include <list.h>

#define UNUSED 0xffffffff

#define PRINT_LIST(L) \
printf(#L " = %u, *{list_space+" #L "} = {%u, %u, %u, %u}\n", \
    L, \
    (list_space+L)->head, \
    (list_space+L)->tail, \
    (list_space+L)->cursor, \
    (list_space+L)->count);

    
#define PRINT_NODE(N, LABEL) \
printf(LABEL " = %u, *{node_space+%u} = {%u, %u, %d}\n", \
    N, \
    N, \
    (node_space+N)->prev, \
    (node_space+N)->next, \
    *(int *)((node_space+N)->item)) 

/* this should not be present in user programs */
extern LIST * list_space;
extern NODE * node_space;

int i = 42;
int j = 96;
int k = 216;

int main() {
    LIST_HANDLE list1 = ListCreate();
    LIST_HANDLE list2 = ListCreate();
    LIST_HANDLE list3 = ListCreate();
    LIST_HANDLE list4 = ListCreate();
    LIST_HANDLE list5 = ListCreate();
    LIST_HANDLE list6 = ListCreate();
    
    LIST_HANDLE list_test;
    
    printf("\nListCreate:\n");
    printf("\nTest1 & 2:\n");

    PRINT_LIST(list1);
    PRINT_LIST(list2);
    PRINT_LIST(list3);
    
    printf("\n");

    printf("\nListPrepend:\n");
    printf("\nTest1:\n");

    ListPrepend(list1, &i);

    PRINT_LIST(list1);
    PRINT_NODE((list_space+list1)->head, "node");

    printf("\nTest2:\n");

    ListPrepend(list1, &j);
    PRINT_LIST(list1);
    PRINT_NODE((list_space+list1)->tail, "node1");
    PRINT_NODE((list_space+list1)->head, "node2");

    printf("\n");

    printf("\nListAppend:\n");
    printf("\nTest1:\n");

    ListAppend(list2, &i);

    PRINT_LIST(list2);
    PRINT_NODE((list_space+list2)->head, "node");

    printf("\nTest2:\n");

    ListAppend(list2, &j);
    PRINT_LIST(list2);
    PRINT_NODE((list_space+list2)->head, "node");
    PRINT_NODE((list_space+list2)->tail, "node");

    printf("\n");

    printf("\nListAdd:\n");
    printf("\nTest1:\n");

    ListAdd(list3, &i);

    PRINT_LIST(list3);
    PRINT_NODE((list_space+list3)->head, "node");

    printf("\nTest2:\n");

    ListAdd(list3, &j);
    PRINT_LIST(list3);
    PRINT_NODE((list_space+list3)->tail, "node1");
    PRINT_NODE((list_space+list3)->head, "node2");

    printf("\nTest3:\n");
    ListAdd(list2, &k);
    PRINT_LIST(list2);
    PRINT_NODE((list_space+list2)->head, "node1");
    PRINT_NODE((list_space+list2)->tail, "node2");
    PRINT_NODE((node_space+((list_space+list2)->head))->next, "node3");
    
    printf("\n");

    printf("\nListInsert:\n");
    printf("\nTest1:\n");

    ListInsert(list4, &i);

    PRINT_LIST(list4);
    PRINT_NODE((list_space+list4)->head, "node");

    printf("\nTest2:\n");
    ListInsert(list4, &j);
    PRINT_LIST(list4);
    PRINT_NODE((list_space+list4)->head, "node1");
    PRINT_NODE((list_space+list4)->tail, "node2");
    
    printf("\nTest3:\n");
    ListInsert(list1, &k);
    PRINT_LIST(list1);
    PRINT_NODE((list_space+list1)->tail, "node1");
    PRINT_NODE((list_space+list1)->head, "node2");
    PRINT_NODE((node_space+((list_space+list1)->head))->next, "node3");

    printf("\n");

    printf("\nListConcat:\n");
    printf("\nTest1:\n");
    ListConcat(list5, list6);
    PRINT_LIST(list5);
    PRINT_LIST(list6);

    /* reset list6 for next test, should be same handle */
    list6 = ListCreate();

    printf("\nTest2:\n");
    ListAppend(list6, &i);
    ListConcat(list5, list6);
    PRINT_LIST(list5);
    PRINT_LIST(list6);
    PRINT_NODE((list_space+list5)->head, "node");

    /* reset */
    list6 = ListCreate();

    printf("\nTest3:\n");
    ListConcat(list5, list6);
    PRINT_LIST(list5);
    PRINT_LIST(list6);
    PRINT_NODE((list_space+list5)->head, "node");

    /* reset */
    list6 = ListCreate();
   
    printf("\nTest4:\n");
    ListAppend(list6, &j);
    ListConcat(list5, list6);
    PRINT_LIST(list5);
    PRINT_LIST(list6);
    PRINT_NODE((list_space+list5)->head, "node1");
    PRINT_NODE((list_space+list5)->tail, "node2");

    printf("\n");    
    
    printf("\nReturn Checking:\n");
    printf("Got to procedure ListCreate\n");
    list_test = ListCreate();
    if (list_test == UNUSED) {
        printf("Error in ListCreate; got UNUSED instead of handle.\n");
    }

    printf("Got to procedure ListPrepend\n");
    if (ListPrepend(list_test, &i) == -1) {
        printf("Error in ListPrepend; got return value of -1.\n");
    }

    printf("Got to procedure ListAppend\n");
    if (ListAppend(list_test, &i) == -1) {
        printf("Error in ListAppend; got return value of -1.\n");
    }

    printf("Got to procedure ListAdd\n");
    if (ListAdd(list_test, &i) == -1) {
        printf("Error in ListAdd; got return value of -1.\n");
    }

    printf("Got to procedure ListInsert\n");
    if (ListInsert(list_test, &i) == -1) {
        printf("Error in ListInsert; got return value of -1.\n");
    }

    printf("Got to procedure ListCount\n");
    if (ListCount(list_test) == UNUSED) {
        printf("Error in ListCount; got return value UNUSED.\n");
    }

    printf("Got to procedure ListFirst\n");
    if (ListFirst(list_test) == NULL) {
        printf("Error in ListFirst; got return value of NULL.\n");
    }

    printf("Got to procedure ListNext\n");
    if (ListNext(list_test) == NULL) {
        printf("Error in ListNext; got return value of NULL.\n");
    }

    printf("Got to procedure ListLast\n");
    if (ListLast(list_test) == NULL) {
        printf("Error in ListLast; got return value of NULL.\n");
    }

    printf("Got to procedure ListPrev\n");
    if (ListPrev(list_test) == NULL) {
        printf("Error in ListPrev; got return value of NULL.\n");
    }

    printf("Got to procedure ListCurr\n");
    if (ListCurr(list_test) == NULL) {
        printf("Error in ListCurr; got return value of NULL.\n");
    }

    printf("Got to procedure ListRemove\n");
    if (ListRemove(list_test) == NULL) {
        printf("Error in ListRemove; got return value of NULL.\n");
    }

    printf("Got to procedure ListTrim\n");
    if (ListTrim(list_test) == NULL) {
        printf("Error in ListTrim; got return value of NULL.\n");
    }

    printf("Got to procedure ListSearch\n");
    if (ListSearch(list_test, NULL, NULL) == NULL) {
        printf("Error in ListSearch; got return value of NULL.\n");
    }

    return 0;
}
