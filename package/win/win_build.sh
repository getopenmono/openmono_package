source ../configuration.sh
source ../common.sh

WIN_CERT="monolit-cert.p12"
ARCH=86
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

if [[ $1 == "-ci" || ! -f "$WIN_GCC_ARM_DIR_NAME" ]]; then
	downloadUrl "VC2013 C++ Redistributable" $WIN_VC2013_X86_REDIST_URL
	downloadGcc $GCC_ARM_WIN_URL
	thinGcc $WIN_GCC_ARM_DIR_NAME
fi

copyGcc $WIN_GCC_ARM_DIR_NAME $DIST_DEST_DIR

cloneMonoFramework
modifyMakefile $MONOFRMWRK_NAME $GCC_PATH
if [[ ! -f $MONOFRMWRK_NAME/build ]]; then
	mkdir -p $MONOFRMWRK_NAME/build
fi
buildMonoFramework

cloneMonoProg
compileMonoprogWin $MONOPROG_NAME/$MONOPROG_WIN_EXECUTABLE $DIST_DEST_DIR/monoprog/.

#rm $DIST_DEST_DIR/bin/monomake
copyFiles "Windows specific binaries" $MSYS_MAKE_DIR $DIST_DEST_DIR
copyFiles "generic binaries" $BINDIR $DIST_DEST_DIR
copyFiles "templates" $TEMPLATE_DIR $DIST_DEST_DIR
cp $MAKEFILES_WIN $DIST_DEST_DIR/.

# Build little helper
buildLittleHelper $LITTLE_HELPER_WIN_ARTIFACT `pwd`
mkdir -p $DIST_DEST_DIR/$LITTLE_HELPER_DISTDIR
unzip $LITTLE_HELPER_WIN_ARTIFACT -d $DIST_DEST_DIR/$LITTLE_HELPER_DISTDIR

if [[ $1 != "-ci" || -f "$WIN_CERT" ]]; then
	if [[ -f $DIST_DEST_DIR/$LITTLE_HELPER_DISTDIR/$LITTLE_HELPER_WIN_EXE ]]; then
		echo "Signing Monomake UI..."
		./sign.ps1 "$WIN_CERT" "$DIST_DEST_DIR/$LITTLE_HELPER_DISTDIR/$LITTLE_HELPER_WIN_EXE"
	fi
fi

#MAKE_PATH=`which make`
#echo "Copying make from: $MAKE_PATH"
#cp "$MAKE_PATH" "$DIST_DEST_DIR/bin/."

writePSConfigurationFile $DIST_DEST_DIR/configuration.ps1 $(basename $MONOPROG_WIN_EXECUTABLE) "$MONOMAKE_POWERSHELL"
makeConfigurationFile $DIST_DEST_DIR/predefines.mk $(basename $MONOPROG_WIN_EXECUTABLE) "$MONOMAKE_POWERSHELL"
#symbolicLink bin/monomake monomake
sed -i.bak "s#set VERSION=.*#set VERSION=$VERSION#g" ./build-nsis.bat
./build-nsis.bat
echo "Creating ZIP archive..."
zip -r "OpenMonoSDK-v$VERSION.zip" $DIST_DEST_DIR

if [[ $1 != "-ci" || -f "$WIN_CERT" ]]; then
	echo "Signing executable..."
	powershell.exe -File ./sign.ps1 "$WIN_CERT" "OpenMonoSetup-v$VERSION.exe"
fi

if [[ $1 != "-ci" ]]; then
	read -p "Should I delete app. cert private key file? ($WIN_CERT) (y/n)" -n 1 -r
	echo
	if [[ $REPLY =~ ^[yY]$ ]]; then
	    echo "Deleting $WIN_CERT..."
	    rm "./$WIN_CERT"
	fi
elif [[ $1 == "-ci" && -f "$WIN_CERT" ]]; then
	echo "Deleting certificate!"
	rm -f "./$WIN_CERT"
fi

echo "All is done!"