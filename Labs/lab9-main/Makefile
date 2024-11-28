CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra 

# Final target
all: testdriver prodconsum

.PHONY: all clean 

OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR) 

$(BIN_DIR):
	mkdir -p $(BIN_DIR) 

clean: 
	rm -rf $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR) testdriver prodconsum 

# Object file rules 
$(OBJ_DIR)/pipe-driver.o: pipe-driver.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $(OBJ_DIR)/pipe-driver.o pipe-driver.c

$(OBJ_DIR)/driver-PC.o: driver-PC.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $(OBJ_DIR)/driver-PC.o driver-PC.c 

$(OBJ_DIR)/produceconsume.o: produceconsume.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) -o $(OBJ_DIR)/produceconsume.o \
	produceconsume.c

# Binary file target rule 
$(BIN_DIR)/testdriver: $(OBJ_DIR)/pipe-driver.o $(OBJ_DIR)/driver-PC.o \
	 | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/pipe-driver.o \
	$(OBJ_DIR)/driver-PC.o -o $(BIN_DIR)/testdriver 

$(BIN_DIR)/prodconsum: $(OBJ_DIR)/produceconsume.o | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/produceconsume.o -o \
	$(BIN_DIR)/prodconsum

# Symlink rule 
testdriver: $(BIN_DIR)/testdriver
	ln -sf $(BIN_DIR)/testdriver testdriver 

prodconsum: $(BIN_DIR)/prodconsum
	ln -sf $(BIN_DIR)/prodconsum prodconsum

