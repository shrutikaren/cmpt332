obj-m += pipe-driver.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules
	gcc -o driver-PC driver-PC.c 
	#gcc -o produceconsume produceconsume.c -lpthread	
	
clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -rf driver-PC # producer_consumer
