#!/bin/sh -eu
# --- Zenity bootstrap shell script ---
# Downloads an old zenity version from the CentOS 6.10 repositories, converts it to tar.gz using rpm2targz from Slackware 13.37 and creates a script to make it usable
# Warning: it will create the zenity bootstrap environment in the current directory. Leaving a script and a zenity folder here.

# Step 0: set variables and remove any previous zenity environment
CURR_DIR=$(pwd) # Save the current dir
if [ "$(uname -m)" = "x86_64" ]; then
    SLACKARCH="64"
    SLACKPKGARCH="x86_64"
    CENTOSARCH="x86_64"
elif [ "$(uname -m)" = "x86" ]; then
    SLACKARCH=""
    SLACKPKGARCH="i486"
    CENTOSARCH="i386"
    echo "Architecture not supported (yet)! Please create an issue with the output of uname -m"
else
    echo "Architecture not supported (yet)! Please create an issue with the output of uname -m"
fi

if [ -d $CURR_DIR/zenity ]; then
    rm -rfv $CURR_DIR/zenity
fi
if [ -f $CURR_DIR/runzenity ]; then
rm -v $CURR_DIR/runzenity
fi

# Step 1: create the zenity dir we will work in and download the 3 components we will use
mkdir -v $CURR_DIR/zenity
cd $CURR_DIR/zenity
wget https://mirrors.slackware.com/slackware/slackware$SLACKARCH-14.2/slackware$SLACKARCH/l/libnotify-0.7.6-$SLACKPKGARCH-1.txz https://raw.githubusercontent.com/ByJumperX4/firefox-privacykit/master/slash-tmp/zenity-tarball.tar.xz https://mirrors.slackware.com/slackware/slackware$SLACKARCH-13.37/slackware$SLACKARCH/l/libpng-1.4.5-$SLACKPKGARCH-1.txz

# Step 2: decompress everything
tar xvf libnotify*.txz
tar xvf libpng*.txz
tar xvf zenity-tarball.tar.xz

# Step 3: install properly and remove unneeded stuff
mkdir -p /tmp/zenity
cp -r $CURR_DIR/zenity/zenity/* /tmp/zenity
cp -r $CURR_DIR/zenity/zenity/* $CURR_DIR/zenity/usr
chmod +x $CURR_DIR/zenity/usr/bin/zenity

# Step 4: create a script to use zenity
echo "#!/bin/sh" > $CURR_DIR/runzenity
echo "cd $CURR_DIR/zenity" >>  $CURR_DIR/runzenity
echo "PATH=$PATH:$CURR_DIR/runzenity/usr/bin LD_PRELOAD=./usr/lib$SLACKARCH/libnotify.so.4.0.0:./usr/lib$SLACKARCH/libpng14.so.14.5.0 ./usr/bin/zenity" \$\@ >>  $CURR_DIR/runzenity
chmod +x $CURR_DIR/runzenity
