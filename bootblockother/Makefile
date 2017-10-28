TARGET = i386-jos-elf
CC = $(TARGET)-gcc
LD = $(TARGET)-ld
OBJDUMP = $(TARGET)-objdump
OBJCOPY = $(TARGET)-objcopy

CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing \
 -Wall -MD -ggdb -fno-omit-frame-pointer -ffreestanding -fno-common \
 -nostdlib -I../include -gdwarf-2 -m32 -O0 -fno-stack-protector \
 -fno-pic -nostdinc

LDFLAGS = -m elf_i386 -N -e start -Ttext 0x7000

ASMS = entryother.S
SRCS = 
OBJS = $(SRCS:.c=.o) $(ASMS:.S=.o)

BINARY = entryother 

all : objs binary

objs : $(OBJS)

binary : $(BINARY)

%.o : %.c
	$(CC) $(CFLAGS) -O -c -o $@ $<

%.o : %.S
	$(CC) $(CFLAGS)    -c -o $@ $<

$(BINARY) : $(OBJS)
	$(LD) $(LDFLAGS) -o bootblockother.o $(OBJS)
	$(OBJCOPY) -S -O binary -j .text bootblockother.o $@
	$(OBJDUMP) -S bootblockother.o > entryother.asm

clean :
	rm -f $(OBJS)
	rm -f bootblockother.o entryother.asm entryother
	rm -f *.d


