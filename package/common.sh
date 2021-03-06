function confirmBuild {
    echo "Will build package with version $VERSION"
    read -p "Are you sure? (y/n)" -n 1 -r
    echo
    if ! [[ $REPLY =~ ^[yY]$ ]]; then
        echo "Aborting!"
        exit
    fi
}

function buildLittleHelper {
	if ! hash npm; then
		echo "NodeJs NPM not found in path!"
	fi

	echo "Copy result: $1 --> $2"

	if [[ -d "little-helper/.git" ]]; then
		echo "Resetting source repo and pulling Git changes..."
		cd "little-helper"
		git checkout -- .
		git pull
		cd ..
	else
		git clone $LITTLE_HELPER_GIT "little-helper"
	fi

	echo "Building little helper..."
	cd little-helper && \
	echo "Setting version to $VERSION..." && node ../../replaceVersion.js "package.json" "$VERSION" && \
	npm install --unsafe-perm && \
	npm run dist && cp $1 $2 && cp build/elf.ico $2 && cd ..

	SUCCESS=$?

	if ! [ $SUCCESS ]; then
		echo "failed to build little helper!"
		exit 1
	fi
}

function downloadGcc {
	FILE=$(basename $1)

	if [[ ! -f $FILE && ! -d $GCC_ARM_DIR_NAME ]]; then
		echo "Downloading GCC Embedded Arm..."
		curl -O -L $1
	else
		echo "Skipping GCC download"
	fi

	if [ ! -d $GCC_ARM_DIR_NAME ]; then
		extension="${FILE##*.}"
		echo "Extracting GCC... ($extension)"

		if [[ $extension == "zip" ]]; then
			unzip -qn $FILE -d $GCC_ARM_DIR_NAME
		else
			tar -xjf $FILE
		fi
	else
		echo "GCC is already extracted"
	fi

	if [ ! -d $GCC_ARM_DIR_NAME ]; then
		echo "Error: extracted directory is not named $GCC_ARM_DIR_NAME"
		exit 1
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
		echo "Cloning monoprog from GitHub..."
		git clone $MONOPROG_GIT_URL
	else
		echo "Pulling monoprog changes from GitHub..."
		CUR_DIR=`pwd`
		cd $MONOPROG_NAME
		git checkout -- .
		git pull
		cd $CUR_DIR
	fi
}

function cloneMonoFramework {
	BRANCHNAME="production"
	if [[ $FRM_BRANCH != "" ]]; then BRANCHNAME=$FRM_BRANCH; fi
	if [ ! -d $MONOFRMWRK_NAME ]; then
		echo "Cloning mono framework ($BRANCHNAME) from GitHub..."
		git clone -b $BRANCHNAME $MONOFRMWRK_GIT_URL $MONOFRMWRK_NAME || exit 1
	else
		echo "Pulling mono framework changes from GitHub..."
		cd $MONOFRMWRK_NAME && \
		echo `pwd` && \
		git status && \
		git reset --hard && \
		git clean -fXd && \
		git checkout $BRANCHNAME && \
		git pull && \
		cd .. || exit 1
	fi
}

function cloneMbedLibrary {
	if [ ! -d $MBED_LIB_NAME ]; then
		echo "Cloning mbed Library from GitHub..."
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
	COMMIT=`git show --oneline -s`
	echo "Building commit: $COMMIT"
	if [[ $1 == "win" ]]; then
		bash resources/setup_icons.sh resources/icons.mk.tmp "../../$DIST_DEST_DIR" win
	else
		bash resources/setup_icons.sh resources/icons.mk.tmp "../../$DIST_DEST_DIR"
	fi
	make clean
	SUCCESS=$?
    if [ ! $SUCCESS ]; then
    	echo "ERROR: Build was unsuccessful. Aborting!"
        exit 1
    fi

	make release
    SUCCESS=$?
    if [ ! $SUCCESS ]; then
    	echo "ERROR: Build was unsuccessful. Aborting!"
        exit 1
    fi
	cd ..
}

function compileMonoprog {
	echo "Compiling monoprog..."
	CUR_DIR=`pwd`
	cd $MONOPROG_NAME
	COMMIT=`git show --oneline -s`
	echo "Building commit: $COMMIT"
	./compile.sh
	cd $CUR_DIR
	echo "Copying to monoprog dist... ($1 --> $2)"
	mkdir -p $2
	cp -r $1 $2
}

function compileMonoprogMac {
	echo "Compiling monoprog (macOS)..."
	CUR_DIR=`pwd`
	cd $MONOPROG_NAME
	COMMIT=`git show --oneline -s`
	echo "Building commit: $COMMIT"
	qmake monoprog.pro
	make
	if [[ ! $? ]]; then
		echo "Failed to compile monoprog!"
		exit 1
	fi
	cd $CUR_DIR
	echo "Copying to monoprog dist... ($1 --> $2)"
	mkdir -p $2
	cp -r $1 $2
}

function compileMonoprogWin {
	echo "Compiling monoprog..."
	CUR_DIR=`pwd`
	cd $MONOPROG_NAME
	COMMIT=`git show --oneline -s`
	echo "Building commit: $COMMIT"
	./configuration.bat
	qmake -tp vc monoprog.pro
	if ! [ $? ]; then
		exit 1
	fi
	MSBuild.exe monoprog.vcxproj //p:Configuration=Release //p:Platform=x$ARCH
	if ! [ $? ]; then
		exit 1
	fi

	cd $CUR_DIR
	echo "Copying to monoprog dist..."
	mkdir -p $2
	cp -r $1 $2
	windeployqt.exe $2/monoprog.exe --release --no-translations --dir $2

	if ! [ $? ]; then
		exit 1
	fi
}

