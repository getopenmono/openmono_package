#!/bin/bash

VERSION=1.0
BINDIR='bin'
FRAMEWORK_DIR='mono'
TEMPLATE_DIR='template'
GCC_ARM_DIR_NAME="gcc-arm-none-eabi-5_2-2015q4"
GCC_ARM_MAC_URL="https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-mac.tar.bz2"
GCC_ARM_DEB_URL="https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2"

MAKEFILES="../../mono_default_main.cpp ../../mono.mk ../../Build.mk"

MONOPROG_GIT_URL="https://github.com/getopenmono/monoprog.git"
MONOPROG_REVISION="HEAD"
MONOPROG_NAME="monoprog"
MONOPROG_MAC_EXECUTABLE="bin/monoprog.app"
MONOPROG_MAC_EXECUTABLE_BINARY="Contents/MacOS/monoprog"
MONOPROG_DEB_EXECUTABLE="bin/monoprog"