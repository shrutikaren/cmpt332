/*
	Shruti Kaur
	ICH524
	11339265
*/
#include <stdlib.h>
#include "list.h"

#define MIN_LISTS 2
#define MIN_NODES 2

#define UNUSED 0xffffffff

/*
 * Allowed to use more than one array.
 *
 * Double pointer array is an acceptable solution: however, you will lose
 * marks.
 */

/*
 * Purpose: Retrieves a node from node_space, and allocates more memory if
 * there is not enough.
 * Preconditions: int i; NODE_HANDLE node; NODE * temp; must be declared 
 * Postconditions: node is set to an empty node, or NULL on failure
 */
#define NODECREATE(on_error) { \
    /* Allocate more memory if we don't have enough space. */ \
    node = UNUSED; \
    if (node_count >= MIN_LISTS) { \
        temp = (NODE *)realloc(node_space, \
                (MIN_NODES << (node_mult + 1)) * sizeof(NODE)); \
        if (!temp) { \
            return on_error; \
        } \
        node_space = temp;\
        node_mult++;\
    } \
    \
    for (i = 0; i < (unsigned int)(MIN_NODES << (node_count / MIN_NODES)) \
            ; i++) { \
        if (!(node_space+i)->item) { \
            node_count++; \
            \
            (node_space+i)->next = UNUSED; \
            (node_space+i)->prev = UNUSED; \
            \
            node = i; \
            break; \
        } \
    } \
}

/*
 * Purpose: Check if the amount of used lists is at or below half the capacity
 * of the allocated space.
 * Postcondition: if there are half or less of the lists used, halfs the
 * allocated space.
 */

LIST * list_space;
NODE * node_space;
unsigned int list_count, node_count, list_mult, node_mult;

/*
 * Purpose: initializes an empty List to be further used by other functions.
 * Returns: a list pointer or NULL on error
 */
LIST_HANDLE ListCreate() {
    LIST * temp;
    unsigned long i;
   
    if (!list_space) {
        list_space = (LIST *)malloc(MIN_LISTS * sizeof(LIST));
        if (!list_space) {
            return UNUSED;
        }
        for (i = 0; i < MIN_LISTS; i++) {
            (list_space+i)->count = UNUSED;
        }
        list_mult = 0;
        list_count = 0;
    }
   
    if (!node_space) {
        node_space = (NODE *)malloc(MIN_NODES * sizeof(NODE));
        if (!node_space) {
            free(list_space);
            list_space = NULL;
            return UNUSED;
        }
        for (i = 0; i < MIN_NODES; i++) {
            (node_space+i)->item = NULL;
        }
        node_mult = 0;
        node_count = 0;
    }
    
    /* We assign the return value of realloc to a temporary value first.
     * realloc will return NULL if we don't have enough memory BUT won't
     * delete the original pointer. */
    if (list_count >= (unsigned int)(MIN_LISTS << list_mult)) {
        temp = (LIST *)realloc(list_space,
                (MIN_LISTS << (list_mult + 1)) * sizeof(LIST));
        if (!temp) {
            return UNUSED;
        }
        list_space = temp;
        for (i = 0; i < (unsigned int)(MIN_LISTS << (list_mult)); i++) {
            (list_space+i+(MIN_LISTS << list_mult))->count = UNUSED;
        }
        list_mult++;
    }
   
    for (i = 0; i < (unsigned int)(MIN_LISTS << (list_mult)); i++) {
        if ((list_space+i)->count == UNUSED) {
            list_count++;

            /* clear out list */
            (list_space+i)->head = UNUSED;
            (list_space+i)->tail = UNUSED;
            (list_space+i)->cursor = UNUSED;
            (list_space+i)->count = 0;

            return i;
        }
    }

    return UNUSED;
}

/*
 * Purpose: inserts an item into the list before the current item
 * Returns: 0 on success, -1 on failure
 */
int ListInsert(LIST_HANDLE list, void *item) {
    NODE * temp;
    NODE_HANDLE node, cursor;
    unsigned int i;

    if (list == UNUSED) {
        return -1;
    }
    if (!item) {
        return -1;
    }

    NODECREATE(-1);
    (node_space+node)->item = item;
    
    cursor = (list_space+list)->cursor;

    if ((list_space+list)->count == 0) {
       (list_space+list)->head = node;
       (list_space+list)->tail = node;
       (list_space+list)->cursor = node;
       (list_space+list)->count++;
       return 0;
    }
   
    (node_space+node)->prev = (list_space+list)->cursor;
    if ((node_space+cursor)->next == UNUSED) {
        (node_space+cursor)->next = node;
        (list_space+list)->tail = node;
    } else {
        (node_space+(node_space+cursor)->next)->prev = node;
        (node_space+node)->next = (node_space+cursor)->next;
        (node_space+cursor)->next = node;
    }
    (list_space+list)->cursor = node;
    (list_space+list)->count++;
   
    return 0;
}

