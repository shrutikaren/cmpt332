#executable file names not provided by assignment
#hence, they were named in accordance to the architectures of 
#linux, arm, power pc


CC = gcc
CFLAGS = -g
CPPFLAGS = -I. -std=gnu90 -Wall -pedantic #I directives for header
CROSS_COMPILE = arm-linux-gnueabihf-

BUILD_DIR = build/obj/cmpt332-linux build/lib/cmpt332-linux \
			build/bin/cmpt332-linux build/obj/cmpt332-arm \
			build/lib/cmpt332-arm build/bin/cmpt332-arm \
			build/obj/cmpt332-ppc build/lib/cmpt332-ppc \
			build/bin/cmpt332-ppc
			
LIB_DIR = lib
BIN_DIR = bin

LIB_DIRS = -L$(BUILD_DIR) #-L directives 

EXECUTABLES = sample-linux sample-linux-ppc sample-linux-arm

OBJ_FILES = $(BUILD_DIR)/sample-linux.o $(BUILD_DIR)/linux-lib.o $(BUILD_DIR)/sample-raspi.o

.PHONY: all clean
all: $(BIN_DIR)/virtual_linux virtual_arm_arch virtual_power_pc

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR) $(LIB_DIR)

#make the directories
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(LIB_DIR):
	mkdir -p $(LIB-DIR)

#compiling the object files
$(BUILD_DIR)/sample-linux.o: sample-linux.c lab1.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) sample-linux.c -o $(BUILD_DIR)/sample-linux.o

$(BUILD_DIR)/linux-lib.o: linux-lib.c lab1.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) linux-lib.c -o $(BUILD_DIR)/linux-lab.o

$(BUILD_DIR)/sample-raspi.o: sample-raspi.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) sample-raspi.c -o $(BUILD_DIR)/sample-raspi.o

$(BUILD-DIR)/raspi-lib.o: raspi-lib.c | $(BUILD_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) raspi-lib.c -o $(BUILD_DIR)/raspi-lib.o

#archive linux-lib.o into a libraray .a file --> called library lib_library.a
$(LIB_DIR)/lib_linux.a: $(BUILD_DIR)/linux-lib.o | $(LIB_DIR)
	ar rcs -L -l $(LIB_DIR)/lib_linux.a 

#trying to convert raspi-lib.o into a library .a file
$(LIB_DIR)/lib_raspi.a: $(BUILD_DIR)/raspi-lib.o | $(LIB_DIR)
	ar rcs -L -l $(LIB_DIR)/lib_raspi.a

#linking object files to the executable
$(BIN_DIR)/sample-linux: $(BUILD_DIR)/sample-linux.o $(LIB_DIR)/libpthreads.a $(LIB_DIR)/lib_linux.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(BUILD_DIR)/sample-linux.o -o $(BIN_DIR)/sample-linux

#target for each of those architectures - not sure what that means?

#creating a symbolic link
virtual_linux: $(BIN_DIR)/virtual_linux
	ln -sf $(BIN_DIR)/virtual_linux virtual_linux

virtual_arm_arch: $(BIN_DIR)/virtual_arm_arch
	ln -sf $(BIN_DIR)/virtual_arm_arch

virtual_power_pc: $(BIN_DIR)/virtual_power_pc
	ln -sf $(BIN_DIR)/virtual_power_pc


