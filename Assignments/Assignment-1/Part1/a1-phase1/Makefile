CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra 
Op_Sys = $(shell uname -s)
Arch = $(shell uname -m)

#for cross compiling in diff operating systems
CROSS_COMPILE_ARM = arm-linux-gnueabihf-
CROSS_COMPILE_PPC = powerpc-linux-gnu-

BUILD_DIR_LINUX_OBJ = build/obj/cmpt332-linux
BUILD_DIR_LINUX_LIB = build/lib/cmpt332-linux
BUILD_DIR_LINUX_BIN = build/bin/cmpt332-linux

BUILD_DIR_ARM_OBJ = build/obj/cmpt332-arm
BUILD_DIR_ARM_LIB = build/lib/cmpt332-arm
BUILD_DIR_ARM_BIN = build/bin/cmpt332-arm

BUILD_DIR_PPC_OBJ = build/obj/cmpt332-ppc
BUILD_DIR_PPC_LIB = build/lib/cmpt332-ppc
BUILD_DIR_PPC_BIN = build/bin/cmpt332-ppc

BUILD_DIRS = build/obj/cmpt332-linux build/lib/cmpt332-linux \
	     build/bin/cmpt332-linux build/obj/cmpt332-arm \
	     build/lib/cmpt332-arm build/bin/cmpt332-arm \ 
	     build/obj/cmpt332-ppc build/lib/cmpt332-ppc \
	     build/bin/cmpt332-ppc 

LIB_DIR = build/lib
BIN_DIR = build/bin

PTHREAD_LIB = /student/cmpt332/pthreads/lib
PTHREAD_LIB_BELOW = /student/cmpt332/pthreads 

target: partA1 mytestlist

all: $(target)

.PHONY all clean 
$(BUILD_DIRS) $(LIB_DIR) $(BIN_DIR9)
	mkdir -p $@

clean: 
	rm -rf build/ bin/ $(target) 

#compile objects 
$(BUILD_DIR_LINUX_OBJ)/square.o : square.c square.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) square.c -o $(BUILD_DIR)/square.o


$(BUILD_DIR_LINUX_OBJ)/partA1.o: partA1.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) partA1.c -o $(BUILD_DIR)/partA1.o

$(BUILD_DIR_LINUX_OBJ)/mytestlist.o: mytestlist.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) mytestlist.c -o \
	$(BUILD_LIST)/mytestlist.o


#archiving the object files into the libraries 
$(BUILD_DIR_LINUX_LIB)/liblist.a: $(BUILD_DIR_LINUX_OBJ)/mytestlist.o
	ar rcs $(BUILD_DIR_LINUX_LIB)/liblist.a \
	 $(BUILD_DIR_LINUX_OBJ)/mytestlist.o

#linking
$(BIN_DIR)/mytestlist: $(BUILD_DIR_LINUX_LIB)/liblist.a \
		       $(BUILD_DIR_LINUX_OBJ)/mytestlist.o 
	$(CC) $(CFLAGS) $(BUILD_DIR_LINUX_OBJ)/mytestlist.o -L$(LIB_DIR) \
	-llist $(BUILD_DIR_LINUX_LIB)/liblist.a 


#creating symbolic links 
mytestlist: $(BIN_DIR)/mytestlist
	ln -sf $(BIN_DIR)/mytestlist mytestlist
