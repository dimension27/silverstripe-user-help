#!/bin/bash

RSYNC_COMMAND="rsync --recursive --verbose"
SRC_DIR=$1
DEST_DIR=$2

if [ -z "$SRC_DIR" -o -z "$DEST_DIR" ]; then
	echo "ERROR: Invalid usage";
	echo "Usage: $0 [source] [dest]"
	echo "Copies the contents of the database and public/assets directory from source to dest using "
	echo "script/database-dump.sh, script/mysql.sh and rsync"
	exit
else
	read -p "Are you sure you want to copy the database and assets from $SRC_DIR to $DEST_DIR? " -n 1
	echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	    exit
	fi
fi

source $DEST_DIR/script/env.sh

echo "Creating backup database dump from $DEST_DIR..."
$DEST_DIR/script/database-dump.sh

echo "Creating database dump from $SRC_DIR..."
DUMP_FILE=`$SRC_DIR/script/database-dump.sh`

echo "Loading database dump into $DEST_DIR..."
gunzip --stdout $DUMP_FILE | $DEST_DIR/script/mysql.sh

echo "Creating backup tarball of $DEST_DIR/public/assets..."
DATE=`date +%Y%m%d-%H%M%S`
cd $DEST_DIR && tar czf public-assets-$DATE.tar.gz public/assets

echo "Loading post-dump-$HTTP_HOST.sql..."
POST_DUMP="$DEST_DIR/db/post-dump-$HTTP_HOST.sql"
if [ -f $POST_DUMP ]; then
	cat $POST_DUMP | $DEST_DIR/script/mysql.sh
else
	echo "...not found";
fi

echo "Rsync-ing $SRC_DIR/public/assets to $DEST_DIR/public/assets..."
$RSYNC_COMMAND $SRC_DIR/public/assets/ $DEST_DIR/public/assets