function writeConfigurationFile {
	echo "Writing monomake configuration file..."
	echo "#!/bin/bash" > $1
	DATE=`date`
	echo "# This is the configuration file for monomake, autogenerated $DATE" >> $1
	echo "" >> $1
	echo "TEMPLATE_DIR=$(basename $TEMPLATE_DIR)" >> $1
	echo "MAKEFILE_DIR=\$MONO_PATH" >> $1
	echo "MONOPROG_DIR=\$MONO_PATH/monoprog/$2" >> $1
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
	echo "# This is an auto generated file for OpenMono SDK $VERSION" > $1
	echo "" >> $1

	if [ "$4" = "" ]; then
		echo "ARCH=\"\$(MONO_PATH)/$GCC_ARM_DIR_NAME/bin/arm-none-eabi-\"" >> $1
	else
		echo "Writing custom Makefile ARCH variable: $4"
		echo "ARCH=\"$4\"" >> $1
	fi

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
	cat ../../predefines_statics.mk >> $1
}

function copyFiles {
	echo "Copying $1 to dist... ($2 --> $3)"
	cp -r $2 $3
}

function modifyMakefile {
    IN_PATH=`hash $2gcc`
    EXISTS=$?
    if [ ! $EXISTS ]; then
        echo "ERROR: No GCC executable on $2!"
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "Using default GCC ARCH value: \"../$GCC_ARM_DIR_NAME/bin/arm-none-eabi-\""

        if ! [ -f "$1/../$GCC_ARM_DIR_NAME/bin/arm-none-eabi-gcc" ]; then
            echo "ERROR: No GCC compiler found at: $1/../$GCC_ARM_DIR_NAME/bin/arm-none-eabi-!"
            exit 1
        fi

        MK_ARCH="ARCH=\"../$GCC_ARM_DIR_NAME/bin/arm-none-eabi-\""
    else
        MK_ARCH="ARCH=$2"
    fi

    echo "replacing GCC file path in makefile to: $MK_ARCH"
    sed -i.bak "s#ARCH=\".*\"#$MK_ARCH#g" $1/Makefile
    if [ -z "$2" ]; then
        MK_ARCH="ARCH=\"../../../$GCC_ARM_DIR_NAME/bin/arm-none-eabi-\""

        if ! [ -f "$1/src/cypress/../../../$GCC_ARM_DIR_NAME/bin/arm-none-eabi-gcc" ]; then
            echo "ERROR: No compiler found at: $1/src/cypress/../../../$GCC_ARM_DIR_NAME/bin/arm-none-eabi-"
            exit 1
        fi
    elif [[ $2 =~ ^\"?[\.\/].+$ ]]; then
        MK_ARCH="ARCH=\"../../\"$2"
    else
        echo "GCC is in path!"
    fi

    echo "   - and recursive harmful makefiles to: $MK_ARCH"

    sed -i.bak "s#ARCH=\".*\"#$MK_ARCH#g" $1/src/cypress/Makefile
    sed -i.bak "s#ARCH=\".*\"#$MK_ARCH#g" $1/src/mbedcomp/Makefile

	MONO_FRAMEWORK_PATH=../$MONOFRMWRK_NAME
	echo "replacing MONO_FRAMEWORK_PATH dir: $MONO_FRAMEWORK_PATH"
	sed -i.bak "s#MONO_FRAMEWORK_PATH=.*#MONO_FRAMEWORK_PATH=$MONO_FRAMEWORK_PATH#g" $1/Makefile

	PACKAGE_TARGET=../$DIST_DEST_DIR
	echo "replacing RELEASE_DIR dir: $PACKAGE_TARGET"
	sed -i.bak "s#RELEASE_DIR=.*#RELEASE_DIR=$PACKAGE_TARGET#g" $1/Makefile

}

function thinGcc {
	echo "Thinning GCC: docs"
	deleteSilent ./$1/share/doc

	echo "Thinning GCC: samples"
	deleteSilent ./$1/share/gcc-arm-none-eabi/samples

	echo "Thinning GCC: armv6-m, armv7-ar, armv7e-m, armv8-m & fpu libs"
	LIBS="./$1/lib/gcc/arm-none-eabi/5.2.1"
	deleteSilent $LIBS/armv6-m
	deleteSilent $LIBS/armv7-ar
	deleteSilent $LIBS/armv7e-m
	deleteSilent $LIBS/armv8-m.base
	deleteSilent $LIBS/armv8-m.main
	deleteSilent $LIBS/fpu

	LIBS="./$1/arm-none-eabi/lib"
	deleteSilent $LIBS/armv6-m
	deleteSilent $LIBS/armv7-ar
	deleteSilent $LIBS/armv7e-m
	deleteSilent $LIBS/armv8-m.base
	deleteSilent $LIBS/armv8-m.main
	deleteSilent $LIBS/fpu
}

function deleteSilent {
	if [ -e $1 ]; then
		rm -r $1
	fi
}