#!/bin/bash
#----------------------------------------------------------
# Purpose:
#    Installs dependencies required by the Ardupilot's SITL.
#----------------------------------------------------------
# Acknowledgements / References:
#    This script comes largely from the file initvagrant.sh
#    located on ardupilot/Tools/vagrant.
#----------------------------------------------------------


# Stops at the first error it encounters
#set -e

echo "Initial setup of Ubuntu"

BASE_PKGS="gawk make git arduino-core curl"
SITL_PKGS="g++ python-pip python-matplotlib python-serial python-wxgtk2.8 python-scipy python-opencv python-numpy python-empy python-pyparsing ccache"
AVR_PKGS="gcc-avr binutils-avr avr-libc"
PYTHON_PKGS="pymavlink MAVProxy droneapi"
PX4_PKGS="python-serial python-argparse openocd flex bison libncurses5-dev \
          autoconf texinfo build-essential libftdi-dev libtool zlib1g-dev \
          zip genromfs"
UBUNTU64_PKGS="libc6:i386 libgcc1:i386 gcc-4.6-base:i386 libstdc++5:i386 libstdc++6:i386"
EXTRA_PKGS="gnome-session-fallback git-core"

# GNU Tools for ARM Embedded Processors
# (see https://launchpad.net/gcc-arm-embedded/)
ARM_ROOT="gcc-arm-none-eabi-4_7-2014q2"
ARM_TARBALL="$ARM_ROOT-20140408-linux.tar.bz2"
ARM_TARBALL_URL="http://firmware.diydrones.com/Tools/PX4-tools/$ARM_TARBALL"


sudo usermod -a -G dialout $USER

sudo apt-get -y remove modemmanager
sudo apt-get -y update
sudo apt-get -y install dos2unix g++-4.7 ccache python-lxml screen
sudo apt-get -y install $BASE_PKGS $SITL_PKGS $PX4_PKGS $UBUNTU64_PKGS $AVR_PKGS
sudo apt-get -y install $EXTRA_PKGS
sudo pip -q install $PYTHON_PKGS
sudo pip install catkin_pkg
sudo apt-get -y dist-upgrade

# ARM toolchain
if [ ! -d /opt/$ARM_ROOT ]; then
    (
        cd /opt;
        sudo wget -nv $ARM_TARBALL_URL;
        sudo tar xjf ${ARM_TARBALL};
        sudo rm ${ARM_TARBALL};
    )
fi
