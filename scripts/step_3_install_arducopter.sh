#!/bin/bash
#----------------------------------------------------------
# Purpose:
#    Downloads and installs the lastest Github version of Ardupilot
#    and JSBSim simulator, placing them in the directory:
#     /home/<user>/shared_sitl
#----------------------------------------------------------
# Acknowledgements / References:
#    Commands inspired from:
#     http://dev.ardupilot.com/wiki/using-rosgazebo-simulator-with-sitl/
#----------------------------------------------------------


# Stops at the first error it encounters
#set -e

#----------------------------------------------------------
# Feel free to modify the destination path for the ROS workspace:
PROJECT_DIR=~/shared_sitl


##---------------------------------------------------------
## Downloads ARDUPILOT

echo "Getting latest version of Ardupilot..."
cd $PROJECT_DIR
#git clone git://github.com/diydrones/ardupilot.git
# For the moment, use Alex Buyval's RangeFinderSITL2 branch
git clone https://github.com/alexbuyval/ardupilot
cd ardupilot
git checkout RangeFinderSITL2
# Saves the path on a variable
export APM_ROOT=$PROJECT_DIR/ardupilot

# Appends the path to Ardupilot to the PATH variable in the .profile script
exportline="export PATH=$APM_ROOT/Tools/autotest:\$PATH"
# Only appends it if not already present...
if grep -Fxq "$exportline" ~/.profile
then
  echo nothing to do
else
  echo $exportline >> ~/.profile
  echo "JSBSim directory added to PATH in .profile"
fi


##---------------------------------------------------------
## Downloads & Builds JSBSIM

echo "Getting latest version of JSBSim..."
cd $PROJECT_DIR
# Removes any existing jsbsim folder
rm -rf jsbsim
git clone git://github.com/tridge/jsbsim.git
# Additional dependencies required
sudo apt-get install libtool automake autoconf libexpat1-dev
cd jsbsim
git pull
./autogen.sh --enable-libraries
make -j2
sudo make install
# Saves the path on a variable
export JSBSIM_ROOT=$PROJECT_DIR/jsbsim

# Appends the path to JSBSim to the PATH variable in the .profile script
exportline="export PATH=$JSBSIM_ROOT/src:\$PATH"
# Only appends it if not already present...
if grep -Fxq "$exportline" ~/.profile
then
  echo nothing to do
else
  echo $exportline >> ~/.profile
  echo "JSBSim directory added to PATH in .profile"
fi

##---------------------------------------------------------

# Execute .profile to update the changes to PATH
sudo . ~/.profile

cd $PROJECT_DIR

echo "Ardupilot environment ready."
echo "You can now launch the ROS installation script, for a Gazebo simulation."
echo "Or you can directly run 'sim_vehicle.sh' to start a regular simulation."
