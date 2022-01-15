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
FPK_SANDBOX=$($ZENITY --forms --add-list="What sandbox solution do you want ?" --list-values "Debian chroot (recommended)|Gentoo chroot [NOT WORKING YET] (most secure, takes hours to update)|Firejail [NOT WORKING YET] (lightweight without too much compromize on security)|User dedicated to Firefox [NOT WORKING YET] (weak, may be totally useless on some operating systems)|None [NOT WORKING YET] (insecure, but you may want this if you are already in a sandboxed environment)" | cut -d " " -f1 | tr '[:upper:]' '[:lower:]')
echo "Debug: FPK_SANDBOX : $FPK_SANDBOX"
# Privacy level
FPK_LEVEL=$($ZENITY --forms --add-list="What level of privacy do your need ?" --list-values "Ultimate : provides the maximum level of privacy this installer has to offer, it will require to read documentation to understand how to use it|High [NOT WORKING YET] : A very good privacy level that should be as easy to use as Tor Browser|Medium [NOT WORKING YET] : A medium security level without having very advanced privacy features, should be a pretty decent daily driver for non-technical people" | cut -d " " -f1 | tr '[:upper:]' '[:lower:]')
echo "Debug: FPK_LEVEL : $FPK_LEVEL"
# IP hiding
FPK_ANONIP=$($ZENITY --forms --add-list="What method do you want to use to hide you IP address ?" --list-values "Lokinet|Tor [NOT WORKING YET] (not recommended: Tor Browser is better for this)|None (Only use this if you are already hiding your IP in a system-wide way (for example: use of a VPN))" | cut -d " " -f1 | tr '[:upper:]' '[:lower:]')
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

if ! [ -d $HOME/.local/share/applications ]; then
    mkdir -pv $HOME/.local/share/applications
fi
if ! [ -d $HOME/.local/share/firefox-privacykit/resources ]; then
    mkdir $HOME/.local/share/firefox-privacykit/resources
fi
if ! [ -d $HOME/.local/bin ]; then
    mkdir -pv $HOME/.local/bin
fi
cd $HOME/.local/share/firefox-privacykit/resources
if ! [ -f firefox-icon.png ]; then
    wget -O firefox-icon.png "https://www.mozilla.org/media/img/favicons/firefox/browser/favicon-196x196.59e3822720be.png"
fi
if ! [ -f arkenfox-updater ]; then
    wget -O arkenfox-updater "https://raw.githubusercontent.com/arkenfox/user.js/master/updater.sh"
    chmod +x arkenfox-updater
fi

if [ "$FPK_SANDBOX" = "debian" ] || [ "$FPK_SANDBOX" = "gentoo" ]; then
    wget https://proot.gitlab.io/proot/bin/proot
    chmod +x proot
fi
    
case $FPK_SANDBOX in
    debian)
	cd $FPK_DIR
	# proot will be used for chroot setup
	wget https://proot.gitlab.io/proot/bin/proot
	chmod +x proot
	# get debootstrap
	wget http://deb.debian.org/debian/pool/main/d/debootstrap/debootstrap_1.0.123.tar.gz
	tar xvf debootstrap_1.0.123.tar.gz
	chmod +x debootstrap/debootstrap
	# Create the chroot
	$ZENITY --info --text "Pleae wait while Debian is being installed in $HOME/.local/share/debian-$FPK_RANDOMNUMBER\n
A new window will appear when its installation is completed to confirm it worked." &
	cd $HOME/.local/share/firefox-privacykit
	echo "Debug : Starting to install Debian"
	FPK_DEBDIR=$HOME/.local/share/firefox-privacykit/debian-$FPK_RANDOMNUMBER
	if DEBOOTSTRAP_DIR=$FPK_DIR/debootstrap $FPK_DIR/proot --kill-on-exit -0 $FPK_DIR/debootstrap/debootstrap --arch=amd64 --variant=minbase stable ./debian-$FPK_RANDOMNUMBER
	then
	   $ZENITY --error --text "The Debian installation was not successful :(\n
