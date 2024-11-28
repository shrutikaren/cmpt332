/*
 * vfifofum.c - implementation of a character based FIFO device driver
 * for CMPT 332 Lab 9 in 2023
 * NAME, NSID, Student Number
 *
 */

#include <linux/atomic.h> 
#include <linux/cdev.h> 
#include <linux/fs.h> 
#include <linux/init.h> 
#include <linux/kobject.h> 
#include <linux/module.h> 
#include <linux/string.h> 
#include <linux/sysfs.h>
#include <linux/types.h>
#include <linux/uaccess.h>
#include <linux/version.h>

static int vfifofum_open(struct inode *, struct file *);
static int vfifofum_release(struct inode *, struct file *);
static ssize_t vfifofum_read(struct file *, char __user *, size_t, loff_t *);
static ssize_t vfifofum_write(struct file *, const char __user *, size_t, loff_t *);

static int major; /* our major number */
#define DEVICE_NAME "vfifofum"
static struct class *cls;

static struct file_operations vfifofum_fops = {
  .read = vfifofum_read,
  .write = vfifofum_write,
  .open = vfifofum_open,
  .release = vfifofum_release,
};

#define DEVNAME_SIZE 1024
static int __init vfifofum_init(void)
{
  
  major = register_chrdev(0, DEVICE_NAME, &vfifofum_fops);
  /* check to see that we got a major number back, else bail. */
  if (major < 0) {
    pr_alert("Registering vfifofum char device failed with %d\n", major);
    return major;
  }

  pr_info("vfifofum was assigned major %d\n", major);

#if LINUX_VERSION_CODE >= KERNEL_VERSION(6, 4, 0) 
    cls = class_create(DEVICE_NAME); 
#else 
    cls = class_create(THIS_MODULE, DEVICE_NAME); 
#endif 
    /* we will get assigned a major number, and will use 0 for the minor */
    device_create(cls, NULL, MKDEV(major, 0), NULL, DEVICE_NAME);
    pr_info("vfifofum created as /dev/%s\n", DEVICE_NAME);
    
    /* happy happy, joy joy */
    return 0;
}


static void __exit vfifofum_exit(void)
{
  /* say good night, Charlie... */ 
  device_destroy(cls, MKDEV(major, 0));
  class_destroy(cls); 
  unregister_chrdev(major, DEVICE_NAME); 
  pr_info("vfifofum shutdown\n");
}

static int vfifofum_open(struct inode *, struct file *)
{
  try_module_get(THIS_MODULE);
  return 0;
}


static int vfifofum_release(struct inode *, struct file *)
{
  module_put(THIS_MODULE);
  return 0;
}


static ssize_t vfifofum_read(struct file *file, char __user *buffer, size_t length, loff_t *offset)
{
  pr_alert("read not implmented!\n");
  return -EINVAL;
}

static ssize_t vfifofum_write(struct file *file, const char __user *buffer, size_t length, loff_t *offset)
{
  pr_alert("write not implmented!\n");
  return -EINVAL;
}

module_init(vfifofum_init); 
module_exit(vfifofum_exit); 

MODULE_LICENSE("GPL");
