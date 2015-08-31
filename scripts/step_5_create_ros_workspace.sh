#!/bin/bash
#----------------------------------------------------------
# Purpose:
#    Creates a ROS workspace and fetch source repositories,
#    placing them in the directory:
#      /home/<user>/ros/catkin_ws
#----------------------------------------------------------
# Acknowledgements / References:
#    This script comes largely from:
#     https://pixhawk.org/dev/ros/sitl
#----------------------------------------------------------


# Stops at the first error it encounters
#set -e

#-----------------------------------------------
# Feel free to modify the destination path for the ROS workspace:
WORKSPACE=~/ros/catkin_ws

# Or if you prefer to create the workspace from the location of the
# script, you can uncomment the following lines:
#   WDIR=`pwd`
#   WORKSPACE=$WDIR/catkin_ws
#-----------------------------------------------

source ~/.bashrc

# Setup workspace
mkdir -p $WORKSPACE/src
cd $WORKSPACE/src
catkin_init_workspace
cd $WORKSPACE
catkin_make
sh -c "echo 'source $WORKSPACE/devel/setup.bash' >> ~/.bashrc"
 
# Fetch sources
## Arducopter ROS configuration
cd $WORKSPACE/src
git clone https://alexbuyval@bitbucket.org/alexbuyval/arducopter_sitl_ros.git 

## rotors simulator
cd $WORKSPACE/src
#git clone https://github.com/PX4/rotors_simulator.git
git clone https://github.com/alexbuyval/rotors_simulator.git
cd rotors_simulator
git checkout sonar_plugin

## mav comm
cd $WORKSPACE/src
git clone https://github.com/PX4/mav_comm.git

## glog catkin
cd $WORKSPACE/src
git clone https://github.com/ethz-asl/glog_catkin.git

## catkin simple
cd $WORKSPACE/src
git clone https://github.com/catkin/catkin_simple.git

## Mavros
cd $WORKSPACE
# Installation of source code:
wstool init src     # (if not already initialized)
wstool set -t src mavros --git https://github.com/alexbuyval/mavros.git
wstool update -t src
# Instead of getting raw source code for Mavros, it is possible
# to download precompiled binaries with this command:
#   sudo apt-get install ros-indigo-mavros ros-indigo-mavros-extras

# Checks any missing dependency
echo "Checking for missing dependencies:"
rosdep install --from-paths src --ignore-src --rosdistro indigo -y
# It may throw an error of missing dependency on [gflags_catkin] for
# package "glog_catkin", but this error does not seem to disrupt the
# compilation (catkin_make).

# Disable parallel make jobs for compilation.
# Sometimes required inside Docker container or VMs with not enough memory.
# If you're on a native Ubuntu installation, you can leave this away.
export ROS_PARALLEL_JOBS=
 
# Compile workspace
cd $WORKSPACE
source devel/setup.bash
catkin_make
# or use "catkin build" ?

# If you wish to check that the workspace is properly setup, run the
# following command to be sure it contains the path to the "src" folder
# of your workspace.
#    echo $ROS_PACKAGE_PATH


