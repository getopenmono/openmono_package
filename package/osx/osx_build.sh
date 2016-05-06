#!/bin/bash

source ../configuration.sh
source ../common.sh

PACKAGE_NAME=OpenMono-v$VERSION-x64.pkg
BINDIR=../../$BINDIR
FRAMEWORK_DIR=../../$FRAMEWORK_DIR
TEMPLATE_DIR=../../$TEMPLATE_DIR
DISTDIR=dist
DIST_DEST_DIR="$DISTDIR/usr/local/openmono"

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

if [ -e "$DISTDIR" ]; then
    rm -rf "$DISTDIR"
fi
checkExists git
clonePsoc5Library
modifyMakefile $PSOC5_LIB_NAME
buildPsoc5Library
cloneMbedLibrary
cloneMbedCompLibrary
modifyMakefile $MBEDCOMP_LIB_NAME
buildMbedCompLibrary
cloneMonoFramework
modifyMakefile $MONOFRMWRK_NAME
buildMonoFramework
cloneMonoProg
compileMonoprog $MONOPROG_NAME/$MONOPROG_MACEXECUTABLE $DIST_DEST_DIR/monoprog/.
downloadGcc $GCC_ARM_MAC_URL
copyGcc $GCC_ARM_DIR_NAME $DIST_DEST_DIR
copyFiles "binaries" $BINDIR $DIST_DEST_DIR
copyFiles "framework" $FRAMEWORK_DIR $DIST_DEST_DIR
copyFiles "templates" $TEMPLATE_DIR $DIST_DEST_DIR
cp $MAKEFILES $DIST_DEST_DIR
writeConfigurationFile $DIST_DEST_DIR/configuration.sh
makeConfigurationFile $DIST_DEST_DIR/predefines.mk $(basename $MONOPROG_MAC_EXECUTABLE)/$MONOPROG_MAC_EXECUTABLE_BINARY
symbolicLink bin/monomake monomake
echo "Package setup done"

echo "Adding Qt libraries to monoprog application bundle..."
if [ ! hash macdeployqt 2>/dev/null; then
    echo macdeployqt does not exist, cannot create package.
    exit 2
fi

macdeployqt $MONOPROG_NAME/$MONOPROG_MAC_EXECUTABLE -no-plugins


if ! hash pkgbuild 2>/dev/null; then
    echo pkgbuild does not exist, cannot create package.
    exit 3
fi
echo "Building package..."
pkgbuild \
    --root "$DISTDIR" \
    --component-plist component.plist \
    --identifier com.openmono.monoframework \
    --version $VERSION \
    --install-location / \
    --scripts scripts \
    "$PACKAGE_NAME"