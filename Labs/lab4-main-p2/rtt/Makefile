CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -std=gnu90 -Wextra 

OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib 

target = monitor

all : $(target) 

.PHONY: all clean 

# Make the directories 
$(OBJ_DIR) : 
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)


# Cleanup rule 
clean:
	rm -rf bin/ ob/ lib/
