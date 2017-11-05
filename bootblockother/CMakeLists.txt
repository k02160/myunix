cmake_minimum_required(VERSION 2.8)

project(bootblockother C ASM)

set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER i386-jos-elf-gcc)
set(CMAKE_ASM_COMPILER i386-jos-elf-gcc)
set(CMAKE_LINKER "i386-jos-elf-ld")
#set(CMAKE_EXE_LINKER "i386-jos-elf-ld")

set(CFLAGS "")
set(CFLAGS "${CFLAGS} -fno-builtin")
set(CFLAGS "${CFLAGS} -fno-pic")
set(CFLAGS "${CFLAGS} -m32")
set(CFLAGS "${CFLAGS} -nostdinc")
set(CMAKE_C_FLAGS "${CFLAGS}")

set(AFLAGS "")
set(AFLAGS "${AFLAGS} -fno-pic -static -fno-builtin ")
set(AFLAGS "${AFLAGS} -fno-strict-aliasing -Wall -MD -ggdb")
set(AFLAGS "${AFLAGS} -fno-omit-frame-pointer -ffreestanding")
set(AFLAGS "${AFLAGS} -fno-common -nostdlib")
set(AFLAGS "${AFLAGS} -gdwarf-2 -m32 -nostdinc")
set(CMAKE_ASM_FLAGS "${AFLAGS}")

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS) # remove -rdynamic option

set(LDFLAGS "-m elf_i386 -nodefaultlibs -N -e start -Ttext 0x7000")
set(CMAKE_EXE_LINKER_FLAGS "${LDFLAGS}")

#
# bootblockotherはassemblerのファイルのみなので、
# CMAKE_C_LINK_EXECUTABLEではなく
# CMAKE_ASM_LINK_EXECUTABLEを指定する。
# CMAKE_C_LINK_EXECUTABLEを使用すると、
# linkerがldではなくgccになり、意図した動作にならない。
#
set(CMAKE_ASM_LINK_EXECUTABLE  "<CMAKE_LINKER> \
<LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>"
)
include_directories(
	${CMAKE_SOURCE_DIR}/include
)

add_executable(bootblockother.o entryother.S)

add_custom_command(
  TARGET bootblockother.o
  POST_BUILD
  COMMAND i386-jos-elf-objcopy -S -O binary -j .text 
  	${PROJECT_BINARY_DIR}/bootblockother.o
	${PROJECT_BINARY_DIR}/entryother
  COMMENT "generate binary data"
  VERBATIM
)

add_custom_command(
	TARGET bootblockother.o
	POST_BUILD
	COMMAND i386-jos-elf-objdump -S bootblockother.o > entryother.asm
	COMMENT "generate asm file"
	VERBATIM
)

