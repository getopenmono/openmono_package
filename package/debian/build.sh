#!/bin/bash

source ../configuration.sh
source ../common.sh

BINDIR=../../$BINDIR
FRAMEWORK_DIR=./mono_framework/dist/$FRAMEWORK_DIR
TEMPLATE_DIR=../../$TEMPLATE_DIR

PACKAGE=openmono
DISTDIR=debpackage
PKGROOT=${DISTDIR}/${PACKAGE}_${VERSION}
DIST_DEST_DIR=$PKGROOT/usr/lib/openmono

function symbolicLink {
    ln -s "../lib/openmono/$1" "$PKGROOT/usr/bin/$2"
}

confirmBuild

if [ -d $PKGROOT ]; then
    echo "Re-assigning user priviledges..."
	sudo chown -R `whoami`:`whoami` "${PKGROOT}"
fi

#checkExists git

cloneMonoFramework
modifyMakefile $MONOFRMWRK_NAME "arm-none-eabi-"
buildMonoFramework

cloneMonoProg
compileMonoprog $MONOPROG_NAME/$MONOPROG_DEB_EXECUTABLE $DIST_DEST_DIR/monoprog/.
mkdir -p $DIST_DEST_DIR
copyFiles "binaries" $BINDIR $DIST_DEST_DIR
#copyFiles "framework" $FRAMEWORK_DIR $DIST_DEST_DIR
copyFiles "templates" $TEMPLATE_DIR $DIST_DEST_DIR

cp $MAKEFILES $DIST_DEST_DIR
writeConfigurationFile $DIST_DEST_DIR/configuration.sh
makeConfigurationFile $DIST_DEST_DIR/predefines.mk "monoprog" "" "arm-none-eabi-"

mkdir -p $PKGROOT/usr/bin
symbolicLink bin/monomake monomake

##UDEV rules
echo "Creating udev rules for USB device..."
UDEVDIR=${PKGROOT}/etc/udev/rules.d
mkdir -p "${UDEVDIR}"
cp etc-udev-rules.d-openmono.rules "${UDEVDIR}/10-openmono.rules"


echo "Package setup done"

echo "creating package control file.."
mkdir -p "${PKGROOT}/DEBIAN"

DEBARCH=$(dpkg --print-architecture)
sed -e "s;%DEBARCH%;$DEBARCH;g" -e "s;%VERSION%;$VERSION;g" control.template > "${PKGROOT}/DEBIAN/control"
echo "" >> "${PKGROOT}/DEBIAN/control"

echo "Building package..."
sudo chown -R root:root "${PKGROOT}"
sudo dpkg-deb --build "${PKGROOT}"
sudo chown -R `whoami`:`whoami` "${PKGROOT}"
