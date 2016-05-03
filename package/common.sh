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

function downloadUrl
{
	echo "Downloading $1..."
	curl -O -L $2
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
		git checkout -- .
		git pull
		cd ..
	fi
}

function cloneMonoFramework {
	if [ ! -d $MONOFRMWRK_NAME ]; then
		echo "Cloing mono framework from GitHub..."
		git clone $MONOFRMWRK_GIT_URL $MONOFRMWRK_NAME
	else
		echo "Pulling mono framework changes from GitHub..."
		cd $MONOFRMWRK_NAME
		git checkout -- .
		git pull
		cd ..
	fi
}

function cloneMbedLibrary {
	if [ ! -d $MBED_LIB_NAME ]; then
		echo "Cloing mbed Library from GitHub..."
		git clone $MBED_LIB_GIT_URL $MBED_LIB_NAME
	else
		echo "Pulling mbed Library changes from GitHub..."
		cd $MBED_LIB_NAME
		git checkout -- .
		git pull
		cd ..
	fi
}

function cloneMbedCompLibrary {
	if [ ! -d $MBEDCOMP_LIB_NAME ]; then
		echo "Cloing mono mbed Library from GitHub..."
		git clone $MBEDCOMP_LIB_GIT_URL $MBEDCOMP_LIB_NAME
	else
		echo "Pulling mono mbed Library changes from GitHub..."
		cd $MBEDCOMP_LIB_NAME
		git checkout -- .
		git pull
		cd ..
	fi
}

function buildMbedCompLibrary {
	echo "Compiling mono mbed Library..."
	cd $MBEDCOMP_LIB_NAME
	make clean
	make mbed
	cd ..
}

function clonePsoc5Library {
	if [ ! -d $PSOC5_LIB_NAME ]; then
		echo "Cloing mono PSoC5 Library from GitHub..."
		git clone $PSOC5_LIB_GIT_URL $PSOC5_LIB_NAME
	else
		echo "Pulling mono PSoC5 Library changes from GitHub..."
		cd $PSOC5_LIB_NAME
		git checkout -- .
		git pull
		cd ..
	fi
}

function buildPsoc5Library {
	echo "Compiling mono PSoC5 Library..."
	cd $PSOC5_LIB_NAME
	make clean
	make library
	cd ..
}

function buildMonoFramework {
	echo "Compiling mono framework..."
	cd $MONOFRMWRK_NAME
	make clean
	make release
	cd ..
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

function compileMonoprogWin {
	echo "Compiling monoprog..."
	cd $MONOPROG_NAME
	./configuration.bat
	qmake -tp vc monoprog.pro
	MSBuild.exe monoprog.vcxproj //p:Configuration=Release //p:Platform=x64
	cd ..
	echo "Copying to monoprog dist..."
	mkdir -p $2
	cp -r $1 $2
	windeployqt.exe $2/monoprog.exe --release --no-translations --dir $2
}

function writeConfigurationFile {
	echo "Writing monomake configuration file..."
	echo "#!/bin/bash" > $1
	DATE=`date`
	echo "# This is the configuration file for monomake, autogenerated $DATE" >> $1
	echo "" >> $1
	echo "TEMPLATE_DIR=$(basename $TEMPLATE_DIR)" >> $1
	echo "MAKEFILE_DIR=\$MONO_PATH" >> $1
	echo "MONOPROG_DIR=\$MONO_PATH/$MONOPROG_NAME/$2" >> $1
	if [ "$3" = "" ]; then
		echo "Using default Bash monomake tool, in configuration."
		echo "MONOMAKE=$MONOMAKE_BASH" >> $1
	else
		echo "MONOMAKE=$3" >> $1
	fi
}

function writePSConfigurationFile {
	echo "Writing monomake configuration file..."
	echo "#Requires -Version 2" > $1
	DATE=`date`
	echo "# This is the configuration file for monomake, autogenerated $DATE" >> $1
	echo "" >> $1
	echo "\$TEMPLATE_DIR=\"$(basename $TEMPLATE_DIR)\"" >> $1
	echo "\$MAKEFILE_DIR=\"\$ScriptDir\"" >> $1
	echo "\$MONOPROG_DIR=\"\$ScriptDir/$MONOPROG_NAME/$2\"" >> $1
	if [ "$3" = "" ]; then
		echo "Using default Bash monomake tool, in configuration."
		echo "\$MONOMAKE=\"$MONOMAKE_BASH\"" >> $1
	else
		echo "\$MONOMAKE=\"$3\"" >> $1
	fi
}

function makeConfigurationFile {
	echo "Writing $1..."
	echo "ARCH=\"\$(MONO_PATH)/$GCC_ARM_DIR_NAME/bin/arm-none-eabi-\"" > $1
	echo "INCLUDE_DIR=\$(MONO_PATH)/mono/include/mbed/target_cypress" >> $1
	echo "BUILD_DIR=build" >> $1
	echo "MONO_FRAMEWORK_PATH=\$(MONO_PATH)/mono" >> $1
	echo "MONOPROG=\$(MONO_PATH)/monoprog/$2" >> $1
	if [ "$3" = "" ]; then
		echo "Using default Bash monomake tool, in Makefile configuration."
		echo "MONOMAKE=$MONOMAKE_BASH" >> $1
	else
		echo "MONOMAKE=$3" >> $1
	fi
	
}

function copyFiles {
	echo "Copying $1 to dist..."
	cp -r $2 $3
}