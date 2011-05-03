#!/bin/bash

source `dirname $0`/env.sh
export CWD=`pwd`

$PHP_EXECUTABLE -d include_path="$INCLUDE_PATH" -f $@