#Student Name: KAUR Shruti
#NSID: ICH524
#Student Number: 11339265

CPPFLAGS = -Wall -std=gnu90 -pedantic -g
# Look at header files in the current directory 

CC = gcc
CFLAGS = -g 	# Wall -> All Warnings
										
# -std=c99: C99 is used.
										
# -pedantic: C standards
										
#  -g: Used for gdb

BUILD_DIR 	= build
LIB_DIR		= lib
BIN_DIR		= bin


LIB_DIRS	= -L$(LIB_DIR)
EXECUTABLES = myQsort

QSORT_OBJS  = $(BUILD_DIR)/qsort.o $(BUILD_DIR)/intComp.o \
 		$(BUILD_DIR)/doubleComp.o $(BUILD_DIR)/complexComp.o \
		$(BUILD_DIR)/input-routines.o $(BUILD_DIR)/swap.o \
		$(BUILD_DIR)/sortMain.o

.PHONY: all clean

all: $(BIN_DIR)/myQsort

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Compiling Object Files
$(BUILD_DIR)/qsort.o: qsort.c qsort.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) qsort.c -o $(BUILD_DIR)/qsort.o

$(BUILD_DIR)/intComp.o: intComp.c qsort.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) intComp.c -o $(BUILD_DIR)/intComp.o

$(BUILD_DIR)/doubleComp.o: doubleComp.c qsort.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) doubleComp.c -o \
	 $(BUILD_DIR)/doubleComp.o

$(BUILD_DIR)/complexComp.o: complexComp.c qsort.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) complexComp.c -o \
	$(BUILD_DIR)/complexComp.o

$(BUILD_DIR)/input-routines.o: input-routines.c qsort.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) input-routines.c -o \
	$(BUILD_DIR)/input-routines.o

$(BUILD_DIR)/swap.o: swap.c qsort.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) swap.c -o $(BUILD_DIR)/swap.o

$(BUILD_DIR)/sortMain.o: sortMain.c qsort.h | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(CFLAGS) sortMain.c -o $(BUILD_DIR)/sortMain.o


# Link the object files into the executable
$(BIN_DIR)/myQsort: $(QSORT_OBJS) | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(QSORT_OBJS) -o $(BIN_DIR)/myQsort

myQsort: $(BIN_DIR)/myQsort
	ln -sf $(BIN_DIR)/myQsort myQsort
