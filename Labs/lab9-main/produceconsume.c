#include <linux/circ_buf.h> /* For circular buffers */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

/* More header files for this problem specifically */
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/spinlock.h>
#include <linux/sched.h>
#include <linux/wait.h>
#include <linux/uaccess.h>

#define BUF_SIZE 128
static char buffer_data[BUF_SIZE];
static struct circular_buffer buffer = {
	buf = buffer_data;
	head = 0;
	tail = 0;	
};

/* Creating the producer that produce those messages.
 * It will write data intothe circular buffer while
 * ensuring that it doesn't overwrite any data */



/* Consumer code that consumes the message produced.
 * In simplest terms, you would read the data from 
 * the circular buffer to ensure that there is no
 * overhead data available. */
