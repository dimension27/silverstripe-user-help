#!/bin/bash

# Runs sake as the webserver user

source `dirname $0`/env.sh
unset HTTP_HOST # cli-script.php complains if HTTP_HOST is set
cd "$BASE_PATH/public"
`getSudo` ./sapphire/sake $@
echo