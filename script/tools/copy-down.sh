#!/bin/bash

source `dirname $0`/../env.sh
cd "$BASE_PATH"
sudo true
./script/tools/download-dump.sh $@
./script/sake.sh dev/build
./script/tools/rsync.sh $@ --down public/assets