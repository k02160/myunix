TARGET = i386-jos-elf

ifneq ($(TARGET),)
CC = $(TARGET)-gcc
LD = $(TARGET)-ld
AR = $(TARGET)-ar
OBJDUMP = $(TARGET)-objdump
OBJCOPY = $(TARGET)-objcopy
else
CC = gcc
LD = ld
AR = ar
OBJDUMP = objdump
OBJCOPY = objcopy
endif

