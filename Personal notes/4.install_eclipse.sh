#!/bin/bash
# Aurelien Roy
# 11/09/2015

# From:
# http://askubuntu.com/questions/26632/how-to-install-eclipse
# Run it next to Eclipse's archive (.tar.gz)

# Stops at the first error it encounters
#set -e

ECLIPSE_VERSION=eclipse-cpp-mars
DESKTOP_SHORTCUT=~/Bureau/Eclipse.desktop

echo "Installation of $ECLIPSE_VERSION"

# Extracts the eclipse.XX.YY.tar.gz using
tar -zxvf $ECLIPSE_VERSION*.tar.gz

# Renames the extracted folder
# (it supposes the extracted name is "eclipse")
sudo mv eclipse $ECLIPSE_VERSION

# Copies the eclipse folder to /opt
sudo mv $ECLIPSE_VERSION /opt

# Creates a shortcut on the desktop
cat >$DESKTOP_SHORTCUT <<EOL
[Desktop Entry]
Name=Eclipse
Type=Application
Exec=env UBUNTU_MENUPROXY=0 eclipse44
Terminal=false
Icon=eclipse
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=Eclipse
EOL

cat $DESKTOP_SHORTCUT

# Installs the shortcut it in the unity
sudo desktop-file-install $DESKTOP_SHORTCUT
sudo chmod +x $DESKTOP_SHORTCUT

# Creates a symlink in /usr/local/bin
sudo ln -s /opt/$ECLIPSE_VERSION/eclipse /usr/local/bin/eclipse44

# For eclipse icon to be displayed in dash, eclipse icon can be added as
sudo cp /opt/$ECLIPSE_VERSION/icon.xpm /usr/share/pixmaps/eclipse.xpm

# Need to have either OpenJDK or Sun Java installed to be able to run eclipse
sudo apt-get install openjdk-6-jdk

# Launches eclipse and then give it the required permissions to modify the osgi file:
#sudo chown -R $USER:$USER /opt/$ECLIPSE_VERSION/configuration/org.eclipse.osgi
sudo chown -R $USER:$USER /opt/$ECLIPSE_VERSION
sudo chmod -R +r /opt/$ECLIPSE_VERSION

echo ""
echo "Eclipse has been successfully installed !"
echo "A shortcut has been placed on your desktop."

