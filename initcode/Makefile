#TARGET = i386-jos-elf
#CC = $(TARGET)-gcc
#LD = $(TARGET)-ld
#OBJDUMP = $(TARGET)-objdump
#OBJCOPY = $(TARGET)-objcopy

AFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing \
	-Wall -MD -ggdb -fno-omit-frame-pointer -ffreestanding -fno-common \
	-nostdlib -I../include -gdwarf-2 -m32 -O0 -fno-stack-protector \
	-nostdinc 

LDFLAGS = -m elf_i386 -nodefaultlibs -N -e start -Ttext 0

ASMS = initcode.S
SRCS = 
OBJS = $(SRCS:.c=.o) $(ASMS:.S=.o)

BINARY = initcode

all : objs binary

objs : $(OBJS)

binary : $(BINARY)

%.o : %.S
	$(CC) $(AFLAGS)    -c -o $@ $<

$(BINARY) :
	$(LD) $(LDFLAGS) -o initcode.out $(OBJS)
	$(OBJCOPY) -S -O binary initcode.out initcode
	$(OBJDUMP) -S initcode.o > initcode.asm

clean :
	rm -f $(OBJS)
	rm -f initcode.out initcode.asm initcode
	rm -f *.d

