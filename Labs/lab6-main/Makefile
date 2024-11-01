# Name: KAUR Shruti
# NSID: ICH524
# Student Number: 11339265

CC = gcc
CPPFLAGS = -Wall -pedantic -std=gnu90 -Wextra -I.
CFLAGS = -g
LDFLAGS = -L/usr/local/include -L.
INC = -I.

# For pthreads usage
UBC_PTHREAD_INCLUDE_DIR = /student/cmpt332/pthreads
UBC_PTHREAD_DIR = /student/cmpt332/pthreads/lib/$(OS)$(ARCH)
UBC_COMPILER_FLAG = -DUSE_UBC_THREADS

target: bfit_algor

all: $(target)

OS = $(shell uname -s)

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
	rm -rf obj/ bin/ lib/ bfit_algor

LIST_OBJECTS = $(OBJ_DIR)/list_adders.o $(OBJ_DIR)/list_movers.c \
	       $(OBJ_DIR)/list_removers.o

MON_OBJECTS = $(OBJ_DIR)/Monitor.o

# Compile all the list objects 
$(OBJ_DIR)/list_adders.o: list_adders.c
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o: list_movers.c
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o: list_removers.o 
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	list_removers.c -o $(OBJ_DIR)/list_removers.o

# Compile objects for all the other 3 C files
$(OBJ_DIR)/BestFit.o: BestFit.c
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	BestFit.c -o $(OBJ_DIR)/BestFit.o

$(OBJ_DIR)/BestFitMonitor.o: BestFitMonitor.c
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	BestFitMonitor.c -o $(OBJ_DIR)/BestFitMonitor.o

$(OBJ_DIR)/Monitor.o: Monitor.c
	$(CC) -c $(CPPFLAGS) $(INC) -I$(CURRENT_DIR) \
	Monitor.c -o $(OBJ_DIR)/Monitor.o

# Archiving list objects into a liblist library
$(LIB_LIST)/liblist.a:  $(LIST_OBJECTS) | $(LIB_DIR)
	ar rcs $(LIB_LIST)/liblist.a $(LIST_OBJECTS)

# Archiving Monitor objects into a libMonitor library
$(LIB_LIST)/libMonitor.a: $(MON_OBJECTS) | $(LIB_DIR)
	ar rcs $(LIB_LIST)/libMonitor.a $(MON_OBJECTS)

# Put everything together for the executable 


# Linkng the executable for a symbolic link

