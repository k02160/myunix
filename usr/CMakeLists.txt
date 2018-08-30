cmake_minimum_required(VERSION 2.8)

project(usr C ASM)

set(CMAKE_LINKER i386-jos-elf-ld)

set(CFLAGS "")
set(CFLAGS "${CFLAGS} -fno-pic -static")
set(CFLAGS "${CFLAGS} -fno-builtin -fno-strict-aliasing")
set(CFLAGS "${CFLAGS} -Wall -MD -ggdb -fno-omit-frame-pointer")
set(CFLAGS "${CFLAGS} -ffreestanding -fno-common -nostdlib")
set(CFLAGS "${CFLAGS} -gdwarf-2 -m32")
set(CFLAGS "${CFLAGS} -fno-stack-protector")
set(CMAKE_C_FLAGS "${CFLAGS}")

set(AFLAGS "")
set(AFLAGS "${AFLAGS} -gdwarf-2 -Wa,-divide -m32")
set(CMAKE_ASM_FLAGS "${AFLAGS}")

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS) # remove -rdynamic option

set(LDFLAGS "-m elf_i386 -nodefaultlibs -N -e main -Ttext 0")

set(CMAKE_EXE_LINKER_FLAGS "${LDFLAGS}")
set(CMAKE_C_LINK_EXECUTABLE  
	"<CMAKE_LINKER> <LINK_FLAGS> <OBJECTS> -o <TARGET> <LINK_LIBRARIES>"
)

include_directories(
	${CMAKE_SOURCE_DIR}/include
)

set(ULIB_C
	ulib.c
	printf.c
	umalloc.c
)

set(ULIB_S usys.S)

set(PROGS cat echo grep init kill ln ls mkdir rm sh 
 stressfs usertests wc zombie
)

foreach(PROG ${PROGS})
	add_executable(${PROG} ${ULIB_C} ${ULIB_S} ${PROG}.c)
endforeach()
	
add_executable(forktest ulib.c ${ULIB_S} forktest.c)

foreach(PROG ${PROGS} forktest)
	add_custom_command(
		TARGET ${PROG}
		POST_BUILD
		COMMAND ${OBJDUMP} -S ${PROG} > ${PROG}.asm
	)
endforeach()

foreach(PROG ${PROGS} forktest)
	add_custom_command(
		TARGET ${PROG}
		POST_BUILD
		COMMAND ${OBJDUMP} -t ${PROG} | sed '1,/SYMBOL TABLE/d\; s/ .* / /\; /^$$/d' > ${PROG}.sym
	)
endforeach()

add_custom_target(fs ALL
	../tools/mkfs fs.img ${PROGS} forktest
	DEPENDS ${PROGS} forktest
)

