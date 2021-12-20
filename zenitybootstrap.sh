#!/bin/sh
# --- Zenity bootstrap shell script ---
# Downloads an old zenity version from the CentOS 6.10 repositories, converts it to tar.gz using rpm2targz from Slackware 13.37 and creates a script to make it usable
# Warning: it will create the zenity bootstrap environment in the current directory. Leaving a script and a zenity folder here.

# Step 0: set variables and remove any previous zenity environment
_CURR_DIR=$(pwd) # Save the current dir
if [ "$(uname -m)" = "x86_64" ]; then
    _SLACKARCH="64"
    _SLACKPKGARCH="x86_64"
    _CENTOSARCH="x86_64"
elif [ "$(uname -m)" = "x86" ]; then
    _SLACKARCH=""
    _SLACKPKGARCH="i486"
    _CENTOSARCH="i386"
else
    echo "Architecture not supported (yet)! Please create an issue with the output of uname -m"
fi
rm -rfv $_CURR_DIR/zenity
rm -v $_CURR_DIR/runzenity

# Step 1: create the zenity dir we will work in and download the 3 components we will use
mkdir -v $_CURR_DIR/zenity
cd $_CURR_DIR/zenity
wget https://mirrors.slackware.com/slackware/slackware$_SLACKARCH-13.37/slackware$_SLACKARCH/a/rpm2tgz-1.2.2-$_SLACKPKGARCH-1.txz
wget https://vault.centos.org/6.10/os/$_CENTOSARCH/Packages/libnotify-0.5.0-1.el6.$_CENTOSARCH.rpm
wget https://vault.centos.org/6.10/os/$_CENTOSARCH/Packages/zenity-2.28.0-1.el6.$_CENTOSARCH.rpm

# Step 2: decompress everything
tar xvf rpm2tgz*.txz
$_CURR_DIR/zenity/usr/bin/rpm2targz $_CURR_DIR/zenity/libnotify*.rpm
$_CURR_DIR/zenity/usr/bin/rpm2targz $_CURR_DIR/zenity/zenity*.rpm
tar xvf libnotify*.tar.gz
tar xvf zenity*.tar.gz

# Step 3: install properly and remove unneeded stuff
rm -v $_CURR_DIR/zenity/*.rpm $_CURR_DIR/zenity/*.txz $_CURR_DIR/zenity/*.tar.gz
cp -rv $_CURR_DIR/zenity/libnotify*/* $_CURR_DIR/zenity/
cp -rv $_CURR_DIR/zenity/zenity*/* $_CURR_DIR/zenity/
rm -rfv $_CURR_DIR/zenity/libnotify* $_CURR_DIR/zenity/zenity*

# Step 4: create a script to use zenity
echo "#!/bin/sh" > $_CURR_DIR/runzenity
echo "cd $_CURR_DIR/zenity" >>  $_CURR_DIR/runzenity
echo "LD_PRELOAD=./usr/lib64/libnotify.so.1.2.3 ./usr/bin/zenity" \$\@ >>  $_CURR_DIR/runzenity
chmod +x $_CURR_DIR/runzenity
