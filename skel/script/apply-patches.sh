#!/bin/bash

source `dirname $0`/env.sh

cd "$BASE_PATH/public/sapphire"
patch -Np0 < ../../patches/cli-port.patch
patch -Np0 < ../../patches/static-main-realpath.patch
patch -Np0 < ../../patches/ss-navigator-margin.patch
patch -Np0 < ../../patches/fieldisrequired.patch
patch -Np0 < ../../patches/form-css.patch
patch -Np0 < ../../patches/datefield-within-fieldgroup.patch
patch -Np0 < ../../patches/SelectionGroup-css.patch
cd "$BASE_PATH/public/dataobject_manager"
patch -Np0 < ../../patches/dataobject_manager-improvements.patch
# Patches for userforms (if it's installed)
# cd "$BASE_PATH/public/userforms"
# patch -Np0 < ../../patches/userforms-improvements.patch