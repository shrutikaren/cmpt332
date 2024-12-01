#obj-m += vfifofum.o
obj-m += pipe-driver.o
#obj-m += produceconsume.o
#obj-m += driver-PC.o
HEADER = $(PWD)/linux-5.15.133/usr/include 
#HEADER +=$(PWD)/linux-5.15.133/arch 

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	$(MAKE) -I$(HEADER)-C $(KDIR) M=$(PWD) modules
	gcc -I$(HEADER) -o driver-PC driver-PC.c 
	gcc -I$(HEADER) -o produceconsume produceconsume.c	
	
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
