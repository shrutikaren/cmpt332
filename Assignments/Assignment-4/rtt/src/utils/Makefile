# Makefile for the Utilities for RT Threads

PLATFORM = $(shell uname -s)
ARCH = $(shell uname -m)


ifeq ($(ARCH), SunOS)
ARCH = $(PLATFORM)
PROCESSOR = "$(shell uname -p)"

ifeq ($(PROCESSOR),i386)
ARCH = i86pc
endif
endif

ifeq ($(ARCH),ibm)
  CC = xlc -D_ALL_SOURCE
else
  CC = gcc
endif

ifeq ($(ARCH), x86_64)
EXTRA=
endif

ifeq ($(PLATFORM), Linux)
  ifeq ($(ARCH), x86_64)
   CFLAGS += -fPIC
  endif
endif

ifeq ($(ARCH),i86pc)
  OSDEF = solaris
  ASMDEF = $(ARCH)
else
  OSDEF = $(ARCH)
  ASMDEF = $(ARCH)
endif

ifeq ($(ARCH), x86_64)
EXTRA= -mstackrealign
ASMDEF=x86_64
endif

ifeq ($(PLATFORM), Darwin)
EXTRA+= -mstackrealign
endif


ROOTDIR = ../..

RTTINC = $(ROOTDIR)/include

SD = .
OD = $(ROOTDIR)/obj/$(PLATFORM)$(ARCH)
LD = $(ROOTDIR)/lib/$(PLATFORM)$(ARCH)



# compile options
INCLUDES = -I. -I$(RTTINC) -I/usr/include/tirpc
CFLAGS = -g $(INCLUDES) $(EXTRA) -fPIC  -D$(PLATFORM) -D$(OSDEF)


OBJS = $(OD)/RttBarrier.o $(OD)/RttCommon.o $(OD)/RttMutex.o $(OD)/RttQueue.o

all:	dirs lib

dirs:
	mkdir -p $(OD)
	mkdir -p $(LD)

lib:	$(OBJS) $(LD)/libRttUtils.a

$(LD)/libRttUtils.a: $(OBJS)
	ar rc $(LD)/libRttUtils.a $(OBJS)
	-@chmod ug+w $(LD)/libRttUtils.a
ifneq ($(ARCH),sun4sol)
	ranlib $(LD)/libRttUtils.a
endif

install:
	cp RttBarrier.h $(RTTINC)
	-@chmod ug+w $(RTTINC)/RttBarrier.h
	cp RttCommon.h $(RTTINC)
	-@chmod ug+w $(RTTINC)/RttCommon.h
	cp RttMutex.h $(RTTINC)
	-@chmod ug+w $(RTTINC)/RttMutex.h
	cp RttQueue.h $(RTTINC)
	-@chmod ug+w $(RTTINC)/RttQueue.h

clean:
	rm -f  *~ $(OBJS) $(LD)/libRttUtils.a

$(OD)/RttBarrier.o: $(SD)/RttBarrier.c
	$(CC) $(CFLAGS) -c $(SD)/RttBarrier.c -o $(OD)/RttBarrier.o

$(OD)/RttCommon.o: $(SD)/RttCommon.c
	$(CC) $(CFLAGS) -c $(SD)/RttCommon.c -o $(OD)/RttCommon.o

$(OD)/RttMutex.o: $(SD)/RttMutex.c
	$(CC) $(CFLAGS) -c $(SD)/RttMutex.c -o $(OD)/RttMutex.o

$(OD)/RttQueue.o: $(SD)/RttQueue.c
	$(CC) $(CFLAGS) -c $(SD)/RttQueue.c -o $(OD)/RttQueue.o



