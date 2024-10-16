#Student Name: KAUR Shruti
#NSID: ICH524
#Student Number: 11339265

CPPFLAGS = -Wall -std=gnu90 -pedantic -g -Wextra
# Look at header files in the current directory 

CC = gcc
CFLAGS = -g 	# Wall -> All Warnings
INC = -I.
										
# -std=c99: C99 is used.
										
# -pedantic: C standards
										
#  -g: Used for gdb

BUILD_DIR 	= build
LIB_DIR		= lib
BIN_DIR		= bin


LIB_DIRS	= -L$(LIB_DIR)
EXECUTABLES = myQsort
HEADER_FILE_DIR = ./#~/git_hub/cmpt332/Labs/lab0-main/submission

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
$(BUILD_DIR)/qsort.o: qsort.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) $(INC) -I$(HEADER_FILE_DIR)  qsort.c -o \
	 $(BUILD_DIR)/qsort.o

$(BUILD_DIR)/intComp.o: intComp.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) -I$(HEADER_FILE_DIR) intComp.c -o \
	$(BUILD_DIR)/intComp.o

$(BUILD_DIR)/doubleComp.o: doubleComp.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) -I$(HEADER_FILE_DIR) doubleComp.c -o \
	 $(BUILD_DIR)/doubleComp.o

$(BUILD_DIR)/complexComp.o: complexComp.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) -I$(HEADER_FILE_DIR) complexComp.c -o \
	$(BUILD_DIR)/complexComp.o

$(BUILD_DIR)/input-routines.o: input-routines.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) -I$(HEADER_FILE_DIR) input-routines.c -o \
	$(BUILD_DIR)/input-routines.o

$(BUILD_DIR)/swap.o: swap.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) -I$(HEADER_FILE_DIR)  swap.c -o $(BUILD_DIR)/swap.o

$(BUILD_DIR)/sortMain.o: sortMain.c | $(BUILD_DIR)
	$(CC) -c $(CPPFLAGS) -I$(HEADER_FILE_DIR)  sortMain.c \
	-o $(BUILD_DIR)/sortMain.o


# Link the object files into the executable
$(BIN_DIR)/myQsort: $(QSORT_OBJS) | $(BIN_DIR)
	$(CC) $(CPPFLAGS) $(QSORT_OBJS) -o $(BIN_DIR)/myQsort

myQsort: $(BIN_DIR)/myQsort
	ln -sf $(BIN_DIR)/myQsort myQsort
