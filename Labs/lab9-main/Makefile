CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra 

# Final target
all: testdriver prodconsum

.PHONY: all clean 

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
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/pipe-driver.o pipe-driver.c

$(OBJ_DIR)/driver-PC.o: driver-PC.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/driver-PC.o driver-PC.c 

$(OBJ_DIR)/produc


