source ../configuration.sh
source ../common.sh

WIN_CERT="Monolit ApS.p12"
ARCH=64
PACKAGE_NAME=OpenMono-v$VERSION.exe
BINDIR=../../$BINDIR
FRAMEWORK_DIR=../../$FRAMEWORK_DIR
TEMPLATE_DIR=../../$TEMPLATE_DIR
DISTDIR=dist
DIST_DEST_DIR="$DISTDIR"
GCC_ARM_DIR_NAME=$WIN_GCC_ARM_DIR_NAME
GCC_PATH="\"../$WIN_GCC_ARM_DIR_NAME/bin/arm-none-eabi-\""

function downloadMake {
	curl -O -L $WIN_MINGW_MAKE_PATH
}

function checkExists {
	if ! hash $1 2>/dev/null; then
		echo $1 does not exist, cannot run.
		exit 3
	fi
}

if [[ $1 != "-ci" && ! -f "./$WIN_CERT" ]]; then
	echo "Build cannot finish, the app certificate ($WIN_CERT) cannot be found!"
	read -p "Do you want to continue? (y/n)" -n 1 -r
	echo
    if ! [[ $REPLY =~ ^[yY]$ ]]; then
        echo "Aborting!"
        exit
    fi
fi

if [[ $1 != "-ci" ]]; then
	confirmBuild
fi

checkExists git

cloneMonoFramework
modifyMakefile $MONOFRMWRK_NAME $GCC_PATH
buildMonoFramework

cloneMonoProg
compileMonoprogWin $MONOPROG_NAME/$MONOPROG_WIN_EXECUTABLE $DIST_DEST_DIR/monoprog/.

if [[ $1 == "-ci" || ! -f "$WIN_GCC_ARM_DIR_NAME" ]]; then
	downloadUrl "VC2013 C++ Redistributable" $WIN_VC2013_X64_REDIST_URL
	downloadGcc $GCC_ARM_WIN_URL
	thinGcc $WIN_GCC_ARM_DIR_NAME
fi

copyGcc $WIN_GCC_ARM_DIR_NAME $DIST_DEST_DIR
#rm $DIST_DEST_DIR/bin/monomake
copyFiles "Windows specific binaries" $MSYS_MAKE_DIR $DIST_DEST_DIR
copyFiles "generic binaries" $BINDIR $DIST_DEST_DIR
copyFiles "templates" $TEMPLATE_DIR $DIST_DEST_DIR
cp $MAKEFILES_WIN $DIST_DEST_DIR/.

writePSConfigurationFile $DIST_DEST_DIR/configuration.ps1 $(basename $MONOPROG_WIN_EXECUTABLE) "$MONOMAKE_POWERSHELL"
makeConfigurationFile $DIST_DEST_DIR/predefines.mk $(basename $MONOPROG_WIN_EXECUTABLE) "$MONOMAKE_POWERSHELL"
#symbolicLink bin/monomake monomake
sed -i.bak "s#set VERSION=.*#set VERSION=$VERSION#g" ./build-nsis.bat
./build-nsis.bat

if [[ $1 != "-ci" || -f "Monolit ApS.p12" ]]; then
	./sign.ps1 "Monolit ApS.p12" "OpenMonoSetup-v$VERSION.exe"
fi

if [[ $1 != "-ci" ]]; then
	read -p "Should I delete app. cert private key file? ($WIN_CERT) (y/n)" -n 1 -r
	echo
	if [[ $REPLY =~ ^[yY]$ ]]; then
	    echo "Deleting $WIN_CERT..."
	    rm "./$WIN_CERT"
	fi
fi