Please report this by:\n
1. launching the installer with ./install.sh > errorlog.log\n
2. creating an issue on the github repo with as much info on your system as you can provide'n
3. sending the errorlog.log file with your system info.\n"
	   exit 1
	fi
	cd $FPK_DIR
	FPK_PROOT="$FPK_DIR/proot -0 -b /dev -b /proc -b /sys -r $FPK_DEBDIR"
	$ZENITY --info --text "Debian has been installed, the installer will now configure it" &
	echo "deb http://deb.debian.org/debian bullseye main" > $FPK_DEBDIR/etc/apt/sources.list
	echo "deb http://security.debian.org/debian-security bullseye-security main" >> $FPK_DEBDIR/etc/apt/sources.list
	echo "deb http://deb.debian.org/debian bullseye-updates main" >> $FPK_DEBDIR/etc/apt/sources.list
	# Create the user required by APT
	$FPK_PROOT useradd -u 168 -M -r _apt
	# Create the root user
	$FPK_PROOT useradd -u 0 -d /root -m -r -s /bin/sh root
	# Update the repositories list
	$FPK_PROOT apt-get update
	# Block some packages that will pull a lot of useless deps
	echo "Package: systemd libsystemd0 dbus apt-utils gnome* mesa*
Pin: release *
Pin-Priority: -1" > $FPK_DEBDIR/etc/apt/preferences.d/blocklist
	# Add keyboard config, not doing this would require manual steps
	echo 'XKBMODEL="pc105"
XKBLAYOUT="us"
XKBVARIANT=""
XKBOPTIONS=""

BACKSPACE="guess"' > $FPK_DEBDIR/etc/default/keyboard
	# Install the Firefox dependencies
	DEBIAN_FRONTEND=noninteractive $FPK_PROOT apt-get -y -o Dpkg::Options::="--force-confnew" install gawk # Install gawk first because otherwise it causes errors
	$FPK_PROOT groupadd audio
	$FPK_PROOT groupadd mail
	$FPK_PROOT groupadd utmp
	DEBIAN_FRONTEND=noninteractive $FPK_PROOT apt-get -y -o Dpkg::Options::="--force-confnew" install pipewire libgtk-3-0 xserver-xorg-core libstdc++5 pulseaudio ca-certificates
	# Add an unpriviledged user
	FPK_USER=$(whoami)-$FPK_RANDOMNUMBER
	echo Debug: create user $FPK_USER
	$FPK_PROOT useradd -d /home/$(whoami) -m -s /bin/sh $FPK_USER
	if ! [ "$FPK_ANONIP" = "none" ]; then
        echo ""	   
	fi
	$ZENITY --info --text "Debian has been configured, now, your IP address hiding medthod ($FPK_ANONIP) will be configured too" &
	case $FPK_ANONIP in
	    lokinet)
		echo "deb https://deb.oxen.io bullseye main" > $FPK_DEBDIR/etc/apt/sources.list.d/oxen.list
		wget -O $FPK_DEBDIR/etc/apt/trusted.gpg.d/oxen.gpg https://deb.oxen.io/pub.gpg
		$FPK_PROOT apt-get update
		DEBIAN_FRONTEND=noninteractive $FPK_PROOT apt-get -y -o Dpkg::Options::="--force-confnew" install lokinet
		mkdir -p $FPK_DEBDIR/home/$(whoami)/.lokinet
		echo "[network]
