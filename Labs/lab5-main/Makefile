#
# Shruti Kaur
# ich524
# 11339265
#

CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra

ARCH = $(shell uname -m)
OS := $(shell uname -s)

INC = -I.
OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin

UBC_PTHREAD_INCLUDE_DIR = /student/cmpt332/pthreads
UBC_PTHREAD_DIR = /student/cmpt332/pthreads/lib/$(OS)$(ARCH)
UBC_COMPILER_FLAG = -DUSE_UBC_THREADS

LIST_OBJS = \
	$(OBJ_DIR)/list_adders.o \
	$(OBJ_DIR)/list_movers.o \
	$(OBJ_DIR)/list_removers.o

all: sim

.PHONY: all clean

# Directory creation rules
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Cleanup rule
clean: 
	rm -rf $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR)

# Object file rules
$(OBJ_DIR)/sim.o: sim.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) -I$(UBC_PTHREAD_INCLUDE_DIR) sim.c -o $(OBJ_DIR)/sim.o

# compile objects for list
$(OBJ_DIR)/list_adders.o : list_adders.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o : list_movers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o : list_removers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_removers.c -o $(OBJ_DIR)/list_removers.o

# library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# Binary target rule
$(BIN_DIR)/sim: $(OBJ_DIR)/sim.o $(LIB_DIR)/liblist.a $(UBC_PTHREAD_DIR)/libpthreads.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) $(UBC_COMPILER_FLAG) $(OBJ_DIR)/sim.o \
	-L$(LIB_DIR) $(LIB_DIR)/liblist.a -L$(UBC_PTHREAD_DIR) -lpthreads -o $(BIN_DIR)/sim

# Symlink rule for monitor
sim: $(BIN_DIR)/sim
	ln -sf $(BIN_DIR)/sim sim
