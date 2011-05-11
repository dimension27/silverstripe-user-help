#!/bin/bash

rmCaches() {
	if [ "`find $@ -type f -not -path '*/.svn/*' -not -path '*/.htaccess'`" ]; then
		find $@ -type f -not -path '*/.svn/*' -not -path '*/.htaccess' -print0 | sudo xargs -0 rm
	fi
}

source `dirname $0`/env.sh
cd "$BASE_PATH"
sudo true
if [ -d "$1" ]; then
	rmCaches $1
else
	echo "Removing cache files..."
	rmCaches public/cache
	rmCaches public/silverstripe-cache
	rmCaches public/themes/*/_combined
	if [ "$1" != "--no-build" ]; then
		echo "Running dev/build..."
		./script/sake.sh dev/build
	fi
fi