hops=4
paths=3
exit-node=exit.loki
[dns]
upstream=9.9.9.10
bind=127.5.7.6:53" > $FPK_DEBDIR/home/$(whoami)/.lokinet/lokinet.ini
		DEBIAN_FRONTEND=noninteractive $FPK_PROOT apt-get remove resolvconf
		$HOME/.local/share/firefox-privacykit/resources/proot -i 1000:1000 -b /dev -b /run -b /proc -b /sys -r $FPK_DEBDIR lokinet-bootstrap
		export FPK_ANONIP_COMMAND="\$HOME/.local/share/firefox-privacykit/resources/proot -i 1000:1000 -b /dev -b /run -b /proc -b /sys -r \$HOME/.local/share/firefox-privacykit/debian-$FPK_RANDOMNUMBER lokinet"
		echo "nameserver 127.5.7.6" > $FPK_DEBDIR/etc/resolv.conf
		wget -O $FPK_DEBDIR/home/$(whoami)/.lokinet/bootstrap.signed https://seed.lokinet.org/lokinet.signed
	    ;;
	    tor)
	    ;;
	    none)
		echo nothing to do
	esac
	cd $FPK_DIR
	$ZENITY --info --text "Your IP address hiding method has been configured. Now, Firefox is going to be installed with your privacy level." &
	wget -O firefox-esr.tar.bz2 'https://download.mozilla.org/?product=firefox-esr-latest-ssl&os=linux64&lang=en-US'
	cd $FPK_DEBDIR/home/$(whoami)
	mkdir -pv ./.local/share
	cd $FPK_DEBDIR/home/$(whoami)/.local/share
	tar xvf $FPK_DIR/firefox-esr.tar.bz2
	mkdir -p $FPK_DEBDIR/home/$(whoami)/.mozilla/firefox
	cd $HOME/.local/bin
	echo "#!/bin/sh" > ./firefox-privacy-$FPK_RANDOMNUMBER
	echo "\$HOME/.local/share/firefox-privacykit/resources/proot -0 -b /dev -b /run -b /proc -b /sys -r \$HOME/.local/share/firefox-privacykit/debian-$FPK_RANDOMNUMBER apt-get update" >> ./firefox-privacy-$FPK_RANDOMNUMBER
	echo "DEBIAN_FRONTEND=noninteractive \$HOME/.local/share/firefox-privacykit/resources/proot -0 -b /dev -b /run -b /proc -b /sys -r \$HOME/.local/share/firefox-privacykit/debian-$FPK_RANDOMNUMBER apt-get -y -o Dpkg::Options::='--force-confnew' full-upgrade" >> ./firefox-privacy-$FPK_RANDOMNUMBER
	echo "xauth extract \$HOME/.local/share/firefox-privacykit/debian-$FPK_RANDOMNUMBER/home/$(whoami)/.Xauthority \$HOSTNAME/unix:0" >> ./firefox-privacy-$FPK_RANDOMNUMBER
	echo "$FPK_ANONIP_COMMAND &" >> ./firefox-privacy-$FPK_RANDOMNUMBER
	echo "for f in \$(ls \$HOME/.local/share/firefox-privacykit/debian-$FPK_RANDOMNUMBER/home/\$(whoami)/.mozilla/firefox); do" >> ./firefox-privacy-$FPK_RANDOMNUMBER
	echo "\$HOME/.local/share/firefox-privacykit/resources/arkenfox-updater -e -u -s -p \$HOME/.local/share/firefox-privacykit/debian-$FPK_RANDOMNUMBER/home/\$(whoami)/.mozilla/firefox/\$f" >> ./firefox-privacy-$FPK_RANDOMNUMBER
        echo "done" >> ./firefox-privacy-$FPK_RANDOMNUMBER
	echo "\$HOME/.local/share/firefox-privacykit/resources/proot -i 1000:1000 -b /dev -b /run -b /proc -b /sys -r \$HOME/.local/share/firefox-privacykit/debian-$FPK_RANDOMNUMBER \$HOME/.local/share/firefox/firefox \"\$@\"" >> ./firefox-privacy-$FPK_RANDOMNUMBER
	chmod +x ./firefox-privacy-$FPK_RANDOMNUMBER
	cd $FPK_DIR
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
