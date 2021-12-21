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

# This is still very experimental, warn the user about this
$FPK_DIR/runzenity --warning --width 480 --text "WARNING: Firefox Privacy Kit is still an experimental project and isn't feature-complete yet ! You shouldn't assume this works out of the box and/or is as secure/private as using Tor Browser on QubesOS."

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
# Create a directory in .local for data if it's not there yet
if ! [ -d $HOME/.local/share/firefox-privacykit ]; then
   mkdir -v $HOME/.local/share/firefox-privacykit
fi
   
# Install zenity permanently (delete any old one)
if [ -d $HOME/.local/share/firefox-privacykit/zenity ]; then
   rm -rfv $HOME/.local/share/firefox-privacykit/zenity
fi
if [ -d $HOME/.local/share/firefox-privacykit/runzenity ]; then
   rm -v $HOME/.local/share/firefox-privacykit/runzenity
fi
cp $FPK_DIR/zenitybootstrap.sh $HOME/.local/share/firefox-privacykit/
cd $HOME/.local/share/firefox-privacykit
sh ./zenitybootstrap.sh
ZENITY=$HOME/.local/share/firefox-privacykit/runzenity
cd $FPK_DIR

# Ask the user some questions and set some variables depending on the answers
# Sandboxing solution
FPK_SANDBOX=$($ZENITY --forms --add-list="What sandbox solution do you want ?" --list-values "Debian chroot (recommended)|Gentoo chroot (most secure, takes hours to update)|Firejail (lightweight without too much compromize on security)|User dedicated to Firefox (weak, may be totally useless on some operating systems)|None (insecure, but you may want this if you are already in a sandboxed environment)" | cut -d " " -f1)
FPK_LEVEL=$($ZENITY --forms --add-list="What level of privacy do your need ?" --list-values "Ultimate : provides the maximum level of privacy this installer has to offer, it will require to read documentation to understand how to use it|High : A very good privacy level that should be as easy to use as Tor Browser|Medium : A medium security level without having very advanced privacy features, easiest to use and should be " | cut -d " " -f1)


# Install everything
# COMMAND HERE | if $FPK_DIR/runzenity --text-info --auto-scroll --width 480 --no-wrap

# Exit
if [ -d $HOME/_firefox-privacykit ]; then
    rm -rfv $HOME/_firefox-privacykit
fi
exit 0
