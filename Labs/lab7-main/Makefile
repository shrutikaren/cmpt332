CC = gcc 
CPPFLAGS = -Wall -pedantic -std=gnu90 -Wextra
CFLAGS = -g


target: sim

all: $(target)

OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin

.PHONY: all clean
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean: 
	rm -rf obj/ bin/ lib/ sim 

$(OBJ_DIR)/sim.o: sim.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) sim.c -o $(OBJ_DIR)/sim.o 

$(BIN_DIR)/sim: $(OBJ_DIR)/sim.o | $(BIN_DIR)
	$(CC) $(CFLAGS) $(OBJ_DIR)/sim.o -lm -o $(BIN_DIR)/sim 

sim: $(BIN_DIR)/sim
	ln -sf $(BIN_DIR)/sim sim
