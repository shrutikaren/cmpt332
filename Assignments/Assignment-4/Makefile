# Shruti Kaur
# ich524
# 11339265

CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra  

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

# compile objects for list
$(OBJ_DIR)/list_adders.o : list_adders.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o : list_movers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o : list_removers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) list_removers.c \
		-o $(OBJ_DIR)/list_removers.o

# compile objects for the reader_writer files
$(OBJ_DIR)/reader_writer_monitor.o: reader_writer_monitor.c \
					reader_writer_monitor.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) reader_writer_monitor.c \
		-o $(OBJ_DIR)/reader_writer_monitor.o

$(OBJ_DIR)/reader_writer.o: reader_writer.c | $(OBJ_DIR)
	$(CC) -o $(CPPFLAGS) $(CFLAGS) reader_writer.c -o \
	$(OBJ_DIR)/reader_writer.o

#compile objects for the monitor files
$(OBJ_DIR)/monitor.o: monitor.c monitor.h | $(OBJ_DIR)
	$(CC) -o $(CPPFLAGS) $(CFLAGS) monitor.c -o $(OBJ_DIR)/monitor.o

# Add Target-Specific CPPFLAGS for reader-writer.o
$(OBJ_DIR)/reader_writer.o : CPPFLAGS += -I$(UBC_PTHREAD_INCLUDE_DIR)

# archiving list files into liblist library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# link executable for list
$(BIN_DIR)/reader_writer_test : \
	$(OBJ_DIR)/reader_writer.o $(LIB_DIR)/liblist.a $(LIB_DIR)/libMonitor.a
	\ | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/mytestlist.o \
		-L$(LIB_DIR) -llist -o $(BIN_DIR)/mytestlist

# linking executable to root folder
reader_writer_test : $(BIN_DIR)/reader_writer_test
	ln -sf $(BIN_DIR)/reader_writer_test reader_writer_test

