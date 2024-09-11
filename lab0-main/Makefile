CPPFLAGS = -I.
CC = gcc
CFLAGS = -Wall -std=c99 -pedantic -g

#directories on the system type
BUILD_DIR = build/$(shell uname -s)-$(shell uname -m)
LIB_DIR = lib/$(shell uname -s)-$(shell uname -m)
BIN_DIR = bin/$(shell uname -s)-$(shell uname -m)

#library directories to link
LIB_DIRS =-L$(LIB_DIR)

#objects 
TEST_MAP_OBJS = $(BUILD_DIR)/#add object file here
MAP_MOD_OBJS = $(BUILD_DIR)/#add object file here
MAP_UTIL_OBJS = $(BUILD_DIR)/#add object file here

#list of executables that a Makefile creates
EXECUTABLES = test-map

.PHONY: all clean
all: $(EXECUTABLES)
clean:
	rm -rf build/ lib/ bin/ $(EXECUTABLES)

#directories
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)


#compiling object files - FIX THIS ACCORDING TO YOUR FILES
$(BUILD_DIR)/test-map.o: test-map.c map.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) test-map.c -o $(BUILD_DIR)/test-map.o

$(BUILD_DIR)/map-modify.o: map-modify.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) map-modify.c -o $(BUILD_DIR)/map-modify.o

$(BUILD_DIR)/map-util.o: map-util.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) map-util.c -o $(BUILD_DIR)/map-util.o


#libraries - FIX THES ACCORDING TO YOUR FILES
$(LIB_DIR)/libmap.a: $(MAP_MOD_OBJS) $(MAP_UTIL_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/libmap.a $(MAP_MOD_OBJS) $(MAP_UTIL_OBJS)

#linking - FIX THIS ACCORDNG TO YOUR FILES
$(BIN_DIR)/test-map: $(LIB_DIR)/libmap.a $(BUILD_DIR)/test-map.o | $(BIN_DIR)
	$(CC) $(CFLAGS) $(LIB_DIRS) $(BUILD_DIR)/test-map.o -lmap -o $(BIN_DIR)/test-map

#symolic links - FIX THIS ACCORDING TO YOUR FILES
test-map : $(BIN_DIR)/test-map
	ln -sf $(BIN_DIR)/test-map test-map

