cmake_minimum_required(VERSION 2.8)

project(tests)

set(CMAKE_SYSTEM_NAME Generic)

set(IMAGE xv6.img)
set(BOOTBLOCK ../bootblock/bootblock)
set(KERNEL ../kernel/kernel.elf)
set(FS ../usr/fs.img)

set(QEMU qemu-system-i386)

add_custom_target(image ALL
	/usr/bin/rm -f ${IMAGE}
	COMMAND dd if=/dev/zero of=${IMAGE} count=10000
	COMMAND dd if=${BOOTBLOCK} of=${IMAGE} conv=notrunc
	COMMAND dd if=${KERNEL}    of=${IMAGE} seek=1 conv=notrunc
)

add_custom_target(qemu
	${QEMU} -serial mon:stdio -net none -hdb ${FS} ${IMAGE} -smp 2 -m 512
)


