#!/bin/sh
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

MYSQL_WP_DATABASE=$(cat $MYSQL_WP_DATABASE_FILE)
MYSQL_WP_USER=$(cat $MYSQL_WP_USER_FILE)
MYSQL_ROOT_PASSWORD=$(cat $MYSQL_ROOT_PASSWORD_FILE)
MYSQL_WP_PASSWORD=$(cat $MYSQL_WP_PASSWORD_FILE)

cat <<EOF >/var/lib/mysql/init.sql
CREATE DATABASE IF NOT EXISTS ${MYSQL_WP_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_WP_USER}'@'%' IDENTIFIED BY '${MYSQL_WP_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_WP_DATABASE}.* TO '${MYSQL_WP_USER}'@'%';

FLUSH PRIVILEGES;
EOF

rm /etc/my.cnf.d/mariadb-server.cnf
mv /tmp/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

exec mariadbd --user=mysql --datadir=/var/lib/mysql --init-file=/var/lib/mysql/init.sql
