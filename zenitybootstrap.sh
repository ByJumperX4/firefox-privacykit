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
wget https://mirrors.slackware.com/slackware/slackware$SLACKARCH-13.37/slackware$SLACKARCH/a/rpm2tgz-1.2.2-$SLACKPKGARCH-1.txz https://mirrors.slackware.com/slackware/slackware$SLACKARCH-13.37/slackware$SLACKARCH/ap/rpm-4.8.1-$SLACKPKGARCH-1.txz https://vault.centos.org/6.10/os/$CENTOSARCH/Packages/libnotify-0.5.0-1.el6.$CENTOSARCH.rpm https://vault.centos.org/6.10/os/$CENTOSARCH/Packages/zenity-2.28.0-1.el6.$CENTOSARCH.rpm

# Step 2: decompress everything
tar xvf rpm2tgz*.txz
tar xvf rpm-*.txz
PATH=$CURR_DIR/zenity/usr/bin:$PATH LD_PRELOAD=$CURR_DIR/zenity/usr/lib$SLACKARCH/librpm.so.1.0.0 $CURR_DIR/zenity/usr/bin/rpm2targz $CURR_DIR/zenity/libnotify*.rpm
PATH=$CURR_DIR/zenity/usr/bin:$PATH LD_PRELOAD=$CURR_DIR/zenity/usr/lib$SLACKARCH/librpm.so.1.0.0 $CURR_DIR/zenity/usr/bin/rpm2targz $CURR_DIR/zenity/zenity*.rpm
tar xvf libnotify*.tar.gz
tar xvf zenity*.tar.gz

# Step 3: install properly and remove unneeded stuff
rm -v $CURR_DIR/zenity/*.rpm $CURR_DIR/zenity/*.txz $CURR_DIR/zenity/*.tar.gz
cp -rv $CURR_DIR/zenity/libnotify*/* $CURR_DIR/zenity/
cp -rv $CURR_DIR/zenity/zenity*/* $CURR_DIR/zenity/
rm -rfv $CURR_DIR/zenity/libnotify* $CURR_DIR/zenity/zenity*

# Step 4: create a script to use zenity
echo "#!/bin/sh" > $CURR_DIR/runzenity
echo "cd $CURR_DIR/zenity" >>  $CURR_DIR/runzenity
echo "LD_PRELOAD=./usr/lib$SLACKARCH/libnotify.so.1.2.3 ./usr/bin/zenity" \$\@ >>  $CURR_DIR/runzenity
chmod +x $CURR_DIR/runzenity
