obj-m += pip-driver.o

KERNEL_BUILD := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
KERNEL_HEADERS := $(PWD)/linux-5.15.133/usr/include

CFLAGS := -I$(KERNEL_HEADERS)

all: kernel_module user_programs

kernel_module:
	$(MAKE) -C $(KERNEL_BUILD) M=$(PWD) modules

user_programs:
	gcc -o driver-PC driver-PC.c $(CFLAGS)
	gcc -o producer_consumer producer_consumer.c -lpthread $(CFLAGS)

clean:
	$(MAKE) -C $(KERNEL_BUILD) M=$(PWD) clean
	rm -f driver-PC producer_consumer
