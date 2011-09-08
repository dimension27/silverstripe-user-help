# Setup instructions...

cat db/init.mysql.sql | mysql -uroot -ppassword
gunzip -c db/sshelp-db.sql.gz | ./script/mysql.sh
./script/sake.sh dev/build