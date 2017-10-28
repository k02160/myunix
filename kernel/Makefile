TARGET = i386-jos-elf
CC = $(TARGET)-gcc
LD = $(TARGET)-ld
OBJDUMP = $(TARGET)-objdump
OBJCOPY = $(TARGET)-objcopy

CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing \
	-Wall -MD -ggdb -fno-omit-frame-pointer -ffreestanding \
	-fno-common -nostdlib -I../include -gdwarf-2 -m32 -O0 \
	-fno-stack-protector

SRCS = bio.c console.c exec.c file.c fs.c \
	ide.c ioapic.c kalloc.c kbd.c lapic.c log.c \
	main.c mp.c acpi.c picirq.c pipe.c proc.c spinlock.c \
	string.c syscall.c sysfile.c sysproc.c timer.c \
	trap.c uart.c vm.c

VECTORS_S = vectors.S

ASMS = entry.S swtch.S trapasm.S $(VECTORS_S)

AFLAGS = -gdwarf-2 -Wa,-divide -I../include -m32

LDFLAGS = -m elf_i386 -nodefaultlibs -T kernel.ld

OBJS = $(ASMS:.S=.o) $(SRCS:.c=.o)

KERNEL_ELF = kernel.elf
KERNEL_ASM = $(KERNEL_ELF:.elf=.asm)
KERNEL_SYM = $(KERNEL_ELF:.elf=.sym)

all : vectors objs kernel

vectors : $(VECTORS_S)

$(VECTORS_S) : ../tools/vectors.pl
	perl $< > $@

kernel : $(KERNEL_ELF) $(KERNEL_ASM) $(KERNEL_SYM)

objs : $(OBJS)

$(KERNEL_SYM) : $(KERNEL_ELF)
	$(OBJDUMP) -t $< | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $@

$(KERNEL_ASM) : $(KERNEL_ELF)
	$(OBJDUMP) -S $< > $@

$(KERNEL_ELF) : $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) \
		-b binary ../initcode/initcode ../bootblockother/entryother

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o : %.S
	$(CC) $(AFLAGS) -c -o $@ $<

clean :
	rm -f $(VECTORS_S) $(OBJS) $(KERNEL_ELF)
	rm -f *.d

.PHONY : \
	all clean test \
		vectors objs

