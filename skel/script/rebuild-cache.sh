#!/bin/bash

source `dirname $0`/env.sh
SUDO="sudo -u $SERVER_USER"
if [ `whoami` == "$SERVER_USER" ]; then
	SUDO=""
fi
cd "$BASE_PATH/public"
$SUDO rm -rf cache/*
$SUDO ./sapphire/sake dev/buildcache flush=1