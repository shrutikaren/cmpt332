#include <linux/cdev.h> 
#include <linux/fs.h> 
#include <linux/init.h> 
#include <linux/module.h> 
#include <linux/uaccess.h>
#include <linux/cdev.h>
#include <linux/devices.h>
#include <linux/mutex.h>
#include <linux/wait.h>
#include <linux/sched.h>

#define DEVICE_NAME "fifo"
#define FIFO_SIZE 1024

// BONUS PART
#define NUM_FIFOS 2
#define NUM_MINORS (NUM_FIFOS *2)


static int fifo_open(struct inode *, struct file *);
static int fifo_release(struct inode *, struct file *);
static ssize_t fifo_read(struct file *, char __user *, size_t, loff_t *);
static ssize_t fifo_write(struct file *, const char __user *, size_t, loff_t *);


static int major; /* our major number */
static struct class *fifo_class;


struct fifo_dev{
    struct cdev cdev;
    char buffer[FIFO_SIZE];
    int read_pos;
    int write_pos;
    int data_size;
    int readers;
    int writers;
    struct mutex lock;
    wait_queue_head_t read_queue;
    wait_queue_head_t write_queue;
};


static struct fifo_dev fifo_device[NUM_FIFOS];

static struct file_operations fifo_fops = {
    .owner = THIS_MODULE,
    .open = fifo_open,
    .release = fifo_release,
    .read = fifo_read,
    .write = fifo_write,
};


static int fifo_open(struct inode* inode, struct file* flip){
    int minor = iminor(inode);
    int fifo_idx = minor /2;
    struct fifo_dev* dev = &fifo_device[fifo_idx];
    flip->private_data = dev;

    mutex_lock(&dev->lock);

    if(minor%2 == 0){ dev->writers++; }

    else{ dev->readers++; }

    mutex_unlock(&dev->lock);

    return 0;
}



