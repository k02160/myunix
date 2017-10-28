TARGET = i386-jos-elf
CC = $(TARGET)-gcc
LD = $(TARGET)-ld
OBJDUMP = $(TARGET)-objdump
OBJCOPY = $(TARGET)-objcopy

CFLAGS = -fno-builtin -fno-pic -m32 -nostdinc \
 -I../include

LDFLAGS = -m elf_i386 -nodefaultlibs -N -e start -Ttext 0x7C00

ASMS = bootasm.S
SRCS = bootmain.c
OBJS = $(ASMS:.S=.o) $(SRCS:.c=.o)

BINARY = bootblock

all : objs binary

objs : $(OBJS)

binary : $(BINARY)

%.o : %.c
	$(CC) $(CFLAGS) -O -c -o $@ $<

%.o : %.S
	$(CC) $(CFLAGS)    -c -o $@ $<

$(BINARY) :
	$(LD) $(LDFLAGS) -o bootblock.o $(OBJS)
	$(OBJDUMP) -S bootblock.o > bootblock.asm
	$(OBJCOPY) -S -O binary -j .text bootblock.o bootblock
	perl ../tools/sign.pl bootblock

clean :
	rm -f $(OBJS)
	rm -f bootblock.o bootblock.asm bootblock

