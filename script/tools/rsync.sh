#!/bin/bash

source `dirname $0`/../env.sh

REMOTE=$DEPLOY_STAGING
COMMAND="rsync --update --recursive --compress --progress --rsh=ssh --verbose --exclude .svn "
SRC=""
DEST=""
DOWNLOAD=0
DRY_RUN=0

ARGS=""
for ARG in $@; do
	if [ "$ARG" = "--live" ]; then
		REMOTE=$DEPLOY_LIVE
	elif [ "$ARG" = "--down" ]; then
		DOWNLOAD=1
	elif [ "$ARG" = "--dry-run" ]; then
		DRY_RUN=1
		COMMAND="$COMMAND --dry-run"
	elif [ -z "$SRC" ]; then
		SRC=$ARG
	elif [ -z "$DEST" ]; then
		DEST=$ARG
	fi
done

if [ -z "$DEST" ]; then
	DEST=$SRC
fi

if [ $DOWNLOAD = "1" ]; then
	SRC="$REMOTE/$SRC"
	DEST="$DEPLOY_LOCAL/$ARG"
else
	SRC="$DEPLOY_LOCAL/$SRC"
	DEST="$REMOTE/$ARG"
fi

if [ "$SRC" -a "$DEST" ]; then
	echo "$COMMAND \"$SRC/\" \"$DEST\""
	$COMMAND "$SRC/" "$DEST"
else
	echo "Usage: $0 [--down] [--dry-run] {src} {dest}"
fi