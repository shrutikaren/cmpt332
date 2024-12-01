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
			if (CIRC_SPACE(buffer.head, buffer.tail, BUF_SIZE) > 0){
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
		if (copy_from_user(buffer.buf + buffer.head, user_buffer + bytes_written, min_to_write)){
				spin_unlock_irqrestore(&lock_buffer, flags);I
				return -EFAULT;
				}

	I	buffer.head = buffer.head + min_to_write;
		count -= min_to_write;
		bytes_written += min_to_write;	
	}
	spin_unlock_irqrestore(&lock_buffer, flags);
	wake_up_interruptible(&wait_queue);
	return bytes_written;
}


/* Consumer code that consumes the message produced.
 * In simplest terms, you would read the data from 
 * the circular buffer to ensure that there is no
 * overhead data available. */
ssize_t consumer(const char *user_buffer, size_t count){
	unsigned long flags;
	bool condition;
	size_t bytes_read = 0;
	spin_lock_irqsave(&lock_buffer, flags);
	while (count > 0 ){
		size_t occupancy = CIRC_CNT(buffer.head, buffer.tail, BUF_SIZE);
		if (occupancy == 0){
			spin_unlock_irqrestore(&lock_buffer, flags);
			if (CIRC_CNT(buffer.head, buffer.tail, BUF_SIZE)){
				condition = true;
			}
			else{
				condition = false;
			}
			wait_event_interruptible(buffer_wait_queue, condition);
			spin_lock_irqsave(&lock_buffer, flags);
		}
		remaining_occupancy = CTRC_CNT_TO_END(buffer.head, buffer.tail, BUF_SIZE);
		size_t min_to_read = min(remaining_occupancy, count);
	}
}
