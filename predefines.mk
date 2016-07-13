ARCH="$(MONO_PATH)/gcc-arm-none-eabi-5_2-2015q4/bin/arm-none-eabi-"
INCLUDE_DIR=$(MONO_PATH)/mono/include/mbed/target_cypress
BUILD_DIR=build
MONO_FRAMEWORK_PATH=$(MONO_PATH)/mono
MONOPROG=monomake monoprog
SH_MONOMAKE=monomake

OPTIMIZATION = -O0


OBJECTS =		$(patsubst %.c,%.o,$(wildcard *.c)) \
				$(patsubst %.cpp,%.o,$(wildcard *.cpp))

TARGET_HEADERS=	$(wildcard ./*.h) \
				$(wildcard ./*.hpp)