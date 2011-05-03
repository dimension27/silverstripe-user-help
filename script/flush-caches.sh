#!/bin/bash

rmCaches() {
	if [ "`find $@ -type f -not -path '*/.svn/*' -not -path '*/.htaccess'`" ]; then
		find $@ -type f -not -path '*/.svn/*' -not -path '*/.htaccess' -print0 | sudo xargs -0 rm
	fi
}

source `dirname $0`/env.sh
cd "$BASE_PATH"
sudo true
echo "Removing cache files..."
rmCaches public/cache
rmCaches public/silverstripe-cache
rmCaches public/themes/*/_combined
echo "Running dev/build..."
./script/sake.sh dev/build