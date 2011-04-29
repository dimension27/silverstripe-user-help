#!/bin/bash

source `dirname $0`/../env.sh

cd "$BASE_PATH"
REGEXP='^(.+):(.*)'
SED_ARG=`getSedExtendedRegExpArg`;

if [ "$1" == "--live" ]; then
	REMOTE=$DEPLOY_LIVE
	LIVE="--live "
else
	REMOTE=$DEPLOY_STAGING
fi

REMOTE_HOST=`echo $REMOTE | sed -$SED_ARG -e "s/$REGEXP/\1/"`
REMOTE_BASE=`echo $REMOTE | sed -$SED_ARG -e "s/$REGEXP/\2/"`

echo "-- Creating database dump on $REMOTE_HOST"
COMMAND="ssh $REMOTE_HOST cd $REMOTE_BASE; ./script/database-dump.sh"
echo $COMMAND
DUMP_FILE=`$COMMAND`

if [ $? -eq 0 -a "$DUMP_FILE" != "" ]; then
	echo "-- Downloading $DUMP_FILE from $REMOTE_HOST"
	COMMAND="./script/scp.sh $LIVE--down $DUMP_FILE"
	echo $COMMAND
	$COMMAND
	if [ $? -eq 0 ]; then
		# echo "-- Creating backup of local database"
		# COMMAND="./script/database-dump.sh"
		# echo $COMMAND
		# $COMMAND
		if [ $? -eq 0 ]; then
			echo "-- Loading $DUMP_FILE to local database"
			echo "gunzip --stdout \"./$DUMP_FILE\" | \"./script/mysql.sh\""
			gunzip --stdout "./$DUMP_FILE" | "./script/mysql.sh"
			POST_DUMP="./db/post-dump-$HTTP_HOST.sql"
			if [ -f $POST_DUMP ]; then
				echo "-- Running post-dump script $POST_DUMP"
				cat $POST_DUMP | ./script/mysql.sh
			fi
		fi
	fi
fi
