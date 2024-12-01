/* pipe-driver.c - Virtual FIFO Device Driver */

#include <linux/module.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <linux/device.h>
#include <linux/mutex.h>
#include <linux/uaccess.h>
#include <linux/wait.h>
#include <linux/sched.h>
#include <linux/init.h>

#define DEVICE_NAME "fifo" /* Device name */
#define N 1  /* Number of FIFOs */

#define BUFFER_SIZE 1024 /* Size of the FIFO buffer */

/* Structure to represent a FIFO buffer */
struct fifo_buffer {
    char data[BUFFER_SIZE];
    int read_pos;
    int write_pos;
    int count;
    int is_open_read;
    int is_open_write;
    struct mutex lock;
    wait_queue_head_t read_queue;
    wait_queue_head_t write_queue;
};

static struct fifo_buffer fifos[N]; /* Array of FIFO buffers */

static dev_t dev_num;      /* Device number */
static struct cdev *my_cdev; /* Character device structure */
static struct class *cls;    /* Device class */

/* Open function */
static int device_open(struct inode *inode, struct file *file)
{
    int minor;
    int fifo_index;
    struct fifo_buffer *fifo;

    minor = iminor(inode);           /* Get minor number */
    fifo_index = minor / 2;          /* Determine FIFO index */
    fifo = &fifos[fifo_index];

    mutex_lock(&fifo->lock);
    if (minor % 2 == 0) { /* Write end */
        if (fifo->is_open_write) {
            mutex_unlock(&fifo->lock);
            return -EBUSY; /* Device is busy */
        }
        fifo->is_open_write = 1;
    } else { /* Read end */
        if (fifo->is_open_read) {
            mutex_unlock(&fifo->lock);
            return -EBUSY; /* Device is busy */
        }
        fifo->is_open_read = 1;
    }
    mutex_unlock(&fifo->lock);

    return 0;
}

/* Release function */
static int device_release(struct inode *inode, struct file *file)
{
    int minor;
    int fifo_index;
    struct fifo_buffer *fifo;

    minor = iminor(inode);           /* Get minor number */
    fifo_index = minor / 2;          /* Determine FIFO index */
    fifo = &fifos[fifo_index];

    mutex_lock(&fifo->lock);
    if (minor % 2 == 0) { /* Write end */
        fifo->is_open_write = 0;
        wake_up_interruptible(&fifo->read_queue); /* Wake up readers */
    } else { /* Read end */
        fifo->is_open_read = 0;
        wake_up_interruptible(&fifo->write_queue); /* Wake up writers */
    }
    mutex_unlock(&fifo->lock);

    return 0;
}

/* Read function */
static ssize_t device_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
{
    int minor;
    int fifo_index;
    struct fifo_buffer *fifo;
    ssize_t ret = 0;
    size_t bytes_to_read;
    size_t first_chunk;

    minor = iminor(file_inode(file));  /* Get minor number */
    fifo_index = minor / 2;            /* Determine FIFO index */
    fifo = &fifos[fifo_index];

    if (minor % 2 == 0) {
        /* Read operation not allowed on write end */
        return -EINVAL;
    }

    mutex_lock(&fifo->lock);
    while (fifo->count == 0) {
        if (!fifo->is_open_write) {
            /* Write end is closed, return EOF */
            ret = 0;
            goto out;
        }
        mutex_unlock(&fifo->lock);
        /* Wait for data or write end to close */
        if (wait_event_interruptible(fifo->read_queue, fifo->count > 0 || !fifo->is_open_write)) {
            return -ERESTARTSYS; /* Interrupted by signal */
        }
        mutex_lock(&fifo->lock);
    }

    /* Determine number of bytes to read */
    bytes_to_read = min(count, (size_t)fifo->count);
    first_chunk = min(bytes_to_read, (size_t)(BUFFER_SIZE - fifo->read_pos));

    /* Copy data to user space */
    if (copy_to_user(buf, fifo->data + fifo->read_pos, first_chunk)) {
        ret = -EFAULT;
        goto out;
    }
    fifo->read_pos = (fifo->read_pos + first_chunk) % BUFFER_SIZE;
    fifo->count -= first_chunk;
    ret += first_chunk;

    /* Handle wrap-around */
    if (bytes_to_read > first_chunk) {
        size_t second_chunk = bytes_to_read - first_chunk;
        if (copy_to_user(buf + first_chunk, fifo->data + fifo->read_pos, second_chunk)) {
            ret = -EFAULT;
            goto out;
        }
        fifo->read_pos = (fifo->read_pos + second_chunk) % BUFFER_SIZE;
        fifo->count -= second_chunk;
        ret += second_chunk;
    }

    wake_up_interruptible(&fifo->write_queue); /* Wake up writers */

out:
    mutex_unlock(&fifo->lock);
    return ret;
}

