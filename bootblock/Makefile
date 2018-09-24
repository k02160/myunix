include ../mk/target.mk

CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 \
		 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer \
		 -fno-stack-protector -fno-pic  \
		 -I../include

LDFLAGS = -m elf_i386 -N -e start -Ttext 0x7C00

ASMS = bootasm.S
SRCS = bootmain.c
OBJS = $(ASMS:.S=.o) $(SRCS:.c=.o)

BINARY = bootblock

all : objs binary

objs : $(OBJS)

binary : $(BINARY)

%.o : %.c
	$(CC) $(CFLAGS) -O -nostdinc -c -o $@ $<

%.o : %.S
	$(CC) $(CFLAGS)    -nostdinc -c -o $@ $<

$(BINARY) :
	$(LD) $(LDFLAGS) -o bootblock.o $(OBJS)
	$(OBJDUMP) -S bootblock.o > bootblock.asm
	$(OBJCOPY) -S -O binary -j .text bootblock.o bootblock
	perl ../tools/sign.pl bootblock

clean :
	rm -f $(OBJS)
	rm -f bootblock.o bootblock.asm bootblock

