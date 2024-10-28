# Shruti Kaur
# ich524
# 11339265

CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra  
LDFLAGS = -L/usr/local/include -L. 
INC = -I. 
CURRENT_DIR = ./ 

ARCH = $(shell uname -m)
OS := $(shell uname -s)
target: reader_writer_test

all: $(target)

OBJ_DIR = obj/$(OS)
LIB_DIR = lib/$(OS)
BIN_DIR = bin/$(OS)

CROSS_COMPILE_ARM = arm-linux-gnuabihf-
CROSS_COMPILE_PPC = powerpc-linux-gnu-

BUILD_DIRS = build/obj/cmpt332-linux build/lib/cmpt332-linux \
	     build/bin/cmpt332-linux build/obj/cmpt332-arm \
	     build/lib/cmpt332-arm build/bin/cmpt332-arm \
	     build/obj/cmpt332-ppc build/lib/cmpt332-ppc \
	     build/bin/cmpt332-ppc

BUILD_DIR_LINUX_OBJ = build/obj/cmpt332-linux
BUILD_DIR_LINUX_LIB = build/lib/cmpt332-linux
BUILD_DIR_LINUX_BIN = build/lib/cmpt332-linux

BUILD_DIR_ARM_OBJ = build/obj/cmpt332-arm
BUILD_DIR_ARM_LIB = build/lib/cmpt332-arm
BUILD_DIR_ARM_BIN = build/lib/cmpt332-arm

BUILD_DIR_PPC_OBJ = build/obj/cmpt332-ppc
BUILD_DIR_PPC_LIB = build/lib/cmpt332-ppc
BUILD_DIR_PPC_BIN = build/lib/cmpt332-ppc

UBC_PTHREAD_INCLUDE_DIR = /student/cmpt332/pthreads/
UBC_PTHREAD_DIR = /student/cmpt332/pthreads/lib/$(OS)$(ARCH)
UBC_COMPILER_FLAG = -DUSE_UBC_THREADS
RT_THREADS = /student/cmpt332/rtt/include 
X86_RT_THREADS = /student/cmpt332/rtt/lib/Linuxx86_64

.PHONY: all clean

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean: 
	rm -rf obj/ lib/ bin/ reader_writer_test 

LIST_OBJS = \
	$(OBJ_DIR)/list_adders.o \
	$(OBJ_DIR)/list_movers.o \
	$(OBJ_DIR)/list_removers.o

MONITOR_OBJS = $(OBJ_DIR)/Monitor.o

# Compile objects for list
$(OBJ_DIR)/list_adders.o : list_adders.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o : list_movers.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o : list_removers.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_removers.c -o $(OBJ_DIR)/list_removers.o

# Compile objects for the reader_writer files
$(OBJ_DIR)/reader_writer_monitor.o: reader_writer_monitor.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(UBC_PTHREAD_INCLUDE_DIR) \
	-I$(CURRENT_DIR) reader_writer_monitor.c -o \
	$(OBJ_DIR)/reader_writer_monitor.o

$(OBJ_DIR)/reader_writer.o: reader_writer.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(UBC_COMPILER_FLAG) $(INC) \
	-I$(CURRENT_DIR) -I$(UBC_PTHREAD_INCLUDE_DIR) reader_writer.c -o \
	$(OBJ_DIR)/reader_writer.o

# Compile objects for the monitor files
$(OBJ_DIR)/Monitor.o: Monitor.c Monitor.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	-I$(UBC_PTHREAD_INCLUDE_DIR) Monitor.c -o $(OBJ_DIR)/Monitor.o

# Compile objects for s-chat
$(OBJ_DIR)/s-chat.o: s-chat.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(RT_THREADS) s-chat.c -o \
	$(OBJ_DIR)/s-chat.o

# Archive list files into liblist library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# Archive the monitor files into the libMonitor library
$(LIB_DIR)/libMonitor.a: $(MONITOR_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/libMonitor.a $(MONITOR_OBJS)

# Link executable for reader_writer_test
$(BIN_DIR)/reader_writer_test : \
	$(OBJ_DIR)/reader_writer.o $(LIB_DIR)/liblist.a \
	$(LIB_DIR)/libMonitor.a $(UBC_PTHREAD_DIR)/libpthreads.a \
	$(OBJ_DIR)/reader_writer_monitor.o $(OBJ_DIR)/Monitor.o | $(BIN_DIR)
	$(CC) $(CFLAGS) $(UBC_COMPILER_FLAG) \
	$(OBJ_DIR)/reader_writer.o $(OBJ_DIR)/Monitor.o \
	$(OBJ_DIR)/reader_writer_monitor.o \
	$(LDFLAGS) -L$(UBC_PTHREAD_DIR) -L$(LIB_DIR) \
	-llist -lMonitor -lpthreads -o $(BIN_DIR)/reader_writer_test

# Link executable for s-chat
$(BIN_DIR)/s-chat: $(OBJ_DIR)/s-chat.o | $(BIN_DIR)
	$(CC) $(CFLAGS) $(OBJ_DIR)/s-chat.o \
	-L$(X86_RT_THREADS) -ltirpc -lRtt -lRttUtils -o $(BIN_DIR)/s-chat

# Linking executable to root folder
reader_writer_test : $(BIN_DIR)/reader_writer_test
	ln -sf $(BIN_DIR)/reader_writer_test reader_writer_test
