CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra 

# Checks if the OS is on Windows, compiles partA1 if so
# otherwise compiles everything else.
ifeq "$(OS)" "Windows_NT"
target: partA1
else # Linux
OS = $(shell uname -s)
target: mytestlist
endif

all: $(target)

OBJ_DIR = obj/$(OS)
LIB_DIR = lib/$(OS)
BIN_DIR = bin/$(OS)

PTHREAD_DIR = /student/cmpt332/pthreads 
PTHREAD_LIB = $(PTHREAD_DIR)/lib

.PHONY: all clean

$(OBJ_DIR) $(LIB_DIR) $(BIN_DIR):
	mkdir -p $@

clean: 
	rm -rf obj/ lib/ bin/ partA1.exe partA2 partA3 partA4 mytestlist 

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

$(OBJ_DIR)/mytestlist.o : mytestlist.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) mytestlist.c -o $(OBJ_DIR)/mytestlist.o

# compile objects for partA1
$(OBJ_DIR)/square.o : square.c square.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) square.c -o $(OBJ_DIR)/square.o

$(OBJ_DIR)/partA1.o : partA1.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) partA1.c -o $(OBJ_DIR)/partA1.o

# library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# link executable for list
$(BIN_DIR)/mytestlist : \
	$(OBJ_DIR)/mytestlist.o $(LIB_DIR)/liblist.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/mytestlist.o \
		-L$(LIB_DIR) -llist -o $(BIN_DIR)/mytestlist

# link executable for partA1
$(BIN_DIR)/partA1 : $(OBJ_DIR)/partA1.o | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/partA1.o \
		-o $(BIN_DIR)/partA1

# linking executable to root folder
mytestlist : $(BIN_DIR)/mytestlist
	ln -sf $(BIN_DIR)/mytestlist mytestlist

partA1 : $(BIN_DIR)/partA1
	cmd /k mklink partA1.exe bin\Windows_NT\partA1.exe


