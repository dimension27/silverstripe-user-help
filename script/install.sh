#!/bin/bash

source `dirname $0`/env.sh
cd "$BASE_PATH"
make
# copy .htaccess-default to .htaccess
if [ -f public/.htaccess ]; then
	echo "public/.htaccess already exists - please remove first"
else
	cp public/.htaccess-default public/.htaccess
fi
# set permissions
sudo ./script/set-permissions.sh
# check to see if the database exists and create it if necessary
echo 'SHOW TABLES' | ./script/mysql.sh > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "Database '$DB_NAME' doesn't exist - creating database, enter MySQL root password..."
	cat db/init.mysql.sql | mysql -uroot -p
fi
# run a dev/build
./script/sake.sh dev/build