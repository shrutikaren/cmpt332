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
static spinlock_t lock_buffer;
static wait_queue_head_t wait_queue;

/* Creating the producer that produce those messages.
 * It will write data intothe circular buffer while
 * ensuring that it doesn't overwrite any data */
ssize_t producer(const char *user_buffer, size_t count){
	unsigned long flags;
	size_t bytes_written = 0;
	while (count > 0){
		size_t space_remain = CIRC_SPACE(buffer.head, buffer.tail, BUF_SIZE);
		if (space_remain == 0){
			/* No more space remains - wait patiently */
			spin_unlock_irqrestore(&lock_buffer, flags);
		}
	}
}


/* Consumer code that consumes the message produced.
 * In simplest terms, you would read the data from 
 * the circular buffer to ensure that there is no
 * overhead data available. */
