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


# Compile objects for all the other 3 C files


# Archiving list objects into a liblist library
$(LIB_LIST)/liblist.a:  $(LIST_OBJECTS) | $(LIB_DIR)
	ar rcs $(LIB_LIST)/liblist.a $(LIST_OBJECTS)

# Archiving Monitor objects into a libMonitor library
$(LIB_LIST)/libMonitor.a: $(MON_OBJECTS) | $(LIB_DIR)
	ar rcs $(LIB_LIST)/libMonitor.a $(MON_OBJECTS)

# Put everything together for the executable 


# Linkng the executable for a symbolic link

