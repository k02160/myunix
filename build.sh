#!/bin/sh
ROOT=$(cd $(dirname ${BASH_SOURCE:-$0}) && pwd)

BUILDDIR=_build

TARGET=i386-jos-elf

CONFIG_OPTIONS="-DCMAKE_INSTALL_PREFIX=/usr"
#CONFIG_OPTIONS="${CONFIG_OPTIONS} -DCMAKE_INSTALL_LIBDIR=/usr/lib64"
#CONFIG_OPTIONS="${CONFIG_OPTIONS} -DCMAKE_BUILD_TYPE=Release"
#CONFIG_OPTIONS="${CONFIG_OPTIONS} -DCMAKE_BUILD_TYPE=Debug"
CONFIG_OPTIONS="${CONFIG_OPTIONS} -DCMAKE_LINKER=i386-jos-elf-ld"

function find_cmake()
{
	declare -a CMDS
	CMDS=("cmake3" "cmake")
	CMAKE=""

	for cmd in "${CMDS[@]}"; do
		CMAKE=`which $cmd`
		if [ ! -z "$CMAKE" ] ; then
			break
		fi
	done
}

function configure()
{
	pushd ${ROOT}
	rm -rf ${BUILDDIR}
	mkdir -p ${BUILDDIR}
	pushd ${BUILDDIR}
	$CMAKE -G "Unix Makefiles" ${CONFIG_OPTIONS} ../
	popd
	popd
		
	#	-DCMAKE_TOOLCHAIN_FILE=./${TARGET}.cmake

}

function build()
{
	pushd ${ROOT}
	pushd ${BUILDDIR}
	make VERBOSE=1
	popd
	popd
}

function clean()
{
	pushd ${ROOT}
	pushd ${BUILDDIR}
	make clean
	popd
	popd
}

function maintainer_clean()
{
	pushd ${ROOT}
	pushd ${BUILDDIR}
	find ./ -type d -name CMakeFiles -exec rm -rf {} \;
	find ./ -type f -name Makefile -exec rm -f {} \;
	find ./ -type f -name cmake_install.cmake -exec rm -f {} \;
	popd
	popd
}

function _test()
{
	pushd ${ROOT}
	pushd ${BUILDDIR}
	make qemu
	popd
	popd
}

function main()
{
	echo main
}

function usage()
{
	echo "usage : $0 command <args>"
}

declare -a ARGV
declare -A OPTIONS

VERSION=1.0.0
PROGRAM=$(basename $0)

find_cmake

echo "DEBUG : cmake is $CMAKE"

for OPT in "$@"
do
	case "$OPT" in
		'-h' | '--help' )
			usage
			exit 1
			;;
		'-v' | '--version' )
			echo $VERSION
			exit 1
			;;
		'-i' | '--input' )
			if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
				echo "$PROGRAM: option requires an argument -- $1" 1>&2
				exit 1
			fi
			OPTIONS["input"]="$2"
			shift 2
			;;
		'-o' | '--output' )
			if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
				echo "$PROGRAM: option requires an argument -- $1" 1>&2
				exit 1
			fi
			OPTIONS["output"]="$2"
			shift 2
			;;
        *)
			if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
            	ARGV=("${ARGV[@]}" "$1")
				shift 1
			fi
			;;
    esac
done

if [ ${#ARGV[@]} = 0 ] ; then
	usage
	exit 1
fi


COMMAND=${ARGV[0]}
ARGV=("${ARGV[@]:1}")

echo "COMMAND : '$COMMAND'"


# オプションを表示
echo "OPTIONS"
for i in ${!OPTIONS[@]}; do
	echo "  ${i} => '${OPTIONS[$i]}'"
done

# 引数を表示
for arg in "${ARGV[@]}"; do
	echo "  ARG : '$arg'"
done

if [[ "$COMMAND" == "build" ]]; then
	build
elif [[ "$COMMAND" == "config" ]]; then
	configure
elif [[ "$COMMAND" == "clean" ]]; then
	clean
elif [[ "$COMMAND" == "test" ]]; then
	_test
elif [[ "$COMMAND" == "help" ]]; then
	usage
else
	echo "ERROR : unknown command, '$COMMAND'"
	exit 2
fi
