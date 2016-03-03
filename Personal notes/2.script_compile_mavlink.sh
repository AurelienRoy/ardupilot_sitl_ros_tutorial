#!/bin/sh

cd ~/shared_sitl/ardupilot
./libraries/GCS_MAVLink/generate.sh

cd ~/shared_sitl/mavlink-gbp-release
sed 's|\(2014.11.11-3trusty\)|\1-custom|' -i debian/changelog
fakeroot dpkg-buildpackage -us -uc -b
cd ..
sudo dpkg -i ./ros-indigo-mavlink_2015.11.25-0trusty_amd64.deb 


