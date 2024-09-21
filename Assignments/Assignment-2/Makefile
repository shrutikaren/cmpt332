# Jack Donegan, Shruti Kaur
# lvf165, ich524
# 11357744, 11339265

CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra  

# Checks if the OS is on Windows, compiles partA1 if so
# otherwise compiles everything else.
ifeq ($(OS),Windows_NT)
target: partA1
else # Linux
OS := $(shell uname -s)
target: mytestlist partA2 partA3 partA4
endif

all: $(target)

OBJ_DIR = obj/$(OS)
LIB_DIR = lib/$(OS)
BIN_DIR = bin/$(OS)

PTHREAD_DIR = /student/cmpt332/pthreads 
PTHREAD_LIB = $(PTHREAD_DIR)/lib

.PHONY: all clean

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

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

#compiling objects for partA2
$(OBJ_DIR)/partA2.o : partA2.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) partA2.c -o $(OBJ_DIR)/partA2.o

# library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# link executable for list
$(BIN_DIR)/mytestlist : \
	$(OBJ_DIR)/mytestlist.o $(LIB_DIR)/liblist.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/mytestlist.o \
		-L$(LIB_DIR) -llist -o $(BIN_DIR)/mytestlist

# link executable for partA1
partA1 : $(OBJ_DIR)/partA1.o $(OBJ_DIR)/square.o | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/partA1.o \
		$(OBJ_DIR)/square.o -o partA1

# link executable for partA2
$(BIN_DIR)/partA2: $(OBJ_DIR)/partA2.o $(OBJ_DIR)/square.o | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/partA2.o $(OBJ_DIR)/sqaure.o
	-o partA2

# linking executable to root folder
mytestlist : $(BIN_DIR)/mytestlist
	ln -sf $(BIN_DIR)/mytestlist mytestlist

partA2: $(BIN_DIR)/partA2
	ln -sf $(BIN_DIR)/partA2 partA2

# partA1 : $(BIN_DIR)/partA1
#	cmd /c "mklink partA1.exe bin\Windows_NT\partA1.exe"
#	partA1.exe
