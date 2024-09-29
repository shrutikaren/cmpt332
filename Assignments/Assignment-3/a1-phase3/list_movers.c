/*
 * Jack Donegan, Shruti Kaur
 * lvf165, ich524
 * 11357744, 11339265
 */

#include <list.h>
#include <stddef.h>

#define UNUSED 0xffffffff

extern LIST * list_space;
extern NODE * node_space;

/* For resizing double pointer. */
/* algolist.net/Data_structures/Hash_table/Dynamic_resizing */

/*
 * Purpose: counts the number of items in the list
 * Returns: the number of items in the list
 */
unsigned int ListCount(LIST_HANDLE list) {
    if (list == UNUSED) {
        return UNUSED;
    }
    return (list_space+list)->count;
}

/*
 * Purpose: provides a pointer to the first item of the list
 * Effects: the current item becomes the first item
 * Returns: a pointer to the first item of the list
 */
void *ListFirst(LIST_HANDLE list) {
    if (list == UNUSED) {
        return NULL;
    }
    (list_space+list)->cursor = (list_space+list)->head;
    return (node_space+(list_space+list)->head)->item;
}

/*
 * Purpose: provides a pointer to the last item of the list
 * Effects: the current item becomes the last item
 * Returns: a pointer to the last item of the list
 */
void *ListLast(LIST_HANDLE list) {
    if (list == UNUSED) {
        return NULL;
    }
    (list_space+list)->cursor = (list_space+list)->tail;
    return (node_space+(list_space+list)->tail)->item;
}

/*
 * Purpose: provides a pointer to the item next to the current item
 * Effects: the current item becomes the item next to it
 * Returns: a pointer to the item next to the current item
 */
void *ListNext(LIST_HANDLE list) {
    if (list == UNUSED) {
        return NULL;
    }
    if ((list_space+list)->cursor == (list_space+list)->tail) {
        return NULL;
    }
    (list_space+list)->cursor = (node_space+(list_space+list)->cursor)->next;
    return (node_space+(list_space+list)->cursor)->item;

}

/*
 * Purpose: provides a pointer to the item previous to the current item
 * Effects: the current item becomes the item previous to it
 * Returns: a pointer to the item previous to the current item
 */
void *ListPrev(LIST_HANDLE list) {
    if (list == UNUSED) {
        return NULL;
    }
    if ((list_space+list)->cursor == (list_space+list)->head) {
        return NULL;
    }
    (list_space+list)->cursor = (node_space+(list_space+list)->cursor)->prev;
    return (node_space+(list_space+list)->cursor)->item;
}

/*
 * Purpose: provides a pointer to the current item
 * Returns: a pointer to the current item
 */
void *ListCurr(LIST_HANDLE list) {
    if (list == UNUSED) {
        return NULL;
    }
    return (node_space+(list_space+list)->cursor)->item;
}

/* 
 * Purpose: searchs the list for comparisonArg using the comparator function
 * Effects: current item becomes the found item, or is set to the last item
 * Returns: a pointer to the item if found, else NULL
 */
void *ListSearch(LIST_HANDLE list, 
	int (*comparator)(void *, void *), 
	void *comparisonArg) {
    unsigned int i;
    if (list == UNUSED) {
        return NULL;
    }
    if (!comparator) {
        return NULL;
    }
    if (!comparisonArg) {
        return NULL;
    }
    if ((list_space+list)->count == 0) {
        return NULL;
    }
    (list_space+list)->cursor = (list_space+list)->head;
    for (i = 0; i < (list_space+list)->count; i++) {
        if (comparator(comparisonArg, (node_space+(list_space+list)->cursor)->item)) {
            return (node_space+(list_space+list)->cursor)->item; 
        }
        (list_space+list)->cursor = 
            (node_space+(list_space+list)->cursor)->next;
    }

    return NULL;
}
