CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra

OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin

LIST_OBJS = \
	$(OBJ_DIR)/list_adders.o \
	$(OBJ_DIR)/list_movers.o \
	$(OBJ_DIR)/list_removers.o

target: $(BIN_DIR)/sim
all: $(target)

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
	rm -rf $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR) sim

# Object file rules
$(OBJ_DIR)/sim.o: sim.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) sim.c -o $(OBJ_DIR)/sim.o

# compile objects for list
$(OBJ_DIR)/list_adders.o : list_adders.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o : list_movers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o : list_removers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_removers.c \
		-o $(OBJ_DIR)/list_removers.o

# library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# Binary target rule
$(BIN_DIR)/sim: $(OBJ_DIR)/sim.o  $(LIB_DIR)/liblist.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/sim.o -llist -o $(BIN_DIR)/sim

# Symlink rule for monitor
sim: $(BIN_DIR)/sim
	ln -sf $(BIN_DIR)/sim sim
