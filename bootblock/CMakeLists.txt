cmake_minimum_required(VERSION 2.8)

project(bootblock C ASM)

set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER   /usr/bin/i386-jos-elf-gcc)
set(CMAKE_ASM_COMPILER i386-jos-elf-gcc)
set(CMAKE_LINKER "i386-jos-elf-ld")

set(OBJDUMP i386-jos-elf-objdump)
set(OBJCOPY i386-jos-elf-objcopy)

set(CFLAGS "")
set(CFLAGS "${CFLAGS} -fno-builtin")
set(CFLAGS "${CFLAGS} -fno-pic")
set(CFLAGS "${CFLAGS} -m32")
set(CFLAGS "${CFLAGS} -nostdinc")
set(CFLAGS "${CFLAGS} -O")
set(CMAKE_C_FLAGS "${CFLAGS}")

set(AFLAGS "")
set(AFLAGS "${AFLAGS} -fno-builtin -fno-pic -m32 -nostdinc")
set(CMAKE_ASM_FLAGS "${AFLAGS}")

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS) # remove -rdynamic option

set(LDFLAGS "-m elf_i386 -nodefaultlibs -N -e start -Ttext 0x7C00")
set(CMAKE_EXE_LINKER_FLAGS "${LDFLAGS}")
set(CMAKE_C_LINK_EXECUTABLE  "<CMAKE_LINKER> \
<LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>"
)

include_directories(
	${CMAKE_SOURCE_DIR}/include
)

add_executable(bootblock.o bootasm.S bootmain.c)

add_custom_command(
	TARGET bootblock.o
	POST_BUILD
	COMMAND ${OBJDUMP} -S bootblock.o > bootblock.asm
	COMMAND ${OBJCOPY} -S -O binary -j .text bootblock.o bootblock
	COMMAND perl ${CMAKE_SOURCE_DIR}/tools/sign.pl bootblock
)

