.SUFFIXES:
.SUFFIXES: .c .o

TARGET = i386-jos-elf
CC = $(TARGET)-gcc
LD = $(TARGET)-ld
AR = $(TARGET)-ar
OBJDUMP = $(TARGET)-objdump
OBJCOPY = $(TARGET)-objcopy

MKFS = ../tools/mkfs

PROGS = cat echo forktest grep init kill ln ls mkdir rm sh \
	stressfs usertests wc zombie
PROG_SRCS = $(PROGS:=.c)

CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing \
	-Wall -MD -ggdb -fno-omit-frame-pointer -ffreestanding \
	-fno-common -nostdlib -I../include -gdwarf-2 -m32 -O0 \
	-fno-stack-protector

LDFLAGS = -m elf_i386 -nodefaultlibs -N -e main -Ttext 0

ULIB_SRCS = ulib.c printf.c umalloc.c

SRCS = $(ULIB_SRCS) $(PROG_SRCS)

ASMS = usys.S

AFLAGS = -gdwarf-2 -Wa,-divide -I../include -m32

ULIB_OBJS = $(ULIB_SRCS:.c=.o) $(ASMS:.S=.o)
PROG_OBJS = $(PROG_SRCS:.c=.o)

OBJS = $(ULIB_OBJS) $(PROG_OBJS)

FS = fs.img

all : objs progs fs

fs :
	$(MKFS) $(FS) cat echo forktest grep init kill \
		ln ls mkdir rm sh stressfs usertests wc zombie

progs : $(PROGS)

% : %.o $(ULIB_OBJS)
	$(LD) $(LDFLAGS) -o $@ $@.o $(ULIB_OBJS)
	$(OBJDUMP) -S $@ > $@.asm
	$(OBJDUMP) -t $@ | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $@.sym

forktest : forktest.o ulib.o usys.o
	$(LD) $(LDFLAGS) -o $@ $@.o ulib.o usys.o

objs : $(OBJS)

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o : %.S
	$(CC) $(AFLAGS) -c -o $@ $<

clean :
	rm -f $(OBJS) $(PROGS) $(FS) 
	rm -f *.d *.asm *.sym

.PHONY : \
	all clean test \
		objs progs fs

