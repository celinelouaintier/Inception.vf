#!/bin/sh

service mariadb start

sleep 5

echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD';" | mysql
echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%'"| mysql
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" | mysql
echo "FLUSH PRIVILEGES;" | mysql

echo "CREATE DATABASE $MYSQL_DATABASE;" | mysql

kill $(cat /var/run/mysqld/mysqld.pid)

exec $@