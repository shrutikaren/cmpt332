/*
	Shruti Kaur
	ICH524
	11339265
*/

CC = gcc
CFLAGS = -g
CPPFLAGS = -Wall -pedantic -I. -std=gnu90 -Wextra

HEADER_RT_THREADS = /student/cmpt332/include
X86_64_RT_THREADS = /student/cmpt332/rtt/lib

target: monitor
all: $(target)

.PHONY: all clean

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -po $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

clean: 
	rm -rf obj/ lib/ bin/ monitor

$(OBJ_DIR)/ monitor.o
