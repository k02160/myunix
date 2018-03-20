cmake_minimum_required(VERSION 2.8)

project(initcode C ASM)

set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER   /usr/bin/i386-jos-elf-gcc)
set(CMAKE_ASM_COMPILER i386-jos-elf-gcc)
set(CMAKE_LINKER "i386-jos-elf-ld")
set(OBJCOPY i386-jos-elf-objcopy)
set(OBJDUMP i386-jos-elf-objdump)

set(AFLAGS "")
set(AFLAGS "${AFLAGS} -fno-pic -static -fno-builtin")
set(AFLAGS "${AFLAGS} -fno-strict-aliasing -Wall -MD -ggdb")
set(AFLAGS "${AFLAGS} -fno-omit-frame-pointer")
set(AFLAGS "${AFLAGS} -ffreestanding")
set(AFLAGS "${AFLAGS} -fno-common")
set(AFLAGS "${AFLAGS} -nostdlib")
set(AFLAGS "${AFLAGS} -gdwarf-2 -m32 -O0 -fno-stack-protector -nostdinc")
set(CMAKE_ASM_FLAGS "${AFLAGS}")

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS) # remove -rdynamic option

set(LDFLAGS "-m elf_i386 -nodefaultlibs -N -e start -Ttext 0")
set(CMAKE_EXE_LINKER_FLAGS "${LDFLAGS}")
set(CMAKE_ASM_LINK_EXECUTABLE  "<CMAKE_LINKER> \
<LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>"
)

include_directories(
	${CMAKE_SOURCE_DIR}/include
)

add_executable(initcode.out initcode.S)

add_custom_command(
	TARGET initcode.out
	POST_BUILD
	COMMAND ${OBJCOPY} -S -O binary initcode.out initcode
)

add_custom_command(
	TARGET initcode.out
	POST_BUILD
	COMMAND ${OBJDUMP} -S ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/initcode.out.dir/initcode.S.o > initcode.asm
)

