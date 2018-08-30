cmake_minimum_required(VERSION 2.8)

project(kernel C ASM)

set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_C_COMPILER   i386-jos-elf-gcc)
set(CMAKE_ASM_COMPILER i386-jos-elf-gcc)
set(CMAKE_LINKER "i386-jos-elf-ld")

set(CFLAGS "")
set(CFLAGS "${CFLAGS} -fno-pic -static")
set(CFLAGS "${CFLAGS} -fno-builtin -fno-strict-aliasing")
set(CFLAGS "${CFLAGS} -Wall -MD -ggdb -fno-omit-frame-pointer -m32 -O0")
set(CFLAGS "${CFLAGS} -fno-stack-protector")
set(CMAKE_C_FLAGS "${CFLAGS}")

set(AFLAGS "")
set(AFLAGS "${AFLAGS} -gdwarf-2 -Wa,-divide -m32")
set(CMAKE_ASM_FLAGS "${AFLAGS}")

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS) # remove -rdynamic option

set(LDFLAGS "-m elf_i386 -nodefaultlibs -T ${CMAKE_SOURCE_DIR}/kernel/kernel.ld")

set(CMAKE_EXE_LINKER_FLAGS "${LDFLAGS}")
set(CMAKE_C_LINK_EXECUTABLE  "<CMAKE_LINKER> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES> -b binary ../initcode/initcode ../bootblockother/entryother"
)

include_directories(
	${CMAKE_SOURCE_DIR}/include
)

set(KERNEL_ASMS
	entry.S
	vectors.S
	swtch.S
	trapasm.S
)

add_executable(kernel.elf
${KERNEL_ASMS} bio.c console.c exec.c file.c fs.c ide.c ioapic.c kalloc.c
kbd.c lapic.c log.c main.c mp.c acpi.c picirq.c pipe.c proc.c
spinlock.c string.c syscall.c sysfile.c sysproc.c timer.c
trap.c uart.c vm.c)

add_custom_command(
  OUTPUT vectors.S
  COMMAND perl ${CMAKE_SOURCE_DIR}/tools/vectors.pl > vectors.S
  COMMENT "generate vectors.S"
  VERBATIM
)

add_custom_command(
	TARGET kernel.elf
	POST_BUILD
	COMMAND i386-jos-elf-objdump -S kernel.elf > kernel.asm
	COMMENT "generate kernel.asm"
	VERBATIM
)

# escape ';', '$' in COMMAND
add_custom_command(
	TARGET kernel.elf
	POST_BUILD
	COMMAND i386-jos-elf-objdump -t kernel.elf | sed '1,/SYMBOL TABLE/d\; s/ .* / /\; /^$$/d' > kernel.sym
)

