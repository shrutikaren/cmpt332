CC = gcc
CFLAGS = -g
CPPFLAGS = -std=gnu90 -Wall -pedantic -Wextra

INC = -I.
HEADER_RT_THREADS = /student/cmpt332/include
X86_64_RT_THREADS = /student/cmpt332/rtt/lib

RTTINC = -I/student/cmpt332/rtt/include -I/usr/include/tirpc
RTTLIB1 = -L/student/cmpt332/rtt/lib/Linuxx86_64
RTTLIB2 = -lRtt -lRttUtils -L. -lMonitor -llist -ltirpc

OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin

target: $(BIN_DIR)/monitor
all: $(target)

.PHONY: all clean

# Directory creation rules
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(LIB_DIR):
	mkdir -p $(LIB_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Cleanup rule
clean: 
	rm -rf $(OBJ_DIR) $(LIB_DIR) $(BIN_DIR) monitor

# Object file rules
$(OBJ_DIR)/monitor.o: monitor.c monitor.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) $(RTTINC) \
		-I$(HEADER_RT_THREADS) -o $(OBJ_DIR)/monitor.o monitor.c

$(OBJ_DIR)/reader-writer.o: reader-writer.c | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) $(RTTINC) \
		-I$(HEADER_RT_THREADS) -o $(OBJ_DIR)/reader-writer.o \
		reader-writer.c

$(OBJ_DIR)/reader-writer-monitor.o: reader-writer-monitor.c \
	reader-writer-monitor.h monitor.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) $(RTTINC) \
		-I$(HEADER_RT_THREADS) -o $(OBJ_DIR)/reader-writer-monitor.o \
		reader-writer-monitor.c

# Binary target rule
$(BIN_DIR)/monitor: $(OBJ_DIR)/monitor.o | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/monitor.o $(RTTLIB1) \
		$(RTTLIB2) -o $(BIN_DIR)/monitor

# Symlink rule for monitor
monitor: $(BIN_DIR)/monitor
	ln -sf $(BIN_DIR)/monitor monitor
