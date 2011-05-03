#!/bin/bash

source `dirname $0`/env.sh

COMMAND="mysql --host=$DB_HOSTNAME --user=$DB_USERNAME --password=$DB_PASSWORD"
PORT="$DB_PORT"
if [ ! -z "$DB_PORT" ]; then
	COMMAND="$COMMAND --port=$PORT"
fi
COMMAND="$COMMAND $DB_NAME"
$COMMAND $@