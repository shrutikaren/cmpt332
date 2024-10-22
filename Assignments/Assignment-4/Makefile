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
target: reader_writer_test 

all: $(target)

OBJ_DIR = obj/$(OS)
LIB_DIR = lib/$(OS)
BIN_DIR = bin/$(OS)

UBC_PTHREAD_INCLUDE_DIR = /student/cmpt332/pthreads/
UBC_PTHREAD_DIR = /student/cmpt332/pthreads/lib/$(OS)$(ARCH)
UBC_COMPILER_FLAG = -DUSE_UBC_THREADS
RT_THREADS = /student/cmpt332/rtt/include 
X86_RT_THREADS = /student/cmpt332/rtt/lib/Linuxx86_64
U = /student/cmpt332/xv6-2024/xv6-threads/user
HEADER_FILE_XV6 = /student/cmpt332/xv6-2024/xv6-fall2024/kernel

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

# ==================== EVERYTHING FOR PART A IS HERE ========================== 
# Compile object for uthread.c
$(U)/uthread.o: $(U)/uthread.c | $(U)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(HEADER_FILE_XV6) $(U)/uthread.c \
	-o $(U)/uthread.o

$(U)/uthread_switch.o: $(U)/uthread_switch.S | $(U)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $(U)/uthread_switch.o \
	$(U)/uthread_switch.S

# Build the _uthread executable
$(U)/_uthread: $(U)/uthread.o $(U)/uthread_switch.o $(ULIB)
	$(LD) $(LDFLAGS) -N -e main -Ttext 0 -o $(U)/_uthread $(U)/uthread.o \
	$(U)/uthread_switch.o $(OBJDUMP) -S $(U)/_uthread > $(U)/uthread.asm

# compile the source file 

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

# link executable for the s-chat
$(BIN_DIR)/s-chat: $(OBJ_DIR)/s-chat.o | $(BIN_DIR)
	$(CC) $(CFLAGS) $(OBJ_DIR)/s-chat.o \
	$(X86_RT_THREADS) -ltirpc -lRtt -lRttUtils -o $(BIN_DIR)/s-chat

# linking executable to root folder
reader_writer_test : $(BIN_DIR)/reader_writer_test
	ln -sf $(BIN_DIR)/reader_writer_test reader_writer_test

