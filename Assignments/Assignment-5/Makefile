CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra  
INC = -I.
CURRENT_DIR = ./

ARCH = $(shell uname -m)
OS := $(shell uname -s)

target: unit_tests 
all: $(target)

OBJ_DIR = obj/$(OS)
LIB_DIR = lib/$(OS)
BIN_DIR = bin/$(OS)

.PHONY: all clean

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean: 
	rm -rf obj/ lib/ bin/ unit_tests 
	
LIST_OBJS = \
	$(OBJ_DIR)/list_adders.o \
	$(OBJ_DIR)/list_movers.o \
	$(OBJ_DIR)/list_removers.o

$(OBJ_DIR)/unit_tests.o: unit_tests.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) -I$(CURRENT_DIR) unit_tests.c -o $(OBJ_DIR)/unit_tests.o

# compile objects for list
$(OBJ_DIR)/list_adders.o : list_adders.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) -I$(CURRENT_DIR) list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o : list_movers.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) -I$(CURRENT_DIR)  list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o : list_removers.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) -I$(CURRENT_DIR) list_removers.c -o $(OBJ_DIR)/list_removers.o

# library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# Binary target rule
$(BIN_DIR)/unit_tests: $(OBJ_DIR)/unit_tests.o $(LIB_DIR)/liblist.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(INC) $(OBJ_DIR)/unit_tests.o -L. \
	-L$(LIB_DIR) $(LIB_DIR)/liblist.a -o $(BIN_DIR)/unit_tests

# Symlink rule for monitor
unit_tests: $(BIN_DIR)/unit_tests
	ln -sf $(BIN_DIR)/unit_tests unit_tests