/* Write function */
static ssize_t device_write(struct file *file, const char __user *buf, size_t count, loff_t *offset)
{
    int minor;
    int fifo_index;
    struct fifo_buffer *fifo;
    ssize_t ret = 0;
    size_t space_available;
    size_t bytes_to_write;
    size_t first_chunk;

    minor = iminor(file_inode(file)); /* Get minor number */
    fifo_index = minor / 2;           /* Determine FIFO index */
    fifo = &fifos[fifo_index];

    if (minor % 2 != 0) {
        /* Write operation not allowed on read end */
        return -EINVAL;
    }

    mutex_lock(&fifo->lock);
    while (fifo->count == BUFFER_SIZE) {
        if (!fifo->is_open_read) {
            /* Read end is closed, cannot write more data */
            ret = -EPIPE;
            goto out;
        }
        mutex_unlock(&fifo->lock);
        /* Wait for space or read end to close */
        if (wait_event_interruptible(fifo->write_queue, fifo->count < BUFFER_SIZE || !fifo->is_open_read)) {
            return -ERESTARTSYS; /* Interrupted by signal */
        }
        mutex_lock(&fifo->lock);
    }

    /* Determine number of bytes to write */
    space_available = BUFFER_SIZE - fifo->count;
    bytes_to_write = min(count, space_available);
    first_chunk = min(bytes_to_write, (size_t)(BUFFER_SIZE - fifo->write_pos));

    /* Copy data from user space */
    if (copy_from_user(fifo->data + fifo->write_pos, buf, first_chunk)) {
        ret = -EFAULT;
        goto out;
    }
    fifo->write_pos = (fifo->write_pos + first_chunk) % BUFFER_SIZE;
    fifo->count += first_chunk;
    ret += first_chunk;

    /* Handle wrap-around */
    if (bytes_to_write > first_chunk) {
        size_t second_chunk = bytes_to_write - first_chunk;
        if (copy_from_user(fifo->data + fifo->write_pos, buf + first_chunk, second_chunk)) {
            ret = -EFAULT;
            goto out;
        }
        fifo->write_pos = (fifo->write_pos + second_chunk) % BUFFER_SIZE;
        fifo->count += second_chunk;
        ret += second_chunk;
    }

    wake_up_interruptible(&fifo->read_queue); /* Wake up readers */

out:
    mutex_unlock(&fifo->lock);
    return ret;
}

/* File operations structure */
static struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = device_open,
    .release = device_release,
    .read = device_read,
    .write = device_write,
};

/* Module initialization function */
static int __init fifo_init(void)
{
    int ret;
    int major;
    int i;

    /* Allocate device numbers */
    ret = alloc_chrdev_region(&dev_num, 0, 2 * N, DEVICE_NAME);
    if (ret < 0) {
        pr_alert("Failed to allocate char device region\n");
        return ret;
    }
    major = MAJOR(dev_num);

    /* Create cdev structure */
    my_cdev = cdev_alloc();
    cdev_init(my_cdev, &fops);
    my_cdev->owner = THIS_MODULE;
    ret = cdev_add(my_cdev, dev_num, 2 * N);
    if (ret < 0) {
        pr_alert("Failed to add cdev\n");
        unregister_chrdev_region(dev_num, 2 * N);
        return ret;
    }

    /* Create device class */
    cls = class_create(THIS_MODULE, DEVICE_NAME);
    if (IS_ERR(cls)) {
        pr_alert("Failed to create device class\n");
        cdev_del(my_cdev);
        unregister_chrdev_region(dev_num, 2 * N);
        return PTR_ERR(cls);
    }

    /* Create device files */
    for (i = 0; i < 2 * N; i++) {
        device_create(cls, NULL, MKDEV(major, i), NULL, "fifo%d", i);
    }

    /* Initialize FIFO buffers */
    for (i = 0; i < N; i++) {
        mutex_init(&fifos[i].lock);
        init_waitqueue_head(&fifos[i].read_queue);
        init_waitqueue_head(&fifos[i].write_queue);
        fifos[i].read_pos = 0;
        fifos[i].write_pos = 0;
        fifos[i].count = 0;
        fifos[i].is_open_read = 0;
        fifos[i].is_open_write = 0;
    }

    pr_info("FIFO driver initialized\n");
    return 0;
}

/* Module exit function */
static void __exit fifo_exit(void)
{
    int major = MAJOR(dev_num);
    int i;

    /* Destroy device files */
    for (i = 0; i < 2 * N; i++) {
        device_destroy(cls, MKDEV(major, i));
    }

    /* Destroy device class */
    class_destroy(cls);

    /* Delete cdev structure */
    cdev_del(my_cdev);

    /* Unregister device numbers */
    unregister_chrdev_region(dev_num, 2 * N);

    pr_info("FIFO driver exited\n");
}

module_init(fifo_init);
module_exit(fifo_exit);

MODULE_DESCRIPTION("Virtual FIFO Device Driver");
