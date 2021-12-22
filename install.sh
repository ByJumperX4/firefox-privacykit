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
$FPK_DIR/runzenity --warning --width 480 --text "WARNING: Firefox Privacy Kit is still an experimental project and isn't feature-complete yet !\n
You shouldn't assume this works out of the box and/or is as secure/private as using Tor Browser on QubesOS."

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
FPK_SANDBOX=$($ZENITY --forms --add-list="What sandbox solution do you want ?" --list-values "Debian chroot (recommended)|Gentoo chroot (most secure, takes hours to update)|Firejail (lightweight without too much compromize on security)|User dedicated to Firefox (weak, may be totally useless on some operating systems)|None (insecure, but you may want this if you are already in a sandboxed environment)" | cut -d " " -f1 | tr '[:upper:]' '[:lower:]')
echo "Debug: FPK_SANDBOX : $FPK_SANDBOX"
# Privacy level
FPK_LEVEL=$($ZENITY --forms --add-list="What level of privacy do your need ?" --list-values "Ultimate : provides the maximum level of privacy this installer has to offer, it will require to read documentation to understand how to use it|High : A very good privacy level that should be as easy to use as Tor Browser|Medium : A medium security level without having very advanced privacy features, should be a pretty decent daily driver for non-technical people" | cut -d " " -f1 | tr '[:upper:]' '[:lower:]')
echo "Debug: FPK_LEVEL : $FPK_LEVEL"
# IP hiding
FPK_ANONIP=$($ZENITY --forms --add-list="What method do you want to use to hide you IP address ?" --list-values "Lokinet|Tor (not recommended: Tor Browser is better for this)|None (Only use this if you are already hiding your IP in a system-wide way (for example: use of a VPN))" | cut -d " " -f1 | tr '[:upper:]' '[:lower:]')
echo "Debug: FPK_ANONIP : $FPK_ANONIP"
# Tor Browser
if $ZENITY --question --width 480 --text "Do you want Tor Browser to be installed ?"
then
    FPK_TOR=1
    if $ZENITY --question --width 480 --text "Do you also want Tor Browser to be sandboxed ?\n
This is useless in most cases as Tor Browser already has some kind of sandbox\n
It is also likely to be slowed down by the IP address hiding method you choosed if you run it in the sandbox"
    then
	FPK_TOR_SANDBOX=1
    else
	FPK_TOR_SANDBOX=0
    fi
else
    FPK_TOR=0
fi

# Install everything
# COMMAND HERE | $FPK_DIR/runzenity --text-info --auto-scroll --width 480 --no-wrap
# Use a random number for the install path, this will make possible to install Firefox Privacy Kit multiple times
echo "Debug: Generating random number..."
while true; do
    FPK_RANDOMNUMBER=$RANDOM
    echo " Debug: Trying $FPK_RANDOMNUMBER"
    if [ "$(ls $HOME/.local/share/firefox-privacykit | grep --color=never $FPK_RANDOMNUMBER)" = "" ]; then
	 echo "Debug: Random number will be $FPK_RANDOMNUMBER"
	 break
    fi
    echo "Warning: $FPK_RANDOMNUMBER is already used by $(ls $HOME/.local/share/firefox-privacykit | grep $FPK_RANDOMNUMBER)"
done	 

case $FPK_SANDBOX in
    debian)
	cd $FPK_DIR
	# proot will be used for chroot setup
	wget https://proot.gitlab.io/proot/bin/proot
	chmod +x proot
	# get debootstrap
	wget http://deb.debian.org/debian/pool/main/d/debootstrap/debootstrap_1.0.123.tar.gz
	tar xvf debootstrap_1.0.123.tar.gz
	#mv debootstrap debootstrap-data
	#wget https://raw.githubusercontent.com/ByJumperX4/firefox-privacykit/master/debootstrap
	chmod +x debootstrap/debootstrap
	# Create the chroot
	$ZENITY --info --text "Pleae wait while Debian is being installed in $HOME/.local/share/debian-$FPK_RANDOMNUMBER\n
A new window will appear when its installation is completed to confirm it worked."
	cd $HOME/.local/share/firefox-privacykit
	echo "Debug : Starting to install Debian"
	FPK_DEBDIR=$HOME/.local/share/debian-$FPK_RANDOMNUMBER
	if DEBOOTSTRAP_DIR=$FPK_DIR/debootstrap $FPK_DIR/proot --kill-on-exit -0 $FPK_DIR/debootstrap/debootstrap --arch=amd64 --variant=minbase oldstable ./debian-$FPK_RANDOMNUMBER && echo "deb http://deb.debian.org/debian oldstable main" > $FPK_DEBDIR/etc/apt/sources.list && echo "deb http://deb.debian.org/debian-security oldstable-security main" >> $FPK_DEBDIR/etc/apt/sources.list && echo "deb http://deb.debian.org/debian oldstable-updates main" >> $FPK_DEBDIR/etc/apt/sources.list
	then
	   $ZENITY --error --text "The Debian installation was not successful :(\n
Please report this by:\n
1. launching the installer with ./install.sh > errorlog.log\n
2. creating an issue on the github repo with as much info on your system as you can provide'n
3. sending the errorlog.log file with your system info.\n"
	   exit 1
	fi
	if ! [ "$FPK_ANONIP" = "none" ]; then
	    $ZENITY --info --text "Debian has been installed, now the installer will proceed with the IP hiding solution you choosed ($FPK_ANONIP)"
	fi
    ;;
    gentoo)
    ;;
    firejail)
    ;;
    user)
    ;;
    none)
esac

# Exit
if [ -d $HOME/_firefox-privacykit ]; then
    rm -rfv $HOME/_firefox-privacykit
fi
exit 0
