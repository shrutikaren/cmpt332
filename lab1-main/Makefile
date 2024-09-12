#executable file names not provided by assignment
#hence, they were named in accordance to the architectures of 
#linux, arm, power pc


CC = gcc
CFLAGS = -g
CPPFLAGS = -I. -std=gnu90 -Wall -pedantic #I directives for header

BUILD_DIR = build/obj/cmpt332-linux build/lib/cmpt332-linux \
			build/bin/cmpt332-linux build/obj/cmpt332-arm \
			build/lib/cmpt332-arm build/bin/cmpt332-arm \
			build/obj/cmpt332-ppc build/lib/cmpt332-ppc \
			build/bin/cmpt332-ppc
			
LIB_DIR = lib
BIN_DIR = bin

LIB_DIRS = -L$(BUILD_DIR) #-L directives 

EXECUTABLES = virtual_linux virtual_arm_arch virtual_power_pc

OBJ_FILES = $(BUILD_DIR)/sample-linux.o $(BUILD_DIR)/linux-lib.o

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
	$(CC) -c $(CPPFLAGS) $(CFLAGS) linux-lib.c -o $(BUILD_DIR)/linux-lab.of

#archive linux-lib.o into a libraray .a file
$(LIB_DIR)/liblinux.a: $(BUILD_DIR)/linux-lib.o | $(LIB_DIR)
	ar rcs $(LIB_DIR)/libthreads.a 

#linking object files to the executable
$(BIN_DIR)/sample-linux: $(BUILD_DIR)/sample-linux.o $(LIB_DIR)/libthreads.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(OBJ_FILES) -o $(BIN_DIR)/sample-linux

#target for each of those architectures

#creating a symbolic link
virtual_linux: $(BIN_DIR)/virtual_linux
	ln -sf $(BIN_DIR)/virtual_linux virtual_linux


