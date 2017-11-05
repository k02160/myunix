cmake_minimum_required(VERSION 2.8)

get_property(LIB64 GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS)

if ("${LIB64}" STREQUAL "TRUE")
	set(LIBSUFFIX 64)
else()
	set(LIBSUFFIX "")
endif()

add_subdirectory(tools    ${CMAKE_CURRENT_BINARY_DIR}/tools)
add_subdirectory(initcode ${CMAKE_CURRENT_BINARY_DIR}/initcode)
add_subdirectory(bootblock ${CMAKE_CURRENT_BINARY_DIR}/bootblock)
add_subdirectory(bootblockother ${CMAKE_CURRENT_BINARY_DIR}/bootblockother)
add_subdirectory(kernel ${CMAKE_CURRENT_BINARY_DIR}/kernel)
add_subdirectory(usr ${CMAKE_CURRENT_BINARY_DIR}/usr)
add_subdirectory(tests ${CMAKE_CURRENT_BINARY_DIR}/tests)

set(CMAKE_VERBOSE_MAKEFILE 1)
