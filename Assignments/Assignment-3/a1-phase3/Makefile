# Jack Donegan, Shruti Kaur
# lvf165, ich524
# 11357744, 11339265

CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra  

ARCH = $(shell uname -m)

# Checks if the OS is on Windows, compiles partA1 if so
# otherwise compiles everything else.
ifeq ($(OS),Windows_NT)
target: partA1
else # Linux
OS := $(shell uname -s)
target: mytestlist partA2
endif

all: $(target)

OBJ_DIR = obj/$(OS)
LIB_DIR = lib/$(OS)
BIN_DIR = bin/$(OS)

UBC_PTHREAD_INCLUDE_DIR = /student/cmpt332/pthreads/
UBC_PTHREAD_DIR = /student/cmpt332/pthreads/lib/$(OS)$(ARCH)
UBC_COMPILER_FLAG = -DUSE_UBC_THREADS

.PHONY: all clean

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean: 
	rm -rf obj/ lib/ bin/ partA1.exe partA2 partA3 partA4 mytestlist 

LIST_OBJS = \
	$(OBJ_DIR)/list_adders.o \
	$(OBJ_DIR)/list_movers.o \
	$(OBJ_DIR)/list_removers.o

# compile objects for list
$(OBJ_DIR)/list_adders.o : list_adders.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o : list_movers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o : list_removers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) list_removers.c \
		-o $(OBJ_DIR)/list_removers.o

$(OBJ_DIR)/mytestlist.o : mytestlist.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) mytestlist.c -o $(OBJ_DIR)/mytestlist.o

# compile objects for partA1
$(OBJ_DIR)/square.o : square.c square.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) square.c -o $(OBJ_DIR)/square.o

$(OBJ_DIR)/partA1.o : partA1.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) partA1.c -o $(OBJ_DIR)/partA1.o

# Add Target-Specific CPPFLAGS for partA2.o
$(OBJ_DIR)/partA2.o : CPPFLAGS += -I$(UBC_PTHREAD_INCLUDE_DIR)

# Compiling objects for partA2 with USE_UBC_THREADS
$(OBJ_DIR)/partA2.o : partA2.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(UBC_COMPILER_FLAG) partA2.c -o $(OBJ_DIR)/partA2.o

#compiling objects for partA3
$(OBJ_DIR)/partA3.o: partA3.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) partA3.c -o $(OBJ_DIR)/partA3.o

#compiling object for partA4
$(OBJ_DIR)/partA4.o: partA4.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) partA4.c -o $(OBJ_DIR)/partA4.o

# archiving list files into liblist library
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)


# link executable for list
$(BIN_DIR)/mytestlist : \
	$(OBJ_DIR)/mytestlist.o $(LIB_DIR)/liblist.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/mytestlist.o \
		-L$(LIB_DIR) -llist -o $(BIN_DIR)/mytestlist

# link executable for partA1
partA1 : $(OBJ_DIR)/partA1.o $(OBJ_DIR)/square.o | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/partA1.o \
		$(OBJ_DIR)/square.o -o partA1

# Link executable for partA2 with UBC pthreads
$(BIN_DIR)/partA2: $(OBJ_DIR)/partA2.o $(OBJ_DIR)/square.o \
	$(UBC_PTHREAD_DIR)/libpthreads.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(UBC_COMPILER_FLAG) $(OBJ_DIR)/partA2.o $(OBJ_DIR)/square.o \
	-L$(UBC_PTHREAD_DIR) -lpthreads -o $(BIN_DIR)/partA2

#executable for partA3
$(BIN_DIR)/partA3: $(OBJ_DIR)/partA3.o $(OBJ_DIR)/square.o \
		| $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/partA3.o $(OBJ_DIR)/square.o \
	-L$(PTHREAD_DIR) -lpthreads -o $(BIN_DIR)/partA3

#executable for partA4
$(BIN_DIR)/partA4: $(OBJ_DIR)/partA4.o $(OBJ_DIR)/square.o \
		$(PTHREAD_DIR)/libpthreads.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/partA4.o $(OBJ_DIR)/square.o \
	-L$(PTHREAD_DIR) -lpthreads -o $(BIN_DIR)/partA4

# linking executable to root folder
mytestlist : $(BIN_DIR)/mytestlist
	ln -sf $(BIN_DIR)/mytestlist mytestlist

partA2: $(BIN_DIR)/partA2
	ln -sf $(BIN_DIR)/partA2 partA2

partA3: $(BIN_DIR)/partA3
	ln -sf $(BIN_DIR)/partA3 partA3

partA4: $(BIN_DIR)/partA4
	ln -sf $(BIN_DIR)/partA4 partA4
# partA1 : $(BIN_DIR)/partA1
#	cmd /c "mklink partA1.exe bin\Windows_NT\partA1.exe"
#	partA1.exe
