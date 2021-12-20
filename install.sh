#!/bin/sh -eu

# Tell the user to not panic because some dumb people launch the program 20 times because it doesn't output anything
echo --- Firefox Privacy Kit ---
echo \ \ Please wait...

# Create a temporary folder for all our garbage in the home folder
if [ -d $HOME/_firefox-privacykit ]; then
    rm -rfv $HOME/_firefox-privacykit
fi
mkdir $HOME/_firefox-privacykit
FPK_DIR=$HOME/_firefox-privacykit
cd $FPK_DIR

# Get zenity
wget https://raw.githubusercontent.com/ByJumperX4/firefox-privacykit/master/zenitybootstrap.sh
sh $FPK_DIR/zenitybootstrap.sh

# Quick ! draw a window using the new zenity install so the user doesn't panic !!!!!
if ! $FPK_DIR/runzenity --question --width 480 --text "Welcome to the Firefox Privacy Kit installer ! \n
This installer is going to set you up Firefox ESR with various protections depending on your choices.\n
The installer will ask you a few questions to fit your needs.\n
Press \"Yes\" to begin..."
then
    echo "The user aborded the installation process !"
    if [ -d $HOME/_firefox-privacykit ]
    then
       rm -rfv $HOME/_firefox-privacykit
    fi
    echo "Closing..."
    exit 0
fi

echo "The user has accepted to install Firefox Privacy Kit ! YAY !"



if [ -d $HOME/_firefox-privacykit ]; then
    rm -rfv $HOME/_firefox-privacykit
fi
