#Name: 
#Student Number:
#NSID:

OS := linux

CC = gcc
CFLAGS = -g
CPPFLAGS = -I. -std=gnu90 -Wall -pedantic #I directives for header

CROSS_COMPILE_ARM = arm-linux-gnueabihf-
CROSS_COMPILE_PPC = powerpc-linux-gnu-

BUILD_DIR = build/obj/cmpt332-linux build/lib/cmpt332-linux \
			build/bin/cmpt332-linux build/obj/cmpt332-arm \
			build/lib/cmpt332-arm build/bin/cmpt332-arm \
			build/obj/cmpt332-ppc build/lib/cmpt332-ppc \
			build/bin/cmpt332-ppc


BUILD_DIR_LINUX_OBJ = build/obj/cmpt332-linux
BUILD_DIR_LINUX_LIB = build/lib/cmpt332-linux
BUILD_DIR_LINUX_BIN = build/bin	/cmpt332-linux

BUILD_DIR_ARM_OBJ = build/obj/cmpt332-arm
BUILD_DIR_ARM_LIB = build/lib/cmpt332-arm
BUILD_DIR_ARM_BIN = build/bin/cmpt332-arm

BUILD_DIR_PPC_OBJ = build/obj/cmpt332-ppc
BUILD_DIR_PPC_LIB = build/lib/cmpt332-ppc
BUILD_DIR_PPC_BIN = build/bin/cmpt332-ppc


			
LIB_DIR = lib
BIN_DIR = bin

LIB_DIRS = -L$(BUILD_DIR) 

EXECUTABLES = sample-linux sample-linux-ppc sample-linux-arm

OBJ_FILES = $(BUILD_DIR)/sample-linux.o $(BUILD_DIR)/linux-lib.o \
			$(BUILD_DIR)/sample-raspi.o $(BUILD_DIR)/raspi-lib.o \
			$(BUILD_DIR)/sample-ppc.o $(BUILD_DIR)/ppc-lib.o

.PHONY: all clean

all: $(EXECUTABLES) 

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR) $(LIB_DIR)

#make the directories
$(BUILD_DIR) $(BIN_DIR) $(LIB_DIR):
	mkdir -p $@ 


# Compiling the object files for linux.
$(BUILD_DIR_LINUX_OBJ)/sample-linux.o: sample-linux.c lab1.h | $(BUILD_DIR_LINUX_OBJ)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) sample-linux.c -o $(BUILD_DIR)/sample-linux.o

$(BUILD_DIR)/linux-lib.o: linux-lib.c lab1.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) linux-lib.c -o $(BUILD_DIR)/linux-lab.o

# Compiling the object files for ARM.
$(BUILD_DIR)/sample-raspi.o: sample-raspi.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) sample-raspi.c -o $(BUILD_DIR)/sample-raspi.o

$(BUILD-DIR)/raspi-lib.o: raspi-lib.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) raspi-lib.c -o $(BUILD_DIR)/raspi-lib.o

# Compiling the object files for PowerPC
$(BUILD_DIR)/sample-ppc.o: sample-ppc.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) sample-ppc.c -o $(BUILD_DIR)/sample-ppc.o

$(BUILD_DIR)/ppc-lib.o: ppc-lib.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) ppc-lib.c -o $(BUILD_DIR)/ppc-lib.o


#archive linux-lib.o into a libraray .a file --> called library lib_library.a
$(LIB_DIR)/lib_linux.a: $(BUILD_DIR)/linux-lib.o | $(LIB_DIR)
	ar rcs -L -l $(LIB_DIR)/lib_linux.a 

#trying to convert raspi-lib.o into a library .a file
$(LIB_DIR)/lib_raspi.a: $(BUILD_DIR)/raspi-lib.o | $(LIB_DIR)
	ar rcs -L -l $(LIB_DIR)/lib_raspi.a

#doing the same for ppc into a library .a file
$(LIB_DIR)/lib_ppc.a: $(BUILD_DIR)/ppc-lib.o |$(LIB_DIR)
	ar rcs -L -l $(LIB_DIR)/lib_ppc.a

#linking object files to the executable - LINUX
$(BIN_DIR)/sample-linux: $(BUILD_DIR)/sample-linux.o $(LIB_DIR)/libpthreads.a $(LIB_DIR)/lib_linux.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(BUILD_DIR)/sample-linux.o -o $(BIN_DIR)/sample-linux

#linking object files to the executable - RPi
#how to link this to the local library?
$(BIN_DIR)/sample-linux-arm: $(BUILD_DIR)/sample-raspi.o $(LIB_DIR)/libpthreads.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(BUILD_DIR)/sample-raspi.o -o $(BIN_DIR)/sample-raspi

#linking object files to the executable - PowerPC
$(BIN_DIR)/sample-linux-ppc: $(BUILD_DIR)/sample-ppc.o $(LIB_DIR)/libpthreads.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(BUILD_DIR)/sample-ppc.o -o $(BIN_DIR)/sample-ppc

#target for each of those architectures - not sure what that means?

#creating a symbolic link
sample-linux: $(BIN_DIR)/sample-linux
	ln -sf $(BIN_DIR)/sample-linux sample-linux

sample-linux-ppc: $(BIN_DIR)/sample-linux-ppc
	ln -sf $(BIN_DIR)/sample-linux-ppc sample-linux-ppc

sample-linux-arm: $(BIN_DIR)/sample-linux-arm
	ln -sf $(BIN_DIR)/sample-linux-arm sample-linux-arm


