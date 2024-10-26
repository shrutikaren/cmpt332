# Shruti Kaur
# ich524
# 11339265

CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra  
LDFLAGS = -L/usr/local/include -L. \ 
INC = -I. 
CURRENT_DIR = ./ #IMPORTANT TO LINK LOCAL HEADER FILES

ARCH = $(shell uname -m)
OS := $(shell uname -s)
target: reader_writer_test partA_test

all: $(target)

OBJ_DIR = obj/$(OS)
LIB_DIR = lib/$(OS)
BIN_DIR = bin/$(OS)

UBC_PTHREAD_INCLUDE_DIR = /student/cmpt332/pthreads/
UBC_PTHREAD_DIR = /student/cmpt332/pthreads/lib/$(OS)$(ARCH)
UBC_COMPILER_FLAG = -DUSE_UBC_THREADS
RT_THREADS = /student/cmpt332/rtt/include 
X86_RT_THREADS = /student/cmpt332/rtt/lib/Linuxx86_64
C_AND_ASSEM_DIR = /git_hub_cpy/cmpt332/Assignments/Assignment-4/xv6-2024/xv6-fall2024/user
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

# compile objects for list
$(OBJ_DIR)/list_adders.o : list_adders.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o : list_movers.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o : list_removers.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_removers.c -o $(OBJ_DIR)/list_removers.o

# compile objects for the reader_writer files`
$(OBJ_DIR)/reader_writer_monitor.o: reader_writer_monitor.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(UBC_PTHREAD_INCLUDE_DIR) \
	-I$(CURRENT_DIR) reader_writer_monitor.c -o \
	$(OBJ_DIR)/reader_writer_monitor.o

$(OBJ_DIR)/reader_writer.o: reader_writer.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(UBC_COMPILER_FLAG) $(INC) \
	-I$(CURRENT_DIR) -I$(UBC_PTHREAD_INCLUDE_DIR) reader_writer.c -o \
	$(OBJ_DIR)/reader_writer.o

#compile objects for the monitor files
$(OBJ_DIR)/Monitor.o: Monitor.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	-I$(UBC_PTHREAD_INCLUDE_DIR) Monitor.c -o $(OBJ_DIR)/Monitor.o

# Add Target-Specific CPPFLAGS for reader-writer.o
#$(OBJ_DIR)/reader_writer.o : CPPFLAGS += -I$(UBC_PTHREAD_INCLUDE_DIR)

#compiling objects for Part C
$(OBJ_DIR)/s-chat.o: s-chat.c | $(OBJ_DIR)
	$(CC) -o $(CPPFLAGS)  $(INC) -I$(RT_THREADS) s-chat.c -o \
	$(OBJ_DIR)/s-chat.o

# compiling object file for partA testing 
$(OBJ_DIR)/producer-consumer.o: producer-consumer.c $( C_AND_ASSEM_DIR)/uthread.c | $(OBJ_DIR)
	$(CC) -o $(CPPFLAGS) producer-consumer.c -o $(OBJ_DIR)/producer-consumer.o

# Add Target-Specific CPPFLAGS for s-chat.o
#$(OBJ_DIR)/s-chat.o : CPPFLAGS += -I$(RT_THREADS) 

# archiving list files into liblist library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

#archiving the monitor files into the liblist library
$(LIB_DIR)/libMonitor.a: $(MONITOR_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/libMonitor.a $(MONITOR_OBJS)

# link executable for list
$(BIN_DIR)/reader_writer_test : \
	$(OBJ_DIR)/reader_writer.o $(LIB_DIR)/liblist.a \
	$(LIB_DIR)/libMonitor.a $(UBC_PTHREAD_DIR)/libpthreads.a \
	$(OBJ_DIR)/reader_writer_monitor.o $(OBJ_DIR)/Monitor.o | $(BIN_DIR)
	$(CC) $(CFLAGS) $(UBC_COMPILER_FLAG) \
	$(OBJ_DIR)/reader_writer.o  \
	 $(OBJ_DIR)/Monitor.o $(OBJ_DIR)/reader_writer_monitor.o \
		$(LDFLAGS)  -L$(UBC_PTHREAD_DIR) -L$(LIB_DIR) -llist -lMonitor \
		 -lpthreads -o $(BIN_DIR)/reader_writer_test

# link executable for the partA testing
$(BIN_DIR)/partA_test: $(OBJ_DIR)/producer-consumer.o \
	$(C_AND_ASSEM_DIR)/uthread.o $(C_AND_ASSEM_DIR)/uthread_switch.S | $(BIN_DIR)
	$(CC) $(CFLAGS) $(C_AND_ASSEM_DR)/uthread.o \
	$(C_AND_ASSEM_DIR)/uthread_switch.S -o $(BIN_DIR)/partA_test

# link executable for the s-chat
$(BIN_DIR)/s-chat: $(OBJ_DIR)/s-chat.o | $(BIN_DIR)
	$(CC) $(CFLAGS) $(OBJ_DIR)/s-chat.o \
	$(X86_RT_THREADS) -ltirpc -lRtt -lRttUtils -o $(BIN_DIR)/s-chat

# linking executable to root folder
reader_writer_test : $(BIN_DIR)/reader_writer_test
	ln -sf $(BIN_DIR)/reader_writer_test reader_writer_test

#linking executable for our partA testing file
partA_test: $(BIN_DIR)/partA_test
	ln -sf $(BIN_DIR)/partA_test partA_test
