#!/bin/bash

source `dirname $0`/env.sh
cd "$BASE_PATH"
`getSudo` rm -rf public/cache/*
./script/sake.sh dev/buildcache flush=1