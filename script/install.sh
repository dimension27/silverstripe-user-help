#!/bin/bash

source `dirname $0`/env.sh
cd "$BASE_PATH"
make
cp public/.htaccess-default public/.htaccess
sudo ./script/set-permissions.sh
./script/sake.sh dev/build 