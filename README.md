# Mono Tool chain Installers

[![Travis Build Status](https://travis-ci.org/getopenmono/openmono_package.svg?branch=master "Travis Build Status")](https://travis-ci.org/getopenmono/openmono_package) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/getopenmono/openmono_package?branch=master&svg=true "AppVeyor Build Status")](https://ci.appveyor.com/project/stoffera/openmono-package)

This repository contains the build tools for the tool chain installer packages. We have installers for:

* Windows (64 bit / 32 bit)
* Mac OS X (10.9 (*Mavericks*) or newer)
* Ubuntu / Debian

The tool chain consists of the following in-house tools:

* **[monoprog](https://github.com/getopenmono/monoprog)**: An USB HID programmer for Mono's bootloader
* **monomake**: An application project template creator and generic utility
  * *Linux / OS X*: The *monomake* bash shell script is found in this repository
  * *Windows*: The C# version can be found here: [win_reset_tool](https://github.com/getopenmono/win_reset_tool)
* **reboot.py** / **reset.exe**: A python or C# app. to use the serial port to reset Mono, using the UART DTR signal.
* **[mbed](https://developer.mbed.org/users/mbed_official/code/mbed-src/)**: An ARM Cortex-M microcontroller library with `stdio.h` features
* **[Mono Framework](https://github.com/getopenmono/mono_framework)**: Our embedded software framework, that you build your application on.

The tool chain installer also install these third party tools:

* **[GCC ARM Embedded](https://launchpad.net/gcc-arm-embedded)**: A Arm Cortex-M port of GCC that comes pre-compiled with C and C++ libraries (newlib-nano)
* **[GNU Make](https://www.gnu.org/software/make/)**: The *good olde* make util for running makefiles
* **[Qt](https://www.qt.io/download-open-source/) core**: *monoprog* depend on Qt Core libraries
* **[PySerial](https://github.com/pyserial/pyserial)**: (OS X & Linux Only) Library to access serials port through python

## Windows

To run on windows you need at least Windows 7 or newer. (The installation might work on Vista or XP, but you did not hear that from us!)

The tool chain needs .NET Framework higher than 3.5. If you do not have the Visual C++ libraries the installer will install *VC++ Redistributable* for you.

## Mac OS X

The install package contains most of the needed tools. On OS X 10.9 (Mavericks) or newer, the first time you run the tool chain the system will detect the missing tools and ask to install them.

If you use OS X 10.8 (Mountain Lion) or older the system will not automatically install the tools, you need to download and install the Developer Command Line Utilities from Apple's Developer site.

## Ubuntu / Debian

We have a api-get package - but no online repo for distributing it. To help you use the `dpkg` tool, we have created an install script that:

1. Adds the APT repository for the GCC Arm Embedded team
1. Updates the apt-get cache
1. Downloads the mono tool chain `.deb` package
1. Installs the package
1. Installs the packages dependencies
1. Installs python package manager and gets the *PySerial* package.

