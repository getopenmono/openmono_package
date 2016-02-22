function downloadGcc {
	FILE=$(basename $1)
	
	if [ ! -f $FILE ]; then
		echo "Downloading GCC Embedded Arm..."
		curl -O -L $1
	fi
	
	if [ ! -d $GCC_ARM_DIR_NAME ]; then
		echo "Extracting GCC..."
		tar -xjf $FILE
	fi
	
	if [ ! -d $GCC_ARM_DIR_NAME ]; then
		echo "Error: extracted directory is not named $GCC_ARM_DIR_NAME"
		return 1
	fi
	echo "GCC downloaded and extracted"
}

function copyGcc {
	echo "Copying GCC to dist dir..."
    if [ ! -d $2/$1 ]; then
		mkdir -p "$2"
		cp -r "$1" "$2"
	fi
}

function cloneMonoProg {
	if [ ! -d $MONOPROG_NAME ]; then
		echo "Cloing monoprog from GitHub..."
		git clone $MONOPROG_GIT_URL $MONOPROG_NAME
	else
		echo "Pulling monoprog changes from GitHub..."
		cd $MONOPROG_NAME
		git pull
		cd ..
	fi
}

function compileMonoprog {
	echo "Compiling monoprog..."
	cd $MONOPROG_NAME
	./compile.sh
	cd ..
	echo "Copying to monoprog dist..."
	mkdir -p $2
	cp -r $1 $2
}

function writeConfigurationFile {
	echo "Writing monomake configuration file..."
	echo "#!/bin/bash" > $1
	DATE=`date`
	echo "# This is the configuration file for monomake, auto generated $DATE" >> $1
	echo "" >> $1
	echo "TEMPLATE_DIR=$(basename $TEMPLATE_DIR)" >> $1
	echo "MAKEFILE_DIR=\$MONO_PATH" >> $1
	echo "MONOPROG_DIR=\$MONO_PATH/$MONOPROG_NAME/$(basename $MONOPROG_MAC_EXECUTABLE)/$(dirname $MONOPROG_MAC_EXECUTABLE_BINARY)" >> $1
}

function makeConfigurationFile {
	echo "Writing $1..."
	echo "ARCH=\"\$(MONO_PATH)/$GCC_ARM_DIR_NAME/bin/arm-none-eabi-\"" > $1
	echo "INCLUDE_DIR=\$(MONO_PATH)/mono/include/mbed/target_cypress" >> $1
	echo "BUILD_DIR=build" >> $1
	echo "MONO_FRAMEWORK_PATH=\$(MONO_PATH)/mono" >> $1
	echo "MONOPROG=\$(MONO_PATH)/monoprog/$2" >> $1
}