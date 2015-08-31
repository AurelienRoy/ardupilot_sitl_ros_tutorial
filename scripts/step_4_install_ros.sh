#!/bin/bash
#----------------------------------------------------------
# Purpose:
#    Installs ROS (Robot Operating System), and a few addional
#    dependencies / compiled packages required for the Ardupilot
#    simulation.
#----------------------------------------------------------
# Acknowledgements / References:
#    This script comes largely from:
#      https://pixhawk.org/dev/ros/sitl
#    With some commands inspired from:
#      http://wiki.ros.org/indigo/Installation/Ubuntu
#      http://gazebosim.org/tutorials?tut=drcsim_install
#      http://dev.ardupilot.com/wiki/using-rosgazebo-simulator-with-sitl/
#----------------------------------------------------------


# Stops at the first error it encounters
#set -e

export DEBIAN_FRONTEND=noninteractive

#sudo apt-get dist-upgrade

 
## add ROS repository and key
## install main ROS pacakges
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -O - | sudo apt-key add -
sudo apt-get update
# Just in case there was a missing dependency
sudo apt-get -y install libgl1-mesa-dev-lts-utopic \
                        ros-indigo-desktop-full

sudo rosdep init
rosdep update

## setup environment variables
sudo sh -c 'echo "source /opt/ros/indigo/setup.bash" >> ~/.bashrc'
source ~/.bashrc

## get rosinstall and some additional dependencies
sudo apt-get -y install python-rosinstall          \
                        ros-indigo-octomap-msgs    \
						ros-indigo-joy             \
						ros-indigo-geodesy         \
						unzip                      \
						ros-indigo-octomap-ros

## add osrf repository
## install drcsim
sudo sh -c 'echo "deb http://packages.osrfoundation.org/drc/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/drc-latest.list'
wget http://packages.osrfoundation.org/drc.key -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install drcsim

## install mavros but from shadow repo to get latest version earlier
sudo sh -c 'echo "deb http://packages.ros.org/ros-shadow-fixed/ubuntu/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-shadow.list'
sudo apt-get update
sudo apt-get -y install ros-indigo-mavros \
                        ros-indigo-mavros-extras
