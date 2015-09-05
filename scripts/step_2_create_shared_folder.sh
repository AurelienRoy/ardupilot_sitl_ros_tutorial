#!/bin/bash
#----------------------------------------------------------
# Purpose:
#    Creates a shared folder with Windows.
#    Before running this script, you should have added on VMWare
#    a folder to be shared, and you should have mounted the VMware
#    Tools cdrom.
#----------------------------------------------------------
#  During the installation, accept all questions !


# Absolute path where will be placed the (symbolic links to)
# shared folders.
#DIR_FOR_SHARED_FOLDERS=~

# Stops at the first error it encounters
set -e

cd /mnt
sudo rm -rf VMwareTools
sudo rm -rf cdrom

# Copies the TAR ball from the cd to a new directory
sudo cp -r /media/apm/VMware\ Tools/ /mnt/cdrom
# Expands the TAR ball in /mnt
cd /mnt
sudo tar zxf /mnt/cdrom/VMwareTools-*.tar.gz

# Runs it
cd /mnt/vmware-tools-distrib
sudo perl ./vmware-install.pl

#cd $DIR_FOR_SHARED_FOLDERS
cd ~
vmware-hgfsclient

echo "Checking that shared folders exists..."
# Checks if any file exists in /mnt/hgfs
if [ `ls /mnt/hgfs` ]
then
  echo "Successful"
  ls /mnt/hgfs
else
  # Recovery attempt
  sudo vmware-config-tools.pl
  if [ `ls /mnt/hgfs` ]
  then
    echo "Successful (on 2nd attempt)"
    ls /mnt/hgfs
  else
    # Failed to set the shared folders, exits
    echo "FAILED !"
	echo "Try a manual setup by running the commands one by one"
    ls /mnt/hgfs
    exit 1
  fi
fi

# Creates a symbolic link in /home/apm
#cd $DIR_FOR_SHARED_FOLDERS
cd ~
ln -s /mnt/hgfs/*/

# Removes temporary files
sudo rm -rf /mnt/cdrom
#umount /media/apm/VMware\ Tools/

