#!/bin/bash

# Runs sake as the webserver user

source `dirname $0`/env.sh
SUDO="sudo -u $SERVER_USER"
if [ `whoami` == "$SERVER_USER" ]; then
	SUDO=""
fi
cd "$BASE_PATH/public"
$SUDO ./sapphire/sake $@
echo