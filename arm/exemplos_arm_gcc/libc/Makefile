# Makefile for tests
# r. anido

# clear suffixes 
.SUFFIXES: 
.SUFFIXES: .c .o .s

CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc

all:	libnosys_gnu.o startup.o

clean:
	rm -f *~ *.o $(OBJS)

# suffix rules
.c.o:
	$(CC) -c  $<

.s.o:
	$(CC) -c  $<

