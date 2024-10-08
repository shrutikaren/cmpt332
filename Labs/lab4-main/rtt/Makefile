# Makefile for outer level RTT
# Copyright University of British Columbia
# 
# Last modified October 16, 2017
# Dwight Makaroff
# got rid of reference to gmake as it is unnecessary.


ARCH = $(shell uname)

ifeq ($(ARCH),SunOS)
ARCH = $(PLATFORM)

PROCESSOR = "$(shell uname -p)"
ifeq ($(PROCESSOR),i386)
ARCH = i86pc
endif

endif

RTTDIR = ./src/rtt
OBJDIR = ./obj/$(ARCH)
LIBDIR = ./lib/$(ARCH)
UTILSDIR = ./src/utils

all:  library utils

library:
	(cd $(RTTDIR) ; make)

utils:
	(cd $(UTILSDIR) ; make)

clean:
	(cd $(RTTDIR) ; make clean)
	(cd $(UTILSDIR); make clean)
