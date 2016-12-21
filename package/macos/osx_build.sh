#!/bin/bash

source ../configuration.sh
source ../common.sh

PACKAGE_NAME=OpenMono-v$VERSION-Mac
BINDIR=../../$BINDIR
FRAMEWORK_DIR=../../$FRAMEWORK_DIR
TEMPLATE_DIR=../../$TEMPLATE_DIR
DISTDIR=dist
DIST_DEST_DIR="$DISTDIR/usr/local/openmono"

if [[ $1 == "-ci" ]]; then
	echo "Running on CI env. Setting GCC_ARM_DIR_NAME to:"
	GCC_ARM_DIR_NAME=$HOME/$GCC_ARM_DIR_NAME
	echo $GCC_ARM_DIR_NAME
fi

get_abs_filename() {
	# $1 : relative filename
	if [ -d "$(dirname "$1")" ]; then
		echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
	else
		echo "$1"
	fi
}

function symbolicLink {
    mkdir -p "$DISTDIR/usr/local/bin"
    ln -s "../openmono/$1" "$DISTDIR/usr/local/bin/$2"
}

if [[ $1 != "-ci" ]]; then
	confirmBuild
fi

# if [ -e "$DISTDIR" ]; then
#     rm -rf "$DISTDIR"
# fi
# checkExists git'

buildLittleHelper $LITTLE_HELPER_MAC_ARTIFACT `pwd`
mkdir -p $LITTLE_HELPER_DISTDIR
echo "Unzipping Monomake-UI for Package installer..."
unzip $(basename $LITTLE_HELPER_MAC_ARTIFACT) -d $LITTLE_HELPER_DISTDIR
mkdir -p $DISTDIR/$LITTLE_HELPER_MAC_DISTDIR
mv $LITTLE_HELPER_DISTDIR/$LITTLE_HELPER_MAC_EXE $DISTDIR/$LITTLE_HELPER_MAC_DISTDIR/Monomake.app

# Download GCC
if [[ -e $GCC_ARM_DIR_NAME ]]; then
	GCC_DIR=$GCC_ARM_DIR_NAME
	GCC_ARCHIVE=$MAC_GCC_ARM_DIR_NAME
	GCC_URL=$GCC_ARM_MAC_URL
	if [[ ! -f $MAC_GCC_ARM_DIR_NAME ]]; then
		echo "GCC Arm does not exists, downloading..."
		wget $GCC_URL -O $GCC_ARCHIVE;
	else
		echo "GCC folder does not exists, but archive does"
	fi
	echo "Extracting GCC to $GCC_ARM_DIR_NAME..."
	tar xfj $GCC_ARCHIVE
fi

cloneMonoFramework
if [[ $1 == "-ci" ]]; then
    modifyMakefile $MONOFRMWRK_NAME "arm-none-eabi-"
else
    modifyMakefile $MONOFRMWRK_NAME
fi
buildMonoFramework

cloneMonoProg
compileMonoprogMac "$MONOPROG_NAME/$MONOPROG_MAC_EXECUTABLE" $DIST_DEST_DIR/monoprog/.

# # downloadGcc $GCC_ARM_MAC_URL
thinGcc $GCC_ARM_DIR_NAME
copyGcc $GCC_ARM_DIR_NAME $DIST_DEST_DIR

copyFiles "binaries" $BINDIR $DIST_DEST_DIR
copyFiles "templates" $TEMPLATE_DIR $DIST_DEST_DIR
cp $MAKEFILES $DIST_DEST_DIR

writeConfigurationFile $DIST_DEST_DIR/configuration.sh $(dirname "$(basename $MONOPROG_MAC_EXECUTABLE)/$MONOPROG_MAC_EXECUTABLE_BINARY")
makeConfigurationFile $DIST_DEST_DIR/predefines.mk $(basename $MONOPROG_MAC_EXECUTABLE)/$MONOPROG_MAC_EXECUTABLE_BINARY
symbolicLink bin/monomake monomake
echo "Package setup done"

echo "Adding Qt libraries to monoprog application bundle..."
if [ ! hash macdeployqt 2>/dev/null; then
    echo macdeployqt does not exist, cannot create package.
    exit 2
fi
macdeployqt $DIST_DEST_DIR/monoprog/monoprog.app -no-plugins

if ! hash pkgbuild 2>/dev/null; then
    echo pkgbuild does not exist, cannot create package.
    exit 3
fi

echo "Building package..."
if [[ $1 != "-ci" && $1 != "--no-sign" ]]; then
    pkgbuild \
        --root "$DISTDIR" \
        --component-plist component.plist \
        --identifier com.openmono.monoframework \
        --version $VERSION \
        --install-location / \
        --scripts scripts \
        --sign "Developer ID Installer: Monolit ApS (MUXP6TEH5D)" \
        "$PACKAGE_NAME.pkg"
else
    echo "(Unsigned)"
    pkgbuild \
        --root "$DISTDIR" \
        --component-plist component.plist \
        --identifier com.openmono.monoframework \
        --version $VERSION \
        --install-location / \
        --scripts scripts \
        "$PACKAGE_NAME.pkg"
fi

echo "Creating TGZ Mac package for those who hate PKG installers..."
tar -czf "$PACKAGE_NAME.tgz" -C "`dirname $DIST_DEST_DIR`" "`basename $DIST_DEST_DIR`"
echo "All Done"