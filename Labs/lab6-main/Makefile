# Name: KAUR Shruti
# NSID: ICH524
# Student Number: 11339265

CC = gcc
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra
CFLAGS = -g
LDFLAGS = -L/usr/local/include -L.
INC = -I.

# For pthreads usage
UBC_PTHREAD_INCLUDE_DIR = /student/cmpt332/pthreads
UBC_PTHREAD_DIR = /student/cmpt332/pthreads/lib/$(OS)$(ARCH)
UBC_COMPILER_FLAG = -DUSE_UBC_THREADS
CURRENT_DIR = ./

target: bfit_algor

all: $(target)

OS = $(shell uname -s)
ARCH = $(shell uname -m)

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
	rm -rf obj/ bin/ lib/ bfit_algor

LIST_OBJECTS = $(OBJ_DIR)/list_adders.o $(OBJ_DIR)/list_movers.o \
	       $(OBJ_DIR)/list_removers.o

MON_OBJECTS = $(OBJ_DIR)/Monitor.o

# Compile all the list objects 
$(OBJ_DIR)/list_adders.o: list_adders.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o: list_movers.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o: list_removers.o | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_removers.c -o $(OBJ_DIR)/list_removers.o

# Compile objects for all the other 3 C files
$(OBJ_DIR)/BestFit.o: BestFit.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	BestFit.c -o $(OBJ_DIR)/BestFit.o

$(OBJ_DIR)/BestFitMonitor.o: BestFitMonitor.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	BestFitMonitor.c -o $(OBJ_DIR)/BestFitMonitor.o
 
$(OBJ_DIR)/Monitor.o: Monitor.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	Monitor.c -o $(OBJ_DIR)/Monitor.o

# Archiving list objects into a liblist library
$(LIB_DIR)/liblist.a:  $(LIST_OBJECTS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJECTS)

# Archiving Monitor objects into a libMonitor library
$(LIB_DIR)/libMonitor.a: $(MON_OBJECTS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/libMonitor.a $(MON_OBJECTS)

# Put everything together for the executable 
$(BIN_DIR)/bfit_algor: $(UBC_PTHREAD_DIR)/libpthreads.a $(LIB_DIR)/liblist.a \
	$(LIB_LIST)/libMonitor.a $(OBJ_DIR)/Monitor.o $(OBJ_DIR)/BestFit.o \
	$(OBJ_DIR)/BestFitMonitor.o | $(BIN_DIR)
	$(CC) $(CFLAGS) $(UBC_COMPILER_FLAG) $(OBJ_DIR)/Monitor.o \
	$(OBJ_DIR)/BestFitMonitor.o $(OBJ_DIR)/BestFit.o $(LDFLAGS) \
	-L$(UBC_PTHREAD_DIR) -L$(LIB_DIR) -llist -lMonitor -lpthreads -o \
	$(BIN_DIR)/bfit_algor

# Linkng the executable for a symbolic link
bfit_algor: $(BIN_DIR)/bfit_algor 
	ln -sf $(BIN_DIR)/bfit_algor bfit_algor
