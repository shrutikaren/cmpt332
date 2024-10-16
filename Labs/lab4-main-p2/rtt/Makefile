CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -std=gnu90 -Wextra 

OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib 
LIST_OBJS = $(OBJ_DIR)/list_adders.o \
	    $(OBJ_DIR)/list_movers.o \
	    $(OBJ_DIR)/list_removers.o
RTT_HEADER_DIR = /student/cmpt332/rtt/include 

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
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(LIB_DIR) $(target)

# Compiling all the C files
$(OBJ_DIR)/monitor.o: monitor.c monitor.h | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c monitor.c -o $(OBJ_DIR)/monitor.o

$(OBJ_DIR)/reader_writer.o: reader_writer.c monitor.h | $(OBJ_DIR) 
	
$(OBJ_DIR)/reader_writer_monitor.o: reader_writer_monitor.c monitor.h | $(OBJ_DIR)

$(OBJ_DIR)/list_adders.o: list_adders.c list.h | $(OBJ_DIR)

$(OBJ_DIR)/list_movers.o: list_movers.c list.h | $(OBJ_DIR)

$(OBJ_DIR)/list_removers.o: list_removers.c list.h | $(OBJ_DIR)

# List objects needs to be archived 
$(LIB_DIR)/liblist.a: $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# Link everything with executable 

# Create a symbolic link with the executable 

