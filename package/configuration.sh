#!/bin/bash

VERSION=1.0
BINDIR='bin'
FRAMEWORK_DIR='mono'
TEMPLATE_DIR='template'
GCC_ARM_DIR_NAME="gcc-arm-none-eabi-5_2-2015q4"
WIN_GCC_ARM_DIR_NAME="gcc-arm-none-eabi-5_2-2015q4-20151219-win32"
GCC_ARM_MAC_URL="https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-mac.tar.bz2"
GCC_ARM_DEB_URL="https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2"

WIN_MINGW_MAKE_PATH="http://downloads.sourceforge.net/project/mingw/MSYS/Base/make/make-3.81-3/make-3.81-3-msys-1.0.13-bin.tar.lzma?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fmingw%2Ffiles%2FMSYS%2FBase%2Fmake%2Fmake-3.81-3%2F&ts=1456831814&use_mirror=heanet"
MSYS_MAKE_DIR="bin"

MAKEFILES="../../mono_default_main.cpp ../../mono.mk ../../Build.mk ../../reboot.py"
MAKEFILES_WIN="$MAKEFILES reset.exe"

MONOPROG_GIT_URL="https://github.com/getopenmono/monoprog.git"
MONOPROG_REVISION="HEAD"
MONOPROG_NAME="monoprog"
MONOPROG_MAC_EXECUTABLE="bin/monoprog.app"
MONOPROG_MAC_EXECUTABLE_BINARY="Contents/MacOS/monoprog"
MONOPROG_DEB_EXECUTABLE="bin/monoprog"
MONOPROG_WIN_EXECUTABLE="release/monoprog.exe"

PSOC5_LIB_GIT_URL="https://github.com/getopenmono/mono_psoc5_library.git"
PSOC5_LIB_NAME="mono_psoc5_library"

MBEDCOMP_LIB_GIT_URL="https://github.com/getopenmono/mbedComp.git"
MBEDCOMP_LIB_NAME="mbedcomp"

MBED_LIB_GIT_URL="https://github.com/getopenmono/mbed.git"
MBED_LIB_NAME="mbed"

MONOFRMWRK_GIT_URL="https://github.com/getopenmono/mono_framework.git"
MONOFRMWRK_REVISION="HEAD"
MONOFRMWRK_NAME="mono_framework"