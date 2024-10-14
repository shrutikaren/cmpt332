/*
 * Shruti Kaur
 * ich524
 * 11339265
 */


#include <stddef.h>
#include <list.h>

#define UNUSED 0xffffffff

extern LIST * list_space;
extern unsigned int list_count;
extern NODE * node_space;
extern unsigned int node_count;


/*
 * Purpose: pops the current item from the list
 * Effects: current item becomes it's next item
 * Returns: a pointer to the current item
 */
void *ListRemove(LIST_HANDLE list) {
    void * item;
    NODE_HANDLE node;
    if (list == UNUSED) {
        return NULL;
    }
    if ((list_space+list)->count == 0) {
        return NULL;
    }
    item = (node_space+(list_space+list)->cursor)->item;
    if ((list_space+list)->count == 1) {
        (list_space+list)->head = UNUSED;
        (list_space+list)->tail = UNUSED;
        (list_space+list)->cursor = UNUSED;
        (list_space+list)->count = 0;
        return item;
    };
    node = (node_space+(list_space+list)->cursor)->prev;
    if (!((list_space+list)->cursor == (list_space+list)->head)) {
        (node_space+node)->next = (node_space+(list_space+list)->cursor)->next;
    }
    if (!((list_space+list)->cursor == (list_space+list)->tail)) {
        (node_space+(node_space+(list_space+list)->cursor)->next)->prev = node;
    }

    (node_space+(list_space+list)->cursor)->item = NULL;
    node_count--;

    return item;
}

/*
 * Purpose: deletes the list, itemFree is used to delete individual items
 */
void ListFree(LIST_HANDLE list, void (*itemFree)(void *)) {
    NODE_HANDLE node;
    if (list == UNUSED) {
        return;
    }
    if (!itemFree) {
        return;
    }
    node = (list_space+list)->head;
    while (node != UNUSED) {
        itemFree((node_space+node)->item);
        (node_space+node)->item = NULL;
        node_count--;
        node = (node_space+node)->next;
    }
    (list_space+list)->count = UNUSED;
    list_count--;

    return;
}

/*
 * Purpose: pops the item from the end of the list
 * Effects: the current item is set to the new last item
 * Returns: a pointer to this item
 */
void *ListTrim(LIST_HANDLE list) {
    void * item;
    NODE_HANDLE node;
    if (list == UNUSED) {
        return NULL;
    }
    if ((list_space+list)->count == 0) {
        return NULL;
    }
    item = (node_space+(list_space+list)->tail)->item;
    if ((list_space+list)->count == 1) {
        (list_space+list)->head = UNUSED;
        (list_space+list)->tail = UNUSED;
        (list_space+list)->cursor = UNUSED;
        (list_space+list)->count = 0;
        return item;
    };
    node = (node_space+(list_space+list)->tail)->prev;
    (node_space+node)->next = (node_space+(list_space+list)->tail)->next;

    (node_space+(list_space+list)->tail)->item = NULL;
    node_count--;

    return item;
}
