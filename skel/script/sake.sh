#!/bin/bash

# Runs sake as the webserver user

source `dirname $0`/env.sh
cd "$BASE_PATH/public"
sudo -u $SERVER_USER ./sapphire/sake $@
echo