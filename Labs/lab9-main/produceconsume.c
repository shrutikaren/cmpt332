#include <include/linux/circ_buf.h> /* For circular buffers */
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
	bool condition;
	size_t remaining_space, min_to_write;
	while (count > 0){
		size_t space_remain = CIRC_SPACE(buffer.head, buffer.tail, BUF_SIZE);
		if (space_remain == 0){
			/* No more space remains - wait patiently */
			spin_unlock_irqrestore(&lock_buffer, flags);
			if (CIRC_SPACEE(buffer.head, buffer.tail, BUF_SIZE) > 0){
				condition = true;
			} else{
				condition = false;
			}
			/* Utilize wait_event_interruptible to sleep until
			 * a condition is finally true */
			wait_event_interruptible(wait_queue, condition);
			spin_lock_irqsave(&lock_buffer, flags);
		}
		remaining_space = CIRC_SPACE_TO_END(buffer.head, buffer.tail, BUF_SIZE);

		size_t min_to_write = min(remaining_space, count);

	}

}


/* Consumer code that consumes the message produced.
 * In simplest terms, you would read the data from 
 * the circular buffer to ensure that there is no
 * overhead data available. */

static int __init producer_consumer_init(void){
	spin_lock_init(&lock_buffer);
	init_waitqueue_head(&wait_queue);
	printk(KERN INFO "Producer-Consumer Problem Code is now enterring successfully");
	return 0;
}

static void __exit producer_consumer_init(void){
	printk(KERN_INFO "Producer-Consumer Problem Code is now successfully exiting");

}
module_init(producer_consumer_init);
module_exit(producer_consumer_exit);
MODULE_LICENSE("GPL");
