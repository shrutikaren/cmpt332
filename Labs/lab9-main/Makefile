obj-m += pip-driver.o
HEADER = /linux-5.15.133/usr/include/linux
all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
	gcc -o driver-PC driver-PC.c
	gcc -o producer_consumer producer_consumer.c -lpthread
	gcc -o -I$(HEADER) vfifofum vfifofum.c

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
	rm -f driver-PC producer_consumer vfifofum
