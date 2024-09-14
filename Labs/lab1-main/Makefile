#Name: 
#Student Number:
#NSID:

OS := linux

CC = gcc
CFLAGS = -g
CPPFLAGS = -I. -std=gnu90 -Wall -pedantic # I directives for header

CROSS_COMPILE_ARM = arm-linux-gnueabihf-
CROSS_COMPILE_PPC = powerpc-linux-gnu-

# Define all build directories
BUILD_DIRS = build/obj/cmpt332-linux build/lib/cmpt332-linux \
            build/bin/cmpt332-linux build/obj/cmpt332-arm \
            build/lib/cmpt332-arm build/bin/cmpt332-arm \
            build/obj/cmpt332-ppc build/lib/cmpt332-ppc \
            build/bin/cmpt332-ppc

# Individual build directories
BUILD_DIR_LINUX_OBJ = build/obj/cmpt332-linux
BUILD_DIR_LINUX_LIB = build/lib/cmpt332-linux
BUILD_DIR_LINUX_BIN = build/bin/cmpt332-linux

BUILD_DIR_ARM_OBJ = build/obj/cmpt332-arm
BUILD_DIR_ARM_LIB = build/lib/cmpt332-arm
BUILD_DIR_ARM_BIN = build/bin/cmpt332-arm

BUILD_DIR_PPC_OBJ = build/obj/cmpt332-ppc
BUILD_DIR_PPC_LIB = build/lib/cmpt332-ppc
BUILD_DIR_PPC_BIN = build/bin/cmpt332-ppc

# Update LIB_DIR and BIN_DIR to point to build directories
LIB_DIR = build/lib
BIN_DIR = build/bin

LIB_DIRS = -L$(LIB_DIR)

EXECUTABLES = sample-linux sample-linux-ppc sample-linux-arm

OBJ_FILES = $(BUILD_DIR_LINUX_OBJ)/sample-linux.o $(BUILD_DIR_LINUX_OBJ)/linux-lib.o \
            $(BUILD_DIR_ARM_OBJ)/sample-raspi.o $(BUILD_DIR_ARM_OBJ)/raspi-lib.o \
            $(BUILD_DIR_PPC_OBJ)/sample-ppc.o $(BUILD_DIR_PPC_OBJ)/ppc-lib.o

.PHONY: all clean directories

# All target depends on directories and executables
all: directories $(EXECUTABLES)

# Directories target creates all necessary build directories
directories:
	mkdir -p $(BUILD_DIRS) $(BIN_DIR) $(LIB_DIR)

# Clean target removes all build and output directories
clean:
	rm -rf build bin 

# Compiling the object files for Linux
$(BUILD_DIR_LINUX_OBJ)/sample-linux.o: sample-linux.c lab1.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) sample-linux.c -o $(BUILD_DIR_LINUX_OBJ)/sample-linux.o

$(BUILD_DIR_LINUX_OBJ)/linux-lib.o: linux-lib.c lab1.h
	$(CC) -c $(CPPFLAGS) $(CFLAGS) linux-lib.c -o $(BUILD_DIR_LINUX_OBJ)/linux-lib.o

# Compiling the object files for ARM
$(BUILD_DIR_ARM_OBJ)/sample-raspi.o: sample-raspi.c
	$(CROSS_COMPILE_ARM)gcc -c $(CPPFLAGS) $(CFLAGS) sample-raspi.c -o $(BUILD_DIR_ARM_OBJ)/sample-raspi.o

$(BUILD_DIR_ARM_OBJ)/raspi-lib.o: raspi-lib.c
	$(CROSS_COMPILE_ARM)gcc -c $(CPPFLAGS) $(CFLAGS) raspi-lib.c -o $(BUILD_DIR_ARM_OBJ)/raspi-lib.o

# Compiling the object files for PowerPC
$(BUILD_DIR_PPC_OBJ)/sample-ppc.o: sample-ppc.c
	$(CROSS_COMPILE_PPC)gcc -c $(CPPFLAGS) $(CFLAGS) sample-ppc.c -o $(BUILD_DIR_PPC_OBJ)/sample-ppc.o

$(BUILD_DIR_PPC_OBJ)/ppc-lib.o: ppc-lib.c
	$(CROSS_COMPILE_PPC)gcc -c $(CPPFLAGS) $(CFLAGS) ppc-lib.c -o $(BUILD_DIR_PPC_OBJ)/ppc-lib.o

# Archiving object files into libraries
$(BUILD_DIR_LINUX_LIB)/lib_linux.a: $(BUILD_DIR_LINUX_OBJ)/linux-lib.o
	ar rcs $(BUILD_DIR_LINUX_LIB)/lib_linux.a $(BUILD_DIR_LINUX_OBJ)/linux-lib.o

$(BUILD_DIR_ARM_LIB)/lib_raspi.a: $(BUILD_DIR_ARM_OBJ)/raspi-lib.o
	$(CROSS_COMPILE_ARM)ar rcs $(BUILD_DIR_ARM_LIB)/lib_raspi.a $(BUILD_DIR_ARM_OBJ)/raspi-lib.o

$(BUILD_DIR_PPC_LIB)/lib_ppc.a: $(BUILD_DIR_PPC_OBJ)/ppc-lib.o
	$(CROSS_COMPILE_PPC)ar rcs $(BUILD_DIR_PPC_LIB)/lib_ppc.a $(BUILD_DIR_PPC_OBJ)/ppc-lib.o

# Linking executables

# Linux Executable
$(BIN_DIR)/sample-linux: $(BUILD_DIR_LINUX_OBJ)/sample-linux.o $(BUILD_DIR_LINUX_LIB)/lib_linux.a lib/libpthreads.a
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $(BIN_DIR)/sample-linux \
		$(BUILD_DIR_LINUX_OBJ)/sample-linux.o \
		$(BUILD_DIR_LINUX_LIB)/lib_linux.a -lpthreads

# ARM Executable
$(BIN_DIR)/sample-linux-arm: $(BUILD_DIR_ARM_OBJ)/sample-raspi.o $(BUILD_DIR_ARM_LIB)/lib_raspi.a lib/libpthreads.a
	$(CROSS_COMPILE_ARM)gcc $(CPPFLAGS) $(CFLAGS) -o $(BIN_DIR)/sample-linux-arm \
		$(BUILD_DIR_ARM_OBJ)/sample-raspi.o \
		$(BUILD_DIR_ARM_LIB)/lib_raspi.a -lpthreads

# PowerPC Executable
$(BIN_DIR)/sample-linux-ppc: $(BUILD_DIR_PPC_OBJ)/sample-ppc.o $(BUILD_DIR_PPC_LIB)/lib_ppc.a lib/libpthreads.a
	$(CROSS_COMPILE_PPC)gcc $(CPPFLAGS) $(CFLAGS) -o $(BIN_DIR)/sample-linux-ppc \
		$(BUILD_DIR_PPC_OBJ)/sample-ppc.o \
		$(BUILD_DIR_PPC_LIB)/lib_ppc.a -lpthreads

# Creating symbolic links
sample-linux: $(BIN_DIR)/sample-linux
	ln -sf $(BIN_DIR)/sample-linux sample-linux

sample-linux-ppc: $(BIN_DIR)/sample-linux-ppc
	ln -sf $(BIN_DIR)/sample-linux-ppc sample-linux-ppc

sample-linux-arm: $(BIN_DIR)/sample-linux-arm
	ln -sf $(BIN_DIR)/sample-linux-arm sample-linux-arm
