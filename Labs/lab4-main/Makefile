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

LIST_OBJS = \
	$(OBJ_DIR)/list_adders.o \
	$(OBJ_DIR)/list_movers.o \
	$(OBJ_DIR)/list_removers.o

# Final target
all: monitor

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
		-I$(HEADER_RT_THREADS) -o $(OBJ_DIR)/reader-writer.o reader-writer.c

$(OBJ_DIR)/reader-writer-monitor.o: reader-writer-monitor.c \
	reader-writer-monitor.h monitor.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) $(RTTINC) \
		-I$(HEADER_RT_THREADS) -o $(OBJ_DIR)/reader-writer-monitor.o \
		reader-writer-monitor.c

# Compile objects for list
$(OBJ_DIR)/list_adders.o : list_adders.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_adders.c -o $(OBJ_DIR)/list_adders.o

$(OBJ_DIR)/list_movers.o : list_movers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_movers.c -o $(OBJ_DIR)/list_movers.o

$(OBJ_DIR)/list_removers.o : list_removers.c list.h | $(OBJ_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) $(INC) list_removers.c \
		-o $(OBJ_DIR)/list_removers.o

# Library rule for list
$(LIB_DIR)/liblist.a : $(LIST_OBJS) | $(LIB_DIR)
	ar rcs $(LIB_DIR)/liblist.a $(LIST_OBJS)

# Library rule for monitor
$(LIB_DIR)/libMonitor.a: $(OBJ_DIR)/monitor.o | $(LIB_DIR)
	ar -rs $(LIB_DIR)/libMonitor.a $(OBJ_DIR)/monitor.o
	ranlib $(LIB_DIR)/libMonitor.a

# Binary target rule
$(BIN_DIR)/monitor: $(OBJ_DIR)/reader-writer.o $(LIB_DIR)/liblist.a $(LIB_DIR)/libMonitor.a | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(OBJ_DIR)/reader-writer.o $(RTTLIB1) \
		$(RTTLIB2) -L$(LIB_DIR) -llist -lMonitor -o $(BIN_DIR)/monitor

# Symlink rule
monitor: $(BIN_DIR)/monitor
	ln -sf $(BIN_DIR)/monitor monitor
