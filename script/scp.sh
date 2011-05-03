#!/bin/bash

source `dirname $0`/env.sh

SRC=$DEPLOY_LOCAL
DEST=$DEPLOY_STAGING

DOWN=""
COMMAND="scp"
FILE_LIST=""

ARGS=""
for ARG in $@; do
	if [ "$ARG" = "--down" ]; then
		DOWN="1"
		SRC=$DEST
		DEST=$DEPLOY_LOCAL
	elif [ "$ARG" = "--live" ]; then
		DEST=$DEPLOY_LIVE
	elif [ "$DOWN" -o -r $ARG ]; then
		FILE_LIST="$FILE_LIST $ARG"
	else
		ARGS="$ARGS $ARG"
	fi
done

if [ -z "$SRC" ]; then
	echo "ERROR: Invalid source '$SRC'"
elif [ -z "$DEST" ]; then
	echo "ERROR: Invalid destination '$DEST'"
elif [ -z "$FILE_LIST" ]; then
	echo "ERROR: Invalid file list '$FILE_LIST'"
else
	for FILE in $FILE_LIST; do
		SRC_FILE="$SRC/$FILE"
		DEST_FILE="$DEST/$FILE"
		if [ -d "$SRC_FILE" ]; then
			SRC_FILE="`dirname $SRC_FILE/.`"
			DEST_FILE=`dirname $DEST_FILE/.`
			DEST_FILE=`dirname $DEST_FILE`
			echo "$COMMAND $ARGS -r \"$SRC_FILE\" \"$DEST_FILE\""
        	$COMMAND $ARGS -r "$SRC_FILE" "$DEST_FILE"
		else
			echo "$COMMAND $ARGS \"$SRC_FILE\" \"$DEST_FILE\""
        	$COMMAND $ARGS "$SRC_FILE" "$DEST_FILE"
		fi
	done
fi
