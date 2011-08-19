#!/bin/bash

source `dirname $0`/env.sh
cd "$BASE_PATH/public"
`getSudo` rm -rf cache/*
`getSudo` ./sapphire/sake dev/buildcache flush=1