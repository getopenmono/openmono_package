#!/bin/bash

source ../configuration.sh
source ../common.sh

BINDIR=../../$BINDIR
FRAMEWORK_DIR=../../$FRAMEWORK_DIR
TEMPLATE_DIR=../../$TEMPLATE_DIR

PACKAGE=openmono
DISTDIR=debpackage
PKGROOT=${DISTDIR}/${PACKAGE}_${VERSION}
DIST_DEST_DIR=$PKGROOT/usr/lib/openmono

function symbolicLink {
    ln -s "../lib/openmono/$1" "$PKGROOT/usr/bin/$2"
}

# clone monoprog
cloneMonoProg
compileMonoprog $MONOPROG_NAME/$MONOPROG_DEB_EXECUTABLE
downloadGcc $GCC_ARM_DEB_URL
copyGcc $GCC_ARM_DIR_NAME $DIST_DEST_DIR
copyFiles "binaries" $BINDIR $DIST_DEST_DIR
copyFiles "framework" $FRAMEWORK_DIR $DIST_DEST_DIR
copyFiles "templates" $TEMPLATE_DIR $DIST_DEST_DIR
cp $MAKEFILES $DIST_DEST_DIR
writeConfigurationFile $DIST_DEST_DIR/configuration.sh
makeConfigurationFile $DIST_DEST_DIR/Configuration.mk ""
symbolicLink bin/monomake monomake
echo "Package setup done"

echo "creating package control file.."
mkdir -p "${PKGROOT}/DEBIAN"

DEBARCH=$(dpkg --print-architecture)
sed -e "s;%DEBARCH%;$DEBARCH;g" -e "s;%VERSION%;$VERSION;g" control.template > "${PKGROOT}/DEBIAN/control"

echo "Building package..."
sudo chown -R root:root "${PKGROOT}"
sudo dpkg-deb --build "${PKGROOT}"