#!/bin/bash

source `dirname $0`/env.sh

GZIP=1
CSV=0
TABLES=""
for ARG in "$@"; do
	if [ $ARG = "--no-gzip" ]; then
		GZIP=0
	elif [ $ARG = "--csv" ]; then
		CSV=1
	else
		TABLES="$TABLES $ARG"
	fi
done

DIR=`dirname $0`
DIR=`dirname $DIR`

DUMP_DIR="$DIR/db"
if [ -d "$DUMP_DIR/dumps" ]; then
	DUMP_DIR="$DUMP_DIR/dumps"
fi

HOST=`hostname`
DATE=`date +%Y%m%d-%H%M%S`
FILE="$DUMP_DIR/$HOST-$DATE.sql"
OPTIONS=" --host="$DB_HOSTNAME" --user="$DB_USERNAME" --password="$DB_PASSWORD""

if [ $CSV -eq 0 ]; then
	OPTIONS="$OPTIONS --skip-add-locks --extended-insert --complete-insert"
	mysqldump $OPTIONS $DB_NAME $TABLES > $FILE
	if [ $? -eq 0 ]; then
		if [ $GZIP -eq 1 ]; then
			gzip -f $FILE
			FILE="$FILE.gz"
		fi
		echo $FILE
	fi
else
	DIR="$DUMP_DIR/$HOST-$DATE-csv/"
	mkdir $DIR && chmod 777 $DIR
	OPTIONS="$OPTIONS --tab=$DIR --fields-enclosed-by=\\\" --fields-terminated-by=,"
	mysqldump $OPTIONS $DB_NAME $TABLES
	chmod 755 $DIR
	if [ $? -eq 0 ]; then
		echo $DIR
	fi
fi