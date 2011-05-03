#!/bin/bash

# Sets the permissions on a number of paths that need to be writable by the webserver.
# This script also traverses directories and sets permissions recursively, as well as setting
# the setgid bit so that new files and directories inherit the group of the parent folder.
# 
# If you're on a Mac and wondering how you can add yourself to the _www group this is how it's done:
# sudo dscl . append /Groups/_www GroupMembership <username>

source `dirname $0`/env.sh

DIR_MODE="775"
FILE_MODE="664"

setWritable() {
	FILE=$1
	USER=$2
	GROUP=$2
	if [ -f "$FILE" ]; then
		chmod $FILE_MODE $FILE
		chown $USER:$GROUP $1
	else
		find $FILE -type d -not -path '*/.*' -print0 | xargs -0 chmod $DIR_MODE
		find $FILE -type d -not -path '*/.*' -print0 | xargs -0 chmod a+s
		if [ "`find $FILE -type f -not -path '*/.*'`" ]; then 
			find $FILE -type f -not -path '*/.*' -print0 | xargs -0 chmod $FILE_MODE
		fi
		find $FILE -not -path '*/.*' -print0 | xargs -0 chown $USER:$GROUP
	fi
}

setWritable "public/assets" $SERVER_USER $SERVER_GROUP
setWritable "public/cache" $SERVER_USER $SERVER_GROUP
setWritable "public/silverstripe-cache" $SERVER_USER $SERVER_GROUP
setWritable "public/themes/*/_combined" $SERVER_USER $SERVER_GROUP
setWritable "logs" $SERVER_USER $SERVER_GROUP
if [ -d public/subsites ]; then
	touch public/subsites/host-map.php
	setWritable "public/subsites/host-map.php" $SERVER_USER $SERVER_GROUP
fi