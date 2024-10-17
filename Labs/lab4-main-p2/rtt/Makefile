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
CURRENT_DIR = ./
INC = -I.

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
$(OBJ_DIR)/monitor.o: monitor.c | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(INC) -I$(CURRENT_DIR)  -c monitor.c -o $(OBJ_DIR)/monitor.o

$(OBJ_DIR)/reader_writer.o: reader_writer.c | $(OBJ_DIR) 
	$(CC) $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) -I$(RTT_HEADER_DIR) -c reader_writer.c -o $(OBJ_DIR)/reader-writer.o

$(OBJ_DIR)/reader_writer_monitor.o: reader_writer_monitor.c | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) -c reader_writer_monitor.c -o $(OBJ_DIR)/reader_writer_monitor.o

$(OBJ_DIR)/list_adders.o: list_adders.c | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) -c list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o: list_movers.c | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) -c list_movers.c -o $(OBJ_DIR)/list_movers.o 

$(OBJ_DIR)/list_removers.o: list_removers.c | $(OBJ_DIR)
	$(CC) $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) -c list_removers.c -o $(OBJ_DIR)/list_removers.o 

# List objects needs to be archived 
$(LIB_DIR)/liblist.a: $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# Library rule for your monitor
$(LIB_DIR)/libMonitor: $(OBJ_DIR)/monitor.o | $(BIN_DIR)
	ar rcs $(LIB_DIR)/libMonitor.a $(OBJ_DIR)/monitor.o 

# Link everything with executable 
$(BIN_DIR)/monitor: 

# Create a symbolic link with the executable 
monitor: $(BIN_DIR)/monitor
	ln -sf $(BIN_DIR)/monitor monitor 
