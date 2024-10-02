# makefile for UBC pthreads
# Maintained by Dwight Makaroff, University of Saskatchewan
#  modified Sep 22, 2016
# Modified: October 16, 2018 to handle Darwin
# No mods needed to handle ARM
#
#CC      = cc    # use CC for hpux
CC     = gcc   # use gcc otherwise


PLATFORM = $(shell uname -s)
ifeq ($(PLATFORM), solaris)
ARCH = $(PLATFORM)
else
ARCH = $(shell uname -m)
endif


#CFLAGS = -O2 -g -Di386 	#defines for old version of linux and optimized
#CFLAGS  =  -g -D$(ARCH) -Aa -D_HPUX_SOURCE #defines for hpux
CFLAGS =  -Wall -g -D$(ARCH)                    # defines otherwise

ifeq ($(PLATFORM), Darwin)
CFLAGS += -mstackrealign ###-fPIC
endif

#ifeq ($(PLATFORM), Linux)
#CFLAGS += -mpreferred-stack-boundary=4 -mstackrealign
#endif

ifeq ($(ARCH), ppc)
CROSS-COMPILE=arm-linux-gnueabihf-
endif


ifeq ($(ARCH), sun4u)
  ASM_ARCH=solaris
else
  ASM_ARCH = $(ARCH)
endif

#special check working for 32 and 64 bit machines. Not currently implemented
EXTRA= 

#ASM_ARCH = $(ARCH)


#ifeq ($(ARCH), x86_64)
#EXTRA=-m32
#ASM_ARCH=i686
#endif

CPP = /usr/bin/cpp

#change these if your application code is not in the same
# directory as the pthreads library.
INCLUDEDIR=.
LIBDIR=lib

HEADERS=standards.h os.h kernelTypes.h ipc.h ptime.h procMgmt.h mem.h \
		synch.h scheduling.h queue.h kernelConfig.h

OBJ=startup.o context.o queue.o procMgmt.o ipc.o time.o scheduling.o \
	synch.o mem.o

all: lib app

app:    app.o $(LIBDIR)/$(PLATFORM)$(ARCH)/libpthreads.a 
	$(CC) $(CFLAGS) $(EXTRA) app.o -L$(LIBDIR)/$(PLATFORM)$(ARCH) \
		-lpthreads -o app

debug-kill:    debug-kill.o $(LIBDIR)/$(PLATFORM)$(ARCH)/libpthreads.a 
	$(CC) $(CFLAGS) $(EXTRA) debug-kill.o -L$(LIBDIR)/$(PLATFORM)$(ARCH) \
		-lpthreads -o debug-kill

lib: $(OBJ)
	ar rc libpthreads.a $(OBJ)
	ranlib libpthreads.a

$(LIBDIR)/$(PLATFORM)$(ARCH)/libpthreads.a: $(OBJ)
	ar rc libpthreads.a $(OBJ)

	ranlib libpthreads.a
	chmod 644 libpthreads.a
	mv libpthreads.a $(LIBDIR)/$(PLATFORM)$(ARCH)

tempapp: app.o testlib libpthreads.a
	$(CC) $(CFLAGS) $(EXTRA) -o tempapp app.o -L. -lpthreads

kernel.h: $(HEADERS) 
#	touch kernel.h

app.o: app.c os.h standards.h
	$(CC) $(CFLAGS) $(EXTRA) -c app.c -I$(INCLUDEDIR)

debug-kill.o: debug-kill.c os.h standards.h
	$(CC) $(CFLAGS) $(EXTRA) -c debug-kill.c -I$(INCLUDEDIR)

synch.o:  synch.c kernel.h os.h
	$(CC) $(CFLAGS) $(EXTRA) -c synch.c -o synch.o

scheduling.o:  scheduling.c kernel.h
	$(CC) $(CFLAGS) $(EXTRA) -c scheduling.c -o scheduling.o

procMgmt.o:  procMgmt.c kernel.h
	$(CC) $(CFLAGS) $(EXTRA) -c procMgmt.c -o procMgmt.o

queue.o:  queue.c kernel.h
	$(CC) $(CFLAGS) $(EXTRA) -c queue.c -o queue.o

ipc.o:  ipc.c kernel.h
	$(CC) $(CFLAGS) $(EXTRA) -c ipc.c -o ipc.o

time.o:  time.c kernel.h
	$(CC) $(CFLAGS) $(EXTRA) -c time.c -o time.o

mem.o:  mem.c kernel.h
	$(CC) $(CFLAGS) $(EXTRA) -c mem.c -o mem.o

startup.o:  startup.c kernel.h
	$(CC) $(CFLAGS) $(EXTRA) -c startup.c -o startup.o

context.o: context.S
#	$(CPP) $(EXTRA) -D$(PLATFORM) -Di686 -P context.S > _context.S
	$(CPP) $(EXTRA) -D$(PLATFORM) -D$(ASM_ARCH) -P context.S > _context.S
	$(CC) -g -D$(ARCH) -g $(EXTRA) -c -o context.o _context.S
	rm _context.S

clean:
	rm *.o $(LIBDIR)/$(PLATFORM)$(ARCH)/*.a app 
