# Makefile for tests
# r. anido

PROGS := $(patsubst %.c,%.o,$(wildcard *.c))
OBJS := $(patsubst %.c,%,$(wildcard *.c))

# clear suffixes 
.SUFFIXES: 
.SUFFIXES: .c .o

CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc

all:	$(PROGS)

clean:
	rm -f *~ *.o $(OBJS)

.c.o:
	$(CC) -o $* $< ../libc/startup.o ../libc/libnosys_gnu.o -lm -nostartfiles -static




