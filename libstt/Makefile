# Makefile for libstt
# Copyright 2013 Paul Furber 

# what to build and where to build it
OUTDIR=build
SONAME=libstt.so
LIBNAME=$(OUTDIR)/$(SONAME)

# release or debug
BUILD := release

LDFLAGS := -shared -Wl,-soname,$(SONAME) 
CFLAGS  := -O2 -pipe -fPIC

CROSS_PREFIX :=

# debug build?
ifeq ($(BUILD),debug)
CFLAGS += -g
LDFLAGS+= -g
endif

CC = $(CROSS_PREFIX)gcc
LD = $(CROSS_PREFIX)gcc

INCLUDES = -Iinclude -I/usr/include/SDL
LIBS = -L/usr/lib -lSDL -lSDL_ttf 

OBJNAME := $(OUTDIR)/stt.o

all	: $(LIBNAME)

$(LIBNAME) : $(OBJNAME) $(OUTDIR)
	$(LD) $(LDFLAGS) -o $@ $< $(LIBS)

$(OBJNAME) : stt.c 
	$(CC) -c $(CFLAGS) $(INCLUDES) -o $@ $<

install	: $(LIBNAME)
	install -m 755 $(LIBNAME) /usr/local/lib

.PHONY:	clean
clean:
	rm -f $(OUTDIR)/stt.o
	rm -f $(OUTDIR)/libstt.so
