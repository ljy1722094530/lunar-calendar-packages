#!/bin/sh

# Copyright (C) 2014 LiuLang <gsushzhsosgsu@gmail.com>

# Use of this source code is governed by GPLv3 license that can be found
# in the LICENSE file.

# Generate deb package from source.
# v1.0 -2014.2.17
# project inited.


DIR="fakeroot/"
PACKAGE=$(sed -n '/Package:/p' control | awk '{print $2}')
VERSION=$(sed -n '/Version:/p' control | awk '{print $2}')
DEB="${PACKAGE}_${VERSION}_all.deb"
if [ ! -d $DIR ]; then
	echo 'Error: no such directory.'
    echo 'Please run ./build.sh first'
	exit 1
fi

cd $DIR
chown -R root:root .
find usr -type f | xargs chmod a+r
find usr -type d | xargs chmod a+rx
echo 'Permissions of files and folders in usr/ updated..'
find usr/bin -type f | xargs chmod a+x
echo 'All files in ./usr/bin executable..'

find usr -type f | xargs md5sum > DEBIAN/md5sums
echo 'MD5sums updated...'

find DEBIAN -type f | xargs chmod a+r
find DEBIAN -type d | xargs chmod a+rx
echo 'Permissions of files and folders in DEBIAN/ updated..'

cd ../

dpkg -b $DIR $DEB
echo 'DEB generated...'

rm -rf $DIR
echo "$DIR cleaned"

# That DEB package needs to be chowned to current user.
OWNER=$(stat -c%u "$0")
GROUP=$(stat -c%g "$0")
chown $OWNER:$GROUP $DEB
echo 'file owner and group owner changed..'

rm -rvf ../*.deb
echo 'Old deb packages removed'

mv -vf $DEB ..
