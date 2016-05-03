source ../configuration.sh
source ../common.sh

ARCH=64
PACKAGE_NAME=OpenMono-v$VERSION-x$ARCH.exe
BINDIR=../../$BINDIR
FRAMEWORK_DIR=../../$FRAMEWORK_DIR
TEMPLATE_DIR=../../$TEMPLATE_DIR
DISTDIR=dist
DIST_DEST_DIR="$DISTDIR"
GCC_ARM_DIR_NAME=$WIN_GCC_ARM_DIR_NAME

function downloadMake {
	curl -O -L $WIN_MINGW_MAKE_PATH
}

function checkExists {
	if ! hash $1 2>/dev/null; then
		echo $1 does not exist, cannot run.
		exit 3
	fi
}

function modifyMakefile {
	ARCH="ARCH=\"../$WIN_GCC_ARM_DIR_NAME/bin/arm-none-eabi-\""
	echo "replacing GCC file path in makefile to: $ARCH"
	sed -i.bak "s#ARCH=\".*\"#$ARCH#g" $1/Makefile

	INCLUDE_DIR=../$PSOC5_LIB_NAME/include
	echo "replacing include dir: $INCLUDE_DIR"
	sed -i.bak "s#INCLUDE_DIR=.*#INCLUDE_DIR=$INCLUDE_DIR#g" $1/Makefile

	CYPRESS_DIR=../$PSOC5_LIB_NAME/Generated_Source/PSoC5
	echo "replacing CYPRESS_DIR dir: $CYPRESS_DIR"
	sed -i.bak "s#CYPRESS_DIR=.*#CYPRESS_DIR=$CYPRESS_DIR#g" $1/Makefile

	CYPRESS_LIB=../$PSOC5_LIB_NAME/lib/monoCyLib.a
	echo "replacing CYPRESS_LIB dir: $CYPRESS_LIB"
	sed -i.bak "s#CYPRESS_LIB=.*#CYPRESS_LIB=$CYPRESS_LIB#g" $1/Makefile

	MONO_FRAMEWORK_PATH=../$MONOFRMWRK_NAME
	echo "replacing MONO_FRAMEWORK_PATH dir: $MONO_FRAMEWORK_PATH"
	sed -i.bak "s#MONO_FRAMEWORK_PATH=.*#MONO_FRAMEWORK_PATH=$MONO_FRAMEWORK_PATH#g" $1/Makefile

	MBED_FS=../$MBED_LIB_NAME/libraries/fs
	echo "replacing MBED_FS dir: $MBED_FS"
	sed -i.bak "s#MBED_FS=.*#MBED_FS=$MBED_FS#g" $1/Makefile

	COMP_LIB=../$PSOC5_LIB_NAME/lib/CyComponentLibrary.a
	echo "replacing COMP_LIB dir: $COMP_LIB"
	sed -i.bak "s#COMP_LIB=.*#COMP_LIB=$COMP_LIB#g" $1/Makefile

	MONO_LIB=../$PSOC5_LIB_NAME/lib/monoCyLib.a
	echo "replacing MONO_LIB dir: $MONO_LIB"
	sed -i.bak "s#MONO_LIB=.*#MONO_LIB=$MONO_LIB#g" $1/Makefile

	PACKAGE_TARGET=../$DIST_DEST_DIR
	echo "replacing PACKAGE_TARGET dir: $PACKAGE_TARGET"
	sed -i.bak "s#PACKAGE_TARGET=.*#PACKAGE_TARGET=$PACKAGE_TARGET#g" $1/Makefile

}

checkExists git
clonePsoc5Library
modifyMakefile $PSOC5_LIB_NAME
cloneMbedLibrary
cloneMbedCompLibrary
modifyMakefile $MBEDCOMP_LIB_NAME
cloneMonoFramework
modifyMakefile $MONOFRMWRK_NAME
buildMonoFramework
cloneMonoProg
compileMonoprogWin $MONOPROG_NAME/$MONOPROG_WIN_EXECUTABLE $DIST_DEST_DIR/monoprog/.
downloadUrl "VC2013 C++ Redistributable" $WIN_VC2013_X64_REDIST_URL
downloadGcc $GCC_ARM_WIN_URL
copyGcc $WIN_GCC_ARM_DIR_NAME $DIST_DEST_DIR
copyFiles "Windows specific binaries" $MSYS_MAKE_DIR $DIST_DEST_DIR
#copyFiles "generic binaries" $BINDIR $DIST_DEST_DIR
#rm $DIST_DEST_DIR/bin/monomake
copyFiles "framework" $FRAMEWORK_DIR $DIST_DEST_DIR
copyFiles "templates" $TEMPLATE_DIR $DIST_DEST_DIR
cp $MAKEFILES_WIN $DIST_DEST_DIR
#writePSConfigurationFile $DIST_DEST_DIR/configuration.ps1 $(basename $MONOPROG_WIN_EXECUTABLE) "$MONOMAKE_POWERSHELL"
#$GCC_ARM_DIR_NAME=$WIN_GCC_ARM_DIR_NAME
makeConfigurationFile $DIST_DEST_DIR/predefines.mk $(basename $MONOPROG_WIN_EXECUTABLE) "$MONOMAKE_POWERSHELL"
#symbolicLink bin/monomake monomake
./build-nsis.bat