/*
 * Purpose: inserts an item into the list after the current item
 * Returns: 0 on success, -1 on failure
 */
int ListAdd(LIST_HANDLE list, void *item) {
    NODE * temp;
    NODE_HANDLE node, cursor;
    unsigned int i;

    if (list == UNUSED) {
        return -1;
    }
    if (!item) {
        return -1;
    }

    NODECREATE(-1);

    (node_space+node)->item = item;
    cursor = (list_space+list)->cursor;

    if ((list_space+list)->count == 0) {
        (list_space+list)->head = node;
        (list_space+list)->tail = node;
        (list_space+list)->cursor = node;
        (list_space+list)->count++;
        return 0;
    }

    (node_space+node)->next = (list_space+list)->cursor;
    if ((node_space+cursor)->prev == UNUSED) {
        (node_space+cursor)->prev = node;
        (list_space+list)->head = node;
    } else {
        (node_space+(node_space+cursor)->prev)->next = node;
        (node_space+node)->prev = (node_space+cursor)->prev;
        (node_space+cursor)->prev = node;
    }
    (list_space+list)->cursor = node;
    (list_space+list)->count++;

    return 0;
}

/*
 * Purpose: appends an item to the end of the list
 * Returns: 0 on success, -1 on failure
 */
int ListAppend(LIST_HANDLE list, void *item) {
    NODE * temp;
    NODE_HANDLE node;
    unsigned int i;

    if (list == UNUSED) {
        return -1;
    }
    if (!item) {
        return -1;
    }

    NODECREATE(-1);

    (node_space+node)->item = item;

    if ((list_space+list)->count == 0) {
        (list_space+list)->head = node;
        (list_space+list)->tail = node;
        (list_space+list)->cursor = node;
        (list_space+list)->count++;
        return 0;
    }
   
    (node_space+((list_space+list)->tail))->next = node;
    (node_space+node)->prev = (list_space+list)->tail;
    (list_space+list)->tail = node;
    (list_space+list)->cursor = node;
    (list_space+list)->count++;

    return 0;
}

/*
 * Purpose: prepends an item to the start of the list
 * Returns: 0 on success, -1 on failure
 */
int ListPrepend(LIST_HANDLE list, void *item) {
    NODE * temp;
    NODE_HANDLE node;
    unsigned int i;

    if (list == UNUSED) {
        return -1;
    }
    if (!item) {
        return -1;
    }

    NODECREATE(-1);

    (node_space+node)->item = item;

    if ((list_space+list)->count == 0) {
       (list_space+list)->head = node;
       (list_space+list)->tail = node;
       (list_space+list)->cursor = node;
       (list_space+list)->count++;
       return 0;
    }

    (node_space+(list_space+list)->head)->prev = node;
    (node_space+node)->next = (list_space+list)->head;
    (list_space+list)->head = node;
    (list_space+list)->cursor = node;
    (list_space+list)->count++;

    return 0;
}

/*
 * Purpose: adds list2 to the end of list1
 * Postconditions: list2 is destroyed
 * Note: List memory will not be reduced in this function until Phase 3.
 *       Only increasing memory is required for Phase 2.
 */
void ListConcat(LIST_HANDLE list1, LIST_HANDLE list2) {
    if (list1 == UNUSED) {
        return;
    }
    if (list2 == UNUSED) {
        return;
    }
    /* We allow the concatenation of empty lists.*/
    if ((list_space+list2)->count == 0) {
        (list_space+list2)->count = UNUSED;
        return;
    }
    /* In the event list1 is empty and list2 is not, copy list2 into list1,
     * and free it.*/
    if ((list_space+list1)->count == 0) {
        (list_space+list1)->head = (list_space+list2)->head;
        (list_space+list1)->tail = (list_space+list2)->tail;
        (list_space+list1)->cursor =(list_space+list2)->cursor;
        (list_space+list1)->count = (list_space+list2)->count;
        (list_space+list2)->count = UNUSED;
        return;
    }

    (node_space+(list_space+list1)->tail)->next = (list_space+list2)->head;
    (node_space+(list_space+list2)->head)->prev = (list_space+list1)->tail;
    (list_space+list1)->tail = (list_space+list2)->tail;
    (list_space+list1)->count += (list_space+list2)->count;
    
    (list_space+list2)->count = UNUSED;
    list_count--;
    /* TODO: add list_count check (macro?) to reduce memory for Phase 3. */
    

    return;
}
