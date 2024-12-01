obj-m += vfifofum.o
#obj-m += pipe-driver.o
#obj-m += produceconsume.o
#3obj-m += driver-PC.o
HEADER = ~/linux-5.15.133/tools/include/linux 

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	$(MAKE) -I$(HEADER)-C $(KDIR) M=$(PWD) modules
	
	